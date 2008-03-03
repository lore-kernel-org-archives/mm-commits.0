From: akpm@linux-foundation.org
Subject: - tcp-debug-sl.patch removed from -mm tree
Date: Mon, 03 Mar 2008 12:54:11 -0800
Message-ID: <200803032054.m23KsBkX005919@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47330 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750817AbYCCUyw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 15:54:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ilpo.jarvinen@helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     TCP debug S+L
has been removed from the -mm tree.  Its filename was
     tcp-debug-sl.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: TCP debug S+L
From: "Ilpo Jarvinen" <ilpo.jarvinen@helsinki.fi>

Debugs sacked & lost skb inconstencies in TCP write queue &
verifies fackets_out related variables.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/tcp.h     |   10 ++-
 net/ipv4/tcp_input.c  |   18 +++++
 net/ipv4/tcp_ipv4.c   |  131 ++++++++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_output.c |   23 +++++--
 4 files changed, 174 insertions(+), 8 deletions(-)

diff -puN include/net/tcp.h~tcp-debug-sl include/net/tcp.h
--- a/include/net/tcp.h~tcp-debug-sl
+++ a/include/net/tcp.h
@@ -272,6 +272,9 @@ DECLARE_SNMP_STAT(struct tcp_mib, tcp_st
 #define TCP_ADD_STATS_BH(field, val)	SNMP_ADD_STATS_BH(tcp_statistics, field, val)
 #define TCP_ADD_STATS_USER(field, val)	SNMP_ADD_STATS_USER(tcp_statistics, field, val)
 
+extern void tcp_print_queue(struct sock *sk);
+extern int			tcp_verify_wq(struct sock *sk);
+
 extern void			tcp_v4_err(struct sk_buff *skb, u32);
 
 extern void			tcp_shutdown (struct sock *sk, int how);
@@ -768,7 +771,12 @@ static inline __u32 tcp_current_ssthresh
 }
 
 /* Use define here intentionally to get WARN_ON location shown at the caller */
-#define tcp_verify_left_out(tp)	WARN_ON(tcp_left_out(tp) > tp->packets_out)
+#define tcp_verify_left_out(tp)		\
+	do {\
+		int res; \
+		res = tcp_verify_wq((struct sock *)tp); \
+		WARN_ON(res || tcp_left_out(tp) > tp->packets_out); \
+	} while(0)
 
 extern void tcp_enter_cwr(struct sock *sk, const int set_ssthresh);
 extern __u32 tcp_init_cwnd(struct tcp_sock *tp, struct dst_entry *dst);
