From: akpm@linux-foundation.org
Subject: - net-ipv4-netfilter-nf_nat_rulec-update-rwlock-initialization-for-nat_table.patch removed from -mm tree
Date: Tue, 16 Dec 2008 12:30:32 -0800
Message-ID: <200812162030.mBGKUWl8006587@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751190AbYLPUes (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Dec 2008 15:34:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, adobriyan@gmail.com, davem@davemloft.net, kaber@trash.net, srostedt@redhat.com, mm-commits@vger.kernel.org


The patch titled
     net/ipv4/netfilter/nf_nat_rule.c: update rwlock initialization for nat_table
has been removed from the -mm tree.  Its filename was
     net-ipv4-netfilter-nf_nat_rulec-update-rwlock-initialization-for-nat_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
dvb-remove-deprecated-use-of-rw_lock_unlocked-in-frontends.patch
remove-linux-hardirqh-from-asm-generic-localh-add-include-linux-irqflagsh-to-acpi-processor_idlec.patch
checkpatch-struct-file_operations-should-normally-be-const.patch

