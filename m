From: akpm@linux-foundation.org
Subject: + net-ipv4-netfilter-nf_nat_rulec-update-rwlock-initialization-for-nat_table.patch added to -mm tree
Date: Thu, 11 Dec 2008 14:18:42 -0800
Message-ID: <200812112218.mBBMIg81032213@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756743AbYLKWTy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Dec 2008 17:19:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, adobriyan@gmail.com, davem@davemloft.net, kaber@trash.net, srostedt@redhat.com


The patch titled
     net/ipv4/netfilter/nf_nat_rule.c: update rwlock initialization for nat_table
has been added to the -mm tree.  Its filename is
     net-ipv4-netfilter-nf_nat_rulec-update-rwlock-initialization-for-nat_table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net/ipv4/netfilter/nf_nat_rule.c: update rwlock initialization for nat_table
From: Steven Rostedt <rostedt@goodmis.org>

The commit e099a173573ce1ba171092aee7bb3c72ea686e59 (netfilter: netns nat:
per-netns NAT table) renamed the nat_table from __nat_table to nat_table
without updating the __RW_LOCK_UNLOCKED(__nat_table.lock).

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/netfilter/nf_nat_rule.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/ipv4/netfilter/nf_nat_rule.c~net-ipv4-netfilter-nf_nat_rulec-update-rwlock-initialization-for-nat_table net/ipv4/netfilter/nf_nat_rule.c
--- a/net/ipv4/netfilter/nf_nat_rule.c~net-ipv4-netfilter-nf_nat_rulec-update-rwlock-initialization-for-nat_table
+++ a/net/ipv4/netfilter/nf_nat_rule.c
@@ -61,7 +61,7 @@ static struct
 static struct xt_table nat_table = {
 	.name		= "nat",
 	.valid_hooks	= NAT_VALID_HOOKS,
-	.lock		= __RW_LOCK_UNLOCKED(__nat_table.lock),
+	.lock		= __RW_LOCK_UNLOCKED(nat_table.lock),
 	.me		= THIS_MODULE,
 	.af		= AF_INET,
 };
_

Patches currently in -mm which might be from rostedt@goodmis.org are

linux-next.patch
net-ipv4-netfilter-nf_nat_rulec-update-rwlock-initialization-for-nat_table.patch
checkpatch-struct-file_operations-should-normally-be-const.patch

