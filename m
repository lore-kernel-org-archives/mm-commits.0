Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63672E06EA
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774386638; cv=none; b=mMe9taiz3x0EJQS70lo80JwEO8Quu1OsPVFJ3Zp7iOizISzplSr7FCYGLlc4mra+ElBVSLTqkcVGASZ1KQBCPaKmVmhNFpvkVFdhY0Ix+nqwrXOdeHYDpC3WS09uMZhMJ8ajJpB8P605oaA8KrUPwHi9ID0mepXfSvv6kHfkMYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774386638; c=relaxed/simple;
	bh=GJCQ+jSzeZI4ZvAMWDVM1hfzOISml2+bYSRXvEFljS0=;
	h=Date:To:From:Subject:Message-Id; b=BkDL97jszBKZtHWrEUp62RhUZAx53HyqhX1oVpWBWWV234Ld+xDXd7PFQ6LuLnbg6W/DRSGy4gBHWq0uPZSskTouszSYlnzOSmC8JAyDTTobZBeQHIpeMrQZp7m6OCqDhDAgpkA9nclruzvq03tJ3m6TeRbzKYGjwpaErSpCGrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=USnAzuHf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="USnAzuHf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356D6C19424;
	Tue, 24 Mar 2026 21:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774386638;
	bh=GJCQ+jSzeZI4ZvAMWDVM1hfzOISml2+bYSRXvEFljS0=;
	h=Date:To:From:Subject:From;
	b=USnAzuHfT7yx5fh6AUjcmF7IVOYwnShGdi1c1FQ+CobIrPdhsAfM1UfDbuKP2mIuz
	 v0MCZjx7O823oYlV1ZHzSkrbNZqkZwu0gEUCNz0f7GKBaRB0Aze1vfdd5wspMpk786
	 71HePtQROJOf15sLqmFmssgOqB2WME/G+JWkbJZM=
Date: Tue, 24 Mar 2026 14:10:37 -0700
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20260324211038.356D6C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch

This patch was dropped because it was folded into maple_tree-start-using-maple-copy-node-for-destination.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes
Date: Sat Jan 31 12:29:16 PM PST 2026

ERROR: code indent should use tabs where possible
#492: FILE: lib/maple_tree.c:3167:
+^I^I^I^I^I         slot_max, ma_pivots(mn, mt),$

ERROR: code indent should use tabs where possible
#493: FILE: lib/maple_tree.c:3168:
+^I^I^I^I^I         ma_slots(mn, mt));$

total: 2 errors, 0 warnings, 721 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/maple_tree-start-using-maple-copy-node-for-destination.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes
+++ a/lib/maple_tree.c
@@ -3164,8 +3164,8 @@ static inline void cp_dst_to_slots(struc
 		if (mt_is_alloc(mas->tree)) {
 			if (ma_is_leaf(mt)) {
 				cp->gap[d] = ma_leaf_max_gap(mn, mt, slot_min,
-					         slot_max, ma_pivots(mn, mt),
-					         ma_slots(mn, mt));
+						 slot_max, ma_pivots(mn, mt),
+						 ma_slots(mn, mt));
 			} else {
 				unsigned long *gaps = ma_gaps(mn, mt);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maple_tree-start-using-maple-copy-node-for-destination.patch
maple_tree-add-cp_is_new_root-helper-fix-fix.patch
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

