Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140C03563E1
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774386678; cv=none; b=SkLHL1qOUnRmkW33otfSB5NB2J5ogoNtC7Gtc4eKys1VhY2RaahXYBEUa1sFhWDxtqSZltF931gCNkIVmK2GYPcvHiTsZcnbWfvzwMuBnOy3UWFWKpZQN7E5sOdeFrW62GfPMNYYtP/2TeEZLCc0SraWl43M8fdPF94ELiu1ETE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774386678; c=relaxed/simple;
	bh=mbApp6X3wgXp/T3Jk7CIXLxH0CiJfhuKFkF5Wt9j284=;
	h=Date:To:From:Subject:Message-Id; b=b0NXziJYt6J2aHtQXwn0UN4doHodisIltb0yXyfanbXx217G+qWGOdy05AjERghGQOoVBkAyEc81OFg6TzXCvudCtO0p2Xe+dO9rxBxsGOpyYKMTNvaE/OoPfpdyk5bVWlAoCsYboiQpdkc/dHzbv1XDQLgfugNK/uT2S3O2sEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AA+0fNRL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AA+0fNRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E5AC19424;
	Tue, 24 Mar 2026 21:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774386677;
	bh=mbApp6X3wgXp/T3Jk7CIXLxH0CiJfhuKFkF5Wt9j284=;
	h=Date:To:From:Subject:From;
	b=AA+0fNRLR+x34nfdN3FqaufXhcgV2iGGqYbnwuMX6fLWMunWoR9eqxe8TLr4exk3q
	 01kpWl1oCcussg3Gp/Jb8NH77IH8Lpjn4TB89XjRZ6jmN4eiCuu2i8jmujv6epy+dm
	 uPt+/8qg5VGfM2Hq1a6+0Hy00HCFleicPSqwIjOE=
Date: Tue, 24 Mar 2026 14:11:17 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,Liam.Howlett@oracle.com,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] maple_tree-add-cp_is_new_root-helper-fix-fix.patch removed from -mm tree
Message-Id: <20260324211117.A8E5AC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree-add-cp_is_new_root-helper-fix-fix
has been removed from the -mm tree.  Its filename was
     maple_tree-add-cp_is_new_root-helper-fix-fix.patch

This patch was dropped because it was folded into maple_tree-add-cp_is_new_root-helper.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: maple_tree-add-cp_is_new_root-helper-fix-fix
Date: Wed Feb  4 11:54:03 AM PST 2026

s/cp->slot[0]/&cp->slot[0]/, per Liam

Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Tested-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-add-cp_is_new_root-helper-fix-fix
+++ a/lib/maple_tree.c
@@ -3361,7 +3361,7 @@ static inline bool cp_is_new_root(struct
 		 * read-side operations that can view it until it is insert into
 		 * the tree after an rcu_assign_pointer() call.
 		 */
-		ma_init_slot(cp->slot[0], cp->dst[0].node, mt);
+		ma_init_slot(&cp->slot[0], cp->dst[0].node, mt);
 		cp->height++;
 	}
 	WARN_ON_ONCE(cp->dst[0].node != mte_to_node(
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maple_tree-add-cp_is_new_root-helper.patch
mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix.patch
mm-rename-zap_page_range_single-to-zap_vma_range-fix.patch
mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix.patch
mm-page_reporting-add-page_reporting_order_unspecified-fix.patch
mm-rename-zone-lock-to-zone-_lock-fix.patch
mm-switch-the-rmap-lock-held-option-off-in-compat-layer-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch
decode_stacktrace-decode-caller-address-checkpatch-fixes.patch
lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch

