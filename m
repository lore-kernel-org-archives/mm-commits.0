Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC842FB990
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025881; cv=none; b=ZtbkvSVkmX4BxU2Oqxe9d1j2A6LGvjELCqK4ED4HqjcXTQSXGaufmdSiKNFCwDFiyfk0iWvJ+LVexDFPDSjpr/fg7kGufL0UduBHueuQ8jT2PnIXzWiQOBLd+vN0Nef10pkQ2e3YO45MOs7vYMI1d1mTIt1faxktCWdHS2KAvEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025881; c=relaxed/simple;
	bh=U3ha0C6aVd9oW4MVVA9s3BfZcOg7Spa5pIsjSopDOM0=;
	h=Date:To:From:Subject:Message-Id; b=jxJkiEnPi6nArMd4pkJL0fXRzSt+e1S1lVkPIknCAqHulJFUrPNGWRjLCyD955JGpP86vov4l8dNHFWY3YLlA77v3CObUrtdo+qSOXFUZdYAJ363ZL/E1Ir8XGIf9Jt6OwDvaCAoDunEyUHEqjGFmkzRfggkOn9taBBOIUF1myY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iUmUHNCo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iUmUHNCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F1AC4CEF1;
	Mon, 24 Nov 2025 23:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025881;
	bh=U3ha0C6aVd9oW4MVVA9s3BfZcOg7Spa5pIsjSopDOM0=;
	h=Date:To:From:Subject:From;
	b=iUmUHNCoAbH8aCygS83Petunysgde3Xg+vUn/dnsoKnczq6hPMoj7UkAyfRXNwPD2
	 N/He1Ywyqt0OJfMyyTb69JAToiwDAIW5wGlSNeyJFGhusBNNF4z1Qd6SoSjelpwRWz
	 3HiPBVSJIjZCC5GnKhbqZT0h+EA2Y3aJfj/C50Ms=
Date: Mon, 24 Nov 2025 15:11:20 -0800
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-change-swap_alloc_slow-to-void.patch removed from -mm tree
Message-Id: <20251124231121.53F1AC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: change swap_alloc_slow() to void
has been removed from the -mm tree.  Its filename was
     mm-swap-change-swap_alloc_slow-to-void.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Youngjun Park <youngjun.park@lge.com>
Subject: mm: swap: change swap_alloc_slow() to void
Date: Fri, 31 Oct 2025 15:50:10 +0900

swap_alloc_slow() does not need to return a bool, as all callers handle
allocation results via the entry parameter.  Update the function signature
and remove return statements accordingly.

Link: https://lkml.kernel.org/r/20251031065011.40863-5-youngjun.park@lge.com
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/swapfile.c~mm-swap-change-swap_alloc_slow-to-void
+++ a/mm/swapfile.c
@@ -1339,7 +1339,7 @@ static bool swap_alloc_fast(swp_entry_t
 }
 
 /* Rotate the device and switch to a new cluster */
-static bool swap_alloc_slow(swp_entry_t *entry,
+static void swap_alloc_slow(swp_entry_t *entry,
 			    int order)
 {
 	unsigned long offset;
@@ -1356,10 +1356,10 @@ start_over:
 			put_swap_device(si);
 			if (offset) {
 				*entry = swp_entry(si->type, offset);
-				return true;
+				return;
 			}
 			if (order)
-				return false;
+				return;
 		}
 
 		spin_lock(&swap_avail_lock);
@@ -1378,7 +1378,6 @@ start_over:
 			goto start_over;
 	}
 	spin_unlock(&swap_avail_lock);
-	return false;
 }
 
 /*
_

Patches currently in -mm which might be from youngjun.park@lge.com are


