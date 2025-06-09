Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6995C2F4A
	for <mm-commits@vger.kernel.org>; Mon,  9 Jun 2025 19:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749497735; cv=none; b=m90UUqH2hTP+jrn+gnpUwR1KmPkJV+FY0tn3F+mqH+KsUNJFIRd66EJmM4Q3XDgI5xP55S8BNcJayv7OdG4Djf+eJDawcyD3pwZNlWsRIeo3ly8ZiVUlyyTExHbOVavywbyz/c46d423lZVjfHHbA5acqYPFUQpetlTl5GnLWGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749497735; c=relaxed/simple;
	bh=zuKeiaXX2xkkKu6ZEn4SauDBHyUGXTnlvIKb59rpBwg=;
	h=Date:To:From:Subject:Message-Id; b=ATTvMxqOHlcCO+f2VDEb7opSba5Emnp+v/uuboetu3c/0iVvagyE5EcK2yxUztbod56ipfVJE86zilNmT6Ni1JxYBiOIequIgQdvgvfJ6xH9dbT3sTU6JNIO6h9rfKm63k+chEhFS9qkciq2pT/fSX1c9+RqaKi1zz6XEmqPX4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w3zqeyPD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w3zqeyPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE5EC4CEEB;
	Mon,  9 Jun 2025 19:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749497735;
	bh=zuKeiaXX2xkkKu6ZEn4SauDBHyUGXTnlvIKb59rpBwg=;
	h=Date:To:From:Subject:From;
	b=w3zqeyPD7ouuomQSXFNVBpt2qkYxtvAuv95+vmF1s2CCGKULh0iuIpS9T/w06W4sd
	 J2yq47vUF5K3vLaBVFT6GHBt3/iJqhGe0e3US2uv1xUEiWtAv5lSU4zJ17aZ/z4/UZ
	 vMQrrGBQwkAm+BuaT0kRrkQ5NS17a0do4WmQN9M4=
Date: Mon, 09 Jun 2025 12:35:34 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,mjguzik@gmail.com,linus.walleij@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fork-define-a-local-gfp_vmap_stack.patch added to mm-nonmm-unstable branch
Message-Id: <20250609193534.ECE5EC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fork: define a local GFP_VMAP_STACK
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fork-define-a-local-gfp_vmap_stack.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fork-define-a-local-gfp_vmap_stack.patch

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

fork-define-a-local-gfp_vmap_stack.patch

