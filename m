From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 26 Apr 2017 14:44:28 -0700
Message-ID: <20170426214428.9l9HqHhB8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56680 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754485AbdDZVoa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Apr 2017 17:44:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN sound/firewire/lib.h~linux-next-git-rejects sound/firewire/lib.h
--- a/sound/firewire/lib.h~linux-next-git-rejects
+++ a/sound/firewire/lib.h
@@ -25,61 +25,4 @@ static inline bool rcode_is_permanent_er
 void snd_fw_schedule_registration(struct fw_unit *unit,
 				  struct delayed_work *dwork);
 
-<<<<<<< HEAD
-struct snd_fw_async_midi_port;
-typedef int (*snd_fw_async_midi_port_fill)(
-				struct snd_rawmidi_substream *substream,
-				u8 *buf);
-
-struct snd_fw_async_midi_port {
-	struct fw_device *parent;
-	struct work_struct work;
-	bool idling;
-	ktime_t next_ktime;
-	bool error;
-
-	u64 addr;
-	struct fw_transaction transaction;
-
-	u8 *buf;
-	unsigned int len;
-
-	struct snd_rawmidi_substream *substream;
-	snd_fw_async_midi_port_fill fill;
-	int consume_bytes;
-};
-
-int snd_fw_async_midi_port_init(struct snd_fw_async_midi_port *port,
-		struct fw_unit *unit, u64 addr, unsigned int len,
-		snd_fw_async_midi_port_fill fill);
-void snd_fw_async_midi_port_destroy(struct snd_fw_async_midi_port *port);
-
-/**
- * snd_fw_async_midi_port_run - run transactions for the async MIDI port
- * @port: the asynchronous MIDI port
- * @substream: the MIDI substream
- */
-static inline void
-snd_fw_async_midi_port_run(struct snd_fw_async_midi_port *port,
-			   struct snd_rawmidi_substream *substream)
-{
-	if (!port->error) {
-		port->substream = substream;
-		schedule_work(&port->work);
-	}
-}
-
-/**
- * snd_fw_async_midi_port_finish - finish the asynchronous MIDI port
- * @port: the asynchronous MIDI port
- */
-static inline void
-snd_fw_async_midi_port_finish(struct snd_fw_async_midi_port *port)
-{
-	port->substream = NULL;
-	port->error = false;
-}
-
-=======
->>>>>>> linux-next/akpm-base
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes.patch
mm-use-is_migrate_highatomic-to-simplify-the-code-fix.patch
mm-introduce-memalloc_nofs_saverestore-api-fix.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes.patch
mm-page_alloc-count-movable-pages-when-stealing-from-pageblock-fix.patch
swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
drm-use-set_memoryh-header-fix.patch
drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch
docs-vm-transhuge-fix-few-trivial-typos-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

