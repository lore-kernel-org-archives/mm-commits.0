Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C721B960
	for <mm-commits@vger.kernel.org>; Wed, 11 Jun 2025 01:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749607068; cv=none; b=Vy30+fOsLHtJ+cZl4boGeZB1IwSFnVPzvNMJ9rqqUnLcZ8WglBJPsLQGD2YyXpRJzmHxrHBmpv5YbhI3cpCWdXiqipbBZeTKQZfoWeWPJdxxbixpbK1+Lq9IzlK33sROXabz3PXe2PscWOkvU1ITlWrC2El9l5vFMrDYPeN5pc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749607068; c=relaxed/simple;
	bh=BxPIyrFPaiWPnX/qMmcDKWktB0kjnKbbDGdhyz2gpvo=;
	h=Date:To:From:Subject:Message-Id; b=OA22+LZlNZWlkUDqhQMueuDp4EUTvFr+13hK2zPb2I0ipSBkYiSmr/Gk733uw4NjqjbKPt29nvWuSrBV1L9AW6AnM34Lb8ivDgfABHcm09cPXADBxkwKzLyoPB/wVFo0aP727tzBY1sLoYG8CYqD0oPmIk1f2mbi1r5o+ONx5PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y1Wa9Z28; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y1Wa9Z28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5468C4CEED;
	Wed, 11 Jun 2025 01:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749607067;
	bh=BxPIyrFPaiWPnX/qMmcDKWktB0kjnKbbDGdhyz2gpvo=;
	h=Date:To:From:Subject:From;
	b=Y1Wa9Z28cDEsfMfNG+vUXgvVdTVPLIWTDaCD5Q2/77DkvFQNh7zuWcF9Ikr+rhPyC
	 irISqwsI+hs67SVIhDbDibhH5fahoI85Od0Vzcx5cJNKSRwFtxBQaAmaJVvZ0ufE8d
	 cnipU+/oHtUp/RTS6OA46JAWa04PbdH1boDveK7c=
Date: Tue, 10 Jun 2025 18:57:47 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,vitaly.wool@konsulko.se,shakeel.butt@linux.dev,nphamcs@gmail.com,igor.b@beldev.am,hannes@cmpxchg.org,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-zblock-avoid-failing-the-build-fix.patch removed from -mm tree
Message-Id: <20250611015747.D5468C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-zblock-avoid-failing-the-build-fix
has been removed from the -mm tree.  Its filename was
     mm-zblock-avoid-failing-the-build-fix.patch

This patch was dropped because it was folded into mm-add-zblock-allocator.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-zblock-avoid-failing-the-build-fix
Date: Mon Apr 28 02:19:47 AM PDT 2025

s/#warn/#warning/

Cc: Igor Belousov <igor.b@beldev.am>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zblock.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zblock.h~mm-zblock-avoid-failing-the-build-fix
+++ a/mm/zblock.h
@@ -21,7 +21,7 @@
 /* max 256 slots per block, max table size 64 */
 #define SLOT_BITS 8
 #else
-#warn This PAGE_SIZE is not quite supported yet
+#warning This PAGE_SIZE is not quite supported yet
 #define SLOT_BITS 8
 #endif
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

docs-proc-update-vmflags-documentation-in-smaps-fix.patch
drivers-rapidio-rio_cmc-prevent-possible-used-uninitialized.patch
mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix.patch
mm-add-zblock-allocator.patch

