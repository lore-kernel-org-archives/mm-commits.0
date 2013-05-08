From: akpm@linux-foundation.org
Subject: + ipc-shmc-dont-use-auto-variable-hs-in-newseg.patch added to -mm tree
Date: Wed, 08 May 2013 15:14:15 -0700
Message-ID: <20130508221415.720A231C15D@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:50557 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab3EHWOQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 18:14:16 -0400
Received: by mail-ve0-f202.google.com with SMTP id 15so231960vea.3
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 15:14:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com, bp@alien8.de


The patch titled
     Subject: ipc/shm.c: don't use auto variable hs in newseg()
has been added to the -mm tree.  Its filename is
     ipc-shmc-dont-use-auto-variable-hs-in-newseg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
ipc-shmc-dont-use-auto-variable-hs-in-newseg.patch

