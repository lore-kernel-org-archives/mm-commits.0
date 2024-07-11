Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889F15BACF
	for <mm-commits@vger.kernel.org>; Thu, 11 Jul 2024 19:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720726549; cv=none; b=aXDLOCX6ibPu3l3HguveUnQkEPBuhOvAx7Ww7w9RcwgNb1y+6K51+wDcnmCqfQCIbQp7c4R2SdQv9FU0KumRgc3CZb6plxR/DtIm7j0aY51zUXAXwUrY0Q6OeHRo4wvJTBnKblh2lqE3G76J0MtApXDB2dgA/7JQRSD0Vc6mAWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720726549; c=relaxed/simple;
	bh=QHJOBRS2+i8S36eEkaBsSsn70nZAi0GdO5A220rO32U=;
	h=Date:To:From:Subject:Message-Id; b=awsMzrHscOWZHAtb+X5eCWiuh3r2+epCmdbhZ3I0WrCizfsy6pmnQJ9BOf32/5Y2sBbELbkVo7FD4sN298gLbgsvz1PPEN1jHHlbYoh6zSUapuRIU8nnNWPYOyB2WFLc358HtqNa2sdMPHJlTv90CWalnkQDQrSpsJlp9nWBqPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q8A6VBOH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q8A6VBOH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E63E2C116B1;
	Thu, 11 Jul 2024 19:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720726549;
	bh=QHJOBRS2+i8S36eEkaBsSsn70nZAi0GdO5A220rO32U=;
	h=Date:To:From:Subject:From;
	b=Q8A6VBOHfrYliU0S9phDlUkt+3TWZaqEFYzyOD0QOlgXbhYrDMSxfa+hTTqeK18Ex
	 B16sX/71RWNbz5olpAdvzuRXdF2bXi9+owqPaNMGCq1ODomNw0xKZcgDP27SQgRvzj
	 rZj5vXQknencaeRkoMts+QHOcNOsbnm2nTkM2fs8=
Date: Thu, 11 Jul 2024 12:35:48 -0700
To: mm-commits@vger.kernel.org,yonghong.song@linux.dev,song@kernel.org,sdf@fomichev.me,roman.gushchin@linux.dev,rientjes@google.com,mjguzik@gmail.com,martin.lau@linux.dev,kpsingh@kernel.org,jolsa@kernel.org,john.fastabend@gmail.com,haoluo@google.com,eddyz87@gmail.com,daniel@iogearbox.net,cl@linux.com,ast@kernel.org,andrii@kernel.org,akinobu.mita@gmail.com,42.hyeyoo@gmail.com,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-slab-put-should_failslab-back-behind-config_should_failslab.patch added to mm-unstable branch
Message-Id: <20240711193548.E63E2C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, slab: put should_failslab() back behind CONFIG_SHOULD_FAILSLAB
has been added to the -mm mm-unstable branch.  Its filename is
     mm-slab-put-should_failslab-back-behind-config_should_failslab.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-slab-put-should_failslab-back-behind-config_should_failslab.patch

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
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slab: put should_failslab() back behind CONFIG_SHOULD_FAILSLAB
Date: Thu, 11 Jul 2024 18:35:30 +0200

Patch series "revert unconditional slab and page allocator fault injection
calls".

These two patches largely revert commits that added function call overhead
into slab and page allocation hotpaths and that cannot be currently
disabled even though related CONFIG_ options do exist.

A much more involved solution that can keep the callsites always existing
but hidden behind a static key if unused, is possible [1] and can be
pursued by anyone who believes it's necessary.  Meanwhile the fact the
should_failslab() error injection is already not functional on kernels
built with current gcc without anyone noticing [2], and lukewarm response
to [1] suggests the need is not there.  I believe it will be more fair to
have the state after this series as a baseline for possible further
optimisation, instead of the unconditional overhead.

For example a possible compromise for anyone who's fine with an empty
function call overhead but not the full CONFIG_FAILSLAB /
CONFIG_FAIL_PAGE_ALLOC overhead is to reuse patch 1 from [1] but insert a
static key check only inside should_failslab() and
should_fail_alloc_page() before performing the more expensive checks.

[1] https://lore.kernel.org/all/20240620-fault-injection-statickeys-v2-0-e23947d3d84b@suse.cz/#t
[2] https://github.com/bpftrace/bpftrace/issues/3258


This patch (of 2):

