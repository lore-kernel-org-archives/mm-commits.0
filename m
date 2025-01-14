Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2FE8C0B
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 00:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736813975; cv=none; b=J8UREkzwhOQHEmFUOQ5kiL9V7bFoI1jMoob37awRNlY1AEatN/OHYYkQ6rE9Nq6/SsH0dmWZMu3wYTAva9WKOxnb0ROEr1FvXRQlofXP1WcWa6+YgSBNVH+/gxqIfMkPOKQP2v6fHiKQFUXPuKsHzc03x6YQljtclwSfzSZg1pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736813975; c=relaxed/simple;
	bh=Sr6TQf7zlLa06ogchHaoYNFI70cueAmsqXmZDzpSgKQ=;
	h=Date:To:From:Subject:Message-Id; b=psNSrPVYlk6RhcwzNBkeOwuqwdPLdoaPYwE5UmKUE5oSzbWcB+QQjoQ2rRtfPHjurbjTR8F6Ko7kmi5N9XBiIv8cI7xTtcZXZDLRzz/GcRBGjPcHaL3hkHGXuWhzg9KZ6vPgbs/2kFjgSSUc9X3kLqRX/u/nrq07jXg8g/KBmzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RNSQw2aQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RNSQw2aQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACF1C4CED6;
	Tue, 14 Jan 2025 00:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736813975;
	bh=Sr6TQf7zlLa06ogchHaoYNFI70cueAmsqXmZDzpSgKQ=;
	h=Date:To:From:Subject:From;
	b=RNSQw2aQqJHS7mGWkonOaCUZVXfDQCY3zKnXa81hYC2WZTY+cby+eOg8wdd3QnvlZ
	 nXki24dagKUysQFlEFLejqeiV9kitlJ7UUrmufUVCTmIVgmLEPUiycnfa8fTph4hqE
	 zet9VodwSdmL3EfiwZ7DjdL/r3Ao5qWP6vFS469M=
Date: Mon, 13 Jan 2025 16:19:34 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,v-songbaohua@oppo.com,ryan.roberts@arm.com,nphamcs@gmail.com,kaleshsingh@google.com,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,bhe@redhat.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-fold-swap_info_get_cont-in-the-only-caller.patch added to mm-unstable branch
Message-Id: <20250114001935.0ACF1C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: fold swap_info_get_cont in the only caller
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-fold-swap_info_get_cont-in-the-only-caller.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-fold-swap_info_get_cont-in-the-only-caller.patch

This patch will later appear in the mm-unstable branch at
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

mm-memcontrol-avoid-duplicated-memcg-enable-check.patch
mm-swap_cgroup-remove-swap_cgroup_cmpxchg.patch
mm-swap_cgroup-remove-global-swap-cgroup-lock.patch
mm-swap_cgroup-decouple-swap-cgroup-recording-and-clearing.patch
mm-swap-minor-clean-up-for-swap-entry-allocation.patch
mm-swap-fold-swap_info_get_cont-in-the-only-caller.patch
mm-swap-remove-old-allocation-path-for-hdd.patch
mm-swap-use-cluster-lock-for-hdd.patch
mm-swap-clean-up-device-availability-check.patch
mm-swap-clean-up-plist-removal-and-adding.patch
mm-swap-hold-a-reference-during-scan-and-cleanup-flag-usage.patch
mm-swap-use-an-enum-to-define-all-cluster-flags-and-wrap-flags-changes.patch
mm-swap-reduce-contention-on-device-lock.patch
mm-swap-simplify-percpu-cluster-updating.patch
mm-swap-introduce-a-helper-for-retrieving-cluster-from-offset.patch
mm-swap-use-a-global-swap-cluster-for-non-rotation-devices.patch
mm-swap_slots-remove-slot-cache-for-freeing-path.patch

