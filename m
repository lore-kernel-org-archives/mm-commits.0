Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAF241760
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 23:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724803041; cv=none; b=fov+NdqQXe/o9gT5xiEQz/tmeMw0pGRYrWY/v+Qvjsnht9izc+ZOTUDL2w+COC+QLfHTj8RHHqD2eegSbMGId5s4odbfhUWFXlbTOggvcnzv15+Ow9fD3is4OkIaAp/JyqVzBHD894/qYbiCdEoDD3TPbmSBdeEqa4ZfcoW68HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724803041; c=relaxed/simple;
	bh=kccdPUYg+HoiZW23Alq5dnCBnPn6xV/ZwJ4GU0c5f8E=;
	h=Date:To:From:Subject:Message-Id; b=mzs4sQ7MA+qv0JEolIxjX+Ym5oBdNjk6UsHlofcj0utR72N2vi6J04IAVtAW3Yh7nJhx1yBYCEql5PP7u3XwadEmiN2V7I6e+mklb/LHAWwCuPpp4Tz2dV/NqPG7kGFoycEtb5FcwYlCsljK/jDDkLLh1kTX5Pyp2BanbYU4bQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PkKQV+t6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PkKQV+t6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CD2C32782;
	Tue, 27 Aug 2024 23:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724803041;
	bh=kccdPUYg+HoiZW23Alq5dnCBnPn6xV/ZwJ4GU0c5f8E=;
	h=Date:To:From:Subject:From;
	b=PkKQV+t6IkhnWRs0dje3O2L+O8WePwChSRCAVOkpL7OZsJkSyC5YugwKpGFlEoBo7
	 uvUqZs5esmd8eTtWtRnhtlxM3IML8IwK2K0gRaobPUHUVR5ZaRNdGgyDSTu2IVLZob
	 mDnEnRK2r9Laj81nvIXX7KhKYysq9H8YXEWcT1WE=
Date: Tue, 27 Aug 2024 16:57:20 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,lizefan.x@bytedance.com,hannes@cmpxchg.org,kinseyho@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + cgroup-clarify-css-sibling-linkage-is-protected-by-cgroup_mutex-or-rcu.patch added to mm-unstable branch
Message-Id: <20240827235721.60CD2C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: cgroup: clarify css sibling linkage is protected by cgroup_mutex or RCU
has been added to the -mm mm-unstable branch.  Its filename is
     cgroup-clarify-css-sibling-linkage-is-protected-by-cgroup_mutex-or-rcu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cgroup-clarify-css-sibling-linkage-is-protected-by-cgroup_mutex-or-rcu.patch

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
From: Kinsey Ho <kinseyho@google.com>
Subject: cgroup: clarify css sibling linkage is protected by cgroup_mutex or RCU
Date: Tue, 27 Aug 2024 23:07:38 +0000

Pach series "Improve mem_cgroup_iter()", v3.

Incremental cgroup iteration is being used again [1].  This patchset
improves the reliability of mem_cgroup_iter().  It also improves
simplicity and code readability.

[1] https://lore.kernel.org/20240514202641.2821494-1-hannes@cmpxchg.org/


This patch (of 5):

Explicitly document that css sibling/descendant linkage is protected by
cgroup_mutex or RCU.  Also, document in css_next_descendant_pre() and
similar functions that it isn't necessary to hold a ref on @pos.

The following changes in this patchset rely on this clarification for
simplification in memcg iteration code.

Link: https://lkml.kernel.org/r/20240827230753.2073580-1-kinseyho@google.com
Link: https://lkml.kernel.org/r/20240827230753.2073580-2-kinseyho@google.com
Suggested-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Kinsey Ho <kinseyho@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup-defs.h |    6 +++++-
 kernel/cgroup/cgroup.c      |   16 +++++++++-------
 2 files changed, 14 insertions(+), 8 deletions(-)

--- a/include/linux/cgroup-defs.h~cgroup-clarify-css-sibling-linkage-is-protected-by-cgroup_mutex-or-rcu
+++ a/include/linux/cgroup-defs.h
@@ -172,7 +172,11 @@ struct cgroup_subsys_state {
 	/* reference count - access via css_[try]get() and css_put() */
 	struct percpu_ref refcnt;
 
-	/* siblings list anchored at the parent's ->children */
+	/*
+	 * siblings list anchored at the parent's ->children
+	 *
+	 * linkage is protected by cgroup_mutex or RCU
+	 */
 	struct list_head sibling;
 	struct list_head children;
 
--- a/kernel/cgroup/cgroup.c~cgroup-clarify-css-sibling-linkage-is-protected-by-cgroup_mutex-or-rcu
+++ a/kernel/cgroup/cgroup.c
@@ -4602,8 +4602,9 @@ struct cgroup_subsys_state *css_next_chi
  *
  * While this function requires cgroup_mutex or RCU read locking, it
  * doesn't require the whole traversal to be contained in a single critical
- * section.  This function will return the correct next descendant as long
- * as both @pos and @root are accessible and @pos is a descendant of @root.
+ * section. Additionally, it isn't necessary to hold onto a reference to @pos.
+ * This function will return the correct next descendant as long as both @pos
+ * and @root are accessible and @pos is a descendant of @root.
  *
  * If a subsystem synchronizes ->css_online() and the start of iteration, a
  * css which finished ->css_online() is guaranteed to be visible in the
@@ -4651,8 +4652,9 @@ EXPORT_SYMBOL_GPL(css_next_descendant_pr
  *
  * While this function requires cgroup_mutex or RCU read locking, it
  * doesn't require the whole traversal to be contained in a single critical
- * section.  This function will return the correct rightmost descendant as
- * long as @pos is accessible.
+ * section. Additionally, it isn't necessary to hold onto a reference to @pos.
+ * This function will return the correct rightmost descendant as long as @pos
+ * is accessible.
  */
 struct cgroup_subsys_state *
 css_rightmost_descendant(struct cgroup_subsys_state *pos)
@@ -4696,9 +4698,9 @@ css_leftmost_descendant(struct cgroup_su
  *
  * While this function requires cgroup_mutex or RCU read locking, it
  * doesn't require the whole traversal to be contained in a single critical
- * section.  This function will return the correct next descendant as long
- * as both @pos and @cgroup are accessible and @pos is a descendant of
- * @cgroup.
+ * section. Additionally, it isn't necessary to hold onto a reference to @pos.
+ * This function will return the correct next descendant as long as both @pos
+ * and @cgroup are accessible and @pos is a descendant of @cgroup.
  *
  * If a subsystem synchronizes ->css_online() and the start of iteration, a
  * css which finished ->css_online() is guaranteed to be visible in the
_

Patches currently in -mm which might be from kinseyho@google.com are

cgroup-clarify-css-sibling-linkage-is-protected-by-cgroup_mutex-or-rcu.patch
mm-dont-hold-css-refcnt-during-traversal.patch
mm-increment-gen-before-restarting-traversal.patch
mm-restart-if-multiple-traversals-raced.patch
mm-clean-up-mem_cgroup_iter.patch

