Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF50F2165E2
	for <mm-commits@vger.kernel.org>; Mon, 28 Jul 2025 22:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753742490; cv=none; b=TdAx+FkLuCO+FtWOAZAtPYyrxNlOYXgB7HmEVgOJlaI5qLbcfUd/in7KSVCXo414/TQqhlYpFYkYW7jzWo2youHTmKAP/0xjbhBoAz1oz8F/7vK3K2JliN8Pb3ZLPru+bqdTTL2IsoGElc8cuFn4G8CgdkGn/rb8BHgCiM8KF6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753742490; c=relaxed/simple;
	bh=aejIE/XJDG9H950y9mj0eSD98pjhMw6gmqwlToVK8nM=;
	h=Date:To:From:Subject:Message-Id; b=IgKsY7LKpEn9FPyo/rEQCe1GvR1u5T2NGwWFZYAEyRL3sL39fnqFHeDLoNxgo64Pux2o7MvmFcKWjuuoo3QMc/DI4l1ioNUHztpNUHRwJZrs+355qVvg2zZnjIWMR53zgYTfeLXRl+rQbaqHzWUHpOJx6eFTDW/US4ZCj4pfyRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VvkXFfqF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VvkXFfqF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA75C4CEE7;
	Mon, 28 Jul 2025 22:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753742490;
	bh=aejIE/XJDG9H950y9mj0eSD98pjhMw6gmqwlToVK8nM=;
	h=Date:To:From:Subject:From;
	b=VvkXFfqFSyqBzWyfbEQTGcoJMmuK4ugz0071K/uKsGd8ASvuH5z3G4+NXXac96bbq
	 Bg60SxkUtLt0ey+exomPeAOj37KlNmL55007wFVSp/XhjROs2PtHsCCbAtR7Kc9QvE
	 7CiF0pUGOrPHMnun1/JMgC0WKTm6AcluHsiJPxco=
Date: Mon, 28 Jul 2025 15:41:30 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,petr.pavlu@suse.com,peterz@infradead.org,mhiramat@kernel.org,da.gomez@samsung.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + execmem-move-execmem_force_rw-and-execmem_restore_rox-before-use.patch added to mm-unstable branch
Message-Id: <20250728224130.9AA75C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: execmem: move execmem_force_rw() and execmem_restore_rox() before use
has been added to the -mm mm-unstable branch.  Its filename is
     execmem-move-execmem_force_rw-and-execmem_restore_rox-before-use.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/execmem-move-execmem_force_rw-and-execmem_restore_rox-before-use.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: execmem: move execmem_force_rw() and execmem_restore_rox() before use
Date: Sun, 13 Jul 2025 10:17:26 +0300

to avoid static declarations.

Link: https://lkml.kernel.org/r/20250713071730.4117334-5-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/execmem.c |   44 +++++++++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 23 deletions(-)

--- a/mm/execmem.c~execmem-move-execmem_force_rw-and-execmem_restore_rox-before-use
+++ a/mm/execmem.c
@@ -137,6 +137,27 @@ err_restore:
 	return err;
 }
 
+static int execmem_force_rw(void *ptr, size_t size)
+{
+	unsigned int nr = PAGE_ALIGN(size) >> PAGE_SHIFT;
+	unsigned long addr = (unsigned long)ptr;
+	int ret;
+
+	ret = set_memory_nx(addr, nr);
+	if (ret)
+		return ret;
+
+	return set_memory_rw(addr, nr);
+}
+
+int execmem_restore_rox(void *ptr, size_t size)
+{
+	unsigned int nr = PAGE_ALIGN(size) >> PAGE_SHIFT;
+	unsigned long addr = (unsigned long)ptr;
+
+	return set_memory_rox(addr, nr);
+}
+
 static void execmem_cache_clean(struct work_struct *work)
 {
 	struct maple_tree *free_areas = &execmem_cache.free_areas;
@@ -328,8 +349,6 @@ static inline void *pending_free_clear(v
 	return (void *)((unsigned long)ptr & ~PENDING_FREE_MASK);
 }
 
-static int execmem_force_rw(void *ptr, size_t size);
-
 static int __execmem_cache_free(struct ma_state *mas, void *ptr, gfp_t gfp_mask)
 {
 	size_t size = mas_range_len(mas);
@@ -415,27 +434,6 @@ static bool execmem_cache_free(void *ptr
 	return true;
 }
 
-static int execmem_force_rw(void *ptr, size_t size)
-{
-	unsigned int nr = PAGE_ALIGN(size) >> PAGE_SHIFT;
-	unsigned long addr = (unsigned long)ptr;
-	int ret;
-
-	ret = set_memory_nx(addr, nr);
-	if (ret)
-		return ret;
-
-	return set_memory_rw(addr, nr);
-}
-
-int execmem_restore_rox(void *ptr, size_t size)
-{
-	unsigned int nr = PAGE_ALIGN(size) >> PAGE_SHIFT;
-	unsigned long addr = (unsigned long)ptr;
-
-	return set_memory_rox(addr, nr);
-}
-
 #else /* CONFIG_ARCH_HAS_EXECMEM_ROX */
 /*
  * when ROX cache is not used the permissions defined by architectures for
_

Patches currently in -mm which might be from rppt@kernel.org are

execmem-drop-unused-execmem_update_copy.patch
execmem-introduce-execmem_alloc_rw.patch
execmem-rework-execmem_cache_free.patch
execmem-move-execmem_force_rw-and-execmem_restore_rox-before-use.patch
execmem-add-fallback-for-failures-in-vmallocvm_allow_huge_vmap.patch
execmem-drop-writable-parameter-from-execmem_fill_trapping_insns.patch
x86-kprobes-enable-execmem_rox_cache-for-kprobes-allocations.patch
x86-ftrace-enable-execmem_rox_cache-for-ftrace-allocations.patch
kho-add-test-for-kexec-handover.patch

