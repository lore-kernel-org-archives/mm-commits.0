From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-warn-the-user-when-issues-arise-on-boot-due-to-hugepages.patch
 added to -mm tree
Date: Mon, 05 Jun 2017 15:38:45 -0700
Message-ID: <5935dd75.NeOKtjpxJ8gGxsJW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54452 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751180AbdFEWiq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jun 2017 18:38:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Liam.Howlett@Oracle.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, gerald.schaefer@de.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, n-horiguchi@ah.jp.nec.com, zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: warn the user when issues arise on boot due to hugepages
has been added to the -mm tree.  Its filename is
     mm-hugetlb-warn-the-user-when-issues-arise-on-boot-due-to-hugepages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-warn-the-user-when-issues-arise-on-boot-due-to-hugepages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-warn-the-user-when-issues-arise-on-boot-due-to-hugepages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/hugetlb.c: warn the user when issues arise on boot due to hugepages

When the user specifies too many hugepages or an invalid
default_hugepagesz the communication to the user is implicit in the
allocation message.  This patch adds a warning when the desired page count
is not allocated and prints an error when the default_hugepagesz is
invalid on boot.

During boot hugepages will allocate until there is a fraction of the
hugepage size left.  That is, we allocate until either the request is
satisfied or memory for the pages is exhausted.  When memory for the pages
is exhausted, it will most likely lead to the system failing with the OOM
manager not finding enough (or anything) to kill (unless you're using
really big hugepages in the order of 100s of MB or in the GBs).  The user
will most likely see the OOM messages much later in the boot sequence than
the implicitly stated message.  Worse yet, you may even get an OOM for
each processor which causes many pages of OOMs on modern systems. 
Although these messages will be printed earlier than the OOM messages, at
least giving the user errors and warnings will highlight the configuration
as an issue.  I'm trying to point the user in the right direction by
providing a more robust statement of what is failing.

During the sysctl or echo command, the user can check the results much
easier than if the system hangs during boot and the scenario of having
nothing to OOM for kernel memory is highly unlikely.

Link: http://lkml.kernel.org/r/20170603005413.10380-1-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: zhongjiang <zhongjiang@huawei.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlb-warn-the-user-when-issues-arise-on-boot-due-to-hugepages mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-warn-the-user-when-issues-arise-on-boot-due-to-hugepages
+++ a/mm/hugetlb.c
@@ -69,6 +69,7 @@ struct mutex *hugetlb_fault_mutex_table
 
 /* Forward declaration */
 static int hugetlb_acct_memory(struct hstate *h, long delta);
+static char * __init memfmt(char *buf, unsigned long n);
 
 static inline void unlock_or_release_subpool(struct hugepage_subpool *spool)
 {
@@ -2212,7 +2213,14 @@ static void __init hugetlb_hstate_alloc_
 					 &node_states[N_MEMORY]))
 			break;
 	}
-	h->max_huge_pages = i;
+	if (i < h->max_huge_pages) {
+		char buf[32];
+
+		memfmt(buf, huge_page_size(h)),
+		pr_warn("HugeTLB: allocating %lu of page size %s failed.  Only allocated %lu hugepages.\n",
+			h->max_huge_pages, buf, i);
+		h->max_huge_pages = i;
+	}
 }
 
 static void __init hugetlb_init_hstates(void)
@@ -2808,6 +2816,11 @@ static int __init hugetlb_init(void)
 		return 0;
 
 	if (!size_to_hstate(default_hstate_size)) {
+		if (default_hstate_size != 0) {
+			pr_err("HugeTLB: unsupported default_hugepagesz %lu. Reverting to %lu\n",
+			       default_hstate_size, HPAGE_SIZE);
+		}
+
 		default_hstate_size = HPAGE_SIZE;
 		if (!size_to_hstate(default_hstate_size))
 			hugetlb_add_hstate(HUGETLB_PAGE_ORDER);
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

mm-hugetlb-warn-the-user-when-issues-arise-on-boot-due-to-hugepages.patch

