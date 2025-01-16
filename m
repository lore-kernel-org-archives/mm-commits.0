Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430DA158524
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006244; cv=none; b=eti44elQSLosfDgqdDV7d/h1a8YaQhY4eS0r55xwzNFZFzyV0HfH0N+S8yljHMiF9cwCeQqyRE3xScd7Mt0ZL8wRmSCB6b60oJOL4jR1BqgX7AnlhWwpFu9mXd59GFPdVdDSziwVA0Ktp7BuHSRc2xIh2DgcZJBt1U57qdrezT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006244; c=relaxed/simple;
	bh=cJnFfrcPsED/r8dRAebTM+wbzAkTEu+t3htQKdGz/2A=;
	h=Date:To:From:Subject:Message-Id; b=D8aHt+QxS2b6cFOiTMku1w6KhI/ccZgnob8ksNwfa2z4ENQJaARifFZ3jVAJkINoLfQYZWc2QUhOJvs15gJf/KQmXj2bpt2TsZbno6Qz8WPmh3iatq4Ax6gn1UxO1b7yHXhPollcfoP6UNQLGPgreJopNw0gYVdoxjygS0cjsKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u6+pEz84; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u6+pEz84"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166B9C4CEDD;
	Thu, 16 Jan 2025 05:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006244;
	bh=cJnFfrcPsED/r8dRAebTM+wbzAkTEu+t3htQKdGz/2A=;
	h=Date:To:From:Subject:From;
	b=u6+pEz84s6MJLdlQWYiMWx7J0/Z6DgnYgZDXycKj7bW3VaaCNINeIhTvrPFKZEJtD
	 1fsfSKAyVhB2agxZ8GzjDXvsMRyzxX0FWIb/bl1QY59MdRCqU7i7pTkkrIkR705TUx
	 Rzzc7cPalMqyVkNxVY31TpW29RjSoCGtMz0KaVgM=
Date: Wed, 15 Jan 2025 21:44:03 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,v-songbaohua@oppo.com,ryan.roberts@arm.com,nphamcs@gmail.com,kaleshsingh@google.com,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,bhe@redhat.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-fold-swap_info_get_cont-in-the-only-caller.patch removed from -mm tree
Message-Id: <20250116054404.166B9C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: fold swap_info_get_cont in the only caller
has been removed from the -mm tree.  Its filename was
     mm-swap-fold-swap_info_get_cont-in-the-only-caller.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: fold swap_info_get_cont in the only caller
Date: Tue, 14 Jan 2025 01:57:21 +0800

The name of the function is confusing, and the code is much easier to
follow after folding, also rename the confusing naming "p" to more
meaningful "si".

Link: https://lkml.kernel.org/r/20250113175732.48099-3-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chis Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   39 +++++++++++++++------------------------
 1 file changed, 15 insertions(+), 24 deletions(-)

--- a/mm/swapfile.c~mm-swap-fold-swap_info_get_cont-in-the-only-caller
+++ a/mm/swapfile.c
@@ -1375,22 +1375,6 @@ out:
 	return NULL;
 }
 
-static struct swap_info_struct *swap_info_get_cont(swp_entry_t entry,
-					struct swap_info_struct *q)
-{
-	struct swap_info_struct *p;
-
-	p = _swap_info_get(entry);
-
-	if (p != q) {
-		if (q != NULL)
-			spin_unlock(&q->lock);
-		if (p != NULL)
-			spin_lock(&p->lock);
-	}
-	return p;
-}
-
 static unsigned char __swap_entry_free_locked(struct swap_info_struct *si,
 					      unsigned long offset,
 					      unsigned char usage)
@@ -1687,14 +1671,14 @@ static int swp_entry_cmp(const void *ent
 
 void swapcache_free_entries(swp_entry_t *entries, int n)
 {
-	struct swap_info_struct *p, *prev;
+	struct swap_info_struct *si, *prev;
 	int i;
 
 	if (n <= 0)
 		return;
 
 	prev = NULL;
-	p = NULL;
+	si = NULL;
 
 	/*
 	 * Sort swap entries by swap device, so each lock is only taken once.
@@ -1704,13 +1688,20 @@ void swapcache_free_entries(swp_entry_t
 	if (nr_swapfiles > 1)
 		sort(entries, n, sizeof(entries[0]), swp_entry_cmp, NULL);
 	for (i = 0; i < n; ++i) {
-		p = swap_info_get_cont(entries[i], prev);
-		if (p)
-			swap_entry_range_free(p, entries[i], 1);
-		prev = p;
+		si = _swap_info_get(entries[i]);
+
+		if (si != prev) {
+			if (prev != NULL)
+				spin_unlock(&prev->lock);
+			if (si != NULL)
+				spin_lock(&si->lock);
+		}
+		if (si)
+			swap_entry_range_free(si, entries[i], 1);
+		prev = si;
 	}
-	if (p)
-		spin_unlock(&p->lock);
+	if (si)
+		spin_unlock(&si->lock);
 }
 
 int __swap_count(swp_entry_t entry)
_

Patches currently in -mm which might be from kasong@tencent.com are


