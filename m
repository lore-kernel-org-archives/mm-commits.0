Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43322C190
	for <mm-commits@vger.kernel.org>; Wed,  9 Apr 2025 00:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744159278; cv=none; b=jHu56xw5OsqAnuyz/jEV02YGRK3MK/rESVB0WIGDPujRnX6FyjsrwUMUbOLziUTZmGr6ozGxn1p6LujuNGNz+honfKqzlVJ76Y1UrgKfYfK+6WePi0DWm/Uy4eVPX/oJEM1XIKTXH9YFJEQBKNdQ67CUyu3Kdb2Gc/Q+KZch4VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744159278; c=relaxed/simple;
	bh=qwawSi+iQgy9wa5isBpmuLkFlAeA48N/nP7lEDclVuM=;
	h=Date:To:From:Subject:Message-Id; b=bNluVoj7Xt1njdHrMRbvojeuVjpdszLMyv2Mmn/xX+y7idimndR35mJL7R2bHmCzoMm1qWWTPcsTPYm5mGV7FiXD0i78PMmTKfynKsCp0JYV9+4+7WC+mZrfzps6migV+7Ka6M5zFlT/4jrYuhGcUgLrznWCD/El7xNzEcyET9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tsp6lRcb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tsp6lRcb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439BDC4CEE5;
	Wed,  9 Apr 2025 00:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744159276;
	bh=qwawSi+iQgy9wa5isBpmuLkFlAeA48N/nP7lEDclVuM=;
	h=Date:To:From:Subject:From;
	b=Tsp6lRcbYuPC33f/pb9jOyvp8ki8mYQLlqzEH2LRO1mDZYoGM2pvUXyUbunmWL8OS
	 OA8Ld+Nmu2MYBbK04RhL1yOuCeb6Ly6Wd18mK/ptT4x/6z1F0f90gVhwzLvP4owX/S
	 tcXup+6RejMlb51ln5WlLKOyd0rn4B6msF8IjGSk=
Date: Tue, 08 Apr 2025 17:41:15 -0700
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,shikemeng@huaweicloud.com,kasong@tencent.com,bhe@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref-fix.patch added to mm-new branch
Message-Id: <20250409004116.439BDC4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref-fix
Date: Tue Apr  8 05:36:58 PM PDT 2025

fix unused-static-inline-function warning

>> mm/swapfile.c:1517:20: warning: function 'swap_is_last_ref' is not needed and will not be emitted [-Wunneeded-internal-declaration]

Link: https://lkml.kernel.org/r/202504081841.jbL7yL0r-lkp@intel.com
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202504081841.jbL7yL0r-lkp@intel.com/
Cc: Baoquan He <bhe@redhat.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/swapfile.c~mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref-fix
+++ a/mm/swapfile.c
@@ -1514,11 +1514,13 @@ fallback:
  * Drop the last ref(1, SWAP_HAS_CACHE or SWAP_MAP_SHMEM) of swap entries,
  * caller have to ensure all entries belong to the same cgroup and cluster.
  */
+#ifdef CONFIG_DEBUG_VM
 static inline bool swap_is_last_ref(unsigned char count)
 {
 	return (count == SWAP_HAS_CACHE) || (count == 1) ||
 	       (count == SWAP_MAP_SHMEM);
 }
+#endif
 
 static void swap_entries_free(struct swap_info_struct *si,
 			      struct swap_cluster_info *ci,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

radix-tree-add-missing-cleanuph-fix.patch
samples-livepatch-add-module-descriptions-fix.patch
mm-kasan-add-module-decription-fix.patch
mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref-fix.patch
mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch

