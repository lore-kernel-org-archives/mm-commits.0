Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F90C47F4A
	for <mm-commits@vger.kernel.org>; Fri,  6 Dec 2024 03:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733456957; cv=none; b=nOKWDHuHnJwGfVeAUENMCvIV1wK47oyhGDjweYoidsGF7mbZfaYdg2VAkHFlUcfEww2r01CrXthRMsMEglVrjQfHH0tmDjkp7QZ/clp46Y30KLzJr2Ic6kCEaZtO3LVfhYo2mqGozKWQKX3l07lIdxcegg6RfkHIN/uerz33W2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733456957; c=relaxed/simple;
	bh=oN98amIsnoVHoENnWtTH3HN5MetE0Mv7vRprtvptsIA=;
	h=Date:To:From:Subject:Message-Id; b=XV3I3xbQtF2luT+Gubj0I0eUz/RgIspEGX8PSmhQBAeQirURFcDJLJXQL3NHZc695TKnv211dpnlbVfvCbTb0TuuRPd4OApe0HHb4pfngwcSJsVIoU/zJXX7FG3UKvY1qT0NZpg1AE2YPhyvPTg3kGIF0/xvSbHRoRGDNxj0oi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Biz7rfP0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Biz7rfP0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C53C4CED1;
	Fri,  6 Dec 2024 03:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733456956;
	bh=oN98amIsnoVHoENnWtTH3HN5MetE0Mv7vRprtvptsIA=;
	h=Date:To:From:Subject:From;
	b=Biz7rfP0codCpMF00xHc3Zxp8I8c35XATCBebMJzu0aX63+17P+eVgbn7ESW2bs7D
	 D9ufyqfNh0J9eG4WjG+5PGmIABpbCXPnTHHp6fHrjaAESl0UnxFd/yghDSLnKrq516
	 A6qj/2UqhbHTyIHM5IVfKz9OT3v2ULbUjy27YuhA=
Date: Thu, 05 Dec 2024 19:49:16 -0800
To: mm-commits@vger.kernel.org,Liam.Howlett@Oracle.com,david@redhat.com,cl@linux.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm-fix.patch removed from -mm tree
Message-Id: <20241206034916.D1C53C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm-fix
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm-fix.patch

This patch was dropped because it was folded into mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm-fix
Date: Thu Nov 21 10:18:19 PM PST 2024

add unlikely()

Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm-fix
+++ a/mm/mempolicy.c
@@ -1080,7 +1080,7 @@ static long migrate_to_node(struct mm_st
 
 	mmap_read_lock(mm);
 	vma = find_vma(mm, 0);
-	if (!vma) {
+	if (unlikely(!vma)) {
 		mmap_read_unlock(mm);
 		return 0;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-proc-vmcorec-fix-warning-when-config_mmu=n.patch
mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm.patch
mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim-checkpatch-fixes.patch
mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch

