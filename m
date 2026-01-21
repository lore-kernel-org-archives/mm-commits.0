Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2AD533C52F
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967327; cv=none; b=iT4E+FQajHMndibthEW6PFXzA2WoRkLron1rcR6ckiBmtYrhM6aSJQz85QoHeSmwCGhtr4P8oTap8xALGVxI6VbNih39cG5SVjmxHBJbrl+3PTl5oCU1A1QUCyTnHTzSMX6zJKAcI+hapgkWlAskwFzTKgPd0wKhCrXu7WjW2oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967327; c=relaxed/simple;
	bh=WyxwDEe/9jLBHvS1LDptJy0h1NiZBziFIFCm1f+BbUU=;
	h=Date:To:From:Subject:Message-Id; b=W28MQcNvvxZUgWGZXFhp1DIeunTIG3gHNtNlD8WLo9hDJCsEhVPOnVGuHy4w+HTn6AatAlsRS6k5fvn1QbpCqchOOE+bS8K0UJBNC9s/a8PU3CH378sLa0tT5P47wJZJUVzhjgCYfyX18EPknaDW2EAnAGE5l/8/5eizJyRLoCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dyGAMgXm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dyGAMgXm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5FABC16AAE;
	Wed, 21 Jan 2026 03:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967326;
	bh=WyxwDEe/9jLBHvS1LDptJy0h1NiZBziFIFCm1f+BbUU=;
	h=Date:To:From:Subject:From;
	b=dyGAMgXmr5KYwWPm4VoljXYy2dNoxfL1Rsts8FZg6hJmjT76ba5SMRhDZxDfPjNuS
	 /AClu9rQhWDEkp7gcgvndRuMtvBYwpoDSHN+QK/tAWis8iSykOUbKmIIMa0d2KPYQJ
	 W2suUjZ6iN8EOSdTvoaclfhI4w1tUMACWrYnMGYE=
Date: Tue, 20 Jan 2026 19:48:46 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,torvalds@linux-foundation.org,mhocko@suse.com,macro@orcam.me.uk,linux@rasmusvillemoes.dk,kees@kernel.org,jannh@google.com,glider@google.com,elver@google.com,dvyukov@google.com,chris.bazley.wg14@gmail.com,alx@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mm-use-array_end-instead-of-open-coding-it.patch removed from -mm tree
Message-Id: <20260121034846.C5FABC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use ARRAY_END() instead of open-coding it
has been removed from the -mm tree.  Its filename was
     mm-use-array_end-instead-of-open-coding-it.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alejandro Colomar <alx@kernel.org>
Subject: mm: use ARRAY_END() instead of open-coding it
Date: Thu, 11 Dec 2025 11:44:04 +0100

There aren't any bugs in this code; it's purely cosmetic.

By using ARRAY_END(), we prevent future issues, in case the code is
modified; it has less moving parts.  Also, it should be more readable (and
perhaps more importantly, greppable), as there are several ways of writing
an expression that gets the end of an array, which are unified by this API
name.

Link: https://lkml.kernel.org/r/2335917d123891fec074ab1b3acfb517cf14b5a7.1765449750.git.alx@kernel.org
Signed-off-by: Alejandro Colomar <alx@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christopher Bazley <chris.bazley.wg14@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Maciej W. Rozycki <macro@orcam.me.uk>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c      |    2 +-
 mm/memcontrol-v1.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/mm/kmemleak.c~mm-use-array_end-instead-of-open-coding-it
+++ a/mm/kmemleak.c
@@ -510,7 +510,7 @@ static void mem_pool_free(struct kmemlea
 {
 	unsigned long flags;
 
-	if (object < mem_pool || object >= mem_pool + ARRAY_SIZE(mem_pool)) {
+	if (object < mem_pool || object >= ARRAY_END(mem_pool)) {
 		kmem_cache_free(object_cache, object);
 		return;
 	}
--- a/mm/memcontrol-v1.c~mm-use-array_end-instead-of-open-coding-it
+++ a/mm/memcontrol-v1.c
@@ -1794,7 +1794,7 @@ static int memcg_numa_stat_show(struct s
 
 	mem_cgroup_flush_stats(memcg);
 
-	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
+	for (stat = stats; stat < ARRAY_END(stats); stat++) {
 		seq_printf(m, "%s=%lu", stat->name,
 			   mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
 						   false));
@@ -1805,7 +1805,7 @@ static int memcg_numa_stat_show(struct s
 		seq_putc(m, '\n');
 	}
 
-	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
+	for (stat = stats; stat < ARRAY_END(stats); stat++) {
 
 		seq_printf(m, "hierarchical_%s=%lu", stat->name,
 			   mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
_

Patches currently in -mm which might be from alx@kernel.org are


