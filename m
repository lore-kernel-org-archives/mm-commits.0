From: akpm@osdl.org
Subject: - sched-correct-output-of-show_state.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:07:44 -0800
Message-ID: <200612072307.kB7N7i1H030389@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52818 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163958AbWLGXHq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:07:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ccaputo@alt.net, mm-commits@vger.kernel.org


The patch titled
     sched: correct output of show_state()
has been removed from the -mm tree.  Its filename was
     sched-correct-output-of-show_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sched: correct output of show_state()
From: Chris Caputo <ccaputo@alt.net>

At present show_state prints a header the does not match the output of
show_task, as follows:

-
                                               sibling
  task             PC      pid father child younger older
init          S 00000000     0     1      0     2               (NOTLB)
-

This patch corrects the output of show_state so that the header is
aligned with the data, ala:

-
                         free                        sibling
  task             PC    stack   pid father child younger older
init          S 00000000     0     1      0     2               (NOTLB)
-

Signed-off-by: Chris Caputo <ccaputo@alt.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sched.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/sched.c~sched-correct-output-of-show_state kernel/sched.c
--- a/kernel/sched.c~sched-correct-output-of-show_state
+++ a/kernel/sched.c
@@ -4822,12 +4822,12 @@ void show_state_filter(unsigned long sta
 
 #if (BITS_PER_LONG == 32)
 	printk("\n"
-	       "                                               sibling\n");
-	printk("  task             PC      pid father child younger older\n");
+	       "                         free                        sibling\n");
+	printk("  task             PC    stack   pid father child younger older\n");
 #else
 	printk("\n"
-	       "                                                       sibling\n");
-	printk("  task                 PC          pid father child younger older\n");
+	       "                                 free                        sibling\n");
+	printk("  task                 PC        stack   pid father child younger older\n");
 #endif
 	read_lock(&tasklist_lock);
 	do_each_thread(g, p) {
_

Patches currently in -mm which might be from ccaputo@alt.net are

origin.patch

