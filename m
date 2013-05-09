From: akpm@linux-foundation.org
Subject: [alternative-merged] ipc-shmc-dont-use-auto-variable-hs-in-newseg.patch removed from -mm tree
Date: Thu, 09 May 2013 13:00:18 -0700
Message-ID: <20130509200018.BA9F55A4251@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:54612 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab3EIUAU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 16:00:20 -0400
Received: by mail-qa0-f74.google.com with SMTP id i13so352270qae.3
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 13:00:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, bp@alien8.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/shm.c: don't use auto variable hs in newseg()
has been removed from the -mm tree.  Its filename was
     ipc-shmc-dont-use-auto-variable-hs-in-newseg.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: ipc/shm.c: don't use auto variable hs in newseg()

Fix "warning: unused variable 'hs'" when !CONFIG_HUGETLB_PAGE introduced
by commit af73e4d9506d "hugetlbfs: fix mmap failure in unaligned size
request".

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN ipc/shm.c~ipc-shmc-dont-use-auto-variable-hs-in-newseg ipc/shm.c
--- a/ipc/shm.c~ipc-shmc-dont-use-auto-variable-hs-in-newseg
+++ a/ipc/shm.c
@@ -491,9 +491,8 @@ static int newseg(struct ipc_namespace *
 
 	sprintf (name, "SYSV%08x", key);
 	if (shmflg & SHM_HUGETLB) {
-		struct hstate *hs = hstate_sizelog((shmflg >> SHM_HUGE_SHIFT)
-						& SHM_HUGE_MASK);
-		size_t hugesize = ALIGN(size, huge_page_size(hs));
+		size_t hugesize = ALIGN(size, huge_page_size(hstate_sizelog(
+				(shmflg >> SHM_HUGE_SHIFT) & SHM_HUGE_MASK)));
 
 		/* hugetlb_file_setup applies strict accounting */
 		if (shmflg & SHM_NORESERVE)
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch

