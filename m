Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E00CA4B
	for <mm-commits@vger.kernel.org>; Thu, 10 Apr 2025 00:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744245672; cv=none; b=BpTQt1ycAIT1zZEF9RIZirA6IdZ6L8ZxuIOfNnYruUvU4Qggt/il/DkmKd9MY+Bt6e9GOTc8CKTxjowKfePKQi1harNTEIG1H+msaU0QQKJpAEOXAEwHEdPXj5xFFI6n2uz0BJ/GVlKKik3V8XS5shz0bqBDLgooCKwOZZtgd5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744245672; c=relaxed/simple;
	bh=7JkuJqrKvjHptc9UzIgKESzCY/t6pWzKECoWnM32g1U=;
	h=Date:To:From:Subject:Message-Id; b=bSnqMSd/4RNw9tjLLVaI4U7IzWcPu29VFaxxwk25LEOxhDEAxybQgDraSHfmGNXVfblGoUbhzHB1r+Rq/1kkFXTZwIlhfhbx9IYjB5CK2lv8lKOwrhv0tY4BUpMIXWy71MxsmT65LeSwZxAos/TJnXB4hNrngyA4AA1mINlh1SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1k7bpwYX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1k7bpwYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851DAC4CEE2;
	Thu, 10 Apr 2025 00:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744245671;
	bh=7JkuJqrKvjHptc9UzIgKESzCY/t6pWzKECoWnM32g1U=;
	h=Date:To:From:Subject:From;
	b=1k7bpwYXOfSjVPu+MOrli1E9S64bx6B0+ze7q2r7PFnMhHfWMmGWEuPkfARy//8T6
	 8Uo1+901kCNV/vhnyRfrvclC1DD+IXKI53hSpb2GnTWd6Z7bjERw1XoouKEJYEzfVv
	 kQBp6pp+gkk5etDSlM4+NgNg/xZEjYB3ULNbqAfA=
Date: Wed, 09 Apr 2025 17:41:10 -0700
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,shikemeng@huaweicloud.com,kasong@tencent.com,bhe@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref-fix.patch removed from -mm tree
Message-Id: <20250410004111.851DAC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref-fix
has been removed from the -mm tree.  Its filename was
     mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref-fix.patch

This patch was dropped because it was withdrawn

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
vmalloc-switch-to-for_each_vmap_node-helper-fix.patch
mm-mempolicy-support-memory-hotplug-in-weighted-interleave-checkpatch-fixes.patch

