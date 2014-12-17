From: akpm@linux-foundation.org
Subject: + mm-hugetlb-fix-type-of-hugetlb_treat_as_movable-variable.patch
 added to -mm tree
Date: Wed, 17 Dec 2014 14:03:33 -0800
Message-ID: <5491fdb5.5ztykhzWJWAPKSKI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42891 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbaLQWDe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Dec 2014 17:03:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, dvyukov@google.com, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: fix type of hugetlb_treat_as_movable variable
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-type-of-hugetlb_treat_as_movable-variable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-type-of-hugetlb_treat_as_movable-variable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-type-of-hugetlb_treat_as_movable-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: mm: hugetlb: fix type of hugetlb_treat_as_movable variable

hugetlb_treat_as_movable declared as unsigned long, but
proc_dointvec() used for parsing it:

static struct ctl_table vm_table[] = {
...
	{
		.procname	= "hugepages_treat_as_movable",
		.data		= &hugepages_treat_as_movable,
		.maxlen		= sizeof(int),
		.mode		= 0644,
		.proc_handler	= proc_dointvec,
	},

This seems harmless, but it's better to use int type here.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 +-
 mm/hugetlb.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlb-fix-type-of-hugetlb_treat_as_movable-variable include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-fix-type-of-hugetlb_treat_as_movable-variable
+++ a/include/linux/hugetlb.h
@@ -86,7 +86,7 @@ void free_huge_page(struct page *page);
 pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud);
 #endif
 
-extern unsigned long hugepages_treat_as_movable;
+extern int hugepages_treat_as_movable;
 extern int sysctl_hugetlb_shm_group;
 extern struct list_head huge_boot_pages;
 
diff -puN mm/hugetlb.c~mm-hugetlb-fix-type-of-hugetlb_treat_as_movable-variable mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-fix-type-of-hugetlb_treat_as_movable-variable
+++ a/mm/hugetlb.c
@@ -35,7 +35,7 @@
 #include <linux/node.h>
 #include "internal.h"
 
-unsigned long hugepages_treat_as_movable;
+int hugepages_treat_as_movable;
 
 int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

origin.patch
hugetlb-sysctl-pass-extra1-=-null-rather-then-extra1-=-zero.patch
mm-hugetlb-fix-type-of-hugetlb_treat_as_movable-variable.patch

