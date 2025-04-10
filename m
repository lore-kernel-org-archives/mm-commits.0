Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52792AD5E
	for <mm-commits@vger.kernel.org>; Thu, 10 Apr 2025 22:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744324316; cv=none; b=SB7IXj3A/DjzwQ0kUuqFFxOX02djH5uoM7ghsQX6p+/LwB4z2XHCJOtNCHfosmXpabFQ6u/6fhgbsxh00K4f3qe5zzoXVdfJU6AXC+F6iOVukkg1hF4fhS4cfEHQ2GyEgDLinKGKhsLznwlX89IvZg+G7oDZCaVVOxZVi1rQ/pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744324316; c=relaxed/simple;
	bh=ITjJZyrROrmSOyiAU4SiEjOXhKBfv/F0IMh78EmmaIc=;
	h=Date:To:From:Subject:Message-Id; b=kRz2aqbFy7Gw5FucuourJ7dPBEq+hDM1L+CUg6lsJLbCaIMhVOhpNvSdMrgU64XRZzbJFpPI2d9iYviRlKjOonWVrN2XDQ/6+dHZpXprkCyhZUQZyRrFfQfWXwlkTvi21MeHH9XRWFlDhyU9Agbpb6zUb/M5cyWLVYjYVEKDbzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TRRxWZbi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TRRxWZbi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E80C4CEDD;
	Thu, 10 Apr 2025 22:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744324315;
	bh=ITjJZyrROrmSOyiAU4SiEjOXhKBfv/F0IMh78EmmaIc=;
	h=Date:To:From:Subject:From;
	b=TRRxWZbiYLJDR7x/rm26NQjMSDVnkIfqu4SuYxsTQ8BpQPF982DrSxzaXcWawOIpe
	 U00mF+SoPqzCAcCdg0Wd7piY1Zs/m8tnHAlHxvN59kjX35pz4h1XKMgyh0/Yb/IWjm
	 H5cMAOTby7A2j6W8P6ZLa0hW33iKjEEBaa8Ex9cw=
Date: Thu, 10 Apr 2025 15:31:54 -0700
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,shikemeng@huaweicloud.com,kasong@tencent.com,bhe@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref-fix.patch removed from -mm tree
Message-Id: <20250410223155.99E80C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref-fix
has been removed from the -mm tree.  Its filename was
     mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref-fix.patch

This patch was dropped because an updated version will be issued

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
mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch
mm-mempolicy-support-memory-hotplug-in-weighted-interleave-checkpatch-fixes.patch

