Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195372165E2
	for <mm-commits@vger.kernel.org>; Mon, 28 Jul 2025 22:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753742488; cv=none; b=LSEdi7fMUR5kdsvx8zi8fyRzKC6cnVLc8lki54dKwkggqhkawwWqVpO501kS//YtfhSlhMfolrAG5itAUfLWWHdieazOwvDq4pIXL27z0mACcnbcYhyEn1fVbLOurJIF3lLIIxbz3ZR3TSa8imyUS2QnPDS5ffiPf8+s205w4QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753742488; c=relaxed/simple;
	bh=rt4yugjaw56mruMgMX0jQmunxaNgcTjwankIQlNhf8M=;
	h=Date:To:From:Subject:Message-Id; b=tX7gZM9on9n4EwP5mW/LWUxtB10/vWSrUJCUvd+HcfXzrarXQiZHAHd8nRwJNlENl/HgytzE4Wtqak5r+4SUc8VCEy21K3YtSydfXrIVCfyk8LpNi//nGTN/0dl1ZjKU4TFDG7BPfmpNSXGmGGiNPmuioBs1hMe29FlRs50JpD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v/5E3+EJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v/5E3+EJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7AA9C4CEE7;
	Mon, 28 Jul 2025 22:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753742487;
	bh=rt4yugjaw56mruMgMX0jQmunxaNgcTjwankIQlNhf8M=;
	h=Date:To:From:Subject:From;
	b=v/5E3+EJ2Cdf22OgvgwnHwoVsLYu+mzA0oPMB8FFm144XzX6ZRcA4Yk9IJkse1tSG
	 JUB/uutMRl4n7iDR7yTcRLRpRckoYR9ZNzA6744ASA+HrtXeWkYOmlOZTr2fO0Ggq5
	 whEhEkPfWLz9GyVJaW/wuRWGH1Lf6BjtvLjUHI1Y=
Date: Mon, 28 Jul 2025 15:41:27 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,petr.pavlu@suse.com,peterz@infradead.org,mhiramat@kernel.org,da.gomez@samsung.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + execmem-introduce-execmem_alloc_rw.patch added to mm-unstable branch
Message-Id: <20250728224127.C7AA9C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: execmem: introduce execmem_alloc_rw()
has been added to the -mm mm-unstable branch.  Its filename is
     execmem-introduce-execmem_alloc_rw.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/execmem-introduce-execmem_alloc_rw.patch

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
Subject: execmem: introduce execmem_alloc_rw()
Date: Sun, 13 Jul 2025 10:17:24 +0300

Some callers of execmem_alloc() require the memory to be temporarily
writable even when it is allocated from ROX cache.  These callers use
execemem_make_temp_rw() right after the call to execmem_alloc().

Wrap this sequence in execmem_alloc_rw() API.

Link: https://lkml.kernel.org/r/20250713071730.4117334-3-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Daniel Gomez <da.gomez@samsung.com>
Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/alternative.c |    3 --
 include/linux/execmem.h       |   38 ++++++++++++++++++--------------
 kernel/module/main.c          |   13 +---------
 mm/execmem.c                  |   27 +++++++++++++++++++++-
 4 files changed, 51 insertions(+), 30 deletions(-)

