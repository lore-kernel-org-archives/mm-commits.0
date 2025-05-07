Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57EF28FAA6;
	Wed,  7 May 2025 21:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746652438; cv=none; b=j8xBG9zdMBr1OdDq2/I7Ru4cs0C8m2ZiRTg0GwS0BwrVuAUoeZOCOlTxM+Javl0iGSgNmsCBzsEAqFZigTH4yGKwswzNlNNDGJNohuuoUIHbgiVr01UEbwbrGZFuIylgsMnSjkzEYD+SRipOeu5YVIqR4f2naXxzZ7ZTlPOjT08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746652438; c=relaxed/simple;
	bh=qMfIrLi6wiBHeC5gOBiAAqCa4IN1viIWWbgrU4pB68U=;
	h=Date:To:From:Subject:Message-Id; b=I3X8VqiubGw1FEteJaJG1usd9I9VV3tAk0ksESD64xsp1t0dhnjrEJYS0fXAnrBsUoqHQKL523X4isNd498HXolS97V4A24ctumDXjTS/Sg0oPtjC6SZRfuqyjw7kbcBih+rqpE88ovb1jipirSFF15Arft/IEdsFHrKUdPC1HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0f4ldn5q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0f4ldn5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E36BC4CEE7;
	Wed,  7 May 2025 21:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746652437;
	bh=qMfIrLi6wiBHeC5gOBiAAqCa4IN1viIWWbgrU4pB68U=;
	h=Date:To:From:Subject:From;
	b=0f4ldn5q3kAifA8L/WN8wrwJGND5313surI2OtdqVSqXtS00TCcuPgl/3gXBoI31M
	 fU6bSZz1XCMTGkHsFp6P1uAOcEYes7q3cv46r/SWGNgFqjcMuVdtJoCB4WDAuqPLDc
	 CrbGOEXxteKccB3FnPR7ixksv8H6c//R9H1uQVQE=
Date: Wed, 07 May 2025 14:13:56 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,david.laight.linux@gmail.com,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmscan-avoid-signedness-error-for-gcc-54.patch removed from -mm tree
Message-Id: <20250507211357.6E36BC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan: avoid signedness error for GCC 5.4
has been removed from the -mm tree.  Its filename was
     mm-vmscan-avoid-signedness-error-for-gcc-54.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: WangYuli <wangyuli@uniontech.com>
Subject: mm: vmscan: avoid signedness error for GCC 5.4
Date: Wed, 7 May 2025 12:08:27 +0800

To the GCC 5.4 compiler, (MAX_NR_TIERS - 1) (i.e., (4U - 1)) is unsigned,
whereas tier is a signed integer.

Then, the __types_ok check within the __careful_cmp_once macro failed,
triggered BUILD_BUG_ON.

Use min_t instead of min to circumvent this compiler error.

Fix follow error with gcc 5.4:
  mm/vmscan.c: In function `read_ctrl_pos':
  mm/vmscan.c:3166:728: error: call to `__compiletime_assert_887' declared with attribute error: min(tier, 4U - 1) signedness error

Link: https://lkml.kernel.org/r/62726950F697595A+20250507040827.1147510-1-wangyuli@uniontech.com
Fixes: 37a260870f2c ("mm/mglru: rework type selection")
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-avoid-signedness-error-for-gcc-54
+++ a/mm/vmscan.c
@@ -3163,7 +3163,7 @@ static void read_ctrl_pos(struct lruvec
 	pos->gain = gain;
 	pos->refaulted = pos->total = 0;
 
-	for (i = tier % MAX_NR_TIERS; i <= min(tier, MAX_NR_TIERS - 1); i++) {
+	for (i = tier % MAX_NR_TIERS; i <= min_t(int, tier, MAX_NR_TIERS - 1); i++) {
 		pos->refaulted += lrugen->avg_refaulted[type][i] +
 				  atomic_long_read(&lrugen->refaulted[hist][type][i]);
 		pos->total += lrugen->avg_total[type][i] +
_

Patches currently in -mm which might be from wangyuli@uniontech.com are

ocfs2-o2net_idle_timer-rename-del_timer_sync-in-comment.patch
treewide-fix-typo-previlege.patch

