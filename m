From: akpm@linux-foundation.org
Subject: - sched-reorder-struct-sched_rt_entity-to-remove-padding-on-64-bit-builds.patch removed from -mm tree
Date: Tue, 26 Aug 2008 11:45:05 -0700
Message-ID: <200808261845.m7QIj5Y0021373@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759130AbYHZSxx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 14:53:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@rsk.demon.co.uk, a.p.zijlstra@chello.nl, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     sched: reorder struct sched_rt_entity to remove padding on 64 bit builds
has been removed from the -mm tree.  Its filename was
     sched-reorder-struct-sched_rt_entity-to-remove-padding-on-64-bit-builds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sched: reorder struct sched_rt_entity to remove padding on 64 bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>

remove 8 bytes of padding on 64 bit builds
(also removes 8 bytes from task_struct)

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/sched.h~sched-reorder-struct-sched_rt_entity-to-remove-padding-on-64-bit-builds include/linux/sched.h
--- a/include/linux/sched.h~sched-reorder-struct-sched_rt_entity-to-remove-padding-on-64-bit-builds
+++ a/include/linux/sched.h
@@ -974,8 +974,8 @@ struct sched_entity {
 
 struct sched_rt_entity {
 	struct list_head run_list;
-	unsigned int time_slice;
 	unsigned long timeout;
+	unsigned int time_slice;
 	int nr_cpus_allowed;
 
 	struct sched_rt_entity *back;
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

linux-next.patch
hrtimer-reorder-struct-hrtimer-to-save-8-bytes-on-64-bit-builds.patch

