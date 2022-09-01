Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 329C5C64991
	for <mm-commits@archiver.kernel.org>; Thu,  1 Sep 2022 17:47:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbiIARr3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Sep 2022 13:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234737AbiIARrN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Sep 2022 13:47:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190D575CC5
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 10:46:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 667FF60B7F
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 17:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C4EC433D6;
        Thu,  1 Sep 2022 17:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662054369;
        bh=ZhOm71cqMpdintIsQkKC0aWsPybF6W08rY9n3jvg/+M=;
        h=Date:To:From:Subject:From;
        b=BNY6LbftKiuaEdzX4yibufgvmBg0ai3uf91NIllsfI3yOgUbQhn+K7lhMFkfxcSeU
         H4gkQBzO6NzEz7YTJfO7rA7OCe/GMz3rswwZPP+/uzTRJvOtwx/ftjGrBk6CKOdn4A
         RbqnA3BWlCM+Vz/DNewJHJxDCGhhPsTtTP3aVy6A=
Date:   Thu, 01 Sep 2022 10:46:08 -0700
To:     mm-commits@vger.kernel.org, zhangxuezhi1@coolpad.com,
        yangtiezhu@loongson.cn, xyangxi5@gmail.com, tangmeng@uniontech.com,
        pmladek@suse.com, penguin-kernel@I-love.SAKURA.ne.jp,
        mcgrof@kernel.org, john.ogness@linutronix.de, jirislaby@kernel.org,
        ilpo.jarvinen@linux.intel.com, gregkh@linuxfoundation.org,
        gpiccoli@igalia.com, elver@google.com, davidgow@google.com,
        dankamongmen@gmail.com, daniel.vetter@intel.com,
        chris@chris-wilson.co.uk, bigeasy@linutronix.de,
        daniel.vetter@ffwll.ch, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kernel-panic-drop-unblank_screen-call.patch removed from -mm tree
Message-Id: <20220901174609.B5C4EC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kernel/panic: drop unblank_screen call
has been removed from the -mm tree.  Its filename was
     kernel-panic-drop-unblank_screen-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: kernel/panic: drop unblank_screen call
Date: Tue, 30 Aug 2022 16:50:04 +0200

console_unblank() does this too (called in both places right after), and
with a lot more confidence inspiring approach to locking.

Reconstructing this story is very strange:

In b61312d353da ("oops handling: ensure that any oops is flushed to the
mtdoops console") it is claimed that a printk(" "); flushed out the
console buffer, which was removed in e3e8a75d2acf ("[PATCH] Extract and
use wake_up_klogd()").  In todays kernels this is done way earlier in
console_flush_on_panic with some really nasty tricks.  I didn't bother to
fully reconstruct this all, least because the call to bust_spinlock(0);
gets moved every few years, depending upon how the wind blows (or well,
who screamed loudest about the various issue each call site caused).

Before that commit the only calls to console_unblank() where in s390 arch
code.

The other side here is the console->unblank callback, which was introduced
in 2.1.31 for the vt driver.  Which predates the console_unblank()
function by a lot, which was added (without users) in 2.4.14.3.  So pretty
much impossible to guess at any motivation here.  Also afaict the vt
driver is the only (and always was the only) console driver implementing
the unblank callback, so no idea why a call to console_unblank() was added
for the mtdooops driver - the action actually flushing out the console
buffers is done from console_unlock() only.

Note that as prep for the s390 users the locking was adjusted in 2.5.22 (I
couldn't figure out how to properly reference the BK commit from the
historical git trees) from a normal semaphore to a trylock.

Note that a copy of the direct unblank_screen() call was added to panic()
in c7c3f05e341a ("panic: avoid deadlocks in re-entrant console drivers"),
which partially inlined the bust_spinlocks(0); call.

Long story short, I have no idea why the direct call to unblank_screen
survived for so long (the infrastructure to do it properly existed for
years), nor why it wasn't removed when the console_unblank() call was
finally added.  But it makes a ton more sense to finally do that than not
- it's just better encapsulation to go through the console functions
instead of doing a direct call, so let's dare.  Plus it really does not
make much sense to call the only unblank implementation there is twice,
once without, and once with appropriate locking.

Link: https://lkml.kernel.org/r/20220830145004.430545-1-daniel.vetter@ffwll.ch
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: "Ilpo Järvinen" <ilpo.jarvinen@linux.intel.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Xuezhi Zhang <zhangxuezhi1@coolpad.com>
Cc: Yangxi Xiang <xyangxi5@gmail.com>
Cc: nick black <dankamongmen@gmail.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: Marco Elver <elver@google.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: David Gow <davidgow@google.com>
Cc: tangmeng <tangmeng@uniontech.com>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/vt/vt.c     |    3 ++-
 include/linux/vt_kern.h |    1 -
 kernel/panic.c          |    3 ---
 lib/bust_spinlocks.c    |    3 ---
 4 files changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/tty/vt/vt.c~kernel-panic-drop-unblank_screen-call
+++ a/drivers/tty/vt/vt.c
@@ -154,6 +154,7 @@ static void console_callback(struct work
 static void con_driver_unregister_callback(struct work_struct *ignored);
 static void blank_screen_t(struct timer_list *unused);
 static void set_palette(struct vc_data *vc);
+static void unblank_screen(void);
 
 #define vt_get_kmsg_redirect() vt_kmsg_redirect(-1)
 
@@ -4452,7 +4453,7 @@ EXPORT_SYMBOL(do_unblank_screen);
  * call it with 1 as an argument and so force a mode restore... that may kill
  * X or at least garbage the screen but would also make the Oops visible...
  */
-void unblank_screen(void)
+static void unblank_screen(void)
 {
 	do_unblank_screen(0);
 }
--- a/include/linux/vt_kern.h~kernel-panic-drop-unblank_screen-call
+++ a/include/linux/vt_kern.h
@@ -30,7 +30,6 @@ struct vc_data *vc_deallocate(unsigned i
 void reset_palette(struct vc_data *vc);
 void do_blank_screen(int entering_gfx);
 void do_unblank_screen(int leaving_gfx);
-void unblank_screen(void);
 void poke_blanked_console(void);
 int con_font_op(struct vc_data *vc, struct console_font_op *op);
 int con_set_cmap(unsigned char __user *cmap);
--- a/kernel/panic.c~kernel-panic-drop-unblank_screen-call
+++ a/kernel/panic.c
@@ -329,9 +329,6 @@ void panic(const char *fmt, ...)
 	if (_crash_kexec_post_notifiers)
 		__crash_kexec(NULL);
 
-#ifdef CONFIG_VT
-	unblank_screen();
-#endif
 	console_unblank();
 
 	/*
--- a/lib/bust_spinlocks.c~kernel-panic-drop-unblank_screen-call
+++ a/lib/bust_spinlocks.c
@@ -22,9 +22,6 @@ void bust_spinlocks(int yes)
 	if (yes) {
 		++oops_in_progress;
 	} else {
-#ifdef CONFIG_VT
-		unblank_screen();
-#endif
 		console_unblank();
 		if (--oops_in_progress == 0)
 			wake_up_klogd();
_

Patches currently in -mm which might be from daniel.vetter@ffwll.ch are


