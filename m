Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287B419DF6A
	for <mm-commits@vger.kernel.org>; Wed,  6 Aug 2025 23:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754523842; cv=none; b=OxToxC2CX4oYcTir5QTTrEjqPmPvpDc+ksImvrfHGN1RKjjY8qlzp92yG49Z2Fo/CdvT9UFa6cN6AumxsCeLuSc12eF8sVrXtBR8AwRsbmWlOaXvttQ4WJb7Dtv0bJNC4dgHfm2kfZJr1hEJH19gj73EHV7BuW3stIlaKATjMTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754523842; c=relaxed/simple;
	bh=nNsD2Kgl1pPr7zGfQWRY0mn6fVc0aimVAzDvGk/tjGw=;
	h=Date:To:From:Subject:Message-Id; b=H40Cn1FK4nMGc2r4kpCXz7NGqT0fY0Tus3K0NhMuVKCs5cW/9lrfOR5TV4pAbyZYW9wV2/s1BEy0waP7BYpK3Fd1piXuzBaQMJ1hVw/YVjD4KTvJyz4caEbYV6pruRFLm17pu4C4V2JS9ZxF+2cUmxipHW+y8t4vxmZIFSe1a/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZfbDn5Rv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZfbDn5Rv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E64C4CEE7;
	Wed,  6 Aug 2025 23:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754523841;
	bh=nNsD2Kgl1pPr7zGfQWRY0mn6fVc0aimVAzDvGk/tjGw=;
	h=Date:To:From:Subject:From;
	b=ZfbDn5RvLUmQILLHIU+xpNlOk3fzKm1NNU4PzJoskU7hHV4Zxz3UGb8p41Qlw+tSc
	 I/tyjEaCa01S9Pt6D4gCMxu329Gxf+b7qQhDd0DgMWV99zjvLddKPXzQOZwpWpIi0v
	 rxuKl6UzKCydYGU++jrKKsSMlqNGpsAWlC0XRlX8=
Date: Wed, 06 Aug 2025 16:44:00 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,richard.weiyang@gmail.com,Liam.Howlett@oracle.com,rongqianfeng@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-remove-redundant-__gfp_nowarn.patch added to mm-new branch
Message-Id: <20250806234401.92E64C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: remove redundant __GFP_NOWARN
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-remove-redundant-__gfp_nowarn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-remove-redundant-__gfp_nowarn.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: maple_tree: remove redundant __GFP_NOWARN
Date: Mon, 4 Aug 2025 20:56:57 +0800

Commit 16f5dfbc851b ("gfp: include __GFP_NOWARN in GFP_NOWAIT") made
GFP_NOWAIT implicitly include __GFP_NOWARN.

Therefore, explicit __GFP_NOWARN combined with GFP_NOWAIT (e.g.,
`GFP_NOWAIT | __GFP_NOWARN`) is now redundant.  Let's clean up these
redundant flags across subsystems.

No functional changes.

Link: https://lkml.kernel.org/r/20250804125657.482109-1-rongqianfeng@vivo.com
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-redundant-__gfp_nowarn
+++ a/lib/maple_tree.c
@@ -1337,11 +1337,11 @@ static void mas_node_count_gfp(struct ma
  * @mas: The maple state
  * @count: The number of nodes needed
  *
- * Note: Uses GFP_NOWAIT | __GFP_NOWARN for gfp flags.
+ * Note: Uses GFP_NOWAIT for gfp flags.
  */
 static void mas_node_count(struct ma_state *mas, int count)
 {
-	return mas_node_count_gfp(mas, count, GFP_NOWAIT | __GFP_NOWARN);
+	return mas_node_count_gfp(mas, count, GFP_NOWAIT);
 }
 
 /*
_

Patches currently in -mm which might be from rongqianfeng@vivo.com are

xarray-remove-redundant-__gfp_nowarn.patch
maple_tree-remove-redundant-__gfp_nowarn.patch
ref_tracker-remove-redundant-__gfp_nowarn.patch

