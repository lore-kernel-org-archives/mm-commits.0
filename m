Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C631553A3
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011034; cv=none; b=b+/YfJyUfpLI8hVvV1kdZVYL0D6QRcQB29gKwMHWC1ge8pdEMlrB2NYwf+SW6l5UIWBc4rUrS7bcX0dGsDW4WeGEi/vKZv11dj8IMxX1uBYZLjo2HaLU/XkRf1mO7PQGgDKqXGvfoo8bGgbuXYXGfs8oBKyP3oThqP2b2FFUlc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011034; c=relaxed/simple;
	bh=PsLnyMlzFWTU/z0Tye/gmaR1MZfDLfTH8YS9nYYUq0M=;
	h=Date:To:From:Subject:Message-Id; b=Rky2Dwelof7aa7C42Q0Znc8/faAD0JmsWV4pB3WhgWEcpEjpXo1lsN+pL9VSTOAgDAiEXhNheSzce7yEuDMfJ4YRW6FJa9Fj714eFnAvcS+GEV7yJzKXP8ifa+ouSCWIt3UewN9rrbcerVvWV42QGy0z5HZLgBgqykfeVlMaKus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oLfLEJgw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oLfLEJgw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AEE1C4CEE4;
	Mon, 12 May 2025 00:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011034;
	bh=PsLnyMlzFWTU/z0Tye/gmaR1MZfDLfTH8YS9nYYUq0M=;
	h=Date:To:From:Subject:From;
	b=oLfLEJgwUTuMEku1I1Wcz9WPPJQ1pUiuf51VUeCCH3i4ykuzKtt1Yh6u+P/7epmil
	 IYBrJssQB32LWkoXmWMPny0Tzvs2VOdmsCtN4DuInLtleGzI0TzmnPCpKaR73l0uO6
	 voRK6fZYyGYAiR8ScqaCfUyuhRg9n2Bq0Yd/fCpk=
Date: Sun, 11 May 2025 17:50:33 -0700
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,kasong@tencent.com,bhe@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-drop-last-swap_map_shmem-flag-in-batch-in-swap_entries_put_nr.patch removed from -mm tree
Message-Id: <20250512005034.3AEE1C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: drop last SWAP_MAP_SHMEM flag in batch in swap_entries_put_nr()
has been removed from the -mm tree.  Its filename was
     mm-swap-drop-last-swap_map_shmem-flag-in-batch-in-swap_entries_put_nr.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: swap: drop last SWAP_MAP_SHMEM flag in batch in swap_entries_put_nr()
Date: Wed, 26 Mar 2025 00:25:25 +0800

The SWAP_MAP_SHMEM indicates last map from shmem.  Therefore we can drop
SWAP_MAP_SHMEM in batch in similar way to drop last ref count in batch.

Link: https://lkml.kernel.org/r/20250325162528.68385-6-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/swapfile.c~mm-swap-drop-last-swap_map_shmem-flag-in-batch-in-swap_entries_put_nr
+++ a/mm/swapfile.c
@@ -192,7 +192,7 @@ static bool swap_is_last_map(struct swap
 	unsigned char *map_end = map + nr_pages;
 	unsigned char count = *map;
 
-	if (swap_count(count) != 1)
+	if (swap_count(count) != 1 && swap_count(count) != SWAP_MAP_SHMEM)
 		return false;
 
 	while (++map < map_end) {
@@ -1487,7 +1487,10 @@ static bool swap_entries_put_nr(struct s
 	unsigned char count;
 	int i;
 
-	if (nr <= 1 || swap_count(data_race(si->swap_map[offset])) != 1)
+	if (nr <= 1)
+		goto fallback;
+	count = swap_count(data_race(si->swap_map[offset]));
+	if (count != 1 && count != SWAP_MAP_SHMEM)
 		goto fallback;
 	/* cross into another cluster */
 	if (nr > SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER)
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


