Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C636E5383
	for <mm-commits@vger.kernel.org>; Tue,  4 Feb 2025 00:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738629416; cv=none; b=dLSNJc2/M0i7XUR3OD6XYQY7Z6TnKldJEF5lpkyKQwKE0TZ9qlifpsSRKBFF/YpsLppmKlMcegHukodiR2YxWy/JYLPF4e9cZ9qGFTkrF8RL8QNgc6Q3ZLzyobnIusLbSE1Bi4XMShGIOoPeyWKKQl2Ashe/pxoHPNu2ArzJiXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738629416; c=relaxed/simple;
	bh=lyFymTIX7pK9MBb1hi5r05da1yxE4kkafJ2Z3FkHTHM=;
	h=Date:To:From:Subject:Message-Id; b=GZgjP9VBSPgG37OeZBR3mcYWKY9zUP1Wd4jOkFLk1wQRNZDCuDzpz4rxRVipv3utyLtIhJKwmLYdqLoS+XHlKUXPeMIsVv9xPm2NTgNwzl/fJVOeZIikEcV6U58Xti5ylCZdxDPIHuzomIuYVMzFsMAAC/3QepZ5jvV4eSPjqPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a+l1NGrA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a+l1NGrA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F82DC4CEE0;
	Tue,  4 Feb 2025 00:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738629416;
	bh=lyFymTIX7pK9MBb1hi5r05da1yxE4kkafJ2Z3FkHTHM=;
	h=Date:To:From:Subject:From;
	b=a+l1NGrA/hD1Ys1UPcy5JBzko/wzV7OP6prm/qm4p1zDogbaC/pPKoV2ZRQ5766vh
	 9YvZfKerSmhjh3VNcaAFWG4fizlQnWdJknX6SeNJzJRbb+35C40x+rbEp+P7/1KeEp
	 osOnAhKbVffInToiW9JWfJm5h2SL5OUh+6vGF4cc=
Date: Mon, 03 Feb 2025 16:36:55 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,soci@c64.rulez.org,mcanal@igalia.com,lkp@intel.com,jayakumar.lkml@gmail.com,deller@gmx.de,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fb_defio-do-not-use-deprecated-page-mapping-index-fields-fix.patch added to mm-unstable branch
Message-Id: <20250204003656.2F82DC4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fbdev: have CONFIG_FB_DEFERRED_IO depend on CONFIG_MMU
has been added to the -mm mm-unstable branch.  Its filename is
     fb_defio-do-not-use-deprecated-page-mapping-index-fields-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fb_defio-do-not-use-deprecated-page-mapping-index-fields-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: fbdev: have CONFIG_FB_DEFERRED_IO depend on CONFIG_MMU
Date: Sat, 1 Feb 2025 16:56:02 +0000

Frame buffer deferred I/O is entirely reliant on the page faulting
mechanism (and thus, an MMU) to function.

Express this dependency in the Kconfig, as otherwise randconfig could
generate invalid configurations resulting in build errors.

Link: https://lkml.kernel.org/r/e38046bc-fa35-4f4d-b0e8-00ac4637c725@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202502020030.MnEJ847Z-lkp@intel.com/
Cc: David Hildenbrand <david@redhat.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Kajtar Zsolt <soci@c64.rulez.org>
Cc: Maíra Canal <mcanal@igalia.com>
Cc: Mattew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbdev/core/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/fbdev/core/Kconfig~fb_defio-do-not-use-deprecated-page-mapping-index-fields-fix
+++ a/drivers/video/fbdev/core/Kconfig
@@ -135,6 +135,7 @@ config FB_SYSMEM_FOPS
 config FB_DEFERRED_IO
 	bool
 	depends on FB_CORE
+	depends on MMU
 
 config FB_DMAMEM_HELPERS
 	bool
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-refactor-rmap_walk_file-to-separate-out-traversal-logic.patch
mm-provide-mapping_wrprotect_page-function.patch
fb_defio-do-not-use-deprecated-page-mapping-index-fields.patch
fb_defio-do-not-use-deprecated-page-mapping-index-fields-fix.patch
mm-simplify-vma-merge-structure-and-expand-comments.patch
mm-further-refactor-commit_merge.patch
mm-eliminate-adj_start-parameter-from-commit_merge.patch
mm-make-vmg-target-consistent-and-further-simplify-commit_merge.patch
mm-completely-abstract-unnecessary-adj_start-calculation.patch

