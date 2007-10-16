From: akpm@linux-foundation.org
Subject: - fix-possible-null-deref-on-low-memory-condition-in-capidrvcsend_message.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:40:00 -0700
Message-ID: <200710162040.l9GKe0KG015614@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44522 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761542AbXJPVHv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     fix possible NULL deref on low memory condition in capidrv.c::send_message()
has been removed from the -mm tree.  Its filename was
     fix-possible-null-deref-on-low-memory-condition-in-capidrvcsend_message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix possible NULL deref on low memory condition in capidrv.c::send_message()
From: Jesper Juhl <jesper.juhl@gmail.com>

If we fail to allocate an skb in
drivers/isdn/capi/capidrv.c::send_message(), then we'll end up
dereferencing a NULL pointer.
Since out of memory conditions are not unheard of, I believe it
is better to print a error message and just return rather than
bring down the whole kernel.
Sure, doing this may upset some application, but that's still
better than crashing the whole system.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/capi/capidrv.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/isdn/capi/capidrv.c~fix-possible-null-deref-on-low-memory-condition-in-capidrvcsend_message drivers/isdn/capi/capidrv.c
--- a/drivers/isdn/capi/capidrv.c~fix-possible-null-deref-on-low-memory-condition-in-capidrvcsend_message
+++ a/drivers/isdn/capi/capidrv.c
@@ -506,9 +506,14 @@ static void send_message(capidrv_contr *
 {
 	struct sk_buff *skb;
 	size_t len;
+
 	capi_cmsg2message(cmsg, cmsg->buf);
 	len = CAPIMSG_LEN(cmsg->buf);
 	skb = alloc_skb(len, GFP_ATOMIC);
+	if (!skb) {
+		printk(KERN_ERR "capidrv::send_message: can't allocate mem\n");
+		return;
+	}
 	memcpy(skb_put(skb, len), cmsg->buf, len);
 	if (capi20_put_message(&global.ap, skb) != CAPI_NOERROR)
 		kfree_skb(skb);
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-alsa.patch
git-cifs.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
git-xfs.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
avoid-a-small-unlikely-memory-leak-in-proc_read_escd.patch
docs-ramdisk-initrd-initramfs-corrections.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
add-a-missing-00-index-file-for-documentation-vm.patch
add-a-missing-00-index-file-for-documentation-vm-fix.patch
add-a-00-index-file-to-documentation-mips.patch
add-a-00-index-file-to-documentation-sysctl.patch
add-a-00-index-file-to-documentation-telephony.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch
cyclades-avoid-label-defined-but-not-used-warning.patch
