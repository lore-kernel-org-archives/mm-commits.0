From: akpm@linux-foundation.org
Subject: + hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler.patch added to -mm tree
Date: Wed, 05 Jan 2011 13:00:29 -0800
Message-ID: <201101052100.p05L0TbJ018102@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753042Ab1AEVAs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jan 2011 16:00:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, aarcange@redhat.com, caiqian@redhat.com, nacc@us.ibm.com


The patch titled
     hugetlb: check the return value of string conversion in sysctl handler
has been added to the -mm tree.  Its filename is
     hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler.patch

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
Subject: hugetlb: check the return value of string conversion in sysctl handler
From: Michal Hocko <mhocko@suse.cz>

proc_doulongvec_minmax may fail if the given buffer doesn't represent a
valid number.  If we provide something invalid we will initialize the
resulting value (nr_overcommit_huge_pages in this case) to a random value
from the stack.

The issue was introduced by a3d0c6aa when the default handler has been
replaced by the helper function where we do not check the return value.

Reproducer:
echo "" > /proc/sys/vm/nr_overcommit_hugepages

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: CAI Qian <caiqian@redhat.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler
+++ a/mm/hugetlb.c
@@ -1865,7 +1865,8 @@ static int hugetlb_sysctl_handler_common
 
 	table->data = &tmp;
 	table->maxlen = sizeof(unsigned long);
-	proc_doulongvec_minmax(table, write, buffer, length, ppos);
+	if (proc_doulongvec_minmax(table, write, buffer, length, ppos))
+		return -EINVAL;
 
 	if (write) {
 		NODEMASK_ALLOC(nodemask_t, nodes_allowed,
@@ -1925,7 +1926,8 @@ int hugetlb_overcommit_handler(struct ct
 
 	table->data = &tmp;
 	table->maxlen = sizeof(unsigned long);
-	proc_doulongvec_minmax(table, write, buffer, length, ppos);
+	if (proc_doulongvec_minmax(table, write, buffer, length, ppos))
+		return -EINVAL;
 
 	if (write) {
 		spin_lock(&hugetlb_lock);
_

Patches currently in -mm which might be from mhocko@suse.cz are

hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler.patch
hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler-fix.patch

