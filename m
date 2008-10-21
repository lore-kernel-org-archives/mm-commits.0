From: akpm@linux-foundation.org
Subject: + misc-replace-remaining-__function__-with-__func__.patch added to -mm tree
Date: Tue, 21 Oct 2008 13:51:01 -0700
Message-ID: <200810212051.m9LKp1Nn017049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901AbYJUUvH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Oct 2008 16:51:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, randy.dunlap@oracle.com


The patch titled
     misc: replace remaining __FUNCTION__ with __func__
has been added to the -mm tree.  Its filename is
     misc-replace-remaining-__function__-with-__func__.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: misc: replace remaining __FUNCTION__ with __func__
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kernel-hacking.tmpl |    2 +-
 arch/arm/mach-iop13xx/include/mach/time.h |    4 ++--
 arch/arm/mach-pxa/include/mach/zylonite.h |    4 ++--
 arch/powerpc/include/asm/ptrace.h         |    2 +-
 drivers/net/usb/pegasus.c                 |    4 ++--
 5 files changed, 8 insertions(+), 8 deletions(-)

diff -puN Documentation/DocBook/kernel-hacking.tmpl~misc-replace-remaining-__function__-with-__func__ Documentation/DocBook/kernel-hacking.tmpl
--- a/Documentation/DocBook/kernel-hacking.tmpl~misc-replace-remaining-__function__-with-__func__
+++ a/Documentation/DocBook/kernel-hacking.tmpl
@@ -1105,7 +1105,7 @@ static struct block_device_operations op
     </listitem>
     <listitem>
      <para>
-      Function names as strings (__FUNCTION__).
+      Function names as strings (__func__).
      </para>
     </listitem>
     <listitem>
diff -puN arch/arm/mach-iop13xx/include/mach/time.h~misc-replace-remaining-__function__-with-__func__ arch/arm/mach-iop13xx/include/mach/time.h
--- a/arch/arm/mach-iop13xx/include/mach/time.h~misc-replace-remaining-__function__-with-__func__
+++ a/arch/arm/mach-iop13xx/include/mach/time.h
@@ -41,7 +41,7 @@ static inline unsigned long iop13xx_core
 		return 1200000000;
 	default:
 		printk("%s: warning unknown frequency, defaulting to 800Mhz\n",
-			__FUNCTION__);
+			__func__);
 	}
 
 	return 800000000;
@@ -60,7 +60,7 @@ static inline unsigned long iop13xx_xsi_
 		return 4;
 	default:
 		printk("%s: warning unknown ratio, defaulting to 2\n",
-			__FUNCTION__);
+			__func__);
 	}
 
 	return 2;
diff -puN arch/arm/mach-pxa/include/mach/zylonite.h~misc-replace-remaining-__function__-with-__func__ arch/arm/mach-pxa/include/mach/zylonite.h
--- a/arch/arm/mach-pxa/include/mach/zylonite.h~misc-replace-remaining-__function__-with-__func__
+++ a/arch/arm/mach-pxa/include/mach/zylonite.h
@@ -30,7 +30,7 @@ extern void zylonite_pxa300_init(void);
 static inline void zylonite_pxa300_init(void)
 {
 	if (cpu_is_pxa300() || cpu_is_pxa310())
-		panic("%s: PXA300/PXA310 not supported\n", __FUNCTION__);
+		panic("%s: PXA300/PXA310 not supported\n", __func__);
 }
 #endif
 
@@ -40,7 +40,7 @@ extern void zylonite_pxa320_init(void);
 static inline void zylonite_pxa320_init(void)
 {
 	if (cpu_is_pxa320())
-		panic("%s: PXA320 not supported\n", __FUNCTION__);
+		panic("%s: PXA320 not supported\n", __func__);
 }
 #endif
 
diff -puN arch/powerpc/include/asm/ptrace.h~misc-replace-remaining-__function__-with-__func__ arch/powerpc/include/asm/ptrace.h
--- a/arch/powerpc/include/asm/ptrace.h~misc-replace-remaining-__function__-with-__func__
+++ a/arch/powerpc/include/asm/ptrace.h
@@ -129,7 +129,7 @@ extern int ptrace_put_reg(struct task_st
 #define CHECK_FULL_REGS(regs)						      \
 do {									      \
 	if ((regs)->trap & 1)						      \
-		printk(KERN_CRIT "%s: partial register set\n", __FUNCTION__); \
+		printk(KERN_CRIT "%s: partial register set\n", __func__); \
 } while (0)
 #endif /* __powerpc64__ */
 
diff -puN drivers/net/usb/pegasus.c~misc-replace-remaining-__function__-with-__func__ drivers/net/usb/pegasus.c
--- a/drivers/net/usb/pegasus.c~misc-replace-remaining-__function__-with-__func__
+++ a/drivers/net/usb/pegasus.c
@@ -168,7 +168,7 @@ static int get_registers(pegasus_t * peg
 			netif_device_detach(pegasus->net);
 		if (netif_msg_drv(pegasus) && printk_ratelimit())
 			dev_err(&pegasus->intf->dev, "%s, status %d\n",
-					__FUNCTION__, ret);
+					__func__, ret);
 		goto out;
 	}
 
@@ -192,7 +192,7 @@ static int set_registers(pegasus_t * peg
 	if (!buffer) {
 		if (netif_msg_drv(pegasus))
 			dev_warn(&pegasus->intf->dev, "out of memory in %s\n",
-					__FUNCTION__);
+					__func__);
 		return -ENOMEM;
 	}
 	memcpy(buffer, data, size);
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
byteorder-remove-direct-includes-of-linux-byteorder-swabh.patch
linux-next.patch
cifs-remove-global_extern-macro.patch
input-ads7846c-sparse-lock-annotation.patch
blackfin-remove-__function__-in-new-serial-driver.patch
blackfin-remove-__function__-in-video-driver.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
scsi-remove-private-implementation-of-get_unaligned_be32.patch
usb-avoid-needless-address-taking-of-function-parameters.patch
misc-replace-remaining-__function__-with-__func__.patch

