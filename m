Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9AF7080E
	for <mm-commits@vger.kernel.org>; Thu, 10 Apr 2025 00:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744245141; cv=none; b=TJgoJKV+AQdyyvx59W4xoeSj1jwKmnZhv0CNa1HuvE89jJDrtlPl/WO2itYhvDdiIIQ5LMqUqOQVqAyVM8OjbqMLUxlz9AFSpRyd7/TzZlz/lFEYdLsH+9jYQD3J2dgafbTPPHwc0o7I9iFxr1goDtz6GO3sAbOhJiT+PEGNTR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744245141; c=relaxed/simple;
	bh=PbEBzTaiE+EzBmU4cvst3684Qm44rFbrnxKRbwlviyc=;
	h=Date:To:From:Subject:Message-Id; b=ghKaYbDpAruCI2k9cVcnehvbeByuNNIiLTu2zF9/9Q2nqkqqvmry8Xe5CUn4smQwuTkkag/iqf23Pu3tBQX4AeIHBZPsD6MUYcEnp2NzmyWD3PhSJvOtqytZ41yR4fWNP8+95LIwkNpVU/Ts2GOZfZjwagARvDkr3vvHp8msswU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P/cqW2Uh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P/cqW2Uh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D925C4CEEB;
	Thu, 10 Apr 2025 00:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744245140;
	bh=PbEBzTaiE+EzBmU4cvst3684Qm44rFbrnxKRbwlviyc=;
	h=Date:To:From:Subject:From;
	b=P/cqW2UhW/6esQPKB+eEbJznKp19qISrdMfpNg0/RFrlpoLfql2b7+hOEXAfDrQxz
	 i7UBIV8EFfC6xk3A3xC+8t6QlP+6ZyJjA+pFC11rx782bMxbOhHqfqDLisQH6GgOGk
	 Xbd7hbmwNIN/88f8EnudX8d+NhOpWLjZmQWHo5Gw=
Date: Wed, 09 Apr 2025 17:32:20 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,lkp@intel.com,hch@infradead.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmalloc-switch-to-for_each_vmap_node-helper-fix.patch added to mm-new branch
Message-Id: <20250410003220.9D925C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmalloc-switch-to-for_each_vmap_node-helper-fix
has been added to the -mm mm-new branch.  Its filename is
     vmalloc-switch-to-for_each_vmap_node-helper-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmalloc-switch-to-for_each_vmap_node-helper-fix.patch

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
Subject: vmalloc-switch-to-for_each_vmap_node-helper-fix
Date: Wed Apr  9 05:30:24 PM PDT 2025

fix build warning

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202504100130.OjlBJLkQ-lkp@intel.com/
Cc: Christop Hellwig <hch@infradead.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~vmalloc-switch-to-for_each_vmap_node-helper-fix
+++ a/mm/vmalloc.c
@@ -5084,7 +5084,7 @@ static void __init vmap_init_free_space(
 static void vmap_init_nodes(void)
 {
 	struct vmap_node *vn;
-	int i, n;
+	int i;
 
 #if BITS_PER_LONG == 64
 	/*
@@ -5101,7 +5101,7 @@ static void vmap_init_nodes(void)
 	 * set of cores. Therefore a per-domain purging is supposed to
 	 * be added as well as a per-domain balancing.
 	 */
-	n = clamp_t(unsigned int, num_possible_cpus(), 1, 128);
+	int n = clamp_t(unsigned int, num_possible_cpus(), 1, 128);
 
 	if (n > 1) {
 		vn = kmalloc_array(n, sizeof(*vn), GFP_NOWAIT | __GFP_NOWARN);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

radix-tree-add-missing-cleanuph-fix.patch
samples-livepatch-add-module-descriptions-fix.patch
mm-kasan-add-module-decription-fix.patch
mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref-fix.patch
mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch
vmalloc-switch-to-for_each_vmap_node-helper-fix.patch
mm-mempolicy-support-memory-hotplug-in-weighted-interleave-checkpatch-fixes.patch

