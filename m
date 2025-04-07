Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879791FBE9E
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 01:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743988313; cv=none; b=UN8RopJlL142i9tNVhzQ4u8AdeNdLQ63rRLeYuKl1OidIPHDMmGr1kFyBGioMVstEcn76TgVrIYqML2K3JPxStB/X5U2rdcVZ/YXcwFzQfL81VSMiGY+ErguQBL/6pv/N/mTz6V6sYWbQxcLMh1r9dknI/0ZurbipaFmF+O3Rrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743988313; c=relaxed/simple;
	bh=6yNjbp68vyNcEzHZ4r3UbFziE7mlDT2ZoSIUUxIpz1g=;
	h=Date:To:From:Subject:Message-Id; b=A+ueOm8tTKvjDe5rk8c/6LiMPV+BAwD9BPU5dxewLbRlTMHrwA0S85Qe5p83Klw7Oc4cFrNUZj9ECI27iOdRuw/1+77iRpX18BPPYz/Z5tL2bNprtgk51L/m3KqsLtQDOLeuxnhuZGenTYnjQGE++WVcFcUyQ/o1zoc8m9YqbMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jMLiQBqT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jMLiQBqT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EABF6C4CEE3;
	Mon,  7 Apr 2025 01:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743988313;
	bh=6yNjbp68vyNcEzHZ4r3UbFziE7mlDT2ZoSIUUxIpz1g=;
	h=Date:To:From:Subject:From;
	b=jMLiQBqTTwIsyQYYheq3RABPnU5A1G7+J6M0pqnFp80E+DFLhF53U9n7WaS6i+qp0
	 Y/GMmJgpe8o3NjSWIxBtbwKsvyYc5XtlhctizbOuP2Ov2dLd7ke+Hkb36iLZ4wWgi+
	 wQpuitGGAAargLZGfFT/mvSuvp/V6F11fdBUttLg=
Date: Sun, 06 Apr 2025 18:11:52 -0700
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,kasong@tencent.com,bhe@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-use-swap_entries_free-drop-last-ref-count-in-swap_entries_put_nr.patch added to mm-new branch
Message-Id: <20250407011152.EABF6C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: use swap_entries_free() drop last ref count in swap_entries_put_nr()
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-use-swap_entries_free-drop-last-ref-count-in-swap_entries_put_nr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-use-swap_entries_free-drop-last-ref-count-in-swap_entries_put_nr.patch

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
Subject: mm: swap: use swap_entries_free() drop last ref count in swap_entries_put_nr()
Date: Wed, 26 Mar 2025 00:25:24 +0800

Use swap_entries_free() to directly free swap entries when the swap
entries are not cached and referenced, without needing to set swap entries
to set intermediate SWAP_HAS_CACHE state.

Link: https://lkml.kernel.org/r/20250325162528.68385-5-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/swapfile.c~mm-swap-use-swap_entries_free-drop-last-ref-count-in-swap_entries_put_nr
+++ a/mm/swapfile.c
@@ -1489,10 +1489,11 @@ static bool swap_entries_put_nr(struct s
 		unlock_cluster(ci);
 		goto fallback;
 	}
-	for (i = 0; i < nr; i++)
-		WRITE_ONCE(si->swap_map[offset + i], SWAP_HAS_CACHE);
 	if (!has_cache)
 		swap_entries_free(si, ci, entry, nr);
+	else
+		for (i = 0; i < nr; i++)
+			WRITE_ONCE(si->swap_map[offset + i], SWAP_HAS_CACHE);
 	unlock_cluster(ci);
 
 	return has_cache;
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

