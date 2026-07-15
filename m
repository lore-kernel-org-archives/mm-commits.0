Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89C648C40C;
	Wed, 15 Jul 2026 19:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784144013; cv=none; b=XM16PPqnvYF+acwy3KyGgNMEKPH37DYHa3PyuytgS5+G7fpanSuoFHXj8aOivsPl6RBYFLk1chf8fciifBPj75yVdj4u9R5X1v/FcGU/V4Uxo42HTIulh1YY4U2l4szdBZKnk/2O2fuR6t4QcktGHH0dAjC6Gv6qjthbKAf8Ai8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784144013; c=relaxed/simple;
	bh=FoWioUo1v853u6zI9bLQiiEhuXjxmciD3VUsELirQcQ=;
	h=Date:To:From:Subject:Message-Id; b=fWF6ivrz9k0DV/p5s6f5i+dQsyTMhAMkRACikxhBrExrY7uLgzL3+pIDnbFRw6JquiwnMgPZK1D0AsylGH/PB9FGq34VNX6c5K2E0joXNO5ebYcgcQKhI/KiDxWDhoEsBuelzzYMvEGRiCJEbl6qRX33Fcv7jGbf6l7us+O2dI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ACi283r9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ACi283r9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506A81F00A3A;
	Wed, 15 Jul 2026 19:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784144011;
	bh=NlzbNQ+OrEXLlZC6q06Q4LzXoOinxmPmYIFe+NroSHI=;
	h=Date:To:From:Subject;
	b=ACi283r9BiWkNJBXRR5SPD04WwSALOP7q01Sqcpf1YM7PRurGBEv1pXmhLYrYK8HT
	 4U0ypierHOelaGmS6y/aoZ1gGCU7rocmvUYcR760JYT4yTvEMFqD9dAy2tUVMiupVL
	 Q9Ijndqi6NSNrkfddm9mlop0z0Dw93sK2HGsWz0Q=
Date: Wed, 15 Jul 2026 12:33:30 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,rostedt@goodmis.org,mhocko@suse.com,harry@kernel.org,hannes@cmpxchg.org,bigeasy@linutronix.de,ast@kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-dont-spin_trylock-when-disallowed-in-free_one_page.patch added to mm-new branch
Message-Id: <20260715193331.506A81F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: don't spin_trylock() when disallowed in free_one_page()
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-dont-spin_trylock-when-disallowed-in-free_one_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-dont-spin_trylock-when-disallowed-in-free_one_page.patch

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
Subject: mm/page_alloc: don't spin_trylock() when disallowed in free_one_page()
Date: Wed, 15 Jul 2026 09:03:59 +0000

__free_frozen_pages() checks can_spin_trylock() before entering into the
main free_frozen_page_commit()/free_one_page() path, but before this it
can get to free_one_page() via the !pcp_allowed_order() and
MIGRATE_ISOLATE paths.

The !pcp_allowed_order() path depends on usage by callers so might not be
possible in practice.  The MIGRATE_ISOLATE path probably means kernel
crashes and privilege escalation if anyone ever did memory hotplug and BPF
tracing on a PREEMPT_RT or !SMP build.

Link: https://lore.kernel.org/20260715-alloc-nolock-fixes-v1-2-fadc49952dda@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Fixes: 8c57b687e8331 ("mm, bpf: Introduce free_pages_nolock()")
Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260710-spin-trylock-followup-v1-0-affb5fe5ed00%40google.com?part=2
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-dont-spin_trylock-when-disallowed-in-free_one_page
+++ a/mm/page_alloc.c
@@ -1559,7 +1559,7 @@ static void free_one_page(struct zone *z
 	unsigned long flags;
 
 	if (unlikely(fpi_flags & FPI_TRYLOCK)) {
-		if (!spin_trylock_irqsave(&zone->lock, flags)) {
+		if (!can_spin_trylock() || !spin_trylock_irqsave(&zone->lock, flags)) {
 			add_page_to_zone_llist(zone, page, order);
 			return;
 		}
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
mm-page_alloc-dont-spin_trylock-in-nmi-on-up.patch
mm-page_alloc-dont-spin_trylock-when-disallowed-in-free_one_page.patch
mm-page_alloc-rename-fpi_trylock-fpi_nolock.patch
cgroup-cpuset-update-some-comments-about-the-page-allocator.patch
mm-page_alloc-fixup-alloc_pages_nolock_noprof-comment.patch
mm-page_alloc-remove-a-couple-of-vm_bug_onst.patch

