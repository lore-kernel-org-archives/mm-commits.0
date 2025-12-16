Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E87326B2B0
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 03:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765854293; cv=none; b=L938cPuyEAvCBZQOB18G8SkqCyI3QCZ6MNBNtwUvREbz+ohFiXPE0rGJ//5TrxtomTl8WtjJJP+MIgcb/TNcPgsYgW7gR19IwuwQQ3NznaBXvPGf9gXSBKtHEbroOB8j/WRTRNnn+CYg27mDgLfBIB5bS0aGNhqyAkWylHMEMZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765854293; c=relaxed/simple;
	bh=1mngJokv7CmjtJmfRLHsL6iEr6lcEsKeVdo4xmysgIg=;
	h=Date:To:From:Subject:Message-Id; b=Q+BXb/NU0p0MtarQJuSDkXKlmWHQgpTQssyAr/mWzyx9DVT/7tlOl1wYgM2lc3Dhd2bPuRH1MYMHpl7Tq/WHMKS9B+YcgTmfy0YqtVAesBarpbzrv9FcN4a+aL5zX+D+pUQfdaevVUscbAZuLIOoPn4AGJh8f124JNAoMSGo8GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lVcuZRyd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lVcuZRyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42B4C4CEF5;
	Tue, 16 Dec 2025 03:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765854292;
	bh=1mngJokv7CmjtJmfRLHsL6iEr6lcEsKeVdo4xmysgIg=;
	h=Date:To:From:Subject:From;
	b=lVcuZRyd7ZTi4H8IwtsxhyG3NZSOKzUYUZx+Xj9/4OdQkQWQEKzMrE33D+P0iKGH8
	 iidDKptdYiX99qsyTUCRhbhNGqfdCQaPzEZF6iFRTjSkkeN9XIHqMf6f5h8YUvWXug
	 Ke2sIWjokjnKoijs3j3yaMqy9gEMTloOppdzo6pI=
Date: Mon, 15 Dec 2025 19:04:52 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,torvalds@linux-foundation.org,mhocko@suse.com,macro@orcam.me.uk,linux@rasmusvillemoes.dk,kees@kernel.org,jannh@google.com,glider@google.com,elver@google.com,dvyukov@google.com,chris.bazley.wg14@gmail.com,alx@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-array_end-instead-of-open-coding-it.patch added to mm-nonmm-unstable branch
Message-Id: <20251216030452.B42B4C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use ARRAY_END() instead of open-coding it
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-use-array_end-instead-of-open-coding-it.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-array_end-instead-of-open-coding-it.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

array_sizeh-add-array_end.patch
mm-fix-benign-off-by-one-bugs.patch
kernel-fix-off-by-one-benign-bugs.patch
mm-use-array_end-instead-of-open-coding-it.patch

