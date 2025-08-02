Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78AA24DCE3
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160870; cv=none; b=BpktzgXsdUf2OpfukjO1+w4uIMqcQv/eBBcDstkSYlsGK8YBD0J7yW3pASE1EeFDnqfhEBvGODctEfnrHBofd8YjAV3l1X6Bu/wVkOd7f+R9KTs7SEofobo6+evECRgOkpEjdjo1WQojHVUu0MDV6ra4Ma9Yr6ZfN7sFOJThPDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160870; c=relaxed/simple;
	bh=NQTzH7L9fUJVpU2WCaPZfrSNZwhoUFdj7YYEv4rzvAM=;
	h=Date:To:From:Subject:Message-Id; b=J+zsx1i9ORVppn6dD98/aeYFgXx6NsvTUMcwcswwcxAUS3zWs0+dGz0rhxarIdkeU5yvi/SXNuM08k49RCaTVPbffmpeVZRhVMRSncRr65g1tvBAle33U0sXI3HnwqoF8K0lO4Yb7Lir31KxfPerOOlfWFLZ0JS87alLDwT5UB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1NMhSGRn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1NMhSGRn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 701BBC4CEEF;
	Sat,  2 Aug 2025 18:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160869;
	bh=NQTzH7L9fUJVpU2WCaPZfrSNZwhoUFdj7YYEv4rzvAM=;
	h=Date:To:From:Subject:From;
	b=1NMhSGRnQFa+qAyHzQmtQh99OIYs2GLQO7VaoEfOCT8uOCuQpEZe4/Y5ePaynzWm5
	 1DuS5UXBBoz1EMn6vRo2/4pShhXv4xo/jY9frHrWTuOGsSH3uDmSh8D1Rf5BWVgUoz
	 MKV/cs9Ry4ZfwdSDKjDJYJFCVhd5esXs+ovj0jtE=
Date: Sat, 02 Aug 2025 11:54:28 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,petr.pavlu@suse.com,peterz@infradead.org,mhiramat@kernel.org,da.gomez@samsung.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] execmem-introduce-execmem_alloc_rw.patch removed from -mm tree
Message-Id: <20250802185429.701BBC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: execmem: introduce execmem_alloc_rw()
has been removed from the -mm tree.  Its filename was
     execmem-introduce-execmem_alloc_rw.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

kho-add-test-for-kexec-handover.patch
kho-add-test-for-kexec-handover-fix.patch

