From: akpm@linux-foundation.org
Subject: [merged] kernel-smpc-use-=-for-csd_lock.patch removed from -mm tree
Date: Tue, 07 May 2013 10:47:32 -0700
Message-ID: <20130507174732.7FBF931C15F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:52689 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759209Ab3EGRrd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:47:33 -0400
Received: by mail-gh0-f201.google.com with SMTP id r14so73301ghr.2
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:47:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lig.fnst@cn.fujitsu.com, a.p.zijlstra@chello.nl, mingo@elte.hu, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/smp.c: use '|=' for csd_lock
has been removed from the -mm tree.  Its filename was
     kernel-smpc-use-=-for-csd_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: liguang <lig.fnst@cn.fujitsu.com>
Subject: kernel/smp.c: use '|=' for csd_lock

csd_lock() uses assignment to data->flags rather than |=.  That is not
buggy at present because only one bit (CSD_FLAG_LOCK) is defined in
call_single_data.flags.

But it will become buggy if we later add another flag, so fix it now.

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/smp.c~kernel-smpc-use-=-for-csd_lock kernel/smp.c
--- a/kernel/smp.c~kernel-smpc-use-=-for-csd_lock
+++ a/kernel/smp.c
@@ -109,7 +109,7 @@ static void csd_lock_wait(struct call_si
 static void csd_lock(struct call_single_data *data)
 {
 	csd_lock_wait(data);
-	data->flags = CSD_FLAG_LOCK;
+	data->flags |= CSD_FLAG_LOCK;
 
 	/*
 	 * prevent CPU from reordering the above assignment
_

Patches currently in -mm which might be from lig.fnst@cn.fujitsu.com are

origin.patch

