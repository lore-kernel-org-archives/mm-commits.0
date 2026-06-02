Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9D43B9DA4;
	Tue,  2 Jun 2026 22:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439064; cv=none; b=OYBCunAEGnk2SgGIEnq6by8siy2JdwbvFjCabfcxI9QBEbwiMgUOAZbt+kRU0Uye1jSfKsMgdKLFEoGAdz8SiIv9DwTaynOXWRet10mJBnFN2BRscDyP193QEOG8HXR4svE/otP2630SOi2bvJWrT/LtMKWDVBIzpBXh6PFW554=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439064; c=relaxed/simple;
	bh=wJTH0a7rJF0eILSrpxUy1aXR5voLqDYAutIK32cA/9g=;
	h=Date:To:From:Subject:Message-Id; b=FwUW4UPJw8njxMloKGIH/+Kfjb0V7u21LBJ2GCEYV6n+xZFyz5GFXG62ALVuAU+xMvBcyjr2YggcjzEWRft0DULOljok99VhyFBkUnr02cGKT6mSla5I2FIBU9nQsUu+KJeOChekVcXmCz28l1qNe5rtvQdYyaxItkE7g5mRda4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yov1xRdJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yov1xRdJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67041F00899;
	Tue,  2 Jun 2026 22:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439062;
	bh=l+Gf7DOD+EQQM6WYz1IoTZdAx3550bQBgVrK51/pokw=;
	h=Date:To:From:Subject;
	b=yov1xRdJUOPN81w2e1UwS/FejCeUp/vJCltksGLNzr8pMONItbNmJztTOxjd2MsdK
	 7lyXlgmiErWuby7B9NDXLl10ZBwh1WCEips2uSjoUYGQ9PtrY5Gd8otbAJAntmoDlL
	 nGNkQPtogtLUfCjOwzxrbQKdxZtUaKjNKfVouP3g=
Date: Tue, 02 Jun 2026 15:24:22 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,ryncsn@gmail.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hughd@google.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,jose.fernandez@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap_cgroup-fix-null-deref-in-lookup_swap_cgroup_id-on-swapless-host.patch removed from -mm tree
Message-Id: <20260602222422.B67041F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap_cgroup: fix NULL deref in lookup_swap_cgroup_id on swapless host
has been removed from the -mm tree.  Its filename was
     mm-swap_cgroup-fix-null-deref-in-lookup_swap_cgroup_id-on-swapless-host.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


