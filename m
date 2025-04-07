Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812D81FBE9E
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 01:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743988315; cv=none; b=RZ7w7fCqNFlnJLpqXllj5Iv3wJHEEFErSHDmcB8Vek8ZjvTqKj9FxYzfUx2/CZwWOHHdL7g8jGh2RdWZa33IQ4wtWWiT0TjzRnf3zb27zJvhz/uRMWQ53glyz2auERhbIYDWfH7rgzxg9A1JzAvjKfk+bTlaKVbJEYJHND4TPzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743988315; c=relaxed/simple;
	bh=/RbuVEvOXtAiV0s/wWSPpYimZVZQr3KUqg6tO+E57X0=;
	h=Date:To:From:Subject:Message-Id; b=tP/V+cGzupq/4Xce1LVwjE7ema9iKFirB+7mrQd/oADjkFYU5DGGt6VnkecaAe6f2A6X2A9o8m+cGb7jre38GxaTKx1w491pMEnB/jyRg46tPov8/iHnfzvC1k8GW2ymCjPv/cj5sWpFqFVWE7RLo48/ogW5JGzIFnGpj71V6ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rhEsw42E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rhEsw42E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C11C4CEE3;
	Mon,  7 Apr 2025 01:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743988315;
	bh=/RbuVEvOXtAiV0s/wWSPpYimZVZQr3KUqg6tO+E57X0=;
	h=Date:To:From:Subject:From;
	b=rhEsw42EirwKifn124Jd6rFqr88YdwI+2KA6WX68RswZ6Vt0SdU/6OtqQSn06gX51
	 8o3LqTLSyhnkEJj3k3QPQrUFaj3vcks+kX3nFvyZAaqMPHtQSr4cffi5059Oc29ZSl
	 rMfpAqm32s7x9/3v8O+ua2CAnlOhdE3//YNKcVOk=
Date: Sun, 06 Apr 2025 18:11:54 -0700
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,kasong@tencent.com,bhe@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-drop-last-swap_map_shmem-flag-in-batch-in-swap_entries_put_nr.patch added to mm-new branch
Message-Id: <20250407011154.E4C11C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: drop last SWAP_MAP_SHMEM flag in batch in swap_entries_put_nr()
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-drop-last-swap_map_shmem-flag-in-batch-in-swap_entries_put_nr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-drop-last-swap_map_shmem-flag-in-batch-in-swap_entries_put_nr.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -1478,7 +1478,10 @@ static bool swap_entries_put_nr(struct s
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

mm-swap-rename-__swap__free-to-swap__put.patch
mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref.patch
mm-swap-use-swap_entries_free-to-free-swap-entry-in-swap_entry_put_locked.patch
mm-swap-use-swap_entries_free-drop-last-ref-count-in-swap_entries_put_nr.patch
mm-swap-drop-last-swap_map_shmem-flag-in-batch-in-swap_entries_put_nr.patch
mm-swap-free-each-cluster-individually-in-swap_entries_put_map_nr.patch
mm-swap-factor-out-helper-to-drop-cache-of-entries-within-a-single-cluster.patch
mm-swap-replace-cluster_swap_free_nr-with-swap_entries_put_.patch

