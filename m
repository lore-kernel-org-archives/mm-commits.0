From: akpm@linux-foundation.org
Subject: - kernel-relayc-make-functions-static.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:02:28 -0700
Message-ID: <200707192002.l6JK2Sdi019670@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49357 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758143AbXGSUTr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:19:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, zanussi@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     kernel/relay.c: make functions static
has been removed from the -mm tree.  Its filename was
     kernel-relayc-make-functions-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernel/relay.c: make functions static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Tom Zanussi <zanussi@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

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

origin.patch
fix-x86_64-mm-xen-xen-event-channels.patch
git-acpi.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
git-hwmon.patch
git-kbuild.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
git-scsi-misc.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
git-unionfs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
maps2-add-proc-kpagemap-interface.patch
fs-reiserfs-cleanups.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
