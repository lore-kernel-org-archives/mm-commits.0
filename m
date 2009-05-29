From: akpm@linux-foundation.org
Subject: + cramfs-move-cramfs-magic-out-of-cramfs_fsh.patch added to -mm tree
Date: Fri, 29 May 2009 16:19:53 -0700
Message-ID: <200905292319.n4TNJrp9012353@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752354AbZE2XUT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 May 2009 19:20:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, viro@zeniv.linux.org.uk


The patch titled
     cramfs: move cramfs magic out of cramfs_fs.h
has been added to the -mm tree.  Its filename is
     cramfs-move-cramfs-magic-out-of-cramfs_fsh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cramfs: move cramfs magic out of cramfs_fs.h
From: Mike Frysinger <vapier@gentoo.org>

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cramfs_fs.h |    3 +--
 include/linux/magic.h     |    2 ++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/cramfs_fs.h~cramfs-move-cramfs-magic-out-of-cramfs_fsh include/linux/cramfs_fs.h
--- a/include/linux/cramfs_fs.h~cramfs-move-cramfs-magic-out-of-cramfs_fsh
+++ a/include/linux/cramfs_fs.h
@@ -2,9 +2,8 @@
 #define __CRAMFS_H
 
 #include <linux/types.h>
+#include <linux/magic.h>
 
-#define CRAMFS_MAGIC		0x28cd3d45	/* some random number */
-#define CRAMFS_MAGIC_WEND	0x453dcd28	/* magic number with the wrong endianess */
 #define CRAMFS_SIGNATURE	"Compressed ROMFS"
 
 /*
diff -puN include/linux/magic.h~cramfs-move-cramfs-magic-out-of-cramfs_fsh include/linux/magic.h
--- a/include/linux/magic.h~cramfs-move-cramfs-magic-out-of-cramfs_fsh
+++ a/include/linux/magic.h
@@ -6,6 +6,8 @@
 #define AFS_SUPER_MAGIC		0x5346414F
 #define AUTOFS_SUPER_MAGIC	0x0187
 #define CODA_SUPER_MAGIC	0x73757245
+#define CRAMFS_MAGIC		0x28cd3d45	/* some random number */
+#define CRAMFS_MAGIC_WEND	0x453dcd28	/* magic number with the wrong endianess */
 #define CUSE_SUPER_MAGIC	0x43555345
 #define DEBUGFS_MAGIC		0x64626720
 #define SYSFS_MAGIC		0x62656572
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch
pcmcia-yenta-add-missing-__devexit-marking.patch
drivers-hvc-add-missing-__devexit_p.patch
plat_nand-add-missing-__devexit_p.patch
irda-new-blackfin-on-chip-sir-irda-driver.patch
virtio_blk-add-missing-__devinitexit-markings.patch
kmap_types-make-most-arches-use-generic-header-file.patch
drivers-char-rtc-disable-legacy-rtc-driver-on-blackfin-systems.patch
gpio-max7301-add-missing-__devexit-marking.patch
istallion-add-missing-__devexit-marking.patch
edac-add-missing-__devexit_p.patch
cramfs-move-cramfs-magic-out-of-cramfs_fsh.patch

