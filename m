From: akpm@osdl.org
Subject: - lockdep-fix-ide-proc-interaction.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:02:13 -0800
Message-ID: <200612072302.kB7N2Daq029832@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51662 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163780AbWLGXCT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:02:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     lockdep: fix ide/proc interaction
has been removed from the -mm tree.  Its filename was
     lockdep-fix-ide-proc-interaction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockdep: fix ide/proc interaction
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

rmmod/3080 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
 (proc_subdir_lock){--..}, at: [<c04a33b0>] remove_proc_entry+0x40/0x191

and this task is already holding:
 (ide_lock){++..}, at: [<c05651a2>] ide_unregister_subdriver+0x39/0xc8
which would create a new lock dependency:
 (ide_lock){++..} -> (proc_subdir_lock){--..}

but this new dependency connects a hard-irq-safe lock:
 (ide_lock){++..}
... which became hard-irq-safe at:
  [<c043c458>] lock_acquire+0x4b/0x6b
  [<c06129d7>] _spin_lock_irqsave+0x22/0x32
  [<c0567870>] ide_intr+0x17/0x1a9
  [<c044eb31>] handle_IRQ_event+0x20/0x4d
  [<c044ebf2>] __do_IRQ+0x94/0xef
  [<c0406771>] do_IRQ+0x9e/0xbd

to a hard-irq-unsafe lock:
 (proc_subdir_lock){--..}
... which became hard-irq-unsafe at:
...  [<c043c458>] lock_acquire+0x4b/0x6b
  [<c06126ab>] _spin_lock+0x19/0x28
  [<c04a32f2>] xlate_proc_name+0x1b/0x99
  [<c04a3547>] proc_create+0x46/0xdf
  [<c04a3642>] create_proc_entry+0x62/0xa5
  [<c07c1972>] proc_misc_init+0x1c/0x1d2
  [<c07c1844>] proc_root_init+0x4c/0xe9
  [<c07ad703>] start_kernel+0x294/0x3b3
  [<00000000>] 0x0

Move ide_remove_proc_entries() out from under ide_lock; there is nothing
that indicates that this is needed.

In specific, the call to ide_add_proc_entries() is unprotected, and there
is nothing else in the file using the respective ->proc fields. Also the
lock order around destroy_proc_ide_interface() suggests this.

Alan sayeth:

  proc_ide_write_settings walks the setting list under ide_setting_sem, read
  ditto.  remove_proc_entry is doing proc side housekeeping.

  Looks fine to me, although that old code is such a mess anything could be
  going on.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/ide.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff -puN drivers/ide/ide.c~lockdep-fix-ide-proc-interaction drivers/ide/ide.c
--- a/drivers/ide/ide.c~lockdep-fix-ide-proc-interaction
+++ a/drivers/ide/ide.c
@@ -973,8 +973,8 @@ ide_settings_t *ide_find_setting_by_name
  *	@drive: drive
  *
  *	Automatically remove all the driver specific settings for this
- *	drive. This function may sleep and must not be called from IRQ
- *	context. The caller must hold ide_setting_sem.
+ *	drive. This function may not be called from IRQ context. The
+ *	caller must hold ide_setting_sem.
  */
  
 static void auto_remove_settings (ide_drive_t *drive)
@@ -1874,11 +1874,22 @@ void ide_unregister_subdriver(ide_drive_
 {
 	unsigned long flags;
 	
-	down(&ide_setting_sem);
-	spin_lock_irqsave(&ide_lock, flags);
 #ifdef CONFIG_PROC_FS
 	ide_remove_proc_entries(drive->proc, driver->proc);
 #endif
+	down(&ide_setting_sem);
+	spin_lock_irqsave(&ide_lock, flags);
+	/*
+	 * ide_setting_sem protects the settings list
+	 * ide_lock protects the use of settings
+	 *
+	 * so we need to hold both, ide_settings_sem because we want to
+	 * modify the settings list, and ide_lock because we cannot take
+	 * a setting out that is being used.
+	 *
+	 * OTOH both ide_{read,write}_setting are only ever used under
+	 * ide_setting_sem.
+	 */
 	auto_remove_settings(drive);
 	spin_unlock_irqrestore(&ide_lock, flags);
 	up(&ide_setting_sem);
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
tty-signal-tty-locking.patch
tty-signal-tty-locking-post-viro-trainwreck.patch
tty-signal-tty-locking-post-viro-trainwreck-fix.patch
tty-signal-tty-locking-post-viro-trainwreck-fix-fix.patch
tty-signal-tty-locking-3270-fix.patch
do_task_stat-dont-take-tty_mutex.patch
do_acct_process-dont-take-tty_mutex.patch
sys_unshare-remove-a-broken-clone_sighand-code.patch
remove-the-old-bd_mutex-lockdep-annotation.patch
new-bd_mutex-lockdep-annotation.patch
remove-lock_key-approach-to-managing-nested-bd_mutex-locks.patch
simplify-some-aspects-of-bd_mutex-nesting.patch
use-mutex_lock_nested-for-bd_mutex-to-avoid-lockdep-warning.patch
avoid-lockdep-warning-in-md.patch
bdev-fix-bd_part_count-leak.patch
lockdep-annotate-nfsd4-recover-code.patch

