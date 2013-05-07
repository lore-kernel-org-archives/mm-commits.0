From: akpm@linux-foundation.org
Subject: [merged] kernel-smpc-remove-priv-of-call_single_data.patch removed from -mm tree
Date: Tue, 07 May 2013 10:47:35 -0700
Message-ID: <20130507174735.7C99431C1EC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:55127 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759209Ab3EGRrg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:47:36 -0400
Received: by mail-vb0-f74.google.com with SMTP id q16so85106vbe.3
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:47:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lig.fnst@cn.fujitsu.com, a.p.zijlstra@chello.nl, mingo@elte.hu, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/smp.c: remove 'priv' of call_single_data
has been removed from the -mm tree.  Its filename was
     kernel-smpc-remove-priv-of-call_single_data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: liguang <lig.fnst@cn.fujitsu.com>
Subject: kernel/smp.c: remove 'priv' of call_single_data

The 'priv' field is redundant; we can pass data via 'info'.

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |    1 -
 kernel/softirq.c    |    6 ++----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff -puN include/linux/smp.h~kernel-smpc-remove-priv-of-call_single_data include/linux/smp.h
--- a/include/linux/smp.h~kernel-smpc-remove-priv-of-call_single_data
+++ a/include/linux/smp.h
@@ -20,7 +20,6 @@ struct call_single_data {
 	smp_call_func_t func;
 	void *info;
 	u16 flags;
-	u16 priv;
 };
 
 /* total number of cpus in this system (may exceed NR_CPUS) */
diff -puN kernel/softirq.c~kernel-smpc-remove-priv-of-call_single_data kernel/softirq.c
--- a/kernel/softirq.c~kernel-smpc-remove-priv-of-call_single_data
+++ a/kernel/softirq.c
@@ -620,8 +620,7 @@ static void remote_softirq_receive(void
 	unsigned long flags;
 	int softirq;
 
-	softirq = cp->priv;
