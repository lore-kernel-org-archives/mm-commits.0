From: akpm@linux-foundation.org
Subject: + sched-reorder-struct-sched_rt_entity-to-remove-padding-on-64-bit-builds.patch added to -mm tree
Date: Thu, 14 Aug 2008 02:00:50 -0700
Message-ID: <200808140900.m7E90oN9000495@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758227AbYHNJB0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Aug 2008 05:01:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@rsk.demon.co.uk, a.p.zijlstra@chello.nl, mingo@elte.hu


The patch titled
     sched: reorder struct sched_rt_entity to remove padding on 64 bit builds
has been added to the -mm tree.  Its filename is
     sched-reorder-struct-sched_rt_entity-to-remove-padding-on-64-bit-builds.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

hrtimer-reorder-struct-hrtimer-to-save-8-bytes-on-64-bit-builds.patch
sched-reorder-signal_struct-to-remove-8-bytes-on-64-bit-builds.patch
sched-reorder-struct-sched_rt_entity-to-remove-padding-on-64-bit-builds.patch
reorder-struct-prop_local_single-to-remove-padding-on-64-bit-builds.patch

