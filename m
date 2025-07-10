Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FE829993F
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 22:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752187158; cv=none; b=iDtkgbEU0Z4caT5SiTG7TR0sa7Xx4RmHJbVQ+ndoPwaKnRiDTWDOtOCd0G+V/kfO6QaRBglDyoRSeFaiVdC6Fu4snDOwXLrerRHHNMpmxWPH7R2d3Wc+ZL8v6dW7iHBXfXiaUQsJJ/AJ6gL7hcVbDsngPDYCR6HvmSqStPFQquk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752187158; c=relaxed/simple;
	bh=sSWC40hHdVCRP/Cah9v+LQ5SsylvfzWFGXJGirOdylM=;
	h=Date:To:From:Subject:Message-Id; b=ViF+mg+7oNj3cPdGDDXPlNRv0CHh9ypDFiUH+UGQjWt7lxSzWYove5AaWNfbAoG7puuLGwxifrfjGSPxa7fTaL6D9psZB1Vn8wxnsXDoydfS+3MkSmWNflk2lv3d2RznrxeEVqbOgpskNG0aToyuHF15yBEKEP3qtUu1FLuumrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jk5NRNyv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jk5NRNyv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77FBC4CEE3;
	Thu, 10 Jul 2025 22:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752187156;
	bh=sSWC40hHdVCRP/Cah9v+LQ5SsylvfzWFGXJGirOdylM=;
	h=Date:To:From:Subject:From;
	b=jk5NRNyvkZXlGI/wHyYqF8GZ1Kt91N8lYcoW76lVvtr4sw2l8xqNdqiRjV79XMwU6
	 FEARUtvRX4Pljp/VpN0E2nBDDHYEhcS5MYvOt3pXCTxQwn6r8N28P2k724znXH43mV
	 RiSmHCs2xuVvcf4COzaRbnIkvj1ObbJYcr0y967o=
Date: Thu, 10 Jul 2025 15:39:15 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,liuqiye2025@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-simplify-min_brk-handling-in-brk.patch added to mm-new branch
Message-Id: <20250710223916.C77FBC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: simplify min_brk handling in brk()
has been added to the -mm mm-new branch.  Its filename is
     mm-simplify-min_brk-handling-in-brk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-simplify-min_brk-handling-in-brk.patch

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
From: Xuanye Liu <liuqiye2025@163.com>
Subject: mm: simplify min_brk handling in brk()
Date: Thu, 10 Jul 2025 10:58:58 +0800

Set min_brk to mm->start_brk by default, and override it with mm->end_data
only when CONFIG_COMPAT_BRK is enabled and brk_randomized is false.

This makes the logic clearer with no functional change.

Link: https://lkml.kernel.org/r/20250710025859.926355-1-liuqiye2025@163.com
Signed-off-by: Xuanye Liu <liuqiye2025@163.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/mmap.c~mm-simplify-min_brk-handling-in-brk
+++ a/mm/mmap.c
@@ -127,18 +127,15 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 
 	origbrk = mm->brk;
 
+	min_brk = mm->start_brk;
 #ifdef CONFIG_COMPAT_BRK
 	/*
 	 * CONFIG_COMPAT_BRK can still be overridden by setting
 	 * randomize_va_space to 2, which will still cause mm->start_brk
 	 * to be arbitrarily shifted
 	 */
-	if (current->brk_randomized)
-		min_brk = mm->start_brk;
-	else
+	if (!current->brk_randomized)
 		min_brk = mm->end_data;
-#else
-	min_brk = mm->start_brk;
 #endif
 	if (brk < min_brk)
 		goto out;
_

Patches currently in -mm which might be from liuqiye2025@163.com are

mm-fix-spelling-issue-in-swaph.patch
mm-remove-outdated-filename-comment-in-percpu-statsc.patch
mm-simplify-min_brk-handling-in-brk.patch

