From: akpm@linux-foundation.org
Subject: + networking-fix-sending-netlink-message-when-replace-route.patch added to -mm tree
Date: Fri, 20 Apr 2007 11:59:29 -0700
Message-ID: <200704201859.l3KIxT6T021603@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753289AbXDTS7p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 14:59:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: milon@wq.cz, davem@davemloft.net, kaber@trash.net


The patch titled
     networking: fix sending netlink message when replace route
has been added to the -mm tree.  Its filename is
     networking-fix-sending-netlink-message-when-replace-route.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: networking: fix sending netlink message when replace route
From: Milan Kocian <milon@wq.cz>

When you replace route via ip r r command the netlink multicast message is
not send.  This patch corrects it.  NL message is sent with NLM_F_REPLACE
flag.  Addresses http://bugzilla.kernel.org/show_bug.cgi?id=8320

Signed-off-by: Milan Kocian <milon@wq.cz>
Cc: Patrick McHardy <kaber@trash.net>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/fib_hash.c      |    6 ++++--
 net/ipv4/fib_lookup.h    |    3 ++-
 net/ipv4/fib_semantics.c |    5 +++--
 net/ipv4/fib_trie.c      |    6 ++++--
 4 files changed, 13 insertions(+), 7 deletions(-)

diff -puN net/ipv4/fib_hash.c~networking-fix-sending-netlink-message-when-replace-route net/ipv4/fib_hash.c
--- a/net/ipv4/fib_hash.c~networking-fix-sending-netlink-message-when-replace-route
+++ a/net/ipv4/fib_hash.c
@@ -456,6 +456,8 @@ static int fn_hash_insert(struct fib_tab
 			fib_release_info(fi_drop);
 			if (state & FA_S_ACCESSED)
 				rt_cache_flush(-1);
+			rtmsg_fib(RTM_NEWROUTE, key, fa, cfg->fc_dst_len, tb->tb_id,
+				  &cfg->fc_nlinfo, NLM_F_REPLACE);
 			return 0;
 		}
 
@@ -523,7 +525,7 @@ static int fn_hash_insert(struct fib_tab
 	rt_cache_flush(-1);
 
 	rtmsg_fib(RTM_NEWROUTE, key, new_fa, cfg->fc_dst_len, tb->tb_id,
-		  &cfg->fc_nlinfo);
+		  &cfg->fc_nlinfo, 0);
 	return 0;
 
 out_free_new_fa:
@@ -589,7 +591,7 @@ static int fn_hash_delete(struct fib_tab
 
 		fa = fa_to_delete;
 		rtmsg_fib(RTM_DELROUTE, key, fa, cfg->fc_dst_len,
-			  tb->tb_id, &cfg->fc_nlinfo);
+			  tb->tb_id, &cfg->fc_nlinfo, 0);
 
 		kill_fn = 0;
 		write_lock_bh(&fib_hash_lock);
diff -puN net/ipv4/fib_lookup.h~networking-fix-sending-netlink-message-when-replace-route net/ipv4/fib_lookup.h
--- a/net/ipv4/fib_lookup.h~networking-fix-sending-netlink-message-when-replace-route
+++ a/net/ipv4/fib_lookup.h
@@ -30,7 +30,8 @@ extern int fib_dump_info(struct sk_buff 
 			 int dst_len, u8 tos, struct fib_info *fi,
 			 unsigned int);
 extern void rtmsg_fib(int event, __be32 key, struct fib_alias *fa,
-		      int dst_len, u32 tb_id, struct nl_info *info);
+		      int dst_len, u32 tb_id, struct nl_info *info,
+		      unsigned int nlm_flags);
 extern struct fib_alias *fib_find_alias(struct list_head *fah,
 					u8 tos, u32 prio);
 extern int fib_detect_death(struct fib_info *fi, int order,
diff -puN net/ipv4/fib_semantics.c~networking-fix-sending-netlink-message-when-replace-route net/ipv4/fib_semantics.c
--- a/net/ipv4/fib_semantics.c~networking-fix-sending-netlink-message-when-replace-route
+++ a/net/ipv4/fib_semantics.c
@@ -301,7 +301,8 @@ static inline size_t fib_nlmsg_size(stru
 }
 
 void rtmsg_fib(int event, __be32 key, struct fib_alias *fa,
-	       int dst_len, u32 tb_id, struct nl_info *info)
+	       int dst_len, u32 tb_id, struct nl_info *info,
+	       unsigned int nlm_flags)
 {
 	struct sk_buff *skb;
 	u32 seq = info->nlh ? info->nlh->nlmsg_seq : 0;
@@ -313,7 +314,7 @@ void rtmsg_fib(int event, __be32 key, st
 
 	err = fib_dump_info(skb, info->pid, seq, event, tb_id,
 			    fa->fa_type, fa->fa_scope, key, dst_len,
-			    fa->fa_tos, fa->fa_info, 0);
+			    fa->fa_tos, fa->fa_info, nlm_flags);
 	if (err < 0) {
 		/* -EMSGSIZE implies BUG in fib_nlmsg_size() */
 		WARN_ON(err == -EMSGSIZE);
diff -puN net/ipv4/fib_trie.c~networking-fix-sending-netlink-message-when-replace-route net/ipv4/fib_trie.c
--- a/net/ipv4/fib_trie.c~networking-fix-sending-netlink-message-when-replace-route
+++ a/net/ipv4/fib_trie.c
@@ -1207,6 +1207,8 @@ static int fn_trie_insert(struct fib_tab
 			fib_release_info(fi_drop);
 			if (state & FA_S_ACCESSED)
 				rt_cache_flush(-1);
+			rtmsg_fib(RTM_NEWROUTE, htonl(key), new_fa, plen,
+				tb->tb_id, &cfg->fc_nlinfo, NLM_F_REPLACE);
 
 			goto succeeded;
 		}
@@ -1259,7 +1261,7 @@ static int fn_trie_insert(struct fib_tab
 
 	rt_cache_flush(-1);
 	rtmsg_fib(RTM_NEWROUTE, htonl(key), new_fa, plen, tb->tb_id,
-		  &cfg->fc_nlinfo);
+		  &cfg->fc_nlinfo, 0);
 succeeded:
 	return 0;
 
@@ -1605,7 +1607,7 @@ static int fn_trie_delete(struct fib_tab
 
 	fa = fa_to_delete;
 	rtmsg_fib(RTM_DELROUTE, htonl(key), fa, plen, tb->tb_id,
-		  &cfg->fc_nlinfo);
+		  &cfg->fc_nlinfo, 0);
 
 	l = fib_find_node(t, key);
 	li = find_leaf_info(l, plen);
_

Patches currently in -mm which might be from milon@wq.cz are

networking-fix-sending-netlink-message-when-replace-route.patch
