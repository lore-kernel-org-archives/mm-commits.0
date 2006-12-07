From: akpm@osdl.org
Subject: - make-initramfs-printk-a-warning-on-incorrect-cpio-type.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:04:15 -0800
Message-ID: <200612072304.kB7N4FBf030029@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52017 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163839AbWLGXER (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:04:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Make initramfs printk a warning on incorrect cpio type
has been removed from the -mm tree.  Its filename was
     make-initramfs-printk-a-warning-on-incorrect-cpio-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Make initramfs printk a warning on incorrect cpio type
From: Arjan van de Ven <arjan@linux.intel.com>

It turns out that the "-c" option of cpio is highly unportable even between
distros let alone unix variants, and may actually make the wrong type of
cpio archive.  I just wasted quite some time on this, and the kernel can
detect this and warn about it (it's __init memory so it gets thrown away
and thus there is no runtime overhead)

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 init/initramfs.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN init/initramfs.c~make-initramfs-printk-a-warning-on-incorrect-cpio-type init/initramfs.c
--- a/init/initramfs.c~make-initramfs-printk-a-warning-on-incorrect-cpio-type
+++ a/init/initramfs.c
@@ -182,6 +182,10 @@ static int __init do_collect(void)
 
 static int __init do_header(void)
 {
+	if (memcmp(collected, "070707", 6)==0) {
+		error("incorrect cpio method used: use -H newc option");
+		return 1;
+	}
 	if (memcmp(collected, "070701", 6)) {
 		error("no cpio magic");
 		return 1;
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch
remove-the-old-bd_mutex-lockdep-annotation.patch
new-bd_mutex-lockdep-annotation.patch
round_jiffies-infrastructure.patch
round_jiffies-infrastructure-fix.patch
user-of-the-jiffies-rounding-patch-ata-subsystem.patch
user-of-the-jiffies-rounding-code-jbd.patch
user-of-the-jiffies-rounding-code-networking.patch
user-of-the-jiffies-rounding-patch-slab.patch

