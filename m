Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838A339FE5;
	Sat, 24 Aug 2024 05:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724476912; cv=none; b=p+EVEUJQMIfqPn+zIb+Sk1VJDmTNsLUuGTbNPy0JwvxzXwsLxYevC3+PdAZmq7MXIrWFTBTLh1bjWJ6+YCGv0Z+pXCkQ8IhDn/gZ8rFGBRA8PWVZzACu5kLWCmpLHpsezXBYsdhhQjzl2gAU+4ysciGoWP8mtYAwClM983ru/Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724476912; c=relaxed/simple;
	bh=dKevw9Im7V/XWOVfxvrk8/Ou2IDfcHqlFUOO2BXrfV4=;
	h=Date:To:From:Subject:Message-Id; b=Gi7zQ1diRxkVr4hKmW0Ght+sDY2I8xApfHL3ZN636kkE+sGN5H3I68DnF/7OFOq4UCOsrcjbIP/wRl5hjWPiYrbNEf31nkYpiVB+kHHmFi6Cy/7xkia3P4QIecuQUw0k/9ZowniiIu9/vbmMEb1wSype2JoC1btD4bBBLRiWemk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uATMonK6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uATMonK6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C44C32781;
	Sat, 24 Aug 2024 05:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724476912;
	bh=dKevw9Im7V/XWOVfxvrk8/Ou2IDfcHqlFUOO2BXrfV4=;
	h=Date:To:From:Subject:From;
	b=uATMonK6Wrysjm4k5ZpZtqLtzIuDYvDpAFqsNFwTcB9gvMaml4q+NYEPTzzkklv7D
	 4hKjsnwFS4fUcj6KRglEnNvNKxgkGIX5W2ONQ9T+j+H8bkgv0FEE0j67t1+ZdMgjlO
	 G3qOZ6H5d0O/eJ43K30cR8fOA8KK3NSb9NDbm/V8=
Date: Fri, 23 Aug 2024 22:21:51 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,me@yhndnzj.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-respect-zswapwriteback-setting-from-parent-cg-too.patch added to mm-hotfixes-unstable branch
Message-Id: <20240824052151.E4C44C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memcontrol: respect zswap.writeback setting from parent cg too
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memcontrol-respect-zswapwriteback-setting-from-parent-cg-too.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-respect-zswapwriteback-setting-from-parent-cg-too.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Date: Fri, 23 Aug 2024 16:27:06 +0000

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

Link: https://lkml.kernel.org/r/20240823162506.12117-1-me@yhndnzj.com
Fixes: 501a06fe8e4c ("zswap: memcontrol: implement zswap writeback disablin=
g")
Signed-off-by: Mike Yuan <me@yhndnzj.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    7 ++++---
 mm/memcontrol.c                         |   12 +++++++++---
 2 files changed, 13 insertions(+), 6 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-memcontrol-respect-zswapwriteback-setting-from-parent-cg-too
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1717,9 +1717,10 @@ The following nested keys are defined.
 	entries fault back in or are written out to disk.
 
   memory.zswap.writeback
-	A read-write single value file. The default value is "1". The
-	initial value of the root cgroup is 1, and when a new cgroup is
-	created, it inherits the current value of its parent.
+	A read-write single value file. The default value is "1".
+	Note that this setting is hierarchical, i.e. the writeback would be
+	implicitly disabled for child cgroups if the upper hierarchy
+	does so.
 
 	When this is set to 0, all swapping attempts to swapping devices
 	are disabled. This included both zswap writebacks, and swapping due
--- a/mm/memcontrol.c~mm-memcontrol-respect-zswapwriteback-setting-from-parent-cg-too
+++ a/mm/memcontrol.c
@@ -3613,8 +3613,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 	memcg1_soft_limit_reset(memcg);
 #ifdef CONFIG_ZSWAP
 	memcg->zswap_max = PAGE_COUNTER_MAX;
-	WRITE_ONCE(memcg->zswap_writeback,
-		!parent || READ_ONCE(parent->zswap_writeback));
+	WRITE_ONCE(memcg->zswap_writeback, true);
 #endif
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	if (parent) {
@@ -5320,7 +5319,14 @@ void obj_cgroup_uncharge_zswap(struct ob
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
documentation-cgroup-v2-clarify-that-zswapwriteback-is-ignored-if-zswap-is-disabled.patch
selftests-test_zswap-add-test-for-hierarchical-zswapwriteback.patch

