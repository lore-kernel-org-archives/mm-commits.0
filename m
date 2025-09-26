Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E5C2848AE
	for <mm-commits@vger.kernel.org>; Fri, 26 Sep 2025 20:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758918298; cv=none; b=mjlM8i8Z6nc+0Bly73RAzqF1sBWqCw2NgDVu8uxvXcBdQXVueGYwMKIf4PVeVl+6uvLncq8WU+33SU1TAvQmn1ukxBgS/ydemR8XNeZ49sW9tuvvcKqjFBuKI0QGjba3sXYDHFkMEkSz04iRyNtRa+sKqQeflpFmEjNqtq+eq0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758918298; c=relaxed/simple;
	bh=4gAQqxmJZ7KAITeXMJXnLFq0eY7xvdYc91hcAbWCUbs=;
	h=Date:To:From:Subject:Message-Id; b=YGE3QYpG4z5tIdfm+IOoTesH/Vxku7SHvTC18nToEFlTar8YMcoxhKeRi51qaKnk5X04xXxlgGL54sRxF7LBnfz6BvGvKq466nJPwlaIl+/+/w1F/mRBaSFborZbWepafId0eeBjosxdjBdZFaT2KIf+vJiYUHEp0M2CUCJlIbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fEtnOF/A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fEtnOF/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4CDC4CEF4;
	Fri, 26 Sep 2025 20:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758918298;
	bh=4gAQqxmJZ7KAITeXMJXnLFq0eY7xvdYc91hcAbWCUbs=;
	h=Date:To:From:Subject:From;
	b=fEtnOF/AmU5+12PEBUauMcYZpMAWI3iP1Q5nDFfTAzduxq0jhiaopXzVMS3rH0WnR
	 rwVh2EhrZArSTI9ugqr3asL1OTuGo0WSKmPv41BovGsmuR7p1e+k578cFIBq6QSJcI
	 DQcGGsVUaszSJ0RotjE9c4/VF3GZLIWay8/Q50/w=
Date: Fri, 26 Sep 2025 13:24:57 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,usamaarif642@gmail.com,surenb@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,rientjes@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,cl@gentwo.org,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-fix-boot-failure-due-to-null-pointer-dereference.patch added to mm-unstable branch
Message-Id: <20250926202458.5C4CDC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: fix boot failure due to NULL pointer dereference
has been added to the -mm mm-unstable branch.  Its filename is
     alloc_tag-fix-boot-failure-due-to-null-pointer-dereference.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-fix-boot-failure-due-to-null-pointer-dereference.patch

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
From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: alloc_tag: fix boot failure due to NULL pointer dereference
Date: Fri, 26 Sep 2025 08:06:59 +0000

There is a boot failure when both CONFIG_DEBUG_KMEMLEAK and
CONFIG_MEM_ALLOC_PROFILING are enabled.

BUG: kernel NULL pointer dereference, address: 0000000000000000
RIP: 0010:__alloc_tagging_slab_alloc_hook+0x181/0x2f0
Call Trace:
 kmem_cache_alloc_noprof+0x1c8/0x5c0
 __alloc_object+0x2f/0x290
 __create_object+0x22/0x80
 kmemleak_init+0x122/0x190
 mm_core_init+0xb6/0x160
 start_kernel+0x39f/0x920
 x86_64_start_reservations+0x18/0x30
 x86_64_start_kernel+0x104/0x120
 common_startup_64+0x12c/0x138

In kmemleak, mem_pool_alloc() directly calls kmem_cache_alloc_noprof(), as
a result, current->alloc_tag is NULL, leading to a null pointer
dereference.

Move the checks for SLAB_NO_OBJ_EXT, SLAB_NOLEAKTRACE, and
__GFP_NO_OBJ_EXT to the parent function __alloc_tagging_slab_alloc_hook()
to fix this.

Also this distinguishes the SLAB_NOLEAKTRACE case between the actual
memory allocation failures case, make CODETAG_FLAG_INACCURATE more
accurate.

Link: https://lkml.kernel.org/r/20250926080659.741991-1-ranxiaokai627@163.com
Fixes: b9e2f58ffb84 ("alloc_tag: mark inaccurate allocation counters in /proc/allocinfo output")
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/slub.c~alloc_tag-fix-boot-failure-due-to-null-pointer-dereference
+++ a/mm/slub.c
@@ -2109,15 +2109,6 @@ prepare_slab_obj_exts_hook(struct kmem_c
 {
 	struct slab *slab;
 
-	if (!p)
-		return NULL;
-
-	if (s->flags & (SLAB_NO_OBJ_EXT | SLAB_NOLEAKTRACE))
-		return NULL;
-
-	if (flags & __GFP_NO_OBJ_EXT)
-		return NULL;
-
 	slab = virt_to_slab(p);
 	if (!slab_obj_exts(slab) &&
 	    alloc_slab_obj_exts(slab, s, flags, false)) {
@@ -2135,6 +2126,15 @@ __alloc_tagging_slab_alloc_hook(struct k
 {
 	struct slabobj_ext *obj_exts;
 
+	if (!object)
+		return;
+
+	if (s->flags & (SLAB_NO_OBJ_EXT | SLAB_NOLEAKTRACE))
+		return;
+
+	if (flags & __GFP_NO_OBJ_EXT)
+		return;
+
 	obj_exts = prepare_slab_obj_exts_hook(s, flags, object);
 	/*
 	 * Currently obj_exts is used only for allocation profiling.
_

Patches currently in -mm which might be from ran.xiaokai@zte.com.cn are

alloc_tag-fix-boot-failure-due-to-null-pointer-dereference.patch

