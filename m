From: akpm@linux-foundation.org
Subject: + initramfs-debug-detected-compression-method.patch added to -mm
 tree
Date: Tue, 18 Feb 2014 16:12:39 -0800
Message-ID: <5303f6f7.IPl/PJvJTJRa89AX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51725 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaBSAMk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Feb 2014 19:12:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dan@danweeks.net

Subject: + initramfs-debug-detected-compression-method.patch added to -mm tree
To: dan@danweeks.net
From: akpm@linux-foundation.org
Date: Tue, 18 Feb 2014 16:12:39 -0800


The patch titled
     Subject: initramfs: debug detected compression method
has been added to the -mm tree.  Its filename is
     initramfs-debug-detected-compression-method.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/initramfs-debug-detected-compression-method.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/initramfs-debug-detected-compression-method.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Daniel M. Weeks" <dan@danweeks.net>
Subject: initramfs: debug detected compression method

This can greatly aid in narrowing down the real source of initramfs
problems such as failures related to the compression of the in-kernel
initramfs when an external initramfs is in use as well.  Existing errors
are ambiguous as to which initramfs is a problem and why.

Signed-off-by: Daniel M. Weeks <dan@danweeks.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |    1 +
 lib/decompress.c |    4 ++++
 2 files changed, 5 insertions(+)

diff -puN init/initramfs.c~initramfs-debug-detected-compression-method init/initramfs.c
--- a/init/initramfs.c~initramfs-debug-detected-compression-method
+++ a/init/initramfs.c
@@ -455,6 +455,7 @@ static char * __init unpack_to_rootfs(ch
 		}
 		this_header = 0;
 		decompress = decompress_method(buf, len, &compress_name);
+		printk(KERN_DEBUG "Detected %s compressed data\n", compress_name);
 		if (decompress) {
 			res = decompress(buf, len, NULL, flush_buffer, NULL,
 				   &my_inptr, error);
diff -puN lib/decompress.c~initramfs-debug-detected-compression-method lib/decompress.c
--- a/lib/decompress.c~initramfs-debug-detected-compression-method
+++ a/lib/decompress.c
@@ -17,6 +17,8 @@
 #include <linux/string.h>
 #include <linux/init.h>
 
+#include <linux/printk.h>
+
 #ifndef CONFIG_DECOMPRESS_GZIP
 # define gunzip NULL
 #endif
@@ -61,6 +63,8 @@ decompress_fn __init decompress_method(c
 	if (len < 2)
 		return NULL;	/* Need at least this much... */
 
+	printk(KERN_DEBUG "Compressed data magic: %#.2x %#.2x\n", inbuf[0], inbuf[1]);
+
 	for (cf = compressed_formats; cf->name; cf++) {
 		if (!memcmp(inbuf, cf->magic, 2))
 			break;
_

Patches currently in -mm which might be from dan@danweeks.net are

scripts-gen_initramfs_listsh-fix-flags-for-initramfs-lz4-compression.patch
initramfs-debug-detected-compression-method.patch
initramfs-debug-detected-compression-method-fix.patch

