Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35DE349CFC;
	Wed, 13 May 2026 02:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778640768; cv=none; b=gZ5PaJA8x9QcIIa6FHM155nmZmtaafrIEl6/Gooreg4N/3zx+tZVfS5L7fn6dlY5qeXX5ZeU9Y+tGlAYr5Nk80EwUyAUjb3ABX8xecLR9zVQMei+MKPd1M5SL8pYhUv4imdIgTEzmDC23qaGXIolxbGydNiBJXhjCD6m3eSleuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778640768; c=relaxed/simple;
	bh=3hDimKE1fAKscOhJHZokQog4qjU3uAU1wJQQEOH5qKE=;
	h=Date:To:From:Subject:Message-Id; b=qThLtJwIO0E7REjC0CoJ58UCVt7X/Dv2p71UgeHaURZEt8yMoCxXQg22alYnxZqvzNQRRFTDNQFjk93q3JS9+F5qkbViupd7RX8S8cxHZzk5Zioxbn05XbF1d7xzTKpoB1cL3/MeObffI3FlIAhHZKHYYZzmVMJostntch5FQRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mJYFc58W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mJYFc58W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F91C2BCB0;
	Wed, 13 May 2026 02:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778640767;
	bh=3hDimKE1fAKscOhJHZokQog4qjU3uAU1wJQQEOH5qKE=;
	h=Date:To:From:Subject:From;
	b=mJYFc58WqK2xliPZbi3IVRbt335npuyJ4eUCN8f+8flCWZ/6IjGZaGkOnmkh6FtlH
	 DVYqu3iN9hbfgbSWZPyGC4KwT8JZrqj7NGluAKcuFTkZCHU68XUl91HwcEcHiComzJ
	 7cqZ1WotGlw2U6Pu14kRToYTl5TQljh6k4MtB5ns=
Date: Tue, 12 May 2026 19:52:46 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,ryncsn@gmail.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hughd@google.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,jose.fernandez@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap_cgroup-fix-null-deref-in-lookup_swap_cgroup_id-on-swapless-host.patch added to mm-hotfixes-unstable branch
Message-Id: <20260513025247.60F91C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap_cgroup: fix NULL deref in lookup_swap_cgroup_id on swapless host
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-swap_cgroup-fix-null-deref-in-lookup_swap_cgroup_id-on-swapless-host.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap_cgroup-fix-null-deref-in-lookup_swap_cgroup_id-on-swapless-host.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
Subject: mm: swap_cgroup: fix NULL deref in lookup_swap_cgroup_id on swapless host
Date: Mon, 04 May 2026 12:55:17 +0000

lookup_swap_cgroup_id() passes swap_cgroup_ctrl[type].map to
__swap_cgroup_id_lookup() without checking that the type was ever
registered via swap_cgroup_swapon().  On a swapless host every ctrl->map
is NULL, so __swap_cgroup_id_lookup() dereferences NULL + a scaled
swp_offset().

Since commit bea67dcc5eea ("mm: attempt to batch free swap entries for
zap_pte_range()"), zap_pte_range() -> swap_pte_batch() calls
lookup_swap_cgroup_id() on any non-present, non-none PTE that decodes as a
real swap entry, without first validating it against swap_info[].  A
single PTE corrupted into a type-0 swap entry takes the host down at
process exit.

We hit this in production on a swapless 6.12.58 host: ~1s of
"get_swap_device: Bad swap file entry 3f800204222bb" (do_swap_page() being
correctly defensive about the same entry) followed by

  BUG: unable to handle page fault for address: 000003f800204220
  RIP: 0010:lookup_swap_cgroup_id+0x2b/0x60
  Call Trace:
   swap_pte_batch+0xbf/0x230
   zap_pte_range+0x4c8/0x780
   unmap_page_range+0x190/0x3e0
   exit_mmap+0xd9/0x3c0
   do_exit+0x20c/0x4b0

syzbot has reported the identical stack.

The source of the PTE corruption is a separate bug; this change makes the
teardown path as robust as the fault path already is.  Every other caller
of lookup_swap_cgroup_id() is downstream of a get_swap_device() that has
already validated the entry, so the new branch is cold.

Link: https://lore.kernel.org/20260504-swap-cgroup-fix-7-0-v1-1-f53ff41ee553@linux.dev
Fixes: bea67dcc5eea ("mm: attempt to batch free swap entries for zap_pte_range()")
Signed-off-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
Reported-by: syzbot+e12bd9ca48157add237a@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/69859728.050a0220.3b3015.0033.GAE@google.com
Assisted-by: Claude:unspecified
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_cgroup.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/swap_cgroup.c~mm-swap_cgroup-fix-null-deref-in-lookup_swap_cgroup_id-on-swapless-host
+++ a/mm/swap_cgroup.c
@@ -124,6 +124,8 @@ unsigned short lookup_swap_cgroup_id(swp
 		return 0;
 
 	ctrl = &swap_cgroup_ctrl[swp_type(ent)];
+	if (unlikely(!ctrl->map))
+		return 0;
 	return __swap_cgroup_id_lookup(ctrl->map, swp_offset(ent));
 }
 
_

Patches currently in -mm which might be from jose.fernandez@linux.dev are

mm-swap_cgroup-fix-null-deref-in-lookup_swap_cgroup_id-on-swapless-host.patch

