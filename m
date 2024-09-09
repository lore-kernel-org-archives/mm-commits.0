Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7074518E358
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925311; cv=none; b=olRT6cZ2d70J1buOBKBdF7IGEh84Bn7CGl21U7ZC/7ph9fooMrTIOgeZe3MPea6kZos2kvRTLoprgXtDrmadZDjlIeFgdpLI6AiRxpfrqnsDXi4oD4f/q4l+0s12EHHL29wXqWRs93k+jz7rw935FVbkM5uSdyCW7kyULrW1iUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925311; c=relaxed/simple;
	bh=LHkjcYgqXAydXQ18Ni0DMOM3shU6Fv6/jBb+2Clf6ZI=;
	h=Date:To:From:Subject:Message-Id; b=VeqM595piBgUP55sBgoC+U9UsHuhkvccZNOKL8Yt0jsTAJfMM0jc+qM8fttoeIhB1GSZtS/+rwlVABqwfLKFe083SiHMnB2neH/Umqg8O68TFHQPjXutwZRJhF6bJHwnVPD88gKDU+HEUUPZIL1NW4OkPKKbXaJLu425uk6C5cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XVlFUyf2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XVlFUyf2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C93C4CEC5;
	Mon,  9 Sep 2024 23:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925311;
	bh=LHkjcYgqXAydXQ18Ni0DMOM3shU6Fv6/jBb+2Clf6ZI=;
	h=Date:To:From:Subject:From;
	b=XVlFUyf2dtTzWPX6KqJR0RTTkbUeFF76S0ruRFXK0j3EVr5zXyfzElQ5oJlSVectL
	 uaUY+LQdotvgNVWQnA57cuRdGCythp14YzeUdeMgp8hxM5D/UtfJlCtpHoFQGJ8SSz
	 v4+frrym5Rc9O3EZ/AOpbUU9+p3P7tV2FG2xXE7Y=
Date: Mon, 09 Sep 2024 16:41:50 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tjmercier@google.com,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,lizefan.x@bytedance.com,hughd@google.com,hannes@cmpxchg.org,kinseyho@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] cgroup-clarify-css-sibling-linkage-is-protected-by-cgroup_mutex-or-rcu.patch removed from -mm tree
Message-Id: <20240909234151.48C93C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: cgroup: clarify css sibling linkage is protected by cgroup_mutex or RCU
has been removed from the -mm tree.  Its filename was
     cgroup-clarify-css-sibling-linkage-is-protected-by-cgroup_mutex-or-rcu.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kinsey Ho <kinseyho@google.com>
Subject: cgroup: clarify css sibling linkage is protected by cgroup_mutex or RCU
Date: Thu, 5 Sep 2024 00:30:50 +0000

Patch series "Improve mem_cgroup_iter()", v4.

Incremental cgroup iteration is being used again [1]. This patchset
improves the reliability of mem_cgroup_iter(). It also improves
simplicity and code readability.

[1] https://lore.kernel.org/20240514202641.2821494-1-hannes@cmpxchg.org/


This patch (of 5):

Explicitly document that css sibling/descendant linkage is protected by
cgroup_mutex or RCU.  Also, document in css_next_descendant_pre() and
similar functions that it isn't necessary to hold a ref on @pos.

The following changes in this patchset rely on this clarification for
simplification in memcg iteration code.

Link: https://lkml.kernel.org/r/20240905003058.1859929-1-kinseyho@google.com
Link: https://lkml.kernel.org/r/20240905003058.1859929-2-kinseyho@google.com
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
Cc: Hugh Dickins <hughd@google.com>
Cc: T.J. Mercier <tjmercier@google.com>
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


