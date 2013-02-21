From: akpm@linux-foundation.org
Subject: + ocfs2-ac-ac_allow_chain_relink=0-wont-disable-group-relink.patch added to -mm tree
Date: Thu, 21 Feb 2013 14:13:27 -0800
Message-ID: <20130221221327.A17E031C1B7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:45318 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab3BUWN3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 17:13:29 -0500
Received: by mail-qe0-f73.google.com with SMTP id 7so4287qeb.0
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 14:13:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaowei.hu@oracle.com, jlbec@evilplan.org, mfasheh@suse.com, srinivas.eeda@oracle.com


The patch titled
     Subject: ocfs2: ac->ac_allow_chain_relink=0 won't disable group relink
has been added to the -mm tree.  Its filename is
     ocfs2-ac-ac_allow_chain_relink=0-wont-disable-group-relink.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Xiaowei.Hu <xiaowei.hu@oracle.com>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
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

ocfs2-ac-ac_allow_chain_relink=0-wont-disable-group-relink.patch

