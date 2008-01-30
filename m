From: akpm@linux-foundation.org
Subject: + add-iscsi-ibft-support-v046.patch added to -mm tree
Date: Wed, 30 Jan 2008 14:01:14 -0800
Message-ID: <200801302201.m0UM1FeE027011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39879 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752895AbYA3WCY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jan 2008 17:02:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konrad@darnok.org, James.Bottomley@HansenPartnership.com, konradr@linux.vnet.ibm.com, michaelc@cs.wisc.edu, pjones@redhat.com


The patch titled
     Add iSCSI iBFT support (v0.4.6)
has been added to the -mm tree.  Its filename is
     add-iscsi-ibft-support-v046.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add iSCSI iBFT support (v0.4.6)
From: Konrad Rzeszutek <konrad@darnok.org>

This patch (v0.4.6) adds /sysfs/firmware/ibft/[initiator|targetX|ethernetX]
directories along with text properties which export the the iSCSI
Boot Firmware Table (iBFT) structure.

What is iSCSI Boot Firmware Table? It is a mechanism for the iSCSI
tools to extract from the machine NICs the iSCSI connection information
so that they can automagically mount the iSCSI share/target. Currently
the iSCSI information is hard-coded in the initrd. The /sysfs entries
are read-only one-name-and-value fields.

The usual set of data exposed is:

# for a in `find /sys/firmware/ibft/ -type f -print`; do  echo -n "$a: ";  cat $a; done
/sys/firmware/ibft/target0/target-name: iqn.2007.com.intel-sbx44:storage-10gb
/sys/firmware/ibft/target0/nic-assoc: 0
/sys/firmware/ibft/target0/chap-type: 0
/sys/firmware/ibft/target0/lun: 00000000
/sys/firmware/ibft/target0/port: 3260
/sys/firmware/ibft/target0/ip-addr: 192.168.79.116
/sys/firmware/ibft/target0/flags: 3
/sys/firmware/ibft/target0/index: 0
/sys/firmware/ibft/ethernet0/mac: 00:11:25:9d:8b:01
/sys/firmware/ibft/ethernet0/vlan: 0
/sys/firmware/ibft/ethernet0/gateway: 192.168.79.254
/sys/firmware/ibft/ethernet0/origin: 0
/sys/firmware/ibft/ethernet0/subnet-mask: 255.255.252.0
/sys/firmware/ibft/ethernet0/ip-addr: 192.168.77.41
/sys/firmware/ibft/ethernet0/flags: 7
/sys/firmware/ibft/ethernet0/index: 0
/sys/firmware/ibft/initiator/initiator-name: iqn.2007-07.com:konrad.initiator
/sys/firmware/ibft/initiator/flags: 3
/sys/firmware/ibft/initiator/index: 0

For full details of the IBFT structure please take a look at:
ftp://ftp.software.ibm.com/systems/support/system_x_pdf/ibm_iscsi_boot_firmware_table_v1.02.pdf

Signed-off-by: Konrad Rzeszutek <konradr@linux.vnet.ibm.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Peter Jones <pjones@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup_32.c    |   14 ---------
 arch/x86/kernel/setup_64.c    |   14 ---------
 drivers/firmware/Kconfig      |    1 
 drivers/firmware/iscsi_ibft.c |   48 +++++++++++++++++++++-----------
 include/linux/iscsi_ibft.h    |   16 ++++++++++
 5 files changed, 48 insertions(+), 45 deletions(-)

diff -puN arch/x86/kernel/setup_32.c~add-iscsi-ibft-support-v046 arch/x86/kernel/setup_32.c
--- a/arch/x86/kernel/setup_32.c~add-iscsi-ibft-support-v046
+++ a/arch/x86/kernel/setup_32.c
@@ -226,20 +226,6 @@ static inline void copy_edd(void)
 }
 #endif
 
