Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CF925783C
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 03:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783999031; cv=none; b=g2mZnTz3cVXmIRmX6uui1J9u2/zGLI2deofH/EQE2t6u0ukP52Qbh4QGPLgqgnF0NuSZwHbrH39eG+iX74IdIa9FG81x+/Ax9AO0jyiW7SyuqBQFc9bbKdf9c0GFdOo16lJPyHyOlhWKeA2EOK3DroxAoGkYlk97+rCeoJWK3r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783999031; c=relaxed/simple;
	bh=NOz+bUHgQCKzgDagK6Sns8DrBwHSepKZCH6Ble0Y5Hs=;
	h=Date:To:From:Subject:Message-Id; b=A5Zay1gkkhI9glQa/ny9dU037s2PmOfy1CiKssTG24b7NaUCS16KU0UJfx/p6Ojq7J1vU02Fxt1KTf8q8UeaOIqhY5hOba50wMR2XhWumWcg9FV6n+mJddjjKb9oDezweI1JInj5h37wi8IbukG57WrNeNCBXvXUtVNWP7GReP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2dbuVTG0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2dbuVTG0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2811F000E9;
	Tue, 14 Jul 2026 03:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783999029;
	bh=si/f3+dd2WQ7PanXe3rKCGnmVx+M0S+2DYJRJMs7YaU=;
	h=Date:To:From:Subject;
	b=2dbuVTG0r2O77QZzc3KcacuaTpqqnamx1U52rphFP3UyXOUiGqvX1E3JVofZsfjSK
	 xNwQ7dsHe7tw0LRcF/X16sQoLfff/MwE2haA75Df1YahJgESxhsQVkLkKMfWxcu1fD
	 HsOSTIY5YSZJDzu/tdtE2VlASm6VJAjHR+bQLxZI=
Date: Mon, 13 Jul 2026 20:17:09 -0700
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-hoist-config_memcg-to-function-level-for-print_page_owner_memcg.patch added to mm-unstable branch
Message-Id: <20260714031709.AC2811F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: hoist CONFIG_MEMCG to function level for print_page_owner_memcg()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_owner-hoist-config_memcg-to-function-level-for-print_page_owner_memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-hoist-config_memcg-to-function-level-for-print_page_owner_memcg.patch

This patch will later appear in the mm-unstable branch at
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
From: Ye Liu <ye.liu@linux.dev>
Subject: mm/page_owner: hoist CONFIG_MEMCG to function level for print_page_owner_memcg()
Date: Tue, 14 Jul 2026 09:51:03 +0800

The print_page_owner_memcg() function has CONFIG_MEMCG guarding its entire
body via #ifdef inside the function, which leaves a no-op { return ret; }
when the config is disabled.  Hoist the #ifdef to the top level so the
real implementation and the empty stub are two clearly separated
definitions.

No functional change.

Link: https://lore.kernel.org/20260714015117.78351-5-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-hoist-config_memcg-to-function-level-for-print_page_owner_memcg
+++ a/mm/page_owner.c
@@ -522,13 +522,13 @@ ext_put_continue:
 	seq_putc(m, '\n');
 }
 
+#ifdef CONFIG_MEMCG
 /*
  * Looking for memcg information and print it out
  */
 static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 					 struct page *page)
 {
-#ifdef CONFIG_MEMCG
 	unsigned long memcg_data;
 	struct mem_cgroup *memcg;
 	bool online;
@@ -556,10 +556,16 @@ static inline int print_page_owner_memcg
 			name);
 out_unlock:
 	rcu_read_unlock();
-#endif /* CONFIG_MEMCG */
 
 	return ret;
 }
+#else
+static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
+					 struct page *page)
+{
+	return ret;
+}
+#endif
 
 static ssize_t
 print_page_owner(char __user *buf, size_t count, unsigned long pfn,
_

Patches currently in -mm which might be from ye.liu@linux.dev are

mm-page_owner-extract-skip_buddy_pages-helper-to-unify-buddy-page-skipping.patch
mm-page_owner-add-mr_never-to-enum-migrate_reason-and-use-it-for-last_migrate_reason.patch
mm-use-enum-migrate_reason-instead-of-int-for-migration-reason-parameters.patch
mm-page_owner-hoist-config_memcg-to-function-level-for-print_page_owner_memcg.patch
mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch
mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner.patch
mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols.patch
mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary.patch
mm-page_owner-use-memcg_data-snapshot-to-avoid-toctou-in-print_page_owner_memcg.patch

