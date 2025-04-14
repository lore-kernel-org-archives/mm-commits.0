Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCEB4C74
	for <mm-commits@vger.kernel.org>; Mon, 14 Apr 2025 19:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744659681; cv=none; b=j23v/FkZ2bO+APY2gOUCWMwSAPhlYVPAlrqpTaeqRCal8HnINJrFTuJtl3d4ZBhE/lcr6dN78WoWWyDvGEQ3fnJCU0vjIT/65HHZpEVblOku1JP054MEj9GI8/9vnRRG0ywMPB5yNqwzNJc5vZh4dqCF4oo+3arjYqLgdJSfTo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744659681; c=relaxed/simple;
	bh=klmV08gmoJhxYj5iiWPOmtRPFAGtluVO61etFaieIhA=;
	h=Date:To:From:Subject:Message-Id; b=nPDzEY8bUR68imm2VPfZ4YpOMikf3XzljWMRJhQNs5rGiwBzT6kES9whi6ubGMMsSaXMPrha5cC0W1cKqlmVMReMe5T9x+iQvWmJ7tpPPlS13X+F3EpPfMryxLTv14JIT6y9T2hGlqn6XHF2lXnN4urOBKuv2e4/oafaoug3fYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=loQD6db2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="loQD6db2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63DCC4CEE2;
	Mon, 14 Apr 2025 19:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744659680;
	bh=klmV08gmoJhxYj5iiWPOmtRPFAGtluVO61etFaieIhA=;
	h=Date:To:From:Subject:From;
	b=loQD6db2y9prW9tmwno1GgQxMWpHB0eHadA1DE7XYmgNmOIdOfpf8v5NIgmuDgPUd
	 xU6j49Y87nqIWN7sx9zkOPAbSnx1rCrBcg7JKTSfB7wCuuZ5CkyjK/yzEqZhtSWhuF
	 I57Zw7wV4ErLgRsvCakyClt4abHu9+caNf6HR8JE=
Date: Mon, 14 Apr 2025 12:41:19 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,gautham.ananthakrishna@oracle.com,heming.zhao@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] ocfs2-fixing-global-bitmap-allocating-failure-for-discontig-type.patch removed from -mm tree
Message-Id: <20250414194120.A63DCC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix global bitmap allocating failure for discontig type
has been removed from the -mm tree.  Its filename was
     ocfs2-fixing-global-bitmap-allocating-failure-for-discontig-type.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Heming Zhao <heming.zhao@suse.com>
Subject: ocfs2: fix global bitmap allocating failure for discontig type
Date: Tue, 1 Apr 2025 22:26:21 +0800

commit 4eb7b93e0310 ("ocfs2: improve write IO performance when
fragmentation is high") introduced a regression.  In the discontiguous
extent allocation case, ocfs2_cluster_group_search() is comparing with the
wrong target length, which causes allocation failure.

Call stack:
ocfs2_mkdir()
 ocfs2_reserve_new_inode()
  ocfs2_reserve_suballoc_bits()
   ocfs2_block_group_alloc()
    ocfs2_block_group_alloc_discontig()
     __ocfs2_claim_clusters()
      ocfs2_claim_suballoc_bits()
       ocfs2_search_chain()
        ocfs2_cluster_group_search()

Link: https://lkml.kernel.org/r/20250401142623.31223-1-heming.zhao@suse.com
Fixes: 4eb7b93e0310 ("ocfs2: improve write IO performance when fragmentation is high")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reported-by: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
Tested-by: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/suballoc.c |   10 ++++++++--
 fs/ocfs2/suballoc.h |    1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/suballoc.c~ocfs2-fixing-global-bitmap-allocating-failure-for-discontig-type
+++ a/fs/ocfs2/suballoc.c
@@ -698,10 +698,12 @@ static int ocfs2_block_group_alloc(struc
 
 	bg_bh = ocfs2_block_group_alloc_contig(osb, handle, alloc_inode,
 					       ac, cl);
-	if (PTR_ERR(bg_bh) == -ENOSPC)
+	if (PTR_ERR(bg_bh) == -ENOSPC) {
+		ac->ac_which = OCFS2_AC_USE_MAIN_DISCONTIG;
 		bg_bh = ocfs2_block_group_alloc_discontig(handle,
 							  alloc_inode,
 							  ac, cl);
+	}
 	if (IS_ERR(bg_bh)) {
 		status = PTR_ERR(bg_bh);
 		bg_bh = NULL;
@@ -2365,7 +2367,8 @@ int __ocfs2_claim_clusters(handle_t *han
 	BUG_ON(ac->ac_bits_given >= ac->ac_bits_wanted);
 
 	BUG_ON(ac->ac_which != OCFS2_AC_USE_LOCAL
-	       && ac->ac_which != OCFS2_AC_USE_MAIN);
+	       && ac->ac_which != OCFS2_AC_USE_MAIN
+	       && ac->ac_which != OCFS2_AC_USE_MAIN_DISCONTIG);
 
 	if (ac->ac_which == OCFS2_AC_USE_LOCAL) {
 		WARN_ON(min_clusters > 1);
@@ -2429,6 +2432,9 @@ int ocfs2_claim_clusters(handle_t *handl
 {
 	unsigned int bits_wanted = ac->ac_bits_wanted - ac->ac_bits_given;
 
+	if (ac->ac_which == OCFS2_AC_USE_MAIN_DISCONTIG)
+		bits_wanted = min_clusters;
+
 	return __ocfs2_claim_clusters(handle, ac, min_clusters,
 				      bits_wanted, cluster_start, num_clusters);
 }
--- a/fs/ocfs2/suballoc.h~ocfs2-fixing-global-bitmap-allocating-failure-for-discontig-type
+++ a/fs/ocfs2/suballoc.h
@@ -29,6 +29,7 @@ struct ocfs2_alloc_context {
 #define OCFS2_AC_USE_MAIN  2
 #define OCFS2_AC_USE_INODE 3
 #define OCFS2_AC_USE_META  4
+#define OCFS2_AC_USE_MAIN_DISCONTIG  5
 	u32    ac_which;
 
 	/* these are used by the chain search */
_

Patches currently in -mm which might be from heming.zhao@suse.com are


