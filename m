Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1332E371E;
	Fri,  4 Jul 2025 20:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751662182; cv=none; b=e+eLr4MI6pZzqPqQmRejY2PTEklIu/jbHquXAInOM+GXno/pBBW2WHnQE2WZxCP42eIxxQJjZACm2qubdcO9Uh1apK5QIZqd/gvNIL1fOTim+chVvTn6Zj1f7+RYtuU3xoz4lE3GSV50Y6l43fTF0s6HEL45I+MeF9QepGjxWD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751662182; c=relaxed/simple;
	bh=VDkQIuEYyfL+0b/2jLf/NgxzUs97PHZkUjWLE2AmEp8=;
	h=Date:To:From:Subject:Message-Id; b=ujMqxyN+YT3EKd9906s7kM8TP+NNgWGgB453gDpHu4zM0AZ+fvzQN0FljEai+uqpYY5J+S6dMCAErfASX/PHaPvEsSsWDKW8YPbso+dG1zMSPR/IK8lq2qPTF2Qs3OG0YECY/McKqZunUjOz1qxLHqAHGl/c7LZNmYffPGNNrrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sLtKEfBM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sLtKEfBM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65A3C4CEE3;
	Fri,  4 Jul 2025 20:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751662181;
	bh=VDkQIuEYyfL+0b/2jLf/NgxzUs97PHZkUjWLE2AmEp8=;
	h=Date:To:From:Subject:From;
	b=sLtKEfBMV8tfPXGglpw8h0obDDJpXonlgF10nIE+9OZywc2G9BwJKzIt7AtKwRbiI
	 lWuMk2SV9Tvus8TAwWapiXFRYix/3R7TaRxPZj3WrRefDPNzarF+idVbaAUagWmrDj
	 Yqh9MToaEYfh/9KlHN68Bm1ZF17CKesw6OSfjNzk=
Date: Fri, 04 Jul 2025 13:49:41 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,david@redhat.com,harry.yoo@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-do-not-pass-__gfp_movable-if-config_compaction=n.patch added to mm-hotfixes-unstable branch
Message-Id: <20250704204941.D65A3C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: do not pass __GFP_MOVABLE if CONFIG_COMPACTION=n
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-zsmalloc-do-not-pass-__gfp_movable-if-config_compaction=n.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-do-not-pass-__gfp_movable-if-config_compaction=n.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Harry Yoo <harry.yoo@oracle.com>
Subject: mm/zsmalloc: do not pass __GFP_MOVABLE if CONFIG_COMPACTION=n
Date: Fri, 4 Jul 2025 19:30:53 +0900

Commit 48b4800a1c6a ("zsmalloc: page migration support") added support for
migrating zsmalloc pages using the movable_operations migration framework.
However, the commit did not take into account that zsmalloc supports
migration only when CONFIG_COMPACTION is enabled.  Tracing shows that
zsmalloc was still passing the __GFP_MOVABLE flag even when compaction is
not supported.

This can result in unmovable pages being allocated from movable page
blocks (even without stealing page blocks), ZONE_MOVABLE and CMA area.

Possible user visible effects:
- Some ZONE_MOVABLE memory can be not actually movable
- CMA allocation can fail because of this
- Increased memory fragmentation due to ignoring the page mobility
  grouping feature  
I'm not really sure who uses kernels without compaction support, though :(


To fix this, clear the __GFP_MOVABLE flag when
!IS_ENABLED(CONFIG_COMPACTION).

Link: https://lkml.kernel.org/r/20250704103053.6913-1-harry.yoo@oracle.com
Fixes: 48b4800a1c6a ("zsmalloc: page migration support")
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/zsmalloc.c~mm-zsmalloc-do-not-pass-__gfp_movable-if-config_compaction=n
+++ a/mm/zsmalloc.c
@@ -1043,6 +1043,9 @@ static struct zspage *alloc_zspage(struc
 	if (!zspage)
 		return NULL;
 
+	if (!IS_ENABLED(CONFIG_COMPACTION))
+		gfp &= ~__GFP_MOVABLE;
+
 	zspage->magic = ZSPAGE_MAGIC;
 	zspage->pool = pool;
 	zspage->class = class->index;
_

Patches currently in -mm which might be from harry.yoo@oracle.com are

lib-alloc_tag-do-not-acquire-non-existent-lock-in-alloc_tag_top_users.patch
lib-alloc_tag-do-not-acquire-non-existent-lock-in-alloc_tag_top_users-v3.patch
mm-zsmalloc-do-not-pass-__gfp_movable-if-config_compaction=n.patch

