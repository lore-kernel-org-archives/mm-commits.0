From: akpm@linux-foundation.org
Subject: - dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch removed from -mm tree
Date: Mon, 05 May 2008 12:16:40 -0700
Message-ID: <200805051916.m45JGepL000318@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761960AbYEETQq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 15:16:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, acme@ghostprotocols.net, mm-commits@vger.kernel.org


The patch titled
     dccp: ccid2.c, ccid3.c use clamp(), clamp_t()
has been removed from the -mm tree.  Its filename was
     dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dccp: ccid2.c, ccid3.c use clamp(), clamp_t()
From: Harvey Harrison <harvey.harrison@gmail.com>

Makes the intention of the nested min/max clear.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/dccp/ccids/ccid2.c |    2 +-
 net/dccp/ccids/ccid3.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN net/dccp/ccids/ccid2.c~dccp-ccid2c-ccid3c-use-clamp-clamp_t net/dccp/ccids/ccid2.c
--- a/net/dccp/ccids/ccid2.c~dccp-ccid2c-ccid3c-use-clamp-clamp_t
+++ a/net/dccp/ccids/ccid2.c
@@ -716,7 +716,7 @@ static int ccid2_hc_tx_init(struct ccid 
 	 * packets for new connections, following the rules from [RFC3390]".
 	 * We need to convert the bytes of RFC3390 into the packets of RFC 4341.
 	 */
-	hctx->ccid2hctx_cwnd = min(4U, max(2U, 4380U / dp->dccps_mss_cache));
+	hctx->ccid2hctx_cwnd = clamp(4380U / dp->dccps_mss_cache, 2U, 4U);
 
 	/* Make sure that Ack Ratio is enabled and within bounds. */
 	max_ratio = DIV_ROUND_UP(hctx->ccid2hctx_cwnd, 2);
diff -puN net/dccp/ccids/ccid3.c~dccp-ccid2c-ccid3c-use-clamp-clamp_t net/dccp/ccids/ccid3.c
--- a/net/dccp/ccids/ccid3.c~dccp-ccid2c-ccid3c-use-clamp-clamp_t
+++ a/net/dccp/ccids/ccid3.c
@@ -88,8 +88,8 @@ static void ccid3_hc_tx_set_state(struct
 static inline u64 rfc3390_initial_rate(struct sock *sk)
 {
 	const struct ccid3_hc_tx_sock *hctx = ccid3_hc_tx_sk(sk);
-	const __u32 w_init = min_t(__u32, 4 * hctx->ccid3hctx_s,
-				   max_t(__u32, 2 * hctx->ccid3hctx_s, 4380));
+	const __u32 w_init = clamp_t(__u32, 4380U,
+			2 * hctx->ccid3hctx_s, 4 * hctx->ccid3hctx_s);
 
 	return scaled_div(w_init << 6, hctx->ccid3hctx_rtt);
 }
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
misc-fix-integer-as-null-pointer-warnings.patch
cifs-remove-global_extern-macro.patch
media-use-get_unaligned_-helpers.patch
hid-use-get-put_unaligned_-helpers.patch
git-input.patch
ata-remove-fit-macro.patch
git-mips.patch
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
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
video-fix-integer-as-null-pointer-warnings.patch

