Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4292818A925
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925235; cv=none; b=nFe0qXll/nI5MS4r3oc7vPKC4LgElYmiDA9XVWTBMO/ZbokKRlbD6v6Jc7Pu/P9N9xFcya2TKi4ymdmEZ1AVFwdBZGDs7S4+Oabm3djw9xu4XDpH9wasgLoV+qmCn+sn9uFsKdg2l8MCvjR5VpmmiSAjxndceLVBrgLH7XnmhMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925235; c=relaxed/simple;
	bh=PWna9918APuq75yNmK9iHhYHl/YGhlW6uBYrVcZ8heU=;
	h=Date:To:From:Subject:Message-Id; b=lyzCf5G03ocqKVP9oZgMkQDlmV3Wx21jkYFVza4n8AM36mUKy5yaKj02ibp5UPtebUpcxR3gAmmy13dCwRA00xTEUwuL6YkNKS4yhCg3huExeqQbO42zavDxTF6hsXrKRmP8J942tM9KnOJVHrARD3LITioUU/Ok11JnB3JTOMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IlNSC4vC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IlNSC4vC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B47C4CEC5;
	Mon,  9 Sep 2024 23:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925235;
	bh=PWna9918APuq75yNmK9iHhYHl/YGhlW6uBYrVcZ8heU=;
	h=Date:To:From:Subject:From;
	b=IlNSC4vCxQS+HMUOwXJXo0NA87lZ9af4hAiZMDnA7sgVSklX5GToCCkfYUFXnLkum
	 Bcz2yVX8fStEJYax5PtoluwY6MZSraIMfw1eIGnywT2Ji9QjhKgap7JBQDh88JMJaj
	 1rHYFsQ89yj6AN++FejXNf4ebWDQmPWiTWApEVSA=
Date: Mon, 09 Sep 2024 16:40:34 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,dave@stgolabs.net,mjguzik@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-sort-out-global-lock-annotations.patch removed from -mm tree
Message-Id: <20240909234035.16B47C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: sort out global lock annotations
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-sort-out-global-lock-annotations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mateusz Guzik <mjguzik@gmail.com>
Subject: mm/hugetlb: sort out global lock annotations
Date: Wed, 28 Aug 2024 18:07:04 +0200

The mutex array pointer shares a cacheline with the spinlock:
ffffffff84187480 B hugetlb_fault_mutex_table
ffffffff84187488 B hugetlb_lock

This is because the former is annotated with a macro forcing cacheline
alignment.  I suspect it was meant to be the variant which on top of it
makes sure the object does not share the cacheline with anyone.

Since array pointer itself is de facto read-only such an annotation does
not make sense there anyway.  Instead mark it __ro_after_init along with
the size var.

Do however move the spinlock out of the way.

[akpm@linux-foundation.org: move section directives to the end of the definitions, per convention]
[akpm@linux-foundation.org: DEFINE_SPINLOCK doesn't permit section modifiers at end-of-definition]
Link: https://lkml.kernel.org/r/20240828160704.1425767-1-mjguzik@gmail.com
Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-sort-out-global-lock-annotations
+++ a/mm/hugetlb.c
@@ -72,14 +72,14 @@ static unsigned int default_hugepages_in
  * Protects updates to hugepage_freelists, hugepage_activelist, nr_huge_pages,
  * free_huge_pages, and surplus_huge_pages.
  */
-DEFINE_SPINLOCK(hugetlb_lock);
+__cacheline_aligned_in_smp DEFINE_SPINLOCK(hugetlb_lock);
 
 /*
  * Serializes faults on the same logical page.  This is used to
  * prevent spurious OOMs when the hugepage pool is fully utilized.
  */
-static int num_fault_mutexes;
-struct mutex *hugetlb_fault_mutex_table ____cacheline_aligned_in_smp;
+static int num_fault_mutexes __ro_after_init;
+struct mutex *hugetlb_fault_mutex_table __ro_after_init;
 
 /* Forward declaration */
 static int hugetlb_acct_memory(struct hstate *h, long delta);
_

Patches currently in -mm which might be from mjguzik@gmail.com are


