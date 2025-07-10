Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8188617741
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127149; cv=none; b=i+2SppTmEkcZl6fsdjBEWQoPaB8V3tQ7ePIDAxfnXgeBWoGcgtkwWZphVctNwEO3WqlAeaBYuM1p2QzXKA08/q5Viiu88VWGOU22jhrZA7SrhZ2Tsu8cpSscRI4VrPJ4wgR86OADEQorRpPpgT6k/m1XFKi8VPFyAb27ksimmEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127149; c=relaxed/simple;
	bh=RDw1TITZM0Su9KPmBjdqDz2G5R61dRR1j91/VP0f2Os=;
	h=Date:To:From:Subject:Message-Id; b=lpddab7DiRiDXIxocF62O8Bw9caBpFlZS0OAzGK1TeC9DdPVrqK4AANidQ25gGILo8g12K4gjjfemkNk3uopjWed43lAxAjTVf+pf4wSvRPawIKllkySY6oKE2dCqY/653Ro+XHf8Wc5QEIoWoeOR1qexBOrTiDy/AgCuJ/Xw3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zz4J2wkz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zz4J2wkz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7A4C4CEE3;
	Thu, 10 Jul 2025 05:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752127149;
	bh=RDw1TITZM0Su9KPmBjdqDz2G5R61dRR1j91/VP0f2Os=;
	h=Date:To:From:Subject:From;
	b=Zz4J2wkzbYZPCqwNJGFlQtxBAmxnoiUM8ZqiRcveGz86Swojk5aoM5ZNHLOodivhQ
	 YA3fLvpICJbXdxOxuh4eeeV3e5OXz6m2aANknu74k0volhzCcqTiVGyAqzb2Iui7TR
	 drzClzYWIJcGSifi+fsVE8E+N61wxg2u+jN02+jM=
Date: Wed, 09 Jul 2025 22:59:08 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,mjguzik@gmail.com,linus.walleij@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fork-define-a-local-gfp_vmap_stack.patch removed from -mm tree
Message-Id: <20250710055908.EE7A4C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fork: define a local GFP_VMAP_STACK
has been removed from the -mm tree.  Its filename was
     fork-define-a-local-gfp_vmap_stack.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Linus Walleij <linus.walleij@linaro.org>
Subject: fork: define a local GFP_VMAP_STACK
Date: Fri, 09 May 2025 09:25:09 +0200

The current allocation of VMAP stack memory is using (THREADINFO_GFP &
~__GFP_ACCOUNT) which is a complicated way of saying (GFP_KERNEL |
__GFP_ZERO):

<linux/thread_info.h>:
define THREADINFO_GFP (GFP_KERNEL_ACCOUNT | __GFP_ZERO)
<linux/gfp_types.h>:
define GFP_KERNEL_ACCOUNT (GFP_KERNEL | __GFP_ACCOUNT)

This is an unfortunate side-effect of independent changes blurring the
picture:

commit 19809c2da28aee5860ad9a2eff760730a0710df0 changed (THREADINFO_GFP |
__GFP_HIGHMEM) to just THREADINFO_GFP since highmem became implicit.

commit 9b6f7e163cd0f468d1b9696b785659d3c27c8667 then added stack caching
and rewrote the allocation to (THREADINFO_GFP & ~__GFP_ACCOUNT) as cached
stacks need to be accounted separately.  However that code, when it
eventually accounts the memory does this:

  ret = memcg_kmem_charge(vm->pages[i], GFP_KERNEL, 0)

so the memory is charged as a GFP_KERNEL allocation.

Define a unique GFP_VMAP_STACK to use
GFP_KERNEL | __GFP_ZERO and move the comment there.

Link: https://lkml.kernel.org/r/20250509-gfp-stack-v1-1-82f6f7efc210@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reported-by: Mateusz Guzik <mjguzik@gmail.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/kernel/fork.c~fork-define-a-local-gfp_vmap_stack
+++ a/kernel/fork.c
@@ -201,6 +201,12 @@ static inline void free_task_struct(stru
  */
 #define NR_CACHED_STACKS 2
 static DEFINE_PER_CPU(struct vm_struct *, cached_stacks[NR_CACHED_STACKS]);
+/*
+ * Allocated stacks are cached and later reused by new threads, so memcg
+ * accounting is performed by the code assigning/releasing stacks to tasks.
+ * We need a zeroed memory without __GFP_ACCOUNT.
+ */
+#define GFP_VMAP_STACK (GFP_KERNEL | __GFP_ZERO)
 
 struct vm_stack {
 	struct rcu_head rcu;
@@ -307,13 +313,8 @@ static int alloc_thread_stack_node(struc
 		return 0;
 	}
 
-	/*
-	 * Allocated stacks are cached and later reused by new threads,
-	 * so memcg accounting is performed manually on assigning/releasing
-	 * stacks to tasks. Drop __GFP_ACCOUNT.
-	 */
 	stack = __vmalloc_node(THREAD_SIZE, THREAD_ALIGN,
-				     THREADINFO_GFP & ~__GFP_ACCOUNT,
+				     GFP_VMAP_STACK,
 				     node, __builtin_return_address(0));
 	if (!stack)
 		return -ENOMEM;
_

Patches currently in -mm which might be from linus.walleij@linaro.org are


