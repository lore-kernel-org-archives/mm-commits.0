From: akpm@linux-foundation.org
Subject: - net-use-the-common-ascii-hex-helpers.patch removed from -mm tree
Date: Fri, 02 May 2008 17:08:30 -0700
Message-ID: <200805030008.m4308UdB022230@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765054AbYECAIc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 20:08:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     net: use the common ascii hex helpers
has been removed from the -mm tree.  Its filename was
     net-use-the-common-ascii-hex-helpers.patch

This patch was dropped because an updated version will be merged

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
misc-fix-integer-as-null-pointer-warnings.patch
cifs-remove-global_extern-macro.patch
media-use-get_unaligned_-helpers.patch
hid-use-get-put_unaligned_-helpers.patch
input-replace-remaining-__function__-occurrences.patch
input-make-one-bit-signed-bitfields-unsigned.patch
input-ff-memlessc-use-clamp_val-macro.patch
ata-remove-fit-macro.patch
ide-eliminate-fit-macro.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
ide-use-get_unaligned_-helpers.patch
git-mips.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
net-use-get-put_unaligned_-helpers.patch
bluetooth-use-get-put_unaligned_-helpers.patch
irda-use-get_unaligned_-helpers.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-use-get_unaligned_-helpers.patch
block-use-get_unaligned_-helpers.patch
usb-fix-integer-as-null-pointer-sparse-warnings.patch
usb-use-get_unaligned_-helpers.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-tkipc-use-kernel-provided-infrastructure.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
wireless-use-get-put_unaligned_-helpers.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
mmc-make-one-bit-signed-bitfields-unsigned.patch
net-use-the-common-ascii-hex-helpers.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
cris-use-the-common-ascii-hex-helpers.patch
kgdb-use-the-common-ascii-hex-helpers.patch
frv-gdb-stubc-use-the-common-ascii-hex-helpers.patch
mn10300-gdb-stubc-use-the-common-ascii-hex-helpers.patch
mips-gdb-stubc-use-the-common-ascii-hex-helpers.patch
sh-kgdb-stubc-sh-scic-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
isdn-use-the-common-ascii-hex-helpers.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
video-fix-integer-as-null-pointer-warnings.patch

