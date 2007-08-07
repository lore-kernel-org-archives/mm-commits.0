From: akpm@linux-foundation.org
Subject: + fix-possible-null-deref-on-low-memory-condition-in-capidrvcsend_message.patch added to -mm tree
Date: Tue, 07 Aug 2007 15:09:38 -0700
Message-ID: <200708072209.l77M9cCJ007304@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54811 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964892AbXHGWJt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 18:09:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com, kkeil@suse.de


The patch titled
     fix possible NULL deref on low memory condition in capidrv.c::send_message()
has been added to the -mm tree.  Its filename is
     fix-possible-null-deref-on-low-memory-condition-in-capidrvcsend_message.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 5 insertions(+)

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

git-acpi.patch
git-alsa.patch
au88x0-mem-leak-fix-in-snd_vortex_create.patch
git-agpgart.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
powerpc-clean-out-a-bunch-of-duplicate-includes.patch
git-dvb.patch
git-gfs2-nmw.patch
clean-up-duplicate-includes-in-drivers-input.patch
scripts-ver_linux-correct-printing-of-binutils-version.patch
git-mtd.patch
git-ubi.patch
clean-up-duplicate-includes-in-drivers-net.patch
clean-up-duplicate-includes-in-drivers-atm.patch
clean-up-duplicate-includes-in-net-atm.patch
clean-up-duplicate-includes-in-net-ipv4.patch
clean-up-duplicate-includes-in-net-ipv6.patch
clean-up-duplicate-includes-in-net-sched.patch
clean-up-duplicate-includes-in-net-sunrpc.patch
clean-up-duplicate-includes-in-net-tipc.patch
clean-up-duplicate-includes-in-net-xfrm.patch
dccp-fix-memory-leak-and-clean-up-style-dccp_feat_empty_confirm.patch
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
sh64-arch-sh64-kernel-signalh-duplicate-include-removal.patch
clean-up-duplicate-includes-in-drivers-scsi.patch
mpt-fusion-fix-two-potential-mem-leaks.patch
clean-up-duplicate-includes-in-drivers-block.patch
clean-up-duplicate-includes-in-arch-i386-xen.patch
git-xfs.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-mm.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
clean-up-duplicate-includes-in-drivers-spi.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
fix-several-memory-leaks-in-cr_backlight_probe-take2.patch
fix-a-potential-null-pointer-deref-in-xfs-on-failed-mount.patch
improve-scripts-gcc-versionsh-output-a-bit-when-called-without-args.patch
fix-a-potential-null-pointer-deref-in-the-aic7xxx-ahc_print_register-function.patch
documentation-sysrq-description-of-h-slightly-inaccurate.patch
fix-possible-null-deref-on-low-memory-condition-in-capidrvcsend_message.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
isdn-guard-against-a-potential-null-pointer-dereference-in-old_capi_manufacturer.patch