diff -puN net/ipv4/tcp_input.c~tcp-debug-sl net/ipv4/tcp_input.c
--- a/net/ipv4/tcp_input.c~tcp-debug-sl
+++ a/net/ipv4/tcp_input.c
@@ -1426,8 +1426,10 @@ tcp_sacktag_write_queue(struct sock *sk,
 	int first_sack_index;
 
 	if (!tp->sacked_out) {
-		if (WARN_ON(tp->fackets_out))
+		if (WARN_ON(tp->fackets_out)) {
+			tcp_verify_left_out(tp);
 			tp->fackets_out = 0;
+		}
 		tcp_highest_sack_reset(sk);
 	}
 
@@ -2136,6 +2138,8 @@ static void tcp_mark_head_lost(struct so
 	struct sk_buff *skb;
 	int cnt;
 
+	tcp_verify_left_out(tp);
+
 	BUG_TRAP(packets <= tp->packets_out);
 	if (tp->lost_skb_hint) {
 		skb = tp->lost_skb_hint;
@@ -2501,6 +2505,8 @@ static void tcp_fastretrans_alert(struct
 				    (tcp_fackets_out(tp) > tp->reordering));
 	int fast_rexmit = 0;
 
+	tcp_verify_left_out(tp);
+
 	if (WARN_ON(!tp->packets_out && tp->sacked_out))
 		tp->sacked_out = 0;
 	if (WARN_ON(!tp->sacked_out && tp->fackets_out))
@@ -2645,6 +2651,10 @@ static void tcp_fastretrans_alert(struct
 	if (do_lost || (tcp_is_fack(tp) && tcp_head_timedout(sk)))
 		tcp_update_scoreboard(sk, fast_rexmit);
 	tcp_cwnd_down(sk, flag);
+
+	WARN_ON(tcp_write_queue_head(sk) == NULL);
+	WARN_ON(!tp->packets_out);
+
 	tcp_xmit_retransmit_queue(sk);
 }
 
@@ -2887,6 +2897,8 @@ static int tcp_clean_rtx_queue(struct so
 		}
 	}
 
+	tcp_verify_left_out(tp);
+
 #if FASTRETRANS_DEBUG > 0
 	BUG_TRAP((int)tp->sacked_out >= 0);
 	BUG_TRAP((int)tp->lost_out >= 0);
@@ -3175,6 +3187,8 @@ static int tcp_ack(struct sock *sk, stru
 	prior_fackets = tp->fackets_out;
 	prior_in_flight = tcp_packets_in_flight(tp);
 
+	tcp_verify_left_out(tp);
+
 	if (!(flag & FLAG_SLOWPATH) && after(ack, prior_snd_una)) {
 		/* Window is constant, pure forward advance.
 		 * No more checks are required.
@@ -3237,6 +3251,8 @@ static int tcp_ack(struct sock *sk, stru
 	if ((flag & FLAG_FORWARD_PROGRESS) || !(flag & FLAG_NOT_DUP))
 		dst_confirm(sk->sk_dst_cache);
 
+	tcp_verify_left_out(tp);
+
 	return 1;
 
 no_queue:
diff -puN net/ipv4/tcp_ipv4.c~tcp-debug-sl net/ipv4/tcp_ipv4.c
--- a/net/ipv4/tcp_ipv4.c~tcp-debug-sl
+++ a/net/ipv4/tcp_ipv4.c
@@ -108,6 +108,137 @@ struct inet_hashinfo __cacheline_aligned
 	.lhash_wait  = __WAIT_QUEUE_HEAD_INITIALIZER(tcp_hashinfo.lhash_wait),
 };
 
+void tcp_print_queue(struct sock *sk)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	struct sk_buff *skb;
+	char s[50+1];
+	char h[50+1];
+	int idx = 0;
+	int i;
+
+	i = 0;
+	tcp_for_write_queue(skb, sk) {
+		if (skb == tcp_send_head(sk))
+			printk(KERN_ERR "head %u %p\n", i, skb);
+		else
+			printk(KERN_ERR "skb %u %p\n", i, skb);
+		i++;
+	}
+
+	tcp_for_write_queue(skb, sk) {
+		if (skb == tcp_send_head(sk))
+			break;
+
+		for (i = 0; i < tcp_skb_pcount(skb); i++) {
+			if (TCP_SKB_CB(skb)->sacked & TCPCB_SACKED_ACKED) {
+				s[idx] = 'S';
+				if (TCP_SKB_CB(skb)->sacked & TCPCB_LOST)
+					s[idx] = 'B';
+
+			} else if (TCP_SKB_CB(skb)->sacked & TCPCB_LOST) {
+				s[idx] = 'L';
+			} else {
+				s[idx] = ' ';
+			}
+			if (s[idx] != ' ' && skb->len < tp->mss_cache)
+				s[idx] += 'a' - 'A';
+
+			if (i == 0) {
+				if (skb == tcp_highest_sack(sk))
+					h[idx] = 'h';
+				else
+					h[idx] = '+';
+			} else {
+				h[idx] = '-';
+			}
+
+			if (++idx >= 50) {
+				s[idx] = 0;
+				h[idx] = 0;
+				printk(KERN_ERR "TCP wq(s) %s\n", s);
+				printk(KERN_ERR "TCP wq(h) %s\n", h);
+				idx = 0;
+			}
+		}
+	}
+	if (idx) {
+		s[idx] = '<';
+		s[idx+1] = 0;
+		h[idx] = '<';
+		h[idx+1] = 0;
+		printk(KERN_ERR "TCP wq(s) %s\n", s);
+		printk(KERN_ERR "TCP wq(h) %s\n", h);
+	}
+	printk(KERN_ERR "l%u s%u f%u p%u seq: su%u hs%u sn%u\n",
+		tp->lost_out, tp->sacked_out, tp->fackets_out, tp->packets_out,
+		tp->snd_una, tcp_highest_sack_seq(tp), tp->snd_nxt);
+}
+
+int tcp_verify_wq(struct sock *sk)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	u32 lost = 0;
+	u32 sacked = 0;
+	u32 packets = 0;
+	u32 fackets = 0;
+	int hs_valid = 0;
+	int inconsitent = 0;
+	struct sk_buff *skb;
+
+	tcp_for_write_queue(skb, sk) {
+		if (skb == tcp_send_head(sk))
+			break;
+
+		if ((fackets == packets) && (skb == tp->highest_sack))
+			hs_valid = 1;
+
+		packets += tcp_skb_pcount(skb);
+
+		if (TCP_SKB_CB(skb)->sacked & TCPCB_SACKED_ACKED) {
+			sacked += tcp_skb_pcount(skb);
+			if (TCP_SKB_CB(skb)->sacked & TCPCB_LOST)
+				printk(KERN_ERR "Sacked bitmap S+L: %u %u-%u/%u\n",
+					TCP_SKB_CB(skb)->sacked,
+					TCP_SKB_CB(skb)->end_seq - tp->snd_una,
+					TCP_SKB_CB(skb)->seq - tp->snd_una,
+					tp->snd_una);
+			fackets = packets;
+			hs_valid = 0;
+		}
+		if (TCP_SKB_CB(skb)->sacked & TCPCB_LOST)
+			lost += tcp_skb_pcount(skb);
+	}
+
+	if ((fackets == packets) && (tp->highest_sack == tcp_send_head(sk)))
+		hs_valid = 1;
+
+	if ((lost != tp->lost_out) ||
+	    (tcp_is_sack(tp) && (sacked != tp->sacked_out)) ||
+	    ((sacked || (tcp_is_sack(tp) && tp->sacked_out)) && !hs_valid) ||
+	    (packets != tp->packets_out) ||
+	    (fackets != tp->fackets_out) ||
+	    tcp_left_out(tp) > tp->packets_out) {
+		printk(KERN_ERR "P: %u L: %u vs %u S: %u vs %u F: %u vs %u w: %u-%u (%u)\n",
+			tp->packets_out,
+			lost, tp->lost_out,
+			sacked, tp->sacked_out,
+			fackets, tp->fackets_out,
+			tp->snd_una, tp->snd_nxt,
+			tp->rx_opt.sack_ok);
+		tcp_print_queue(sk);
+		inconsistent = 1;
+	}
+
+	WARN_ON(lost != tp->lost_out);
+	WARN_ON(tcp_is_sack(tp) && (sacked != tp->sacked_out));
+	WARN_ON(packets != tp->packets_out);
+	WARN_ON(fackets != tp->fackets_out);
+	WARN_ON(tcp_left_out(tp) > tp->packets_out);
+
+	return inconsistent;
+}
+
 static inline __u32 tcp_v4_init_sequence(struct sk_buff *skb)
 {
 	return secure_tcp_sequence_number(ip_hdr(skb)->daddr,
diff -puN net/ipv4/tcp_output.c~tcp-debug-sl net/ipv4/tcp_output.c
--- a/net/ipv4/tcp_output.c~tcp-debug-sl
+++ a/net/ipv4/tcp_output.c
@@ -779,10 +779,9 @@ int tcp_fragment(struct sock *sk, struct
 			tp->lost_out -= diff;
 
 		/* Adjust Reno SACK estimate. */
-		if (tcp_is_reno(tp) && diff > 0) {
+		if (tcp_is_reno(tp) && diff > 0)
 			tcp_dec_pcount_approx_int(&tp->sacked_out, diff);
-			tcp_verify_left_out(tp);
-		}
+
 		tcp_adjust_fackets_out(sk, skb, diff);
 	}
 
@@ -790,6 +789,8 @@ int tcp_fragment(struct sock *sk, struct
 	skb_header_release(buff);
 	tcp_insert_write_queue_after(skb, buff, sk);
 
+	tcp_verify_left_out(tp);
+
 	return 0;
 }
 
@@ -1463,6 +1464,7 @@ static int tcp_write_xmit(struct sock *s
 	} else if (result > 0) {
 		sent_pkts = 1;
 	}
+	tcp_verify_left_out(tp);
 
 	while ((skb = tcp_send_head(sk))) {
 		unsigned int limit;
@@ -1764,6 +1766,7 @@ static void tcp_retrans_try_collapse(str
 	tcp_clear_retrans_hints_partial(tp);
 
 	sk_wmem_free_skb(sk, next_skb);
+	tcp_verify_left_out(tp);
 }
 
 /* Do a simple retransmit without using the backoff mechanisms in
@@ -1795,13 +1798,13 @@ void tcp_simple_retransmit(struct sock *
 		}
 	}
 
+	tcp_verify_left_out(tp);
+
 	tcp_clear_all_retrans_hints(tp);
 
 	if (!lost)
 		return;
 
-	tcp_verify_left_out(tp);
-
 	/* Don't muck with the congestion window here.
 	 * Reason is that we do not increase amount of _data_
 	 * in network, but units changed and effective
@@ -1888,6 +1891,8 @@ int tcp_retransmit_skb(struct sock *sk, 
 			tcp_init_nondata_skb(skb, TCP_SKB_CB(skb)->end_seq - 1,
 					     TCP_SKB_CB(skb)->flags);
 			skb->ip_summed = CHECKSUM_NONE;
+
+			tcp_verify_left_out(tp);
 		}
 	}
 
@@ -1970,8 +1975,10 @@ void tcp_xmit_retransmit_queue(struct so
 			 * packet to be MSS sized and all the
 			 * packet counting works out.
 			 */
-			if (tcp_packets_in_flight(tp) >= tp->snd_cwnd)
+			if (tcp_packets_in_flight(tp) >= tp->snd_cwnd) {
+				tcp_verify_left_out(tp);
 				return;
+			}
 
 			if (sacked & TCPCB_LOST) {
 				if (!(sacked & (TCPCB_SACKED_ACKED|TCPCB_SACKED_RETRANS))) {
@@ -1997,6 +2004,8 @@ void tcp_xmit_retransmit_queue(struct so
 		}
 	}
 
+	tcp_verify_left_out(tp);
+
 	/* OK, demanded retransmission is finished. */
 
 	/* Forward retransmissions are possible only during Recovery. */
@@ -2054,6 +2063,8 @@ void tcp_xmit_retransmit_queue(struct so
 
 		NET_INC_STATS_BH(LINUX_MIB_TCPFORWARDRETRANS);
 	}
+
+	tcp_verify_left_out(tp);
 }
 
 /* Send a fin.  The caller locks the socket for us.  This cannot be
_

Patches currently in -mm which might be from ilpo.jarvinen@helsinki.fi are

fs-coda-remove-static-inline-forward-declarations.patch
i2o-remove-static-inline-forward-declarations.patch
tcp-debug-sl.patch

