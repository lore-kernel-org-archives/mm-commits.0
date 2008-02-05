From: akpm@linux-foundation.org
Subject: + net-sched-cls_flowc598-error-struct-tcf_ematch_tree-has-no-member-named-hdr.patch added to -mm tree
Date: Tue, 05 Feb 2008 02:49:16 -0800
Message-ID: <200802051048.m15Amvix016871@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58980 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753863AbYBEKtE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 05:49:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kaber@trash.net


The patch titled
     cls_flow: fix build error with CONFIG_NET_EMATCH=n
has been added to the -mm tree.  Its filename is
     net-sched-cls_flowc598-error-struct-tcf_ematch_tree-has-no-member-named-hdr.patch

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
Subject: cls_flow: fix build error with CONFIG_NET_EMATCH=n
From: Patrick McHardy <kaber@trash.net>

Reported by Ingo Molnar:

net/sched/cls_flow.c: In function 'flow_dump':
net/sched/cls_flow.c:598: error: 'struct tcf_ematch_tree' has no member named 'hdr'

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sched/cls_flow.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN net/sched/cls_flow.c~net-sched-cls_flowc598-error-struct-tcf_ematch_tree-has-no-member-named-hdr net/sched/cls_flow.c
--- a/net/sched/cls_flow.c~net-sched-cls_flowc598-error-struct-tcf_ematch_tree-has-no-member-named-hdr
+++ a/net/sched/cls_flow.c
@@ -595,10 +595,11 @@ static int flow_dump(struct tcf_proto *t
 	if (tcf_exts_dump(skb, &f->exts, &flow_ext_map) < 0)
 		goto nla_put_failure;
 
+#ifdef CONFIG_NET_EMATCH
 	if (f->ematches.hdr.nmatches &&
 	    tcf_em_tree_dump(skb, &f->ematches, TCA_FLOW_EMATCHES) < 0)
 		goto nla_put_failure;
-
+#endif
 	nla_nest_end(skb, nest);
 
 	if (tcf_exts_dump_stats(skb, &f->exts, &flow_ext_map) < 0)
_

Patches currently in -mm which might be from kaber@trash.net are

origin.patch
net-sched-cls_flowc598-error-struct-tcf_ematch_tree-has-no-member-named-hdr.patch
preemptible-rcu-sparse-annotations.patch