-#if defined(CONFIG_ISCSI_IBFT_FIND)
-static void __init reserve_ibft_region(void)
-{
-	unsigned int ibft_len;
-
-	ibft_len = find_ibft();
-	if (ibft_len)
-		reserve_bootmem((unsigned int)ibft_phys,
-				PAGE_ALIGN(ibft_len));
-}
-#else
-static void __init reserve_ibft_region(void) { }
-#endif
-
 int __initdata user_defined_memmap = 0;
 
 /*
diff -puN arch/x86/kernel/setup_64.c~add-iscsi-ibft-support-v046 arch/x86/kernel/setup_64.c
--- a/arch/x86/kernel/setup_64.c~add-iscsi-ibft-support-v046
+++ a/arch/x86/kernel/setup_64.c
@@ -219,20 +219,6 @@ static inline void copy_edd(void)
 }
 #endif
 
-#if defined(CONFIG_ISCSI_IBFT_FIND)
-static void __init reserve_ibft_region(void)
-{
-	unsigned int ibft_len;
-
-	ibft_len = find_ibft();
-	if (ibft_len)
-		reserve_bootmem_generic((unsigned long)ibft_phys,
-					PAGE_ALIGN(ibft_len));
-}
-#else
-static void __init reserve_ibft_region(void) { }
-#endif
-
 #ifdef CONFIG_KEXEC
 static void __init reserve_crashkernel(void)
 {
diff -puN drivers/firmware/Kconfig~add-iscsi-ibft-support-v046 drivers/firmware/Kconfig
--- a/drivers/firmware/Kconfig~add-iscsi-ibft-support-v046
+++ a/drivers/firmware/Kconfig
@@ -95,6 +95,7 @@ config DMIID
 
 config ISCSI_IBFT_FIND
 	bool "iSCSI Boot Firmware Table Attributes"
+	depends on X86 || IA64
 	default n
 	help
 	  This option enables the kernel to find the region of memory
diff -puN drivers/firmware/iscsi_ibft.c~add-iscsi-ibft-support-v046 drivers/firmware/iscsi_ibft.c
--- a/drivers/firmware/iscsi_ibft.c~add-iscsi-ibft-support-v046
+++ a/drivers/firmware/iscsi_ibft.c
@@ -17,8 +17,11 @@
  *
  * Changelog:
  *
+ *  30 Jan 2008 - Konrad Rzeszutek <konradr@linux.vnet.ibm.com>
+ *   Added logic to handle IPv6 addresses. (v0.4.6)
+ *
  *  25 Jan 2008 - Konrad Rzeszutek <konradr@linux.vnet.ibm.com>
- *   Added logic to handle badly not-to-spec iBFTs. (v0.4.5)
+ *   Added logic to handle badly not-to-spec iBFT. (v0.4.5)
  *
  *   4 Jan 2008 - Konrad Rzeszutek <konradr@linux.vnet.ibm.com>
  *   Added __init to function declarations. (v0.4.4)
@@ -64,8 +67,8 @@
 #include <linux/string.h>
 #include <linux/types.h>
 
-#define IBFT_ISCSI_VERSION "0.4.5"
-#define IBFT_ISCSI_DATE "2008-Jan-25"
+#define IBFT_ISCSI_VERSION "0.4."
+#define IBFT_ISCSI_DATE "2008-Jan-30"
 
 MODULE_AUTHOR("Peter Jones <pjones@redhat.com> and \
 Konrad Rzeszutek <konradr@us.ibm.com>");
@@ -272,16 +275,26 @@ static struct ibft_table_header *ibft_de
  */
 static ssize_t sprintf_ipaddr(char *buf, u8 *ip)
 {
+	char *str = buf;
+
 	if (ip[0] == 0 && ip[1] == 0 && ip[2] == 0 && ip[3] == 0 &&
 	    ip[4] == 0 && ip[5] == 0 && ip[6] == 0 && ip[7] == 0 &&
 	    ip[8] == 0 && ip[9] == 0 && ip[10] == 0xff && ip[11] == 0xff) {
 		/*
 		 * IPV4
 		 */
-		return sprintf(buf, "%d.%d.%d.%d\n", ip[12],
+		str += sprintf(buf, NIPQUAD_FMT, ip[12],
 			       ip[13], ip[14], ip[15]);
-	} else
-		return 0;
+	} else {
+		/*
+		 * IPv6
+		 */
+		str += sprintf(str, NIP6_FMT, ntohs(ip[0]), ntohs(ip[1]),
+			       ntohs(ip[2]), ntohs(ip[3]), ntohs(ip[4]),
+			       ntohs(ip[5]), ntohs(ip[6]), ntohs(ip[7]));
+	}
+	str += sprintf(str, "\n");
+	return str - buf;
 }
 
 static ssize_t sprintf_string(char *str, int len, char *buf)
