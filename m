From: akpm@linux-foundation.org
Subject: - net-use-the-common-ascii-hex-helpers.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:07:12 -0700
Message-ID: <200808042007.m74K7CAk027757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51415 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762050AbYHDUHO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:07:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     net: use the common ascii hex helpers
has been removed from the -mm tree.  Its filename was
     net-use-the-common-ascii-hex-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net: use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/skfp/smt.c             |   13 ++++++-------
 net/ipv4/netfilter/ipt_CLUSTERIP.c |    5 ++---
 2 files changed, 8 insertions(+), 10 deletions(-)

diff -puN drivers/net/skfp/smt.c~net-use-the-common-ascii-hex-helpers drivers/net/skfp/smt.c
--- a/drivers/net/skfp/smt.c~net-use-the-common-ascii-hex-helpers
+++ a/drivers/net/skfp/smt.c
@@ -19,6 +19,7 @@
 #include "h/smc.h"
 #include "h/smt_p.h"
 #include <linux/bitrev.h>
+#include <linux/kernel.h>
 
 #define KERNEL
 #include "h/smtstate.h"
@@ -1730,20 +1731,18 @@ void fddi_send_antc(struct s_smc *smc, s
 #endif
 
 #ifdef	DEBUG
-#define hextoasc(x)	"0123456789abcdef"[x]
-
 char *addr_to_string(struct fddi_addr *addr)
 {
 	int	i ;
 	static char	string[6*3] = "****" ;
 
 	for (i = 0 ; i < 6 ; i++) {
-		string[i*3] = hextoasc((addr->a[i]>>4)&0xf) ;
-		string[i*3+1] = hextoasc((addr->a[i])&0xf) ;
-		string[i*3+2] = ':' ;
+		string[i * 3] = hex_asc_hi(addr->a[i]);
+		string[i * 3 + 1] = hex_asc_lo(addr->a[i]);
+		string[i * 3 + 2] = ':';
 	}
-	string[5*3+2] = 0 ;
-	return(string) ;
+	string[5 * 3 + 2] = 0;
+	return(string);
 }
 #endif
 
diff -puN net/ipv4/netfilter/ipt_CLUSTERIP.c~net-use-the-common-ascii-hex-helpers net/ipv4/netfilter/ipt_CLUSTERIP.c
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c~net-use-the-common-ascii-hex-helpers
+++ a/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -475,11 +475,10 @@ static void arp_print(struct arp_payload
 #define HBUFFERLEN 30
 	char hbuffer[HBUFFERLEN];
 	int j,k;
-	const char hexbuf[]= "0123456789abcdef";
 
 	for (k=0, j=0; k < HBUFFERLEN-3 && j < ETH_ALEN; j++) {
-		hbuffer[k++]=hexbuf[(payload->src_hw[j]>>4)&15];
-		hbuffer[k++]=hexbuf[payload->src_hw[j]&15];
+		hbuffer[k++] = hex_asc_hi(payload->src_hw[j]);
+		hbuffer[k++] = hex_asc_lo(payload->src_hw[j]);
 		hbuffer[k++]=':';
 	}
 	hbuffer[--k]='\0';
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
cifs-remove-global_extern-macro.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
v4l-drx397xdc-sparse-annotations.patch
v4l-drx397xdc-replace-__function__-occurrences.patch
input-ads7846c-sparse-lock-annotation.patch
drivers-net-replace-__function__-with-__func__.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
wireless-replace-__function__-with-__func__.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
byteorder-add-a-new-include-linux-swabh-to-define-byteswapping-functions.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers.patch

