From: akpm@osdl.org
Subject: + ebtables-dont-compute-gap-before-checking-struct.patch added to -mm tree
Date: Wed, 27 Dec 2006 01:08:35 -0800
Message-ID: <200612270908.kBR98Zdb006415@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:42680 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684AbWL0JJ6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 04:09:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 76306.1226@compuserve.com, davem@davemloft.net, kaber@trash.net, manty@manty.net, stable@kernel.org


The patch titled
     ebtables: don't compute gap before checking struct   type
has been added to the -mm tree.  Its filename is
     ebtables-dont-compute-gap-before-checking-struct.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ebtables: don't compute gap before checking struct   type
From: Chuck Ebbert <76306.1226@compuserve.com>

We cannot compute the gap until we know we have a 'struct ebt_entry' and
not 'struct ebt_entries'.  Failure to check can cause crash.

Tested-by: Santiago Garcia Mantinan <manty@manty.net>
Signed-off-by: Chuck Ebbert <76306.1226@compuserve.com>
Cc: Patrick McHardy <kaber@trash.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 net/bridge/netfilter/ebtables.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN net/bridge/netfilter/ebtables.c~ebtables-dont-compute-gap-before-checking-struct net/bridge/netfilter/ebtables.c
--- a/net/bridge/netfilter/ebtables.c~ebtables-dont-compute-gap-before-checking-struct
+++ a/net/bridge/netfilter/ebtables.c
@@ -610,7 +610,7 @@ ebt_check_entry(struct ebt_entry *e, str
 	struct ebt_entry_target *t;
 	struct ebt_target *target;
 	unsigned int i, j, hook = 0, hookmask = 0;
-	size_t gap = e->next_offset - e->target_offset;
+	size_t gap;
 	int ret;
 
 	/* don't mess with the struct ebt_entries */
@@ -660,6 +660,7 @@ ebt_check_entry(struct ebt_entry *e, str
 	if (ret != 0)
 		goto cleanup_watchers;
 	t = (struct ebt_entry_target *)(((char *)e) + e->target_offset);
+	gap = e->next_offset - e->target_offset;
 	target = find_target_lock(t->u.name, &ret, &ebt_mutex);
 	if (!target)
 		goto cleanup_watchers;
_

Patches currently in -mm which might be from 76306.1226@compuserve.com are

ebtables-dont-compute-gap-before-checking-struct.patch

