Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D3428DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489840; cv=none; b=L7R+i58WSqYwuHcAEqZ0We2+oNZejsiN5fbwQiI2i1pxZNzhMAFpzKeTu9ZvEbh0qdWQRzQ0tm7PZU4MLx+/xgRYiceOCwwIZWYhqN8VhXpIhVHYdLrHHiQPxibIYvFRMpZKIOHFgnTcxRmm5DxaQKDmcycTy5ALsbrarilASVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489840; c=relaxed/simple;
	bh=xpp0L8gItI7RmjRGrR7dxReHmI6nYKWs6DpVGzbUiZE=;
	h=Date:To:From:Subject:Message-Id; b=DPiQy1Psz+SEeXlUmuABODvX7K44TdsSwoxiEmaGgDq/iz2s38PpUQTTO7ah3wdpxBaEcynEXiiOfDQrvsG0KomvJOwKr1L6DJo1IJqcyNLPBq5jNoLl+JuLRdGfsj04skPNPG16/cWFoRSttpRnTBmZx450fFkYuRLQOviE+wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cTdrKTJr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cTdrKTJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE2EC4CEE7;
	Sun, 21 Sep 2025 21:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489840;
	bh=xpp0L8gItI7RmjRGrR7dxReHmI6nYKWs6DpVGzbUiZE=;
	h=Date:To:From:Subject:From;
	b=cTdrKTJrahn7VImym0FnOd0yxaDLqiZ6cgUYW69nwKI8iDQnsY0pQcvkAnZxP0uZb
	 PsDDcpEikeRHPz2kNVgox+W5kuQmixbYIqrQHyW738DBUq0pdFkQN2RbX6lwKc4zCV
	 6FHoo45uDpXlFz/DaFft4XM9M0otZ5KN0RCUywN4=
Date: Sun, 21 Sep 2025 14:23:59 -0700
To: mm-commits@vger.kernel.org,ulf.hansson@linaro.org,oakad@yahoo.com,maximlevitsky@gmail.com,lorenzo.stoakes@oracle.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memstick-drop-nth_page-usage-within-sg-entry.patch removed from -mm tree
Message-Id: <20250921212400.5CE2EC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memstick: drop nth_page() usage within SG entry
has been removed from the -mm tree.  Its filename was
     memstick-drop-nth_page-usage-within-sg-entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: memstick: drop nth_page() usage within SG entry
Date: Mon, 1 Sep 2025 17:03:49 +0200

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Link: https://lkml.kernel.org/r/20250901150359.867252-29-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/host/jmb38x_ms.c |    3 +--
 drivers/memstick/host/tifm_ms.c   |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/memstick/host/jmb38x_ms.c~memstick-drop-nth_page-usage-within-sg-entry
+++ a/drivers/memstick/host/jmb38x_ms.c
@@ -317,8 +317,7 @@ static int jmb38x_ms_transfer_data(struc
 		unsigned int p_off;
 
 		if (host->req->long_data) {
-			pg = nth_page(sg_page(&host->req->sg),
-				      off >> PAGE_SHIFT);
+			pg = sg_page(&host->req->sg) + (off >> PAGE_SHIFT);
 			p_off = offset_in_page(off);
 			p_cnt = PAGE_SIZE - p_off;
 			p_cnt = min(p_cnt, length);
--- a/drivers/memstick/host/tifm_ms.c~memstick-drop-nth_page-usage-within-sg-entry
+++ a/drivers/memstick/host/tifm_ms.c
@@ -201,8 +201,7 @@ static unsigned int tifm_ms_transfer_dat
 		unsigned int p_off;
 
 		if (host->req->long_data) {
-			pg = nth_page(sg_page(&host->req->sg),
-				      off >> PAGE_SHIFT);
+			pg = sg_page(&host->req->sg) + (off >> PAGE_SHIFT);
 			p_off = offset_in_page(off);
 			p_cnt = PAGE_SIZE - p_off;
 			p_cnt = min(p_cnt, length);
_

Patches currently in -mm which might be from david@redhat.com are