This mostly reverts commit 4f6923fbb352 ("mm: make should_failslab always
available for fault injection").  The commit made should_failslab() a
noinline function that's always called from the slab allocation hotpath,
even if it's empty because CONFIG_SHOULD_FAILSLAB is not enabled, and
there is no option to disable that call.  This is visible in profiles and
the function call overhead can be noticeable especially with cpu
mitigations.

Meanwhile the bpftrace program example in the commit silently does not
work without CONFIG_SHOULD_FAILSLAB anyway with a recent gcc, because the
empty function gets a .constprop clone that is actually being called
(uselessly) from the slab hotpath, while the error injection is hooked to
the original function that's not being called at all [1].

Thus put the whole should_failslab() function back behind
CONFIG_SHOULD_FAILSLAB.  It's not a complete revert of 4f6923fbb352 - the
int return type that returns -ENOMEM on failure is preserved, as well
ALLOW_ERROR_INJECTION annotation.  The BTF_ID() record that was meanwhile
added is also guarded by CONFIG_SHOULD_FAILSLAB.

[1] https://github.com/bpftrace/bpftrace/issues/3258

Link: https://lkml.kernel.org/r/20240711-b4-fault-injection-reverts-v1-0-9e2651945d68@suse.cz
Link: https://lkml.kernel.org/r/20240711-b4-fault-injection-reverts-v1-1-9e2651945d68@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Hao Luo <haoluo@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Song Liu <song@kernel.org>
Cc: Stanislav Fomichev <sdf@fomichev.me>
Cc: Yonghong Song <yonghong.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fault-inject.h |    5 ++---
 kernel/bpf/verifier.c        |    2 ++
 mm/failslab.c                |   14 ++++++++------
 mm/slub.c                    |    8 --------
 4 files changed, 12 insertions(+), 17 deletions(-)

--- a/include/linux/fault-inject.h~mm-slab-put-should_failslab-back-behind-config_should_failslab
+++ a/include/linux/fault-inject.h
@@ -102,11 +102,10 @@ static inline bool __should_fail_alloc_p
 }
 #endif /* CONFIG_FAIL_PAGE_ALLOC */
 
-int should_failslab(struct kmem_cache *s, gfp_t gfpflags);
 #ifdef CONFIG_FAILSLAB
-extern bool __should_failslab(struct kmem_cache *s, gfp_t gfpflags);
+int should_failslab(struct kmem_cache *s, gfp_t gfpflags);
 #else
-static inline bool __should_failslab(struct kmem_cache *s, gfp_t gfpflags)
+static inline int should_failslab(struct kmem_cache *s, gfp_t gfpflags)
 {
 	return false;
 }
--- a/kernel/bpf/verifier.c~mm-slab-put-should_failslab-back-behind-config_should_failslab
+++ a/kernel/bpf/verifier.c
@@ -21123,7 +21123,9 @@ BTF_SET_START(btf_non_sleepable_error_in
  */
 BTF_ID(func, __filemap_add_folio)
 BTF_ID(func, should_fail_alloc_page)
+#ifdef CONFIG_FAILSLAB
 BTF_ID(func, should_failslab)
+#endif
 BTF_SET_END(btf_non_sleepable_error_inject)
 
 static int check_non_sleepable_error_inject(u32 btf_id)
--- a/mm/failslab.c~mm-slab-put-should_failslab-back-behind-config_should_failslab
+++ a/mm/failslab.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/fault-inject.h>
+#include <linux/error-injection.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include "slab.h"
@@ -14,23 +15,23 @@ static struct {
 	.cache_filter = false,
 };
 
-bool __should_failslab(struct kmem_cache *s, gfp_t gfpflags)
+int should_failslab(struct kmem_cache *s, gfp_t gfpflags)
 {
 	int flags = 0;
 
 	/* No fault-injection for bootstrap cache */
 	if (unlikely(s == kmem_cache))
-		return false;
+		return 0;
 
 	if (gfpflags & __GFP_NOFAIL)
-		return false;
+		return 0;
 
 	if (failslab.ignore_gfp_reclaim &&
 			(gfpflags & __GFP_DIRECT_RECLAIM))
-		return false;
+		return 0;
 
 	if (failslab.cache_filter && !(s->flags & SLAB_FAILSLAB))
-		return false;
+		return 0;
 
 	/*
 	 * In some cases, it expects to specify __GFP_NOWARN
@@ -41,8 +42,9 @@ bool __should_failslab(struct kmem_cache
 	if (gfpflags & __GFP_NOWARN)
 		flags |= FAULT_NOWARN;
 
-	return should_fail_ex(&failslab.attr, s->object_size, flags);
+	return should_fail_ex(&failslab.attr, s->object_size, flags) ? -ENOMEM : 0;
 }
+ALLOW_ERROR_INJECTION(should_failslab, ERRNO);
 
 static int __init setup_failslab(char *str)
 {
--- a/mm/slub.c~mm-slab-put-should_failslab-back-behind-config_should_failslab
+++ a/mm/slub.c
@@ -3892,14 +3892,6 @@ static __always_inline void maybe_wipe_o
 			0, sizeof(void *));
 }
 
-noinline int should_failslab(struct kmem_cache *s, gfp_t gfpflags)
-{
-	if (__should_failslab(s, gfpflags))
-		return -ENOMEM;
-	return 0;
-}
-ALLOW_ERROR_INJECTION(should_failslab, ERRNO);
-
 static __fastpath_inline
 struct kmem_cache *slab_pre_alloc_hook(struct kmem_cache *s, gfp_t flags)
 {
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slab-put-should_failslab-back-behind-config_should_failslab.patch
mm-page_alloc-put-should_fail_alloc_page-back-behing-config_fail_page_alloc.patch

