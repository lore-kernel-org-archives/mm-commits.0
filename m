From: akpm@linux-foundation.org
Subject: + kernel-smpc-use-=-for-csd_lock.patch added to -mm tree
Date: Tue, 23 Apr 2013 15:40:23 -0700
Message-ID: <20130423224023.763DF5A42AF@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:59729 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874Ab3DWWkY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Apr 2013 18:40:24 -0400
Received: by mail-ye0-f201.google.com with SMTP id m2so128815yen.2
        for <mm-commits@vger.kernel.org>; Tue, 23 Apr 2013 15:40:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lig.fnst@cn.fujitsu.com, a.p.zijlstra@chello.nl, mingo@elte.hu, oleg@redhat.com


The patch titled
     Subject: kernel/smp.c: use '|=' for csd_lock
has been added to the -mm tree.  Its filename is
     kernel-smpc-use-=-for-csd_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -110,7 +110,7 @@ static void csd_lock_wait(struct call_si
 static void csd_lock(struct call_single_data *data)
 {
 	csd_lock_wait(data);
-	data->flags = CSD_FLAG_LOCK;
+	data->flags |= CSD_FLAG_LOCK;
 
 	/*
 	 * prevent CPU from reordering the above assignment
_

Patches currently in -mm which might be from lig.fnst@cn.fujitsu.com are

linux-next.patch
kernel-smpc-use-=-for-csd_lock.patch
semaphore-give-an-unlikely-for-downs-timeout.patch
semaphore-boolize-semaphore_waiters-up.patch

