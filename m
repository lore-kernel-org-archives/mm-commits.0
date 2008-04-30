From: akpm@linux-foundation.org
Subject: - use-directly-kmalloc-and-kfree-in-init-initramfsc.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:41:37 -0700
Message-ID: <200804300541.m3U5fbus029068@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757480AbYD3Fme (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:42:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thomas.petazzoni@free-electrons.com, jengelh@computergmbh.de, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     directly use kmalloc() and kfree() in init/initramfs.c
has been removed from the -mm tree.  Its filename was
     use-directly-kmalloc-and-kfree-in-init-initramfsc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: directly use kmalloc() and kfree() in init/initramfs.c
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

Instead of using the malloc() and free() wrappers needed by the
lib/inflate.c code for allocations, simply use kmalloc() and kfree() in the
initramfs code.  This is needed for a further lib/inflate.c-related cleanup
patch that will remove the malloc() and free() functions.

Take that opportunity to remove the useless kmalloc() return value
cast.

Based on work done by Matt Mackall.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN init/initramfs.c~use-directly-kmalloc-and-kfree-in-init-initramfsc init/initramfs.c
--- a/init/initramfs.c~use-directly-kmalloc-and-kfree-in-init-initramfsc
+++ a/init/initramfs.c
@@ -57,7 +57,7 @@ static char __init *find_link(int major,
 			continue;
 		return (*p)->name;
 	}
-	q = (struct hash *)malloc(sizeof(struct hash));
+	q = kmalloc(sizeof(struct hash), GFP_KERNEL);
 	if (!q)
 		panic("can't allocate link hash entry");
 	q->major = major;
@@ -77,7 +77,7 @@ static void __init free_hash(void)
 		while (*p) {
 			q = *p;
 			*p = q->next;
-			free(q);
+			kfree(q);
 		}
 	}
 }
@@ -445,10 +445,10 @@ static char * __init unpack_to_rootfs(ch
 {
 	int written;
 	dry_run = check_only;
-	header_buf = malloc(110);
-	symlink_buf = malloc(PATH_MAX + N_ALIGN(PATH_MAX) + 1);
-	name_buf = malloc(N_ALIGN(PATH_MAX));
-	window = malloc(WSIZE);
+	header_buf = kmalloc(110, GFP_KERNEL);
+	symlink_buf = kmalloc(PATH_MAX + N_ALIGN(PATH_MAX) + 1, GFP_KERNEL);
+	name_buf = kmalloc(N_ALIGN(PATH_MAX), GFP_KERNEL);
+	window = kmalloc(WSIZE, GFP_KERNEL);
 	if (!window || !header_buf || !symlink_buf || !name_buf)
 		panic("can't allocate buffers");
 	state = Start;
@@ -484,10 +484,10 @@ static char * __init unpack_to_rootfs(ch
 		buf += inptr;
 		len -= inptr;
 	}
-	free(window);
-	free(name_buf);
-	free(symlink_buf);
-	free(header_buf);
+	kfree(window);
+	kfree(name_buf);
+	kfree(symlink_buf);
+	kfree(header_buf);
 	return message;
 }
 
_

Patches currently in -mm which might be from thomas.petazzoni@free-electrons.com are

origin.patch

