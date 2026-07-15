Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3039841A55F
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 19:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784142529; cv=none; b=fAdSNDM5yb1HUEz2p93zinMJlCREib/2hjcyK1ASha5/2QZjhZk6UZvX3WMIXMJYqKh0+ndt1ohJZQ/I1Pe0ELnh6iZAo9YPwXE7u6XQJO0rxsgDESOAV3MUf5xCv5yX2npcDi33ibKdGw//zkMSO5rEMm8WRzmI2iEllZvsNy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784142529; c=relaxed/simple;
	bh=lugLoNbB67ni7UNjhGiv6Ys0G2JN1eIh7GJzGdo4J/k=;
	h=Date:To:From:Subject:Message-Id; b=McREkKlQCdjMPH3sAS6ZmA5osW27RbgWF3QAHLxOA6wBSNlzeHou9eSc81kUVA9dmiYuEJENgprA1FC+SvNCu8plmbAjsr8pIBQ+ffC+1qF3bTttvwTZWzSE0XjayWJyaEHOfA/HwlJ3OBOTAM2GTUM1ztL5ibEBe2jxBsIBZ4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Lhy4k92T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lhy4k92T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6881F00A3A;
	Wed, 15 Jul 2026 19:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784142517;
	bh=PbDmg/60Odc6Pvp+Y+ZALxnparIvOVI4MJKUgqMQPj4=;
	h=Date:To:From:Subject;
	b=Lhy4k92TQBq/QcZRwP/q4uVm+JSi6Q8FT2UYDVkf9niJRt+f0riI7iWPEX36kxM5G
	 +phPSWk9F7ATdgc5G/qXpAbEAIR59v8L2x78W6xJpVZnC08eaPImppdjL6zBt7vUxc
	 0Itp8GZ3VOZl2zvARXYxxnAXDKwZ6unHXQLJcozU=
Date: Wed, 15 Jul 2026 12:08:36 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,tj@kernel.org,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,mkoutny@suse.com,mhocko@suse.com,longman@redhat.com,ljs@kernel.org,liam@infradead.org,hannes@cmpxchg.org,david@kernel.org,bigeasy@linutronix.de,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fixup-alloc_pages_nolock_noprof-comment.patch added to mm-new branch
Message-Id: <20260715190836.EC6881F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: fixup alloc_pages_nolock_noprof() comment
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-fixup-alloc_pages_nolock_noprof-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-fixup-alloc_pages_nolock_noprof-comment.patch

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
Subject: mm/page_alloc: fixup alloc_pages_nolock_noprof() comment
Date: Wed, 15 Jul 2026 11:03:20 +0000

Update the comment to reflect the recent change to allow flags in
gfp_nolock.

Link: https://lore.kernel.org/20260715-spin-trylock-followup-v3-3-fc4d246f705d@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reported-by: sashiko-bot@kernel.org
Link: https://sashiko.dev/#/patchset/20260703-alloc-trylock-v5-0-c87b714e19d3%40google.com?part=6
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-fixup-alloc_pages_nolock_noprof-comment
+++ a/mm/page_alloc.c
@@ -7983,7 +7983,8 @@ struct page *alloc_frozen_pages_nolock_n
 }
 /**
  * alloc_pages_nolock - opportunistic reentrant allocation from any context
- * @gfp_flags: GFP flags. Only __GFP_ACCOUNT allowed.
+ * @gfp_flags: GFP flags. Only __GFP_ACCOUNT, plus some flags that get set
+ *             internally regardless (see %gfp_nolock) are allowed.
  * @nid: node to allocate from
  * @order: allocation order size
  *
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
mm-page_alloc-rename-fpi_trylock-fpi_nolock.patch
cgroup-cpuset-update-some-comments-about-the-page-allocator.patch
mm-page_alloc-fixup-alloc_pages_nolock_noprof-comment.patch
mm-page_alloc-remove-a-couple-of-vm_bug_onst.patch

