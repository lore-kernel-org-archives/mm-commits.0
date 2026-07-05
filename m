Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0DD35F60E
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 07:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783236675; cv=none; b=O/qRW+qLl6LqkCNsa145jV4ZaCq+mHerTYrmPQjM3hI0eYgV5pRH7+rRqK3P2a19+MWpluGLkD0JbuzoeAui/1zidy8uAzhDVo6huKUbOjeRjRbUehdRCwwL+GIuMWKEGNjHQsCkLi8ShKaM7di+Sl5wR+CCk6oahGPPYmC+zes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783236675; c=relaxed/simple;
	bh=TOCZ8sxz1mr42S+YZjSWXBoj+T7bZ5Wge+NaqgqrlSM=;
	h=Date:To:From:Subject:Message-Id; b=rEgOBIMlI0ww4L8K0Ev4llg4cN1YD16Rn8FUU6k463Amh5JfhAi1HFJT2Cu2bW4VpiKeJmr6B+23uExjcz/kyKnX91ST76h0kR4i1RzCd2w/U6kwJMTpjpPA3WRP4jb4wAgqJT4GH4OwDlXaWQGgUfoVaE8p0r9UeASzIsmIDrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k/XDW4Ic; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k/XDW4Ic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86AF61F000E9;
	Sun,  5 Jul 2026 07:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783236673;
	bh=MX4z2Pi8RLzFh72JuSu1td/UVXv83B48nU6xDXZuHDk=;
	h=Date:To:From:Subject;
	b=k/XDW4IcsKIC6n1bup0MsiCYotxVkSkxKLIz+APxWjLUNbSP+EDYfD8Gzs7Q9oxbt
	 TJbdTeb7kspkPi8ngnkGyWoJ2194tR0YzVfsPNfp35Yqp4JlgXKpNp+svtETAuIVFW
	 0gbyGcUBYN8mIajPMv+0uRzS3XNz9GWw46K3kptg=
Date: Sun, 05 Jul 2026 00:31:13 -0700
To: mm-commits@vger.kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-name-some-args-in-a-function-declaration.patch added to mm-new branch
Message-Id: <20260705073113.86AF61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: name some args in a function declaration
has been added to the -mm mm-new branch.  Its filename is
     mm-name-some-args-in-a-function-declaration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-name-some-args-in-a-function-declaration.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Brendan Jackman <jackmanb@google.com>
Subject: mm: name some args in a function declaration
Date: Fri, 03 Jul 2026 12:31:43 +0000

Checkpatch complains about this, a later patch will move the code, fix it
so that checkpatch doesn't complain about that patch.  Do it in a separate
patch so the "move the code" patch is trivial to review using Git's diff
colouring.

Link: https://lore.kernel.org/20260703-alloc-trylock-v5-3-c87b714e19d3@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/internal.h~mm-name-some-args-in-a-function-declaration
+++ a/mm/internal.h
@@ -919,8 +919,8 @@ extern bool free_pages_prepare(struct pa
 
 extern int user_min_free_kbytes;
 
-struct page *__alloc_frozen_pages_noprof(gfp_t, unsigned int order, int nid,
-		nodemask_t *);
+struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order, int nid,
+		nodemask_t *nodemask);
 #define __alloc_frozen_pages(...) \
 	alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
 void free_frozen_pages(struct page *page, unsigned int order);
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-page_alloc-drop-flag-conversion-optimisation.patch
mm-secretmem-disable-under-highmem.patch
mm-page_alloc-rename-alloc_trylock-alloc_nolock.patch
mm-page_alloc-some-renames-to-clarify-alloc_flags-scopes.patch
mm-name-some-args-in-a-function-declaration.patch
mm-split-out-internal-page_alloch.patch
mm-page_alloc-unify-__alloc_frozen_pages_noprof.patch
mm-page_alloc-relax-gfp-warn-in-nolock-allocs.patch
mm-move-some-stuff-to-mm-page_alloch.patch
perf-x86-intel-use-higher-level-allocator-api.patch
kvm-vmx-use-higher-level-allocator-api.patch
x86-virt-use-higher-level-allocator-api.patch
sgi-xp-use-higher-level-allocator-api.patch
net-funeth-switch-to-higher-level-allocator-api.patch
mm-remove-__alloc_pages_node.patch
mm-move-__alloc_pages-to-mm-page_alloch.patch
mm-replace-__gfp_no_codetag-with-alloc_no_codetag.patch
mm-page_alloc-drop-alloc_flags-arg-from-alloc_flags_cma.patch
mm-factor-out-can_spin_trylock.patch

