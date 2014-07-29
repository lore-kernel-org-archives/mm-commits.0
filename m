From: akpm@linux-foundation.org
Subject: + kexec-export-free_huge_page-to-vmcoreinfo.patch added to -mm
 tree
Date: Tue, 29 Jul 2014 14:16:36 -0700
Message-ID: <53d80f34.wsYsXcaVAqFd1mNM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:46100 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbaG2VQh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Jul 2014 17:16:37 -0400
Received: by mail-yh0-f74.google.com with SMTP id 29so41757yhl.3
        for <mm-commits@vger.kernel.org>; Tue, 29 Jul 2014 14:16:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kumagai-atsushi@mxc.nes.nec.co.jp, bhe@redhat.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: export free_huge_page to VMCOREINFO
has been added to the -mm tree.  Its filename is
     kexec-export-free_huge_page-to-vmcoreinfo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-export-free_huge_page-to-vmcoreinfo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-export-free_huge_page-to-vmcoreinfo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Subject: kexec: export free_huge_page to VMCOREINFO

PG_head_mask was added into VMCOREINFO to filter huge pages in b3acc56bfe1
("kexec: save PG_head_mask in VMCOREINFO"), but makedumpfile still need
another symbol to filter *hugetlbfs* pages.

If a user hope to filter user pages, makedumpfile tries to exclude them by
checking the condition whether the page is anonymous, but hugetlbfs pages
aren't anonymous while they also be user pages.

We know it's possible to detect them in the same way as PageHuge(),
so we need the start address of free_huge_page():

    int PageHuge(struct page *page)
    {
            if (!PageCompound(page))
                    return 0;

            page = compound_head(page);
            return get_compound_page_dtor(page) == free_huge_page;
    }

For that reason, this patch changes free_huge_page() into public
to export it to VMCOREINFO.

Signed-off-by: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    1 +
 kernel/kexec.c          |    2 ++
 mm/hugetlb.c            |    2 +-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff -puN include/linux/hugetlb.h~kexec-export-free_huge_page-to-vmcoreinfo include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~kexec-export-free_huge_page-to-vmcoreinfo
+++ a/include/linux/hugetlb.h
@@ -80,6 +80,7 @@ int dequeue_hwpoisoned_huge_page(struct
 bool isolate_huge_page(struct page *page, struct list_head *list);
 void putback_active_hugepage(struct page *page);
 bool is_hugepage_active(struct page *page);
+void free_huge_page(struct page *page);
 
 #ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
 pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud);
diff -puN kernel/kexec.c~kexec-export-free_huge_page-to-vmcoreinfo kernel/kexec.c
--- a/kernel/kexec.c~kexec-export-free_huge_page-to-vmcoreinfo
+++ a/kernel/kexec.c
@@ -33,6 +33,7 @@
 #include <linux/swap.h>
 #include <linux/syscore_ops.h>
 #include <linux/compiler.h>
+#include <linux/hugetlb.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -1619,6 +1620,7 @@ static int __init crash_save_vmcoreinfo_
 #endif
 	VMCOREINFO_NUMBER(PG_head_mask);
 	VMCOREINFO_NUMBER(PAGE_BUDDY_MAPCOUNT_VALUE);
+	VMCOREINFO_SYMBOL(free_huge_page);
 
 	arch_crash_save_vmcoreinfo();
 	update_vmcoreinfo_note();
diff -puN mm/hugetlb.c~kexec-export-free_huge_page-to-vmcoreinfo mm/hugetlb.c
--- a/mm/hugetlb.c~kexec-export-free_huge_page-to-vmcoreinfo
+++ a/mm/hugetlb.c
@@ -856,7 +856,7 @@ struct hstate *size_to_hstate(unsigned l
 	return NULL;
 }
 
-static void free_huge_page(struct page *page)
+void free_huge_page(struct page *page)
 {
 	/*
 	 * Can't pass hstate in here because it is called from the
_

Patches currently in -mm which might be from kumagai-atsushi@mxc.nes.nec.co.jp are

kexec-export-free_huge_page-to-vmcoreinfo.patch

