Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D9819DFAB
	for <mm-commits@vger.kernel.org>; Sun, 21 Dec 2025 00:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766276749; cv=none; b=UhQjaP+fnSttKglsL3X4Dg1Vi1nLhYT8WlAL9F+HtI1Ff9yfZcteKRxGiNs5ssyC0pftas6WIzxpX3frUJSLnDeS2FdXJ7tCxqlhuQVrkNsSWHVeeeJ7v6vmA8/diq2d7Fp8InvIeYIgyG14epxv79UnsPHj7SaVVcLOCX6BJ3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766276749; c=relaxed/simple;
	bh=faQ/vc9gez8zRCjVx67pzRSKUdzWKcBZ6b0VvwAn9Qw=;
	h=Date:To:From:Subject:Message-Id; b=CT0MJneiEUJ8ClP/4J/E/X+SxgM2W2wfmne2CqB1kTMVxCcQLJJ4ItTSwWhtkz6nBylZHdKDczSGLZVwBkw0l1HqKDRgRY9daN3KHwW4XHZzDQcOSrvmNDHAjxUBUdShAJvKkj09J5uJBy9sWyze0lgbRAIxFbeYybCoCP7yhCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J2dj6xSl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J2dj6xSl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0933C4CEF5;
	Sun, 21 Dec 2025 00:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766276749;
	bh=faQ/vc9gez8zRCjVx67pzRSKUdzWKcBZ6b0VvwAn9Qw=;
	h=Date:To:From:Subject:From;
	b=J2dj6xSlTQPW+taRtq/0a1jbBDCCZfYH1PamSWa1PEUQGmOkUAaqcKTsBJZrPWw7A
	 EbZhjp1gVJ417cLqWBSTk850lFwafQRz/08gi7qzKrrLR19ewdhcsBmSEc/5P9Cmv5
	 lAiuKKwAYJe+GcrPaeasxsKXUNWIw2gplF3svzUc=
Date: Sat, 20 Dec 2025 16:25:48 -0800
To: mm-commits@vger.kernel.org,harry.yoo@oracle.com,david@kernel.org,bagasdotme@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-describe-flags-parameter-in-memalloc_flags_save.patch added to mm-hotfixes-unstable branch
Message-Id: <20251221002548.E0933C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: describe @flags parameter in memalloc_flags_save()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-describe-flags-parameter-in-memalloc_flags_save.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-describe-flags-parameter-in-memalloc_flags_save.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: mm: describe @flags parameter in memalloc_flags_save()
Date: Fri, 19 Dec 2025 08:40:04 +0700

Patch series "mm kernel-doc fixes".

Here are kernel-doc fixes for mm subsystem.  I'm also including textsearch
fix since there's currently no maintainer for include/linux/textsearch.h
(get_maintainer.pl only shows LKML).


This patch (of 4):

Sphinx reports kernel-doc warning:

WARNING: ./include/linux/sched/mm.h:332 function parameter 'flags' not described in 'memalloc_flags_save'

Describe @flags to fix it.

Link: https://lkml.kernel.org/r/20251219014006.16328-2-bagasdotme@gmail.com
Link: https://lkml.kernel.org/r/20251219014006.16328-3-bagasdotme@gmail.com
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Fixes: 3f6d5e6a468d02 ("mm: introduce memalloc_flags_{save,restore}")
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/mm.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/sched/mm.h~mm-describe-flags-parameter-in-memalloc_flags_save
+++ a/include/linux/sched/mm.h
@@ -325,6 +325,7 @@ static inline void might_alloc(gfp_t gfp
 
 /**
  * memalloc_flags_save - Add a PF_* flag to current->flags, save old value
+ * @flags: Flags to add.
  *
  * This allows PF_* flags to be conveniently added, irrespective of current
  * value, and then the old version restored with memalloc_flags_restore().
_

Patches currently in -mm which might be from bagasdotme@gmail.com are

mm-describe-flags-parameter-in-memalloc_flags_save.patch
textsearch-describe-list-member-in-ts_ops-search.patch
mm-vmalloc-fix-up-vrealloc_node_align-kernel-doc-macro-name.patch
mm-kfence-describe-slab-parameter-in-__kfence_obj_info.patch

