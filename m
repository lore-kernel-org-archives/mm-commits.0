From: akpm@linux-foundation.org
Subject: + net-use-get-put_unaligned_-helpers.patch added to -mm tree
Date: Fri, 02 May 2008 16:09:46 -0700
Message-ID: <200805022309.m42N9kGD019885@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932650AbYEBXT6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 19:19:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, davem@davemloft.net


The patch titled
     net: use get/put_unaligned_* helpers
has been added to the -mm tree.  Its filename is
     net-use-get-put_unaligned_-helpers.patch

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
Subject: net: use get/put_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bridge/br_stp_bpdu.c |    4 ++--
 net/core/filter.c        |    4 ++--
 net/ipv4/cipso_ipv4.c    |   18 ++++++++----------
 net/ipv4/tcp_input.c     |   18 +++++++++---------
 4 files changed, 21 insertions(+), 23 deletions(-)

diff -puN net/bridge/br_stp_bpdu.c~net-use-get-put_unaligned_-helpers net/bridge/br_stp_bpdu.c
--- a/net/bridge/br_stp_bpdu.c~net-use-get-put_unaligned_-helpers
+++ a/net/bridge/br_stp_bpdu.c
@@ -58,12 +58,12 @@ static inline void br_set_ticks(unsigned
 {
 	unsigned long ticks = (STP_HZ * j)/ HZ;
 
-	put_unaligned(htons(ticks), (__be16 *)dest);
+	put_unaligned_be16(ticks, dest);
 }
 
 static inline int br_get_ticks(const unsigned char *src)
 {
-	unsigned long ticks = ntohs(get_unaligned((__be16 *)src));
+	unsigned long ticks = get_unaligned_be16(src);
 
 	return DIV_ROUND_UP(ticks * HZ, STP_HZ);
 }
diff -puN net/core/filter.c~net-use-get-put_unaligned_-helpers net/core/filter.c
--- a/net/core/filter.c~net-use-get-put_unaligned_-helpers
+++ a/net/core/filter.c
@@ -213,7 +213,7 @@ unsigned int sk_run_filter(struct sk_buf
 load_w:
 			ptr = load_pointer(skb, k, 4, &tmp);
 			if (ptr != NULL) {
-				A = ntohl(get_unaligned((__be32 *)ptr));
+				A = get_unaligned_be32(ptr);
 				continue;
 			}
 			break;
@@ -222,7 +222,7 @@ load_w:
 load_h:
 			ptr = load_pointer(skb, k, 2, &tmp);
 			if (ptr != NULL) {
-				A = ntohs(get_unaligned((__be16 *)ptr));
+				A = get_unaligned_be16(ptr);
 				continue;
 			}
 			break;
diff -puN net/ipv4/cipso_ipv4.c~net-use-get-put_unaligned_-helpers net/ipv4/cipso_ipv4.c
--- a/net/ipv4/cipso_ipv4.c~net-use-get-put_unaligned_-helpers
+++ a/net/ipv4/cipso_ipv4.c
@@ -983,7 +983,7 @@ static int cipso_v4_map_cat_enum_valid(c
 		return -EFAULT;
 
 	for (iter = 0; iter < enumcat_len; iter += 2) {
-		cat = ntohs(get_unaligned((__be16 *)&enumcat[iter]));
+		cat = get_unaligned_be16(&enumcat[iter]);
 		if (cat <= cat_prev)
 			return -EFAULT;
 		cat_prev = cat;
@@ -1052,7 +1052,7 @@ static int cipso_v4_map_cat_enum_ntoh(co
 
 	for (iter = 0; iter < net_cat_len; iter += 2) {
 		ret_val = netlbl_secattr_catmap_setbit(secattr->attr.mls.cat,
-				ntohs(get_unaligned((__be16 *)&net_cat[iter])),
+				get_unaligned_be16(&net_cat[iter]),
 				GFP_ATOMIC);
 		if (ret_val != 0)
 			return ret_val;
@@ -1086,10 +1086,9 @@ static int cipso_v4_map_cat_rng_valid(co
 		return -EFAULT;
 
 	for (iter = 0; iter < rngcat_len; iter += 4) {
-		cat_high = ntohs(get_unaligned((__be16 *)&rngcat[iter]));
+		cat_high = get_unaligned_be16(&rngcat[iter]);
 		if ((iter + 4) <= rngcat_len)
-			cat_low = ntohs(
-				get_unaligned((__be16 *)&rngcat[iter + 2]));
+			cat_low = get_unaligned_be16(&rngcat[iter + 2]);
 		else
 			cat_low = 0;
 
@@ -1188,10 +1187,9 @@ static int cipso_v4_map_cat_rng_ntoh(con
 	u16 cat_high;
 
 	for (net_iter = 0; net_iter < net_cat_len; net_iter += 4) {
-		cat_high = ntohs(get_unaligned((__be16 *)&net_cat[net_iter]));
+		cat_high = get_unaligned_be16(&net_cat[net_iter]);
 		if ((net_iter + 4) <= net_cat_len)
-			cat_low = ntohs(
-			      get_unaligned((__be16 *)&net_cat[net_iter + 2]));
+			cat_low = get_unaligned_be16(&net_cat[net_iter + 2]);
 		else
 			cat_low = 0;
 
@@ -1562,7 +1560,7 @@ int cipso_v4_validate(unsigned char **op
 	}
 
 	rcu_read_lock();
-	doi_def = cipso_v4_doi_search(ntohl(get_unaligned((__be32 *)&opt[2])));
+	doi_def = cipso_v4_doi_search(get_unaligned_be32(&opt[2]));
 	if (doi_def == NULL) {
 		err_offset = 2;
 		goto validate_return_locked;
@@ -1843,7 +1841,7 @@ static int cipso_v4_getattr(const unsign
 	if (cipso_v4_cache_check(cipso, cipso[1], secattr) == 0)
 		return 0;
 
-	doi = ntohl(get_unaligned((__be32 *)&cipso[2]));
+	doi = get_unaligned_be32(&cipso[2]);
 	rcu_read_lock();
 	doi_def = cipso_v4_doi_search(doi);
 	if (doi_def == NULL)
diff -puN net/ipv4/tcp_input.c~net-use-get-put_unaligned_-helpers net/ipv4/tcp_input.c
--- a/net/ipv4/tcp_input.c~net-use-get-put_unaligned_-helpers
+++ a/net/ipv4/tcp_input.c
@@ -1172,8 +1172,8 @@ static int tcp_check_dsack(struct tcp_so
 			   struct tcp_sack_block_wire *sp, int num_sacks,
 			   u32 prior_snd_una)
 {
-	u32 start_seq_0 = ntohl(get_unaligned(&sp[0].start_seq));
-	u32 end_seq_0 = ntohl(get_unaligned(&sp[0].end_seq));
+	u32 start_seq_0 = get_unaligned_be32(&sp[0].start_seq);
+	u32 end_seq_0 = get_unaligned_be32(&sp[0].end_seq);
 	int dup_sack = 0;
 
 	if (before(start_seq_0, TCP_SKB_CB(ack_skb)->ack_seq)) {
@@ -1181,8 +1181,8 @@ static int tcp_check_dsack(struct tcp_so
 		tcp_dsack_seen(tp);
 		NET_INC_STATS_BH(LINUX_MIB_TCPDSACKRECV);
 	} else if (num_sacks > 1) {
-		u32 end_seq_1 = ntohl(get_unaligned(&sp[1].end_seq));
-		u32 start_seq_1 = ntohl(get_unaligned(&sp[1].start_seq));
+		u32 end_seq_1 = get_unaligned_be32(&sp[1].end_seq);
+		u32 start_seq_1 = get_unaligned_be32(&sp[1].start_seq);
 
 		if (!after(end_seq_0, end_seq_1) &&
 		    !before(start_seq_0, start_seq_1)) {
@@ -1453,8 +1453,8 @@ tcp_sacktag_write_queue(struct sock *sk,
 	for (i = 0; i < num_sacks; i++) {
 		int dup_sack = !i && found_dup_sack;
 
-		sp[used_sacks].start_seq = ntohl(get_unaligned(&sp_wire[i].start_seq));
-		sp[used_sacks].end_seq = ntohl(get_unaligned(&sp_wire[i].end_seq));
+		sp[used_sacks].start_seq = get_unaligned_be32(&sp_wire[i].start_seq);
+		sp[used_sacks].end_seq = get_unaligned_be32(&sp_wire[i].end_seq);
 
 		if (!tcp_is_sackblock_valid(tp, dup_sack,
 					    sp[used_sacks].start_seq,
@@ -3340,7 +3340,7 @@ void tcp_parse_options(struct sk_buff *s
 			switch (opcode) {
 			case TCPOPT_MSS:
 				if (opsize == TCPOLEN_MSS && th->syn && !estab) {
-					u16 in_mss = ntohs(get_unaligned((__be16 *)ptr));
+					u16 in_mss = get_unaligned_be16(ptr);
 					if (in_mss) {
 						if (opt_rx->user_mss &&
 						    opt_rx->user_mss < in_mss)
@@ -3369,8 +3369,8 @@ void tcp_parse_options(struct sk_buff *s
 				    ((estab && opt_rx->tstamp_ok) ||
 				     (!estab && sysctl_tcp_timestamps))) {
 					opt_rx->saw_tstamp = 1;
-					opt_rx->rcv_tsval = ntohl(get_unaligned((__be32 *)ptr));
-					opt_rx->rcv_tsecr = ntohl(get_unaligned((__be32 *)(ptr+4)));
+					opt_rx->rcv_tsval = get_unaligned_be32(ptr);
+					opt_rx->rcv_tsecr = get_unaligned_be32(ptr + 4);
 				}
 				break;
 			case TCPOPT_SACK_PERM:
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
misc-fix-integer-as-null-pointer-warnings.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
input-make-one-bit-signed-bitfields-unsigned.patch
input-ff-memlessc-use-clamp_val-macro.patch
ata-remove-fit-macro.patch
ide-eliminate-fit-macro.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
git-mips.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
usb-fix-integer-as-null-pointer-sparse-warnings.patch
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
xtensa-replace-remaining-__function__-occurences.patch
mmc-make-one-bit-signed-bitfields-unsigned.patch
lib-add-ascii-hex-helper-functions.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
cris-use-the-common-ascii-hex-helpers.patch
kgdb-use-the-common-ascii-hex-helpers.patch
frv-gdb-stubc-use-the-common-ascii-hex-helpers.patch
mn10300-gdb-stubc-use-the-common-ascii-hex-helpers.patch
mips-gdb-stubc-use-the-common-ascii-hex-helpers.patch
sh-kgdb-stubc-sh-scic-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
video-fix-integer-as-null-pointer-warnings.patch
block-use-get_unaligned_-helpers.patch
ide-use-get_unaligned_-helpers.patch
media-use-get_unaligned_-helpers.patch
scsi-use-get_unaligned_-helpers.patch
usb-use-get_unaligned_-helpers.patch
xfs-use-get_unaligned_-helpers.patch
fs-ldm-use-get_unaligned_-helpers.patch
irda-use-get_unaligned_-helpers.patch
hid-use-get-put_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
bluetooth-use-get-put_unaligned_-helpers.patch
wireless-use-get-put_unaligned_-helpers.patch
net-use-get-put_unaligned_-helpers.patch

