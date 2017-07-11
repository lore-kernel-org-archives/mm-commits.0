From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-warn-the-user-when-issues-arise-on-boot-due-to-hugepages.patch
 removed from -mm tree
Date: Tue, 11 Jul 2017 12:23:31 -0700
Message-ID: <20170711192331.X2xQ1-5bk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47646 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933694AbdGKTXc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:23:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, gerald.schaefer@de.ibm.com, kirill.shutemov@linux.intel.com, Liam.Howlett@Oracle.com, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, zhongjiang@huawei.com


The patch titled
     Subject: mm/hugetlb.c: warn the user when issues arise on boot due to hugepages
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-warn-the-user-when-issues-arise-on-boot-due-to-hugepages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Mike said:

: Before sending out this patch, I asked Liam off list why he was doing
: it.  Was it something he just thought would be useful?  Or, was there
: some type of user situation/need.  He said that he had been called in
: to assist on several occasions when a system OOMed during boot.  In
: almost all of these situations, the user had grossly misconfigured huge
: pages.  DB users want to pre-allocate just the right amount of huge
: pages, but sometimes they can be really off.  In such situations, the
: huge page init code just allocates as many huge pages as it can and
: reports the number allocated.  There is no indication that it quit
: allocating because it ran out of memory.  Of course, a user could
: compare the number in the message to what they requested on the command
: line to determine if they got all the huge pages they requested.  The
: thought was that it would be useful to at least flag this situation. 
: That way, the user might be able to better relate the huge page
: allocation failure to the OOM.
: 
: I'm not sure if the e-mail discussion made it obvious that this is
: something he has seen on several occasions.
: 
: I see Michal's point that this will only flag the situation where
: someone configures huge pages very badly.  And, a more extensive look
: at the situation of misconfiguring huge pages might be in order.  But,
: this has happened on several occasions which led to the creation of
: this patch.

[akpm@linux-foundation.org: reposition memfmt() to avoid forward declaration]
Link: http://lkml.kernel.org/r/20170603005413.10380-1-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: zhongjiang <zhongjiang@huawei.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-warn-the-user-when-issues-arise-on-boot-due-to-hugepages mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-warn-the-user-when-issues-arise-on-boot-due-to-hugepages
+++ a/mm/hugetlb.c
@@ -70,6 +70,17 @@ struct mutex *hugetlb_fault_mutex_table
 /* Forward declaration */
 static int hugetlb_acct_memory(struct hstate *h, long delta);
 
+static char * __init memfmt(char *buf, unsigned long n)
+{
+	if (n >= (1UL << 30))
+		sprintf(buf, "%lu GB", n >> 30);
+	else if (n >= (1UL << 20))
+		sprintf(buf, "%lu MB", n >> 20);
+	else
+		sprintf(buf, "%lu KB", n >> 10);
+	return buf;
+}
+
 static inline void unlock_or_release_subpool(struct hugepage_subpool *spool)
 {
 	bool free = (spool->count == 0) && (spool->used_hpages == 0);
@@ -2212,7 +2223,14 @@ static void __init hugetlb_hstate_alloc_
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
@@ -2230,17 +2248,6 @@ static void __init hugetlb_init_hstates(
 	VM_BUG_ON(minimum_order == UINT_MAX);
 }
 
-static char * __init memfmt(char *buf, unsigned long n)
-{
-	if (n >= (1UL << 30))
-		sprintf(buf, "%lu GB", n >> 30);
-	else if (n >= (1UL << 20))
-		sprintf(buf, "%lu MB", n >> 20);
-	else
-		sprintf(buf, "%lu KB", n >> 10);
-	return buf;
-}