@@ -294,16 +307,19 @@ static ssize_t sprintf_string(char *str,
  */
 static int ibft_verify_hdr(char *t, struct ibft_hdr *hdr, int id, int length)
 {
-#define IBFT_VERIFY_HDR_FIELD(val, name) \
-	if (hdr->val != val) { \
-		printk(KERN_ERR \
-		       "iBFT error: In structure %s field %s expected %d but" \
-		       " found %d!\n", \
-		       t, name, val, hdr->val); \
-		return -ENODEV; \
+	if (hdr->id != id) {
+		printk(KERN_ERR "iBFT error: The field header.id is " \
+				"expected %d but found %d!\n", \
+				id, hdr->id);
+		return -ENODEV;
+	}
+	if (hdr->length != length) {
+		printk(KERN_ERR "iBFT error: The field header.length is " \
+				"expected %d but found %d!\n", \
+				length, hdr->length);
+		return -ENODEV;
 	}
-	IBFT_VERIFY_HDR_FIELD(id, "id");
-	IBFT_VERIFY_HDR_FIELD(length, "length");
+
 	return 0;
 }
 
@@ -542,7 +558,7 @@ static int __init ibft_check_and_alloc_d
 				"while this is %d.\n", hdr->revision);
 		return 1;
 	}
-	for (pos = (u8 *)hdr; pos < (u8 *)hdr + len; pos ++)
+	for (pos = (u8 *)hdr; pos < (u8 *)hdr + len; pos++)
 		csum += *pos;
 
 	if (csum) {
diff -puN include/linux/iscsi_ibft.h~add-iscsi-ibft-support-v046 include/linux/iscsi_ibft.h
--- a/include/linux/iscsi_ibft.h~add-iscsi-ibft-support-v046
+++ a/include/linux/iscsi_ibft.h
@@ -19,7 +19,8 @@
 #ifndef ISCSI_IBFT_H
 #define ISCSI_IBFT_H
 
-#if defined(CONFIG_ISCSI_IBFT_FIND)
+#include <linux/bootmem.h>
+#include <asm/mmzone.h>
 
 /*
  * Physical location of iSCSI Boot Format Table.
@@ -33,6 +34,19 @@ extern void *ibft_phys;
  */
 extern ssize_t find_ibft(void);
 
+
+#ifdef CONFIG_ISCSI_IBFT_FIND
+static inline void __init reserve_ibft_region(void)
+{
+	unsigned int ibft_len;
+
+	ibft_len = find_ibft();
+	if (ibft_len)
+		reserve_bootmem((unsigned int)ibft_phys,
+				PAGE_ALIGN(ibft_len));
+}
+#else
+static inline void __init reserve_ibft_region(void) { }
 #endif
 
 #endif /* ISCSI_IBFT_H */
_

Patches currently in -mm which might be from konrad@darnok.org are

add-iscsi-ibft-support-v045.patch
add-iscsi-ibft-support-v046.patch
add-iscsi-ibft-support-v046-fix.patch
