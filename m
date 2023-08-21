Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FAE8EE49AE
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:47:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbjHUUro (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbjHUUr1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:47:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5E713E
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:47:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F65F64B73
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:47:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66DD2C433C8;
        Mon, 21 Aug 2023 20:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650836;
        bh=jPHWppaeoku0kwmB7MVgUrUI2U8te9jnpukGV4KpK38=;
        h=Date:To:From:Subject:From;
        b=JcjJrpl1bNI0Iv53UTifTUm76GwkmxXuHJkQIhxwVVNtMdnYpyzYUgHFnGYo67aa4
         3aS0V3WCxyYM4KbZ/P82i37/YeJTy5wwekxDnQWDJikbYL26ClSvCpavvsBzpw/pH/
         nu/5cjq4dB9iGBMIAtze3aiK861ukiCqA2PbzQeo=
Date:   Mon, 21 Aug 2023 13:47:15 -0700
To:     mm-commits@vger.kernel.org, keescook@chromium.org,
        jirislaby@kernel.org, ebiederm@xmission.com, brauner@kernel.org,
        oleg@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kill-do_each_thread.patch removed from -mm tree
Message-Id: <20230821204716.66DD2C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kill do_each_thread()
has been removed from the -mm tree.  Its filename was
     kill-do_each_thread.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: kill do_each_thread()
Date: Thu, 17 Aug 2023 18:37:08 +0200

Eric has pointed out that we still have 3 users of do_each_thread().
Change them to use for_each_process_thread() and kill this helper.

There is a subtle change, after do_each_thread/while_each_thread g == t ==
&init_task, while after for_each_process_thread() they both point to
nowhere, but this doesn't matter.

> Why is for_each_process_thread() better than do_each_thread()?

Say, for_each_process_thread() is rcu safe, do_each_thread() is not.

And certainly

	for_each_process_thread(p, t) {
		do_something(p, t);
	}

looks better than

	do_each_thread(p, t) {
		do_something(p, t);
	} while_each_thread(p, t);

And again, there are only 3 users of this awkward helper left.  It should
have been killed years ago and in fact I thought it had already been
killed.  It uses while_each_thread() which needs some changes.

Link: https://lkml.kernel.org/r/20230817163708.GA8248@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: "Christian Brauner (Microsoft)" <brauner@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jiri Slaby <jirislaby@kernel.org> # tty/serial
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/mca.c       |    4 ++--
 drivers/tty/tty_io.c         |    4 ++--
 fs/fs_struct.c               |    4 ++--
 include/linux/sched/signal.h |    7 -------
 4 files changed, 6 insertions(+), 13 deletions(-)

--- a/arch/ia64/kernel/mca.c~kill-do_each_thread
+++ a/arch/ia64/kernel/mca.c
@@ -1630,10 +1630,10 @@ default_monarch_init_process(struct noti
 	}
 	printk("\n\n");
 	if (read_trylock(&tasklist_lock)) {
-		do_each_thread (g, t) {
+		for_each_process_thread(g, t) {
 			printk("\nBacktrace of pid %d (%s)\n", t->pid, t->comm);
 			show_stack(t, NULL, KERN_DEFAULT);
-		} while_each_thread (g, t);
+		}
 		read_unlock(&tasklist_lock);
 	}
 	/* FIXME: This will not restore zapped printk locks. */
--- a/drivers/tty/tty_io.c~kill-do_each_thread
+++ a/drivers/tty/tty_io.c
@@ -3031,7 +3031,7 @@ void __do_SAK(struct tty_struct *tty)
 	} while_each_pid_task(session, PIDTYPE_SID, p);
 
 	/* Now kill any processes that happen to have the tty open */
-	do_each_thread(g, p) {
+	for_each_process_thread(g, p) {
 		if (p->signal->tty == tty) {
 			tty_notice(tty, "SAK: killed process %d (%s): by controlling tty\n",
 				   task_pid_nr(p), p->comm);
@@ -3048,7 +3048,7 @@ void __do_SAK(struct tty_struct *tty)
 					PIDTYPE_SID);
 		}
 		task_unlock(p);
-	} while_each_thread(g, p);
+	}
 	read_unlock(&tasklist_lock);
 	put_pid(session);
 }
--- a/fs/fs_struct.c~kill-do_each_thread
+++ a/fs/fs_struct.c
@@ -62,7 +62,7 @@ void chroot_fs_refs(const struct path *o
 	int count = 0;
 
 	read_lock(&tasklist_lock);
-	do_each_thread(g, p) {
+	for_each_process_thread(g, p) {
 		task_lock(p);
 		fs = p->fs;
 		if (fs) {
@@ -79,7 +79,7 @@ void chroot_fs_refs(const struct path *o
 			spin_unlock(&fs->lock);
 		}
 		task_unlock(p);
-	} while_each_thread(g, p);
+	}
 	read_unlock(&tasklist_lock);
 	while (count--)
 		path_put(old_root);
--- a/include/linux/sched/signal.h~kill-do_each_thread
+++ a/include/linux/sched/signal.h
@@ -648,13 +648,6 @@ extern void flush_itimer_signals(void);
 
 extern bool current_is_single_threaded(void);
 
-/*
- * Careful: do_each_thread/while_each_thread is a double loop so
- *          'break' will not work as expected - use goto instead.
- */
-#define do_each_thread(g, t) \
-	for (g = t = &init_task ; (g = t = next_task(g)) != &init_task ; ) do
-
 #define while_each_thread(g, t) \
 	while ((t = next_thread(t)) != g)
 
_

Patches currently in -mm which might be from oleg@redhat.com are


