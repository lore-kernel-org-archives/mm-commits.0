Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE67F1F4C8D
	for <mm-commits@vger.kernel.org>; Wed,  2 Apr 2025 22:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743632718; cv=none; b=K72WkgBiR/A0sSDwf85076PUV6cQ4VLYpnBeZ7tgzlJKrue5NqEnIx3cYL7zHlvgKh8Hm5JfJdSEyWW8fOgykAGlLa4XAOiorfdoV3D4/lGj/FrRlS8HsTX9gMPYFKB0PaHL42OKbKaqEXOM18pDUq2A86C88rG8gAI3Fr56GEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743632718; c=relaxed/simple;
	bh=3lx9pbdN7Rn8rG0APBPQ9gYU4UrQRLvxVA1WOfHK5nk=;
	h=Date:To:From:Subject:Message-Id; b=pyjSAfnzxDmH7aBqondmUvwUfA4XHx9wEaEOnT23/6K90uXcUJjAxsvXz5/YHf+kCwMrtWjXwzYKAKr4U2pEOjMcwjFANqm4geAFt0Fxuwqc/tMM0rImc/goXD4L5LLb3lJJR8JbqhCyVyY0uGizg4Cej2laZq7lLMSko/tglKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X1YDYTvo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X1YDYTvo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28BBBC4CEDD;
	Wed,  2 Apr 2025 22:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743632718;
	bh=3lx9pbdN7Rn8rG0APBPQ9gYU4UrQRLvxVA1WOfHK5nk=;
	h=Date:To:From:Subject:From;
	b=X1YDYTvogrx0lOFT8wLZPeUSd6spEzsYmS7SsmF1G+Ws4HXgWO66ngRrAyKKXsmsy
	 HWrLHaYD7pqzx3HxiEONjYRd3mJ3gY7bpZh3ov0vXfYA9lvTLrY5KdTBHOWYKKdhlL
	 HGTXTaxm8ZJwcMuE9pwXPaRWz5iabwerQUkm2bys=
Date: Wed, 02 Apr 2025 15:25:17 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,gautham.ananthakrishna@oracle.com,heming.zhao@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fixing-global-bitmap-allocating-failure-for-discontig-type.patch added to mm-nonmm-unstable branch
Message-Id: <20250402222518.28BBBC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix global bitmap allocating failure for discontig type
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fixing-global-bitmap-allocating-failure-for-discontig-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fixing-global-bitmap-allocating-failure-for-discontig-type.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

ocfs2-fixing-global-bitmap-allocating-failure-for-discontig-type.patch

