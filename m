Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5ACD45945
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 02:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724811830; cv=none; b=sucdYKYJcm5B1vdYsAoOPoHx+KxrnpooJq5CGZsminTcSlvyhfZOi6YHw6Kx8lL/+Mt8OO8BOkx6F4vHi3PFKKzeNC7XeVRrrDoSGQy5lrJVtem16J+IMmRta6dS40ouRzRBgoYaPrD3qQ1kmsWGySNzPpffQK8wHf+83Y1F6Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724811830; c=relaxed/simple;
	bh=EkbROegmd1qi8fyHLuZlmd/AuJQJEscaBb3ZF/0pATY=;
	h=Date:To:From:Subject:Message-Id; b=aG4sP+A07Hr5QHiWI03b3JY2gMzRLFvK1Wy0sheK3Geg7stODoTrSaxAFUwqA3qTQlB6CrCknhAwZE/ZBsq7+p+lWGVGfyi3RIC5OCXDhSnT4y2KUE1P/YCpxfA8o6KHCR8y6STIKS8tf724+VhDV0bnQmyBaL67bvt6zMGxnjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GkseYQLx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GkseYQLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3500EC4FDFD;
	Wed, 28 Aug 2024 02:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724811829;
	bh=EkbROegmd1qi8fyHLuZlmd/AuJQJEscaBb3ZF/0pATY=;
	h=Date:To:From:Subject:From;
	b=GkseYQLx1k25f0s3lttA3O/CX7rKB0EV7swqAG0UZD77h7AdLPb0lm6/6JAY7tXpg
	 pAbXCjoIQYP1FswOtLkRNT0ATBFzRCy8iuaZI88Y1azXFY7Gk+lcN2BYTexSUJY1SJ
	 anAemcbrkMA8o5Nzg555JqxmKceM4uenB0+iG0ws=
Date: Tue, 27 Aug 2024 19:23:48 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,v-songbaohua@oppo.com,ryan.roberts@arm.com,kasong@tencent.com,kaleshsingh@google.com,david@redhat.com,chrisl@kernel.org,baohua@kernel.org,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix-2.patch added to mm-unstable branch
Message-Id: <20240828022349.3500EC4FDFD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: check all swaps belong to same swap_cgroup in swap_pte_batch() fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix-2.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: mm: check all swaps belong to same swap_cgroup in swap_pte_batch() fix
Date: Sun, 25 Aug 2024 13:09:46 -0700 (PDT)

mm-unstable swap_pte_batch() adds a new usage of lookup_swap_cgroup_id(),
which crashes if CONFIG_MEMCG kernel booted with "cgroup_disable=memory":
it now needs a mem_cgroup_disabled() check.

Link: https://lkml.kernel.org/r/33f34a88-0130-5444-9b84-93198eeb50e7@google.com
Fixes: 92b50df44566 ("mm: check all swaps belong to same swap_cgroup in swap_pte_batch()")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Barry Song <baohua@kernel.org>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_cgroup.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/swap_cgroup.c~mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix-2
+++ a/mm/swap_cgroup.c
@@ -161,6 +161,8 @@ unsigned short swap_cgroup_record(swp_en
  */
 unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
 {
+	if (mem_cgroup_disabled())
+		return 0;
 	return lookup_swap_cgroup(ent, NULL)->id;
 }
 
_

Patches currently in -mm which might be from hughd@google.com are

mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix-2.patch
mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large-fix.patch
mm-shmem-support-large-folio-swap-out-fix.patch
mm-shmem-fix-minor-off-by-one-in-shrinkable-calculation.patch
mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes.patch

