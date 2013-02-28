From: akpm@linux-foundation.org
Subject: [merged] ocfs2-ac-ac_allow_chain_relink=0-wont-disable-group-relink.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:10:44 -0800
Message-ID: <20130228201045.0C9D731C0A0__29061.9450658143$1362082286$gmane$org@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:60157 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab3B1UKq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:10:46 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so244687vea.0
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:10:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaowei.hu@oracle.com, jlbec@evilplan.org, mfasheh@suse.com, srinivas.eeda@oracle.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: ac->ac_allow_chain_relink=0 won't disable group relink
has been removed from the -mm tree.  Its filename was
     ocfs2-ac-ac_allow_chain_relink=0-wont-disable-group-relink.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Xiaowei.Hu" <xiaowei.hu@oracle.com>
Subject: ocfs2: ac->ac_allow_chain_relink=0 won't disable group relink

ocfs2_block_group_alloc_discontig() disables chain relink by setting
ac->ac_allow_chain_relink = 0 because it grabs clusters from multiple
cluster groups.

It doesn't keep the credits for all chain relink,but
ocfs2_claim_suballoc_bits overrides this in this call trace:
ocfs2_block_group_claim_bits()->ocfs2_claim_clusters()->
__ocfs2_claim_clusters()->ocfs2_claim_suballoc_bits()
ocfs2_claim_suballoc_bits set ac->ac_allow_chain_relink = 1; then call
ocfs2_search_chain() one time and disable it again, and then we run out of
credits.

Fix is to allow relink by default and disable it in
ocfs2_block_group_alloc_discontig.

Without this patch, End-users will run into a crash due to run out of
credits, backtrace like this:

RIP: 0010:[<ffffffffa0808b14>]  [<ffffffffa0808b14>]
jbd2_journal_dirty_metadata+0x164/0x170 [jbd2]
RSP: 0018:ffff8801b919b5b8  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88022139ddc0 RCX: ffff880159f652d0
RDX: ffff880178aa3000 RSI: ffff880159f652d0 RDI: ffff880087f09bf8
RBP: ffff8801b919b5e8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000001e00 R11: 00000000000150b0 R12: ffff880159f652d0
R13: ffff8801a0cae908 R14: ffff880087f09bf8 R15: ffff88018d177800
FS:  00007fc9b0b6b6e0(0000) GS:ffff88022fd40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000040819c CR3: 0000000184017000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process dd (pid: 9945, threadinfo ffff8801b919a000, task ffff880149a264c0)
Stack:
  00000001b919b5c8 ffff880159f652d0 ffff8801f565cc70 ffff880087f09bf8
  000000000010e000 ffff88016da2f000 ffff8801b919b618 ffffffffa0865e4f
  0000000000000000 ffff8801f565cc70 ffff880159f652d0 ffff8801fdc76e40
Call Trace:
  [<ffffffffa0865e4f>] ocfs2_journal_dirty+0x2f/0x70 [ocfs2]
  [<ffffffffa0889441>] ocfs2_relink_block_group+0x111/0x480 [ocfs2]
  [<ffffffffa088cda5>] ocfs2_search_chain+0x455/0x9a0 [ocfs2]
  ...

Signed-off-by: Xiaowei.Hu <xiaowei.hu@oracle.com>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/suballoc.c |    7 +++----
 fs/ocfs2/suballoc.h |    2 +-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff -puN fs/ocfs2/suballoc.c~ocfs2-ac-ac_allow_chain_relink=0-wont-disable-group-relink fs/ocfs2/suballoc.c
--- a/fs/ocfs2/suballoc.c~ocfs2-ac-ac_allow_chain_relink=0-wont-disable-group-relink
+++ a/fs/ocfs2/suballoc.c
@@ -642,7 +642,7 @@ ocfs2_block_group_alloc_discontig(handle
 	 * cluster groups will be staying in cache for the duration of
 	 * this operation.
 	 */
-	ac->ac_allow_chain_relink = 0;
+	ac->ac_disable_chain_relink = 1;
 
 	/* Claim the first region */
 	status = ocfs2_block_group_claim_bits(osb, handle, ac, min_bits,
@@ -1823,7 +1823,7 @@ static int ocfs2_search_chain(struct ocf
 	 * Do this *after* figuring out how many bits we're taking out
 	 * of our target group.
 	 */
-	if (ac->ac_allow_chain_relink &&
+	if (!ac->ac_disable_chain_relink &&
 	    (prev_group_bh) &&
 	    (ocfs2_block_group_reasonably_empty(bg, res->sr_bits))) {
 		status = ocfs2_relink_block_group(handle, alloc_inode,
@@ -1928,7 +1928,6 @@ static int ocfs2_claim_suballoc_bits(str
 
 	victim = ocfs2_find_victim_chain(cl);
 	ac->ac_chain = victim;
-	ac->ac_allow_chain_relink = 1;
 
 	status = ocfs2_search_chain(ac, handle, bits_wanted, min_bits,
 				    res, &bits_left);
@@ -1947,7 +1946,7 @@ static int ocfs2_claim_suballoc_bits(str
 	 * searching each chain in order. Don't allow chain relinking
 	 * because we only calculate enough journal credits for one
 	 * relink per alloc. */
-	ac->ac_allow_chain_relink = 0;
+	ac->ac_disable_chain_relink = 1;
 	for (i = 0; i < le16_to_cpu(cl->cl_next_free_rec); i ++) {
 		if (i == victim)
 			continue;
diff -puN fs/ocfs2/suballoc.h~ocfs2-ac-ac_allow_chain_relink=0-wont-disable-group-relink fs/ocfs2/suballoc.h
--- a/fs/ocfs2/suballoc.h~ocfs2-ac-ac_allow_chain_relink=0-wont-disable-group-relink
+++ a/fs/ocfs2/suballoc.h
@@ -49,7 +49,7 @@ struct ocfs2_alloc_context {
 
 	/* these are used by the chain search */
 	u16    ac_chain;
-	int    ac_allow_chain_relink;
+	int    ac_disable_chain_relink;
 	group_search_t *ac_group_search;
 
 	u64    ac_last_group;
_

Patches currently in -mm which might be from xiaowei.hu@oracle.com are

origin.patch

