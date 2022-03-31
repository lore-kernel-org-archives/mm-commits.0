Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D02A1C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 04:40:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbiCaElp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 00:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiCaElo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 00:41:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6209560CC7
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 21:39:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 099E6B81EA0
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 04:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7826CC340EE;
        Thu, 31 Mar 2022 04:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648701594;
        bh=AtfZAE1XM00v/A0EhFrV3l62dSZkTG8qlOvkhuf+FLM=;
        h=Date:To:From:Subject:From;
        b=g+1G0gIwKMWoeJLHjnykA5lmgpqw2THSSOCyBeLikmc1h3PEoMkjAyZZ9ZknRrMrF
         mbMowGNAQ98Lnz4VU6hIY1DXrBAF91udGNLk9DmzeqFKAPD4isTzi9N5SJqQ1Hw4Ti
         CWzfwsZgR7Ca1kYYU80snICSEBoi09ERV5J0gc0I=
Date:   Wed, 30 Mar 2022 21:39:53 -0700
To:     mm-commits@vger.kernel.org, walken@google.com,
        rdunlap@xenotime.net, mingo@elte.hu, dhowells@redhat.com,
        bunk@stusta.de, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mutex-subsystem-synchro-test-module-fix.patch removed from -mm tree
Message-Id: <20220331043954.7826CC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mutex-subsystem-synchro-test-module-fix
has been removed from the -mm tree.  Its filename was
     mutex-subsystem-synchro-test-module-fix.patch

This patch was dropped because it was folded into mutex-subsystem-synchro-test-module.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mutex-subsystem-synchro-test-module-fix

Cc: Adrian Bunk <bunk@stusta.de>
Cc: David Howells <dhowells@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Michel Lespinasse <walken@google.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/synchro-test.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/kernel/synchro-test.c~mutex-subsystem-synchro-test-module-fix
+++ a/kernel/synchro-test.c
@@ -264,7 +264,7 @@ static int spinlocker(void *arg)
 
 	if (verbose >= 2)
 		printk("%s: done\n", current->comm);
-	complete_and_exit(&sp_comp[N], 0);
+	kthread_complete_and_exit(&sp_comp[N], 0);
 }
 
 static int mutexer(void *arg)
@@ -285,7 +285,7 @@ static int mutexer(void *arg)
 
 	if (verbose >= 2)
 		printk("%s: done\n", current->comm);
-	complete_and_exit(&mx_comp[N], 0);
+	kthread_complete_and_exit(&mx_comp[N], 0);
 }
 
 static int semaphorer(void *arg)
@@ -306,7 +306,7 @@ static int semaphorer(void *arg)
 
 	if (verbose >= 2)
 		printk("%s: done\n", current->comm);
-	complete_and_exit(&sm_comp[N], 0);
+	kthread_complete_and_exit(&sm_comp[N], 0);
 }
 
 static int reader(void *arg)
@@ -329,7 +329,7 @@ static int reader(void *arg)
 
 	if (verbose >= 2)
 		printk("%s: done\n", current->comm);
-	complete_and_exit(&rd_comp[N], 0);
+	kthread_complete_and_exit(&rd_comp[N], 0);
 }
 
 static int writer(void *arg)
@@ -352,7 +352,7 @@ static int writer(void *arg)
 
 	if (verbose >= 2)
 		printk("%s: done\n", current->comm);
-	complete_and_exit(&wr_comp[N], 0);
+	kthread_complete_and_exit(&wr_comp[N], 0);
 }
 
 static int downgrader(void *arg)
@@ -380,7 +380,7 @@ static int downgrader(void *arg)
 
 	if (verbose >= 2)
 		printk("%s: done\n", current->comm);
-	complete_and_exit(&dg_comp[N], 0);
+	kthread_complete_and_exit(&dg_comp[N], 0);
 }
 
 static void stop_test(struct timer_list *t)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-shmem-make-shmem_init-return-void-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
mutex-subsystem-synchro-test-module.patch
kernel-forkc-export-kernel_thread-to-modules.patch

