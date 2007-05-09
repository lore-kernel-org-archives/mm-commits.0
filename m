From: akpm@linux-foundation.org
Subject: - sanitize-linux-isdn_divertifh-for-userspace.patch removed from -mm tree
Date: Tue, 08 May 2007 19:53:24 -0700
Message-ID: <200705090253.l492rOoP009692@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032226AbXEICxc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:53:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, dwmw2@infradead.org, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     sanitize linux/isdn_divertif.h for userspace
has been removed from the -mm tree.  Its filename was
     sanitize-linux-isdn_divertifh-for-userspace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sanitize linux/isdn_divertif.h for userspace
From: Mike Frysinger <vapier@gentoo.org>

the isdn_divertif contains kernel-only references so I've wrapped them in
__KERNEL__ and add proper #include statements.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Karsten Keil <kkeil@suse.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/Kbuild          |    2 +-
 include/linux/isdn_divertif.h |    5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff -puN include/linux/Kbuild~sanitize-linux-isdn_divertifh-for-userspace include/linux/Kbuild
--- a/include/linux/Kbuild~sanitize-linux-isdn_divertifh-for-userspace
+++ a/include/linux/Kbuild
@@ -92,7 +92,6 @@ header-y += ip_mp_alg.h
 header-y += ipsec.h
 header-y += ipx.h
 header-y += irda.h
-header-y += isdn_divertif.h
 header-y += iso_fs.h
 header-y += ixjuser.h
 header-y += jffs2.h
@@ -242,6 +241,7 @@ unifdef-y += ipv6.h
 unifdef-y += ipv6_route.h
 unifdef-y += isdn.h
 unifdef-y += isdnif.h
+unifdef-y += isdn_divertif.h
 unifdef-y += isdn_ppp.h
 unifdef-y += isicom.h
 unifdef-y += jbd.h
diff -puN include/linux/isdn_divertif.h~sanitize-linux-isdn_divertifh-for-userspace include/linux/isdn_divertif.h
--- a/include/linux/isdn_divertif.h~sanitize-linux-isdn_divertifh-for-userspace
+++ a/include/linux/isdn_divertif.h
@@ -24,6 +24,10 @@
 #define DIVERT_REL_ERR  0x04  /* module not registered */
 #define DIVERT_REG_NAME isdn_register_divert
 
+#ifdef __KERNEL__
+#include <linux/isdnif.h>
+#include <linux/types.h>
+
 /***************************************************************/
 /* structure exchanging data between isdn hl and divert module */
 /***************************************************************/ 
@@ -40,3 +44,4 @@ typedef struct
 /* function register */
 /*********************/
 extern int DIVERT_REG_NAME(isdn_divert_if *);
+#endif
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
dont-force-uclinux-mtd-map-to-be-root-dev.patch
