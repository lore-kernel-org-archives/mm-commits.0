Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17422F34
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 03:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725421637; cv=none; b=GAmYw3Y/ydZWNE7IK7sSbOszq1e9S0HAMIP4w1Hv/qPqObEhzeYOyV7Emg500kYYDyx+7/ubRrBZ7c6wTYoHclkXfnBz5YNq7XXF87UJlJO7qpBjxLVDuAMHDMs94YhD1dhUQ3S8dXFwuuP5CHfxxsneKmVK+RDiyhRw+oIXbes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725421637; c=relaxed/simple;
	bh=Fei4hvyUpwMF6LfUP2/yNs9RQh71iIAMFaIX4EzhCtE=;
	h=Date:To:From:Subject:Message-Id; b=HOQ8iaFD6VMSn1kapJUZXB2SUwxyinrO5DtJbjCUhFZ78XpKeN5+6Y3zvdV1aGjR/OPxYVHtk8uJ3GVvSoyBeXwhNv+JeLLImHWm5vtTh7PSZWw49yXGeUSdfJdXL0j42OBNBgxcrKR9mNWvcellPEsRECdGcFbSnik+mAB8oLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ALosXYjv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ALosXYjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38BE9C4CEC2;
	Wed,  4 Sep 2024 03:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725421637;
	bh=Fei4hvyUpwMF6LfUP2/yNs9RQh71iIAMFaIX4EzhCtE=;
	h=Date:To:From:Subject:From;
	b=ALosXYjvR9NITjX5fj13mFzJrXoE2scvCKiLcvJZgSL2VEdOHiAQqUYKoRunz5PRn
	 IbMV0D42+j2SA2Y8iYQCmXs35PDtEQYhCBK+PPWiBPJ2QdjLjf/ll9SULHBnHmeAt9
	 4ZQ/1laQqZfqKaMeGUT7x1uKXuSOZMQwp49sPPFc=
Date: Tue, 03 Sep 2024 20:47:16 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,ryncsn@gmail.com,ryan.roberts@arm.com,kaleshsingh@google.com,hughd@google.com,chrisl@kernel.org,21cnbao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap-allow-cache-reclaim-to-skip-slot-cache-fix.patch removed from -mm tree
Message-Id: <20240904034717.38BE9C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-swap-allow-cache-reclaim-to-skip-slot-cache-fix
has been removed from the -mm tree.  Its filename was
     mm-swap-allow-cache-reclaim-to-skip-slot-cache-fix.patch

This patch was dropped because it was folded into mm-swap-allow-cache-reclaim-to-skip-slot-cache.patch

------------------------------------------------------
From: Barry Song <21cnbao@gmail.com>
Subject: mm-swap-allow-cache-reclaim-to-skip-slot-cache-fix
Date: Mon, 5 Aug 2024 13:53:24 +1200

small folios should have nr_pages == 1 but not nr_page == 0

Link: https://lkml.kernel.org/r/20240805015324.45134-1-21cnbao@gmail.com
Signed-off-by: Barry Song <21cnbao@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-allow-cache-reclaim-to-skip-slot-cache-fix
+++ a/mm/swapfile.c
@@ -224,7 +224,7 @@ static int __try_to_reclaim_swap(struct
 
 	spin_lock(&si->lock);
 	/* Only sinple page folio can be backed by zswap */
-	if (!nr_pages)
+	if (nr_pages == 1)
 		zswap_invalidate(entry);
 	swap_entry_range_free(si, entry, nr_pages);
 	spin_unlock(&si->lock);
_

Patches currently in -mm which might be from 21cnbao@gmail.com are

mm-swap-allow-cache-reclaim-to-skip-slot-cache.patch
mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix-3.patch

