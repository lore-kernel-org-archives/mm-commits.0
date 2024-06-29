Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3094816
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719627742; cv=none; b=EVUhrXrgVKwt1E0G4+lvyEVi+HJRnrA/OFGmcSqyH55wk/5X5Hxl6bAFQLyr9Lvjye0ax4iB6DGwsSsiJ8IMmF9ZQ5i1GAgkSjlmW4JHJNyrQet+7zxifYKcueiLI7dDaunrX7gZEUIvyQz4aAIbBNSTwa0QHrJ1Je8MKb4raHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719627742; c=relaxed/simple;
	bh=OI5O/MBLvC2y/0j4jUbruo0MEtT7eKuEZdkS+wr1qBE=;
	h=Date:To:From:Subject:Message-Id; b=CSrBZl19Xs1Msez7F2FAt5dzRdRf0NLZX2s2rEPE66fnFZywsI1ID4rOL6fgXOYsuPtyXU/eDS7007OptoXTP3oRyiyilPCcoNFYFrNbEf+CATMcMmC77K5Vq2zBMwEb1XGRJQYwTc/+PECzswpqxGZNHzO/4EAF64bw/Tf0qP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=htik7+vR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="htik7+vR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70012C116B1;
	Sat, 29 Jun 2024 02:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719627742;
	bh=OI5O/MBLvC2y/0j4jUbruo0MEtT7eKuEZdkS+wr1qBE=;
	h=Date:To:From:Subject:From;
	b=htik7+vRl6OdrJqlUjB+rO2NrNon6fhno3Zwauof1R+JBN/MR6//CdM2Y9q2gqnbb
	 ObDANs2YNEEhrj+ftq65BELArsqR/SOwkufQ5aP464vkJHg7KHDuxiozSttUOcqXrP
	 69O1LXRjb/+l0pZPXhppQ3Gn7/D2W4YagqCHshZg=
Date: Fri, 28 Jun 2024 19:22:21 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix-2.patch removed from -mm tree
Message-Id: <20240629022222.70012C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix-2
has been removed from the -mm tree.  Its filename was
     mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix-2.patch

This patch was dropped because it was folded into mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false.patch

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix-2
Date: Sat, 22 Jun 2024 15:14:53 +1200

For new anon(!anon), there's a possibility that multiple concurrent
threads might execute "if (!anon) folio_add_new_anon_rmap()" in parallel. 
In such cases, the threads should lock the folio before executing this
sequence.  We use VM_WARN_ON_FOLIO() to verify if this condition holds
true.

Link: https://lkml.kernel.org/r/20240622032002.53033-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c   |    1 +
 mm/swapfile.c |    1 +
 2 files changed, 2 insertions(+)

--- a/mm/memory.c~mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix-2
+++ a/mm/memory.c
@@ -4348,6 +4348,7 @@ check_folio:
 		 * here, we have to be careful.
 		 */
 		VM_WARN_ON_ONCE(folio_test_large(folio));
+		VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 		folio_add_new_anon_rmap(folio, vma, address, rmap_flags);
 	} else {
 		folio_add_anon_rmap_ptes(folio, page, nr_pages, vma, address,
--- a/mm/swapfile.c~mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix-2
+++ a/mm/swapfile.c
@@ -1923,6 +1923,7 @@ static int unuse_pte(struct vm_area_stru
 		 */
 		if (!folio_test_anon(folio)) {
 			VM_WARN_ON_ONCE(folio_test_large(folio));
+			VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 			folio_add_new_anon_rmap(folio, vma, addr, rmap_flags);
 		} else {
 			folio_add_anon_rmap_pte(folio, page, vma, addr, rmap_flags);
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false.patch
mm-remove-folio_test_anonfolio==false-path-in-__folio_add_anon_rmap.patch
tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout.patch

