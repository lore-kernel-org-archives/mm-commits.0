Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A70B2253F8
	for <mm-commits@vger.kernel.org>; Thu,  6 Feb 2025 07:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738828662; cv=none; b=XalxIM3oX4k8e5n947+MQgQNdul9aoAc0QWHIe0XtA1kvTn+bsGnHuZVWOhXCNOAa8IIg3xMIb8+4bR6dTTXophTmDHXgHttV6KgqEhJPe0+UvNLZjYn9QbIfUHxybrDfd204ZX41DuJ9ZbB0hEDI+5UIKqhhK37sY7D+PI/qsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738828662; c=relaxed/simple;
	bh=uYWtPlIGJRWnUqF34XbSnm487FZjsKNeLP/PIlh8rQs=;
	h=Date:To:From:Subject:Message-Id; b=aRv34B1aPrlGvD40fF+o2waeSUsAcuW084bDzd2afBeCCXoCEtnouQxWGpJxyogaUjGgDhg/895dLIUK2nlPOA3q9M3i305Ghw769yUQizOUju4TzoweQJHYCpptl5mjrxiEAF1ueBml4FQMsanE69+xBd6uN18CfMq00SkvnfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kL5LzrWK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kL5LzrWK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F81C4CEDD;
	Thu,  6 Feb 2025 07:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738828662;
	bh=uYWtPlIGJRWnUqF34XbSnm487FZjsKNeLP/PIlh8rQs=;
	h=Date:To:From:Subject:From;
	b=kL5LzrWKT1TLP8rx5+CshOc3gKNDjlVgOZdDQzPxQYupynoJB7HZGavAUHTPgCF4x
	 KQutQzzOaRd/7XvvWFWB7zN47BK9nvxV03kpB3k53Z705TMqYW8wvBdn29ZB88pMeP
	 d1TKfps1vujd9bgyNlaHio7TjZqYQC9AzQgvwMe4=
Date: Wed, 05 Feb 2025 23:57:41 -0800
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,chrisl@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfilec-remove-the-unneeded-checking.patch added to mm-unstable branch
Message-Id: <20250206075741.E3F81C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swapfile.c: remove the unneeded checking
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swapfilec-remove-the-unneeded-checking.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapfilec-remove-the-unneeded-checking.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: mm/swapfile.c: remove the unneeded checking
Date: Wed, 5 Feb 2025 17:27:18 +0800

In free_swap_and_cache_nr(), invocation of get_swap_device() has done the
checking if it's a swap entry.  So remove the redundant checking here.

Link: https://lkml.kernel.org/r/20250205092721.9395-10-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Chis Li <chrisl@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/swapfile.c~mm-swapfilec-remove-the-unneeded-checking
+++ a/mm/swapfile.c
@@ -1784,9 +1784,6 @@ void free_swap_and_cache_nr(swp_entry_t
 	bool any_only_cache = false;
 	unsigned long offset;
 
-	if (non_swap_entry(entry))
-		return;
-
 	si = get_swap_device(entry);
 	if (!si)
 		return;
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-swap_statec-fix-the-obsolete-code-comment.patch
mm-swap_statec-optimize-the-code-in-clear_shadow_from_swap_cache.patch
mm-swap-remove-swap_flag_prio_shift.patch
mm-swap-skip-scanning-cluster-range-if-its-empty-cluster.patch
mm-swap-rename-swap_is_has_cache-to-swap_only_has_cache.patch
mm-swapfilec-update-the-code-comment-above-swap_count_continued.patch
mm-swapfilec-optimize-code-in-setup_clusters.patch
mm-swap_statec-remove-the-meaningless-code-comment.patch
mm-swapfilec-remove-the-unneeded-checking.patch
mm-swap-rename-swap_swapcount-to-swap_entry_swapped.patch
mm-swapfilec-remove-the-incorrect-code-comment.patch
mm-swapfilec-open-code-cluster_alloc_swap.patch

