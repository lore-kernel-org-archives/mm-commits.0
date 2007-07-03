From: akpm@linux-foundation.org
Subject: + kernel-relayc-make-functions-static.patch added to -mm tree
Date: Tue, 03 Jul 2007 14:37:45 -0700
Message-ID: <200707032137.l63Lbjdn017267@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49401 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751754AbXGCViW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 17:38:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, zanussi@us.ibm.com


The patch titled
     kernel/relay.c: make functions static
has been added to the -mm tree.  Its filename is
     kernel-relayc-make-functions-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel/relay.c: make functions static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Tom Zanussi <zanussi@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff -puN kernel/relay.c~kernel-relayc-make-functions-static kernel/relay.c
--- a/kernel/relay.c~kernel-relayc-make-functions-static
+++ a/kernel/relay.c
@@ -80,7 +80,7 @@ static struct vm_operations_struct relay
  *
  *	Caller should already have grabbed mmap_sem.
  */
-int relay_mmap_buf(struct rchan_buf *buf, struct vm_area_struct *vma)
+static int relay_mmap_buf(struct rchan_buf *buf, struct vm_area_struct *vma)
 {
 	unsigned long length = vma->vm_end - vma->vm_start;
 	struct file *filp = vma->vm_file;
@@ -145,7 +145,7 @@ depopulate:
  *
  *	Returns channel buffer if successful, %NULL otherwise.
  */
-struct rchan_buf *relay_create_buf(struct rchan *chan)
+static struct rchan_buf *relay_create_buf(struct rchan *chan)
 {
 	struct rchan_buf *buf = kzalloc(sizeof(struct rchan_buf), GFP_KERNEL);
 	if (!buf)
@@ -175,7 +175,7 @@ free_buf:
  *
  *	Should only be called from kref_put().
  */
-void relay_destroy_channel(struct kref *kref)
+static void relay_destroy_channel(struct kref *kref)
 {
 	struct rchan *chan = container_of(kref, struct rchan, kref);
 	kfree(chan);
@@ -185,7 +185,7 @@ void relay_destroy_channel(struct kref *
  *	relay_destroy_buf - destroy an rchan_buf struct and associated buffer
  *	@buf: the buffer struct
  */
-void relay_destroy_buf(struct rchan_buf *buf)
+static void relay_destroy_buf(struct rchan_buf *buf)
 {
 	struct rchan *chan = buf->chan;
 	unsigned int i;
@@ -210,7 +210,7 @@ void relay_destroy_buf(struct rchan_buf 
  *	rchan_buf_struct and the channel buffer.  Should only be called from
  *	kref_put().
  */
-void relay_remove_buf(struct kref *kref)
+static void relay_remove_buf(struct kref *kref)
 {
 	struct rchan_buf *buf = container_of(kref, struct rchan_buf, kref);
 	buf->chan->cb->remove_buf_file(buf->dentry);
@@ -223,11 +223,10 @@ void relay_remove_buf(struct kref *kref)
  *
  *	Returns 1 if the buffer is empty, 0 otherwise.
  */
-int relay_buf_empty(struct rchan_buf *buf)
+static int relay_buf_empty(struct rchan_buf *buf)
 {
 	return (buf->subbufs_produced - buf->subbufs_consumed) ? 0 : 1;
 }
-EXPORT_SYMBOL_GPL(relay_buf_empty);
 
 /**
  *	relay_buf_full - boolean, is the channel buffer full?
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
make-drivers-acpi-oslcosi_linux-static.patch
drivers-acpi-processor_throttlingc-make-2-functions.patch
drivers-cpuidle-governors-menuc-make-a-struct-static.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
make-drivers-char-hvc_consoleckhvcd-static.patch
git-dvb.patch
git-input.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-md-accel.patch
git-mmc.patch
git-mtd.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-netdev-all.patch
git-battery.patch
git-selinux.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
remove-the-dead-cyberstormiii_scsi-option.patch
scsi-lpfc-lpfc_initc-remove-unused-variable.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
i386-remove-support-for-the-rise-cpu.patch
i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch
xen-fix-x86-config-dependencies.patch
xen-suppress-abs-symbol-warnings-for-unused-reloc-pointers.patch
mm-slabc-start_cpu_timer-should-be-__cpuinit.patch
handle-kernelcore=-generic-fix.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
swsusp-remove-code-duplication-between-diskc-and-userc-fix.patch
more-scheduled-oss-driver-removal.patch
init-wait-for-asynchronously-scanned-block-devices-fix.patch
kernel-utf-8-handling-fix.patch
remove-sonypi_camera_command.patch
fs-namespacec-should-include-internalh.patch
proper-prototype-for-proc_nr_files.patch
fs-reiserfs-cleanups.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
revoke-core-code.patch
oss-trident-fix-locking-around-write_voice_regs.patch
remove-options-depending-on-oss_obsolete.patch
pm3fb-possible-cleanups.patch
vt8623fbc-make-code-static.patch
kernel-sched_fairc-make-code-static.patch
fs-proc-basec-make-a-struct-static.patch
mm-implement-swap-prefetching-make-mm-swap_prefetchcremove_from_swapped_list.patch
kernel-relayc-make-functions-static.patch
drivers-edac-core-make-functions-static.patch
lockstat-human-readability-tweaks-fix.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
