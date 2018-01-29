From: akpm@linux-foundation.org
Subject: + mm-hwpoison-disable-memory-error-handling-on-1gb-hugepage.patch tentatively added to -mm tree
Date: Mon, 29 Jan 2018 15:13:16 -0800
Message-ID: <5a6faa8c.EOalgUvFtVScBH2F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43410 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751803AbeA2XNR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jan 2018 18:13:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aneesh.kumar@linux.vnet.ibm.com, khandual@linux.vnet.ibm.com, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hwpoison: disable memory error handling on 1GB hugepage
has been added to the -mm tree.  Its filename is
     mm-hwpoison-disable-memory-error-handling-on-1gb-hugepage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-disable-memory-error-handling-on-1gb-hugepage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-disable-memory-error-handling-on-1gb-hugepage.patch

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
Subject: mm: hwpoison: disable memory error handling on 1GB hugepage

Recently the following BUG was reported:

    Injecting memory failure for pfn 0x3c0000 at process virtual address 0x7fe300000000
    Memory failure: 0x3c0000: recovery action for huge page: Recovered
    BUG: unable to handle kernel paging request at ffff8dfcc0003000
    IP: gup_pgd_range+0x1f0/0xc20
    PGD 17ae72067 P4D 17ae72067 PUD 0
    Oops: 0000 [#1] SMP PTI
    ...
    CPU: 3 PID: 5467 Comm: hugetlb_1gb Not tainted 4.15.0-rc8-mm1-abc+ #3
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.3-1.fc25 04/01/2014

You can easily reproduce this by calling madvise(MADV_HWPOISON) twice on a
1GB hugepage.  This happens because get_user_pages_fast() is not aware of
a migration entry on pud that was created in the 1st madvise() event.

I think that conversion to pud-aligned migration entry is working, but
other MM code walking over page table isn't prepared for it.  We need some
time and effort to make all this work properly, so this patch avoids the
reported bug by just disabling error handling for 1GB hugepage.

Link: http://lkml.kernel.org/r/1517207283-15769-1-git-send-email-n-horiguchi@ah.jp.nec.com
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    1 +
 mm/memory-failure.c |    7 +++++++
 2 files changed, 8 insertions(+)

diff -puN include/linux/mm.h~mm-hwpoison-disable-memory-error-handling-on-1gb-hugepage include/linux/mm.h
--- a/include/linux/mm.h~mm-hwpoison-disable-memory-error-handling-on-1gb-hugepage
+++ a/include/linux/mm.h
@@ -2607,6 +2607,7 @@ enum mf_action_page_type {
 	MF_MSG_POISONED_HUGE,
 	MF_MSG_HUGE,
 	MF_MSG_FREE_HUGE,
+	MF_MSG_GIGANTIC,
 	MF_MSG_UNMAP_FAILED,
 	MF_MSG_DIRTY_SWAPCACHE,
 	MF_MSG_CLEAN_SWAPCACHE,
diff -puN mm/memory-failure.c~mm-hwpoison-disable-memory-error-handling-on-1gb-hugepage mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-disable-memory-error-handling-on-1gb-hugepage
+++ a/mm/memory-failure.c
@@ -508,6 +508,7 @@ static const char * const action_page_ty
 	[MF_MSG_POISONED_HUGE]		= "huge page already hardware poisoned",
 	[MF_MSG_HUGE]			= "huge page",
 	[MF_MSG_FREE_HUGE]		= "free huge page",
+	[MF_MSG_GIGANTIC]		= "gigantic page",
 	[MF_MSG_UNMAP_FAILED]		= "unmapping failed page",
 	[MF_MSG_DIRTY_SWAPCACHE]	= "dirty swapcache page",
 	[MF_MSG_CLEAN_SWAPCACHE]	= "clean swapcache page",
@@ -1090,6 +1091,12 @@ static int memory_failure_hugetlb(unsign
 		return 0;
 	}
 
+	if (hstate_is_gigantic(page_hstate(head))) {
+		action_result(pfn, MF_MSG_GIGANTIC, MF_IGNORED);
+		res = -EBUSY;
+		goto out;
+	}
+
 	if (!hwpoison_user_mappings(p, pfn, trapno, flags, &head)) {
 		action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
 		res = -EBUSY;
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-hwpoison-disable-memory-error-handling-on-1gb-hugepage.patch