--- a/arch/x86/kernel/alternative.c~execmem-introduce-execmem_alloc_rw
+++ a/arch/x86/kernel/alternative.c
@@ -120,7 +120,7 @@ struct its_array its_pages;
 
 static void *__its_alloc(struct its_array *pages)
 {
-	void *page __free(execmem) = execmem_alloc(EXECMEM_MODULE_TEXT, PAGE_SIZE);
+	void *page __free(execmem) = execmem_alloc_rw(EXECMEM_MODULE_TEXT, PAGE_SIZE);
 	if (!page)
 		return NULL;
 
@@ -237,7 +237,6 @@ static void *its_alloc(void)
 	if (!page)
 		return NULL;
 
-	execmem_make_temp_rw(page, PAGE_SIZE);
 	if (pages == &its_pages)
 		set_memory_x((unsigned long)page, 1);
 
--- a/include/linux/execmem.h~execmem-introduce-execmem_alloc_rw
+++ a/include/linux/execmem.h
@@ -68,21 +68,6 @@ enum execmem_range_flags {
 void execmem_fill_trapping_insns(void *ptr, size_t size, bool writable);
 
 /**
- * execmem_make_temp_rw - temporarily remap region with read-write
- *			  permissions
- * @ptr:	address of the region to remap
- * @size:	size of the region to remap
- *
- * Remaps a part of the cached large page in the ROX cache in the range
- * [@ptr, @ptr + @size) as writable and not executable. The caller must
- * have exclusive ownership of this range and ensure nothing will try to
- * execute code in this range.
- *
- * Return: 0 on success or negative error code on failure.
- */
-int execmem_make_temp_rw(void *ptr, size_t size);
-
-/**
  * execmem_restore_rox - restore read-only-execute permissions
  * @ptr:	address of the region to remap
  * @size:	size of the region to remap
@@ -95,7 +80,6 @@ int execmem_make_temp_rw(void *ptr, size
  */
 int execmem_restore_rox(void *ptr, size_t size);
 #else
-static inline int execmem_make_temp_rw(void *ptr, size_t size) { return 0; }
 static inline int execmem_restore_rox(void *ptr, size_t size) { return 0; }
 #endif
 
@@ -166,6 +150,28 @@ struct execmem_info *execmem_arch_setup(
 void *execmem_alloc(enum execmem_type type, size_t size);
 
 /**
+ * execmem_alloc_rw - allocate writable executable memory
+ * @type: type of the allocation
+ * @size: how many bytes of memory are required
+ *
+ * Allocates memory that will contain executable code, either generated or
+ * loaded from kernel modules.
+ *
+ * Allocates memory that will contain data coupled with executable code,
+ * like data sections in kernel modules.
+ *
+ * Forces writable permissions on the allocated memory and the caller is
+ * responsible to manage the permissions afterwards.
+ *
+ * For architectures that use ROX cache the permissions will be set to R+W.
+ * For architectures that don't use ROX cache the default permissions for @type
+ * will be used as they must be writable.
+ *
+ * Return: a pointer to the allocated memory or %NULL
+ */
+void *execmem_alloc_rw(enum execmem_type type, size_t size);
+
+/**
  * execmem_free - free executable memory
  * @ptr: pointer to the memory that should be freed
  */
--- a/kernel/module/main.c~execmem-introduce-execmem_alloc_rw
+++ a/kernel/module/main.c
@@ -1292,20 +1292,11 @@ static int module_memory_alloc(struct mo
 	else
 		execmem_type = EXECMEM_MODULE_TEXT;
 
-	ptr = execmem_alloc(execmem_type, size);
+	ptr = execmem_alloc_rw(execmem_type, size);
 	if (!ptr)
 		return -ENOMEM;
 
-	if (execmem_is_rox(execmem_type)) {
-		int err = execmem_make_temp_rw(ptr, size);
-
-		if (err) {
-			execmem_free(ptr);
-			return -ENOMEM;
-		}
-
-		mod->mem[type].is_rox = true;
-	}
+	mod->mem[type].is_rox = execmem_is_rox(execmem_type);
 
 	/*
 	 * The pointer to these blocks of memory are stored on the module
--- a/mm/execmem.c~execmem-introduce-execmem_alloc_rw
+++ a/mm/execmem.c
@@ -336,7 +336,7 @@ static bool execmem_cache_free(void *ptr
 	return true;
 }
 
-int execmem_make_temp_rw(void *ptr, size_t size)
+static int execmem_force_rw(void *ptr, size_t size)
 {
 	unsigned int nr = PAGE_ALIGN(size) >> PAGE_SHIFT;
 	unsigned long addr = (unsigned long)ptr;
@@ -358,6 +358,16 @@ int execmem_restore_rox(void *ptr, size_
 }
 
 #else /* CONFIG_ARCH_HAS_EXECMEM_ROX */
+/*
+ * when ROX cache is not used the permissions defined by architectures for
+ * execmem ranges that are updated before use (e.g. EXECMEM_MODULE_TEXT) must
+ * be writable anyway
+ */
+static inline int execmem_force_rw(void *ptr, size_t size)
+{
+	return 0;
+}
+
 static void *execmem_cache_alloc(struct execmem_range *range, size_t size)
 {
 	return NULL;
@@ -387,6 +397,21 @@ void *execmem_alloc(enum execmem_type ty
 	return kasan_reset_tag(p);
 }
 
+void *execmem_alloc_rw(enum execmem_type type, size_t size)
+{
+	void *p __free(execmem) = execmem_alloc(type, size);
+	int err;
+
+	if (!p)
+		return NULL;
+
+	err = execmem_force_rw(p, size);
+	if (err)
+		return NULL;
+
+	return no_free_ptr(p);
+}
+
 void execmem_free(void *ptr)
 {
 	/*
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

