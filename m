From: akpm@linux-foundation.org
Subject: [merged] hugetlbfs-correct-handling-of-negative-input-to-proc-sys-vm-nr_hugepages.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:36:50 -0700
Message-ID: <201103232040.p2NKeQwk028534@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53037 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933329Ab1CWU4D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:56:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pholasek@redhat.com, anton@redhat.com, emunson@mgebm.net, mel@csn.ul.ie, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     hugetlbfs: correct handling of negative input to /proc/sys/vm/nr_hugepages
has been removed from the -mm tree.  Its filename was
     hugetlbfs-correct-handling-of-negative-input-to-proc-sys-vm-nr_hugepages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlbfs: correct handling of negative input to /proc/sys/vm/nr_hugepages
From: Petr Holasek <pholasek@redhat.com>

When the user inserts a negative value into /proc/sys/vm/nr_hugepages it
will cause the kernel to allocate as many hugepages as possible and to
then update /proc/meminfo to reflect this.

This changes the behavior so that the negative input will result in
nr_hugepages value being unchanged.

Signed-off-by: Petr Holasek <pholasek@redhat.com>
Signed-off-by: Anton Arapov <anton@redhat.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Eric B Munson <emunson@mgebm.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/hugetlb.c~hugetlbfs-correct-handling-of-negative-input-to-proc-sys-vm-nr_hugepages mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlbfs-correct-handling-of-negative-input-to-proc-sys-vm-nr_hugepages
+++ a/mm/hugetlb.c
@@ -1872,8 +1872,7 @@ static int hugetlb_sysctl_handler_common
 	unsigned long tmp;
 	int ret;
 
-	if (!write)
-		tmp = h->max_huge_pages;
+	tmp = h->max_huge_pages;
 
 	if (write && h->order >= MAX_ORDER)
 		return -EINVAL;
@@ -1938,8 +1937,7 @@ int hugetlb_overcommit_handler(struct ct
 	unsigned long tmp;
 	int ret;
 
-	if (!write)
-		tmp = h->nr_overcommit_huge_pages;
+	tmp = h->nr_overcommit_huge_pages;
 
 	if (write && h->order >= MAX_ORDER)
 		return -EINVAL;
_

Patches currently in -mm which might be from pholasek@redhat.com are

origin.patch
sysctl-add-some-missing-input-constraint-checks.patch

