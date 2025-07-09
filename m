Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC49617C220
	for <mm-commits@vger.kernel.org>; Wed,  9 Jul 2025 02:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752029758; cv=none; b=Hz5K1jr+3vqaIkPm7W+fI3grJ2PKv1Cl0Y8WF4DbwoRC1+K0GZ7D4hMsTiw5dSScYgHfuGETx2OeekTEWvLvRFJettV/OUtSAFTc7P/njwAI4U5ZmFBKMZ24X2M40cSancYiOikxylntbD3EDD4Kxf9sKDQi2dZQDzduylJX3y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752029758; c=relaxed/simple;
	bh=2XRVSc1p5grVMi1borkNfZWUuC9KJegDkieJvRxxtXQ=;
	h=Date:To:From:Subject:Message-Id; b=edsafP0wMrItS0JCyOtq1ndXrG7iONH0r+uD+5HdCLxA+xqQ34RMTU6pcVKKHGNMjeXwx63GJqBfhqGLxKqV+42Xtdrv6Ky1bCOuDLR50RzTq8q/+FOs+yCK8qyGra7WPHinzVyqGu37bnwZBuySGVQqpAGJc9iQIVXiOBuLL9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IRq4JC5y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IRq4JC5y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C00C4CEED;
	Wed,  9 Jul 2025 02:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752029758;
	bh=2XRVSc1p5grVMi1borkNfZWUuC9KJegDkieJvRxxtXQ=;
	h=Date:To:From:Subject:From;
	b=IRq4JC5ysMXRRoVB7rqbafrJzljGD0aSwoIR2l89vN3oYozyZfIVLvJoM+qCj+jWy
	 vpAl3DbSbuCsk272IuBZqmITU3Gz2yuFedi8HYmeAFCSGmBauSOe+dyPv6sBbaiHo5
	 NN1deViopwbdqdrtMhht2+sEGuA/mFTTksG5Qzis=
Date: Tue, 08 Jul 2025 19:55:57 -0700
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,colin.i.king@gmail.com,chanho.min@lge.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250709025558.31C00C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call-fix
Date: Tue Jul  8 07:52:48 PM PDT 2025

fix build

Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Chanho Min <chanho.min@lge.com>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/block.c~squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call-fix
+++ a/fs/squashfs/block.c
@@ -89,7 +89,7 @@ static int squashfs_bio_read_cached(stru
 	int err = 0;
 #ifdef CONFIG_SQUASHFS_COMP_CACHE_FULL
 	struct folio **cache_folios = kmalloc_array(page_count,
-			sizeof(*folio), GFP_KERNEL | __GFP_ZERO);
+			sizeof(*cache_folios), GFP_KERNEL | __GFP_ZERO);
 #endif
 
 	bio_for_each_folio_all(fi, fullbio) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mmslub-use-node-notifier-instead-of-memory-notifier-fix.patch
maple-tree-use-goto-label-to-simplify-code-fix.patch
mm-damon-sysfs-schemes-decouple-from-damos_action-fix.patch
mm-memcg-make-memoryreclaim-interface-generic-fix.patch
introduce-khugepaged_collapse_single_pmd-to-unify-khugepaged-and-madvise_collapse-fix.patch
maintainers-add-lib-raid6-to-software-raid.patch
squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call-fix.patch

