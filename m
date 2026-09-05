Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56D75478D;
	Sat,  5 Sep 2026 18:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788634095; cv=none; b=piQiYx+cgZ7KXLeIcHZDRu+wdiL1kMm3pm+uQEYndqmTf5qr9mKtLeIm2qNpf15EfTOaqImeA/DqU2YDjOgWwvScYlKRB9AwYs+Bs7jix3EywKJkNg0zP7vkdWdPkGOxzg97xw1ACpCpncd/b1/+piJEDl6oYmBS/WKEvPC8ntY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788634095; c=relaxed/simple;
	bh=vP83VOFtX+/U96iImd6w8PmjJJ6/omIHDWhMWM0+tsE=;
	h=Date:To:From:Subject:Message-Id; b=YB0lnNHmandBR1WwKom/DrlhLerAUEGqFrp2OV1t0w1Kcn7ErWKHg3/MszAGUX8j+zZFbB/XP/u/RS+kKsMG0gAXbm13RwCMLuQI2wEFQdy8D8D2F49sZh8musUANH8+/sBYHExVc29iePZftY+zxPbLlOt52cJupVsA0A8t2E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FzHop4Wh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FzHop4Wh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF23B1F00A3A;
	Sat,  5 Sep 2026 18:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788634093;
	bh=/NI8g87xoDe1aHgqfbaE2Pl5+BTDEmxSyQ7Raaqj0hE=;
	h=Date:To:From:Subject;
	b=FzHop4WhH34YytTKcsQnmGNpgpPJ7KTCiJ/gc/PktrBd39JLiCGLoSLUdVEnG0GSz
	 HNh8NT0Gx2k1RqBITHdiFwicLlLkKfe5OyVCZyDf69n8yqc/0nPStdDqM5EfRPFgtP
	 oKATg/+jeOrCBQTMMQhL6TDEdt3hnfuj05GkyAxc=
Date: Sat, 05 Sep 2026 11:48:13 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,stable@vger.kernel.org,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,sashiko-bot@kernel.org,kasong@tencent.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,gourry@gourry.net,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,akpm@linux-foundation.org,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-swap-fix-swap_usage_offlist_bit-collision-with-real-usage-count.patch removed from -mm tree
Message-Id: <20260905184813.AF23B1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: fix SWAP_USAGE_OFFLIST_BIT collision with real usage count
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-swap_usage_offlist_bit-collision-with-real-usage-count.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: mm, swap: fix SWAP_USAGE_OFFLIST_BIT collision with real usage count
Date: Fri, 28 Aug 2026 12:14:33 -0700

SWAP_USAGE_OFFLIST_BIT is embedded in the si->inuse_pages usage counter,
and is meant to sit above any value that counter can reach.  However, it
is defined from BITS_PER_TYPE(atomic_t), so it is bit 30.  On a system
with 4 KiB pages the flag collides with the usage count once that count
reaches 4 TiB.

swap_usage_in_pages() masks bit 30 out, so whenever the real count has
that bit set, every caller of it reads 4 TiB low:

* /proc/swaps understates Used by 4 TiB.

* A raw count of exactly 2^30 masks to zero, so try_to_unuse() takes its
  "if (!swap_usage_in_pages(si)) goto success;" early exit and swapoff
  tears the device down while pages are still swapped out. Nothing in
  the rest of swapoff aborts the teardown, so those pages are lost.

Independently of swapoff, the collision also corrupts the counter and the
plist.  On a device in normal use, a free that leaves bit 30 set in the
count makes swap_usage_sub() see the flag where there is only count, and
call add_to_avail_list().  It clears the bit with
fetch_and(~SWAP_USAGE_OFFLIST_BIT), leaving the stored count 4 TiB below
the real one, and calls plist_add() on a device that is already listed,
tripping the WARN_ON(!plist_node_empty(node)) in plist_add() and linking
the node a second time.

Change the definition of SWAP_USAGE_OFFLIST_BIT to be based on
atomic_long_t instead.  Note that the usage counter field itself is of
this same type, so it is still a valid bit.

Link: https://lore.kernel.org/20260828191433.3304458-1-nphamcs@gmail.com
Fixes: b228386cf237 ("mm, swap: clean up plist removal and adding")
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260825153238.2695446-1-nphamcs%40gmail.com
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Kairui Song <kasong@tencent.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-fix-swap_usage_offlist_bit-collision-with-real-usage-count
+++ a/mm/swapfile.c
@@ -156,7 +156,7 @@ static struct swap_info_struct *swap_ent
  * This bit will be set if the device is not on the plist and not
  * usable, will be cleared if the device is on the plist.
  */
-#define SWAP_USAGE_OFFLIST_BIT (1UL << (BITS_PER_TYPE(atomic_t) - 2))
+#define SWAP_USAGE_OFFLIST_BIT (1UL << (BITS_PER_TYPE(atomic_long_t) - 2))
 #define SWAP_USAGE_COUNTER_MASK (~SWAP_USAGE_OFFLIST_BIT)
 static long swap_usage_in_pages(struct swap_info_struct *si)
 {
_

Patches currently in -mm which might be from nphamcs@gmail.com are


