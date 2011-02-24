From: akpm@linux-foundation.org
Subject: + hugetlbfs-correct-handling-of-negative-input-to-proc-sys-vm-nr_hugepages.patch added to -mm tree
Date: Thu, 24 Feb 2011 14:13:42 -0800
Message-ID: <201102242213.p1OMDgNQ029784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754655Ab1BXWOA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Feb 2011 17:14:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pholasek@redhat.com, anton@redhat.com, emunson@mgebm.net, mel@csn.ul.ie, n-horiguchi@ah.jp.nec.com, rientjes@google.com


The patch titled
     hugetlbfs: correct handling of negative input to /proc/sys/vm/nr_hugepages
has been added to the -mm tree.  Its filename is
     hugetlbfs-correct-handling-of-negative-input-to-proc-sys-vm-nr_hugepages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Anton Arapov <anton@redhat.com>
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

hugetlbfs-correct-handling-of-negative-input-to-proc-sys-vm-nr_hugepages.patch

