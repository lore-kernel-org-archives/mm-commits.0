From: akpm@linux-foundation.org
Subject: + sanitize-linux-isdn_divertifh-for-userspace.patch added to -mm tree
Date: Thu, 03 May 2007 01:28:00 -0700
Message-ID: <200705030828.l438S03S008066@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751704AbXECI2I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 04:28:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, dwmw2@infradead.org, kkeil@suse.de


The patch titled
     sanitize linux/isdn_divertif.h for userspace
has been added to the -mm tree.  Its filename is
     sanitize-linux-isdn_divertifh-for-userspace.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -241,6 +240,7 @@ unifdef-y += ipv6.h
 unifdef-y += ipv6_route.h
 unifdef-y += isdn.h
 unifdef-y += isdnif.h
+unifdef-y += isdn_divertif.h
 unifdef-y += isdn_ppp.h
 unifdef-y += isicom.h
 unifdef-y += jbd.h
_

Patches currently in -mm which might be from vapier@gentoo.org are

git-cpufreq.patch
git-kbuild.patch
dont-force-uclinux-mtd-map-to-be-root-dev.patch
hide-spinlock-in-linux-quotah-behind-__kernel__.patch
sanitize-linux-isdn_divertifh-for-userspace.patch
