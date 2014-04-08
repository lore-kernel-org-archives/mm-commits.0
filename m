From: akpm@linux-foundation.org
Subject: [merged] initramfs-debug-detected-compression-method.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 14:37:37 -0700
Message-ID: <53446c21.zoRiDHxRBP8bCvli%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57089 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757511AbaDHVhh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:37:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dan@danweeks.net

Subject: [merged] initramfs-debug-detected-compression-method.patch removed from -mm tree
To: dan@danweeks.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:37:37 -0700


The patch titled
     Subject: initramfs: debug detected compression method
has been removed from the -mm tree.  Its filename was
     initramfs-debug-detected-compression-method.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Daniel M. Weeks" <dan@danweeks.net>
Subject: initramfs: debug detected compression method

This can greatly aid in narrowing down the real source of initramfs
problems such as failures related to the compression of the in-kernel
initramfs when an external initramfs is in use as well.  Existing errors
are ambiguous as to which initramfs is a problem and why.

[akpm@linux-foundation.org: use pr_debug()]
Signed-off-by: Daniel M. Weeks <dan@danweeks.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |    1 +
 lib/decompress.c |    3 +++
 2 files changed, 4 insertions(+)

diff -puN init/initramfs.c~initramfs-debug-detected-compression-method init/initramfs.c
--- a/init/initramfs.c~initramfs-debug-detected-compression-method
+++ a/init/initramfs.c
@@ -455,6 +455,7 @@ static char * __init unpack_to_rootfs(ch
 		}
 		this_header = 0;
 		decompress = decompress_method(buf, len, &compress_name);
+		pr_debug("Detected %s compressed data\n", compress_name);
 		if (decompress) {
 			res = decompress(buf, len, NULL, flush_buffer, NULL,
 				   &my_inptr, error);
diff -puN lib/decompress.c~initramfs-debug-detected-compression-method lib/decompress.c
--- a/lib/decompress.c~initramfs-debug-detected-compression-method
+++ a/lib/decompress.c
@@ -16,6 +16,7 @@
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/init.h>
+#include <linux/printk.h>
 
 #ifndef CONFIG_DECOMPRESS_GZIP
 # define gunzip NULL
@@ -61,6 +62,8 @@ decompress_fn __init decompress_method(c
 	if (len < 2)
 		return NULL;	/* Need at least this much... */
 
+	pr_debug("Compressed data magic: %#.2x %#.2x\n", inbuf[0], inbuf[1]);
+
 	for (cf = compressed_formats; cf->name; cf++) {
 		if (!memcmp(inbuf, cf->magic, 2))
 			break;
_

Patches currently in -mm which might be from dan@danweeks.net are

origin.patch

