Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F4A1BE85D
	for <mm-commits@vger.kernel.org>; Fri, 16 Aug 2024 21:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723843356; cv=none; b=nHv95HcguL1AI20wSnWpqiWmlNlrEWAQkS2Yudkrx7w+oNX7ykESXwmOqLBwkhn8zopa/Nb3ZrpyQ3+hQzSbc4xBhaPrv32QioI7U/uTAfcDaERZhtOqqy67D1SrkZpnZkJ5HrrPtnSvWf7An9PR5D2Gj4DSsKI6/Z7VxV/citM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723843356; c=relaxed/simple;
	bh=Fs51K56LPxmbc7D7zYYxiR25GaseQVZ5ncuSvaxyBHk=;
	h=Date:To:From:Subject:Message-Id; b=hVhDmidOfXGXKiKlexzuLucC6mLmTpBOrMUdjLr3jGj/R2phBQKDEtblES1xqs9dkvFq9A/3oQaPazdgx2fXaTmR8cnv5YpLqLZBJSqbkRJPuIh1kVHev8qdTOaa761WDFAC/7Gx5+twwnHTr+j8wpm80J4N0O4oDofOp3POc4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OUW+zs4W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OUW+zs4W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400E6C32782;
	Fri, 16 Aug 2024 21:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723843356;
	bh=Fs51K56LPxmbc7D7zYYxiR25GaseQVZ5ncuSvaxyBHk=;
	h=Date:To:From:Subject:From;
	b=OUW+zs4WB953/sHQEwu55eJ88vPpu/UOKMaoq/kvJcnK+UeULLhg4SyA2V36sEPia
	 JmKSz9XSeO0FMY6ThM5kjr3+Sn1+lttBQ83xZnuwjlLOgPk/GevfEzBJhO3dhtVygU
	 ybcM5arK+2bjD0ccZXSe9xxlJac129iuS/xVn208=
Date: Fri, 16 Aug 2024 14:22:35 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,me@yhndnzj.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-respect-zswapwriteback-setting-from-parent-cg-too.patch added to mm-unstable branch
Message-Id: <20240816212236.400E6C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memcontrol: respect zswap.writeback setting from parent cg too
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-respect-zswapwriteback-setting-from-parent-cg-too.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-respect-zswapwriteback-setting-from-parent-cg-too.patch

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
From: Mike Yuan <me@yhndnzj.com>
Subject: mm/memcontrol: respect zswap.writeback setting from parent cg too
Date: Fri, 16 Aug 2024 14:44:07 +0000

Currently, the behavior of zswap.writeback wrt.  the cgroup hierarchy
seems a bit odd.  Unlike zswap.max, it doesn't honor the value from parent
cgroups.  This surfaced when people tried to globally disable zswap
writeback, i.e.  reserve physical swap space only for hibernation [1] -
disabling zswap.writeback only for the root cgroup results in subcgroups
with zswap.writeback=3D1 still performing writeback.

The inconsistency became more noticeable after I introduced the
MemoryZSwapWriteback=3D systemd unit setting [2] for controlling the knob.
The patch assumed that the kernel would enforce the value of parent
cgroups.  It could probably be workarounded from systemd's side, by going
up the slice unit tree and inheriting the value.  Yet I think it's more
sensible to make it behave consistently with zswap.max and friends.

[1] https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate=
#Disable_zswap_writeback_to_use_the_swap_space_only_for_hibernation
[2] https://github.com/systemd/systemd/pull/31734

Link: https://lkml.kernel.org/r/20240816144344.18135-1-me@yhndnzj.com
Signed-off-by: Mike Yuan <me@yhndnzj.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    5 ++++-
 mm/memcontrol.c                         |    9 ++++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-memcontrol-respect-zswapwriteback-setting-from-parent-cg-too
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1744,7 +1744,10 @@ The following nested keys are defined.
   memory.zswap.writeback
 	A read-write single value file. The default value is "1". The
 	initial value of the root cgroup is 1, and when a new cgroup is
-	created, it inherits the current value of its parent.
+	created, it inherits the current value of its parent. Note that
+	this setting is hierarchical, i.e. the writeback would be
+	implicitly disabled for child cgroups if the upper hierarchy
+	does so.
 
 	When this is set to 0, all swapping attempts to swapping devices
 	are disabled. This included both zswap writebacks, and swapping due
--- a/mm/memcontrol.c~mm-memcontrol-respect-zswapwriteback-setting-from-parent-cg-too
+++ a/mm/memcontrol.c
@@ -5355,7 +5355,14 @@ void obj_cgroup_uncharge_zswap(struct ob
 bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
 {
 	/* if zswap is disabled, do not block pages going to the swapping device */
-	return !zswap_is_enabled() || !memcg || READ_ONCE(memcg->zswap_writeback);
+	if (!zswap_is_enabled())
+		return true;
+
+	for (; memcg; memcg = parent_mem_cgroup(memcg))
+		if (!READ_ONCE(memcg->zswap_writeback))
+			return false;
+
+	return true;
 }
 
 static u64 zswap_current_read(struct cgroup_subsys_state *css,
_

Patches currently in -mm which might be from me@yhndnzj.com are

mm-memcontrol-respect-zswapwriteback-setting-from-parent-cg-too.patch
selftests-test_zswap-add-test-for-hierarchical-zswapwriteback.patch

