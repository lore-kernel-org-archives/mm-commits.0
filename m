Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A68FC1D;
	Sun, 25 May 2025 07:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748159663; cv=none; b=PxG56Ki7M+6b56sdU0sJCOaGXeKk4A4nQYbP0PtS16Q75NO5H/QcSYNhraeopZE/9d1fx7iJ/XYIfFTw1v24Yg+OAGjROfx3EI4x69qxvheYmuZDk5L44srKVLZ9ciIplI3rTWq4dKuTRg0Oxr3LSGAOnSiXYQrM9lR05CQC0MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748159663; c=relaxed/simple;
	bh=RVBJVBdBWpmyVzXF5W09vAeRPHxXqPqzAtFJy93Ntso=;
	h=Date:To:From:Subject:Message-Id; b=f9g93bCD8ypz05UgFrtMfwOyJiWGepsoMCowBhX5u1ggHmVAu2ygnTSwlzIE6gExGTS2Ivz8iBz9+yT6+kMObOl1a/CHMWfjaKfWI3bitY5TiCpXCLXa2fK7qB0qO/9cK4CQSe4mOqQPiN7d51Xvvix7Uu2JH/qTAfEXKGIBdr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wFXg03LZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wFXg03LZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B99DC4CEED;
	Sun, 25 May 2025 07:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748159663;
	bh=RVBJVBdBWpmyVzXF5W09vAeRPHxXqPqzAtFJy93Ntso=;
	h=Date:To:From:Subject:From;
	b=wFXg03LZPy25D7HRDMVyFtBk6g26Aqnp4ApjGPu4sswih3viN7X2bud6VeNtlgwD0
	 6Zt3cxAkyYK49wu8PBZV44dW8+wCwBvjwNORAvQyrX0h7fX/9fG04atDFmkaRF8rKu
	 TVxdETGoPMGV94QHktUYnjBCY7Zse83ESvUZu2Tg=
Date: Sun, 25 May 2025 00:54:22 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,stable@vger.kernel.org,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,dennis@kernel.org,cl@gentwo.org,00107082@163.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] alloc_tag-allocate-percpu-counters-for-module-tags-dynamically.patch removed from -mm tree
Message-Id: <20250525075423.0B99DC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: allocate percpu counters for module tags dynamically
has been removed from the -mm tree.  Its filename was
     alloc_tag-allocate-percpu-counters-for-module-tags-dynamically.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: alloc_tag: allocate percpu counters for module tags dynamically
Date: Fri, 16 May 2025 17:07:39 -0700

When a module gets unloaded it checks whether any of its tags are still in
use and if so, we keep the memory containing module's allocation tags
alive until all tags are unused.  However percpu counters referenced by
the tags are freed by free_module().  This will lead to UAF if the memory
allocated by a module is accessed after module was unloaded.

To fix this we allocate percpu counters for module allocation tags
dynamically and we keep it alive for tags which are still in use after
module unloading.  This also removes the requirement of a larger
PERCPU_MODULE_RESERVE when memory allocation profiling is enabled because
percpu memory for counters does not need to be reserved anymore.

Link: https://lkml.kernel.org/r/20250517000739.5930-1-surenb@google.com
Fixes: 0db6f8d7820a ("alloc_tag: load module tags into separate contiguous memory")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: David Wang <00107082@163.com>
Closes: https://lore.kernel.org/all/20250516131246.6244-1-00107082@163.com/
Tested-by: David Wang <00107082@163.com>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/alloc_tag.h |   12 ++++
 include/linux/codetag.h   |    8 +--
 include/linux/percpu.h    |    4 -
 lib/alloc_tag.c           |   89 ++++++++++++++++++++++++++++--------
 lib/codetag.c             |    5 +-
 5 files changed, 89 insertions(+), 29 deletions(-)

--- a/include/linux/alloc_tag.h~alloc_tag-allocate-percpu-counters-for-module-tags-dynamically
+++ a/include/linux/alloc_tag.h
@@ -104,6 +104,16 @@ DECLARE_PER_CPU(struct alloc_tag_counter
 
 #else /* ARCH_NEEDS_WEAK_PER_CPU */
 
+#ifdef MODULE
+
+#define DEFINE_ALLOC_TAG(_alloc_tag)						\
+	static struct alloc_tag _alloc_tag __used __aligned(8)			\
+	__section(ALLOC_TAG_SECTION_NAME) = {					\
+		.ct = CODE_TAG_INIT,						\
+		.counters = NULL };
+
+#else  /* MODULE */
+
 #define DEFINE_ALLOC_TAG(_alloc_tag)						\
 	static DEFINE_PER_CPU(struct alloc_tag_counters, _alloc_tag_cntr);	\
 	static struct alloc_tag _alloc_tag __used __aligned(8)			\
@@ -111,6 +121,8 @@ DECLARE_PER_CPU(struct alloc_tag_counter
 		.ct = CODE_TAG_INIT,						\
 		.counters = &_alloc_tag_cntr };
 
+#endif /* MODULE */
+
 #endif /* ARCH_NEEDS_WEAK_PER_CPU */
 
 DECLARE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
--- a/include/linux/codetag.h~alloc_tag-allocate-percpu-counters-for-module-tags-dynamically
+++ a/include/linux/codetag.h
@@ -36,10 +36,10 @@ union codetag_ref {
 struct codetag_type_desc {
 	const char *section;
 	size_t tag_size;
-	void (*module_load)(struct codetag_type *cttype,
-			    struct codetag_module *cmod);
-	void (*module_unload)(struct codetag_type *cttype,
-			      struct codetag_module *cmod);
+	void (*module_load)(struct module *mod,
+			    struct codetag *start, struct codetag *end);
+	void (*module_unload)(struct module *mod,
+			      struct codetag *start, struct codetag *end);
 #ifdef CONFIG_MODULES
 	void (*module_replaced)(struct module *mod, struct module *new_mod);
 	bool (*needs_section_mem)(struct module *mod, unsigned long size);
--- a/include/linux/percpu.h~alloc_tag-allocate-percpu-counters-for-module-tags-dynamically
+++ a/include/linux/percpu.h
@@ -15,11 +15,7 @@
 
 /* enough to cover all DEFINE_PER_CPUs in modules */
 #ifdef CONFIG_MODULES
-#ifdef CONFIG_MEM_ALLOC_PROFILING
-#define PERCPU_MODULE_RESERVE		(8 << 13)
-#else
 #define PERCPU_MODULE_RESERVE		(8 << 10)
-#endif
 #else
 #define PERCPU_MODULE_RESERVE		0
 #endif
--- a/lib/alloc_tag.c~alloc_tag-allocate-percpu-counters-for-module-tags-dynamically
+++ a/lib/alloc_tag.c
@@ -350,18 +350,28 @@ static bool needs_section_mem(struct mod
 	return size >= sizeof(struct alloc_tag);
 }
 
-static struct alloc_tag *find_used_tag(struct alloc_tag *from, struct alloc_tag *to)
+static bool clean_unused_counters(struct alloc_tag *start_tag,
+				  struct alloc_tag *end_tag)
 {
-	while (from <= to) {
+	struct alloc_tag *tag;
+	bool ret = true;
+
+	for (tag = start_tag; tag <= end_tag; tag++) {
 		struct alloc_tag_counters counter;
 
-		counter = alloc_tag_read(from);
-		if (counter.bytes)
-			return from;
-		from++;
+		if (!tag->counters)
+			continue;
+
+		counter = alloc_tag_read(tag);
+		if (!counter.bytes) {
+			free_percpu(tag->counters);
+			tag->counters = NULL;
+		} else {
+			ret = false;
+		}
 	}
 
-	return NULL;
+	return ret;
 }
 
 /* Called with mod_area_mt locked */
@@ -371,12 +381,16 @@ static void clean_unused_module_areas_lo
 	struct module *val;
 
 	mas_for_each(&mas, val, module_tags.size) {
+		struct alloc_tag *start_tag;
+		struct alloc_tag *end_tag;
+
 		if (val != &unloaded_mod)
 			continue;
 
 		/* Release area if all tags are unused */
-		if (!find_used_tag((struct alloc_tag *)(module_tags.start_addr + mas.index),
-				   (struct alloc_tag *)(module_tags.start_addr + mas.last)))
+		start_tag = (struct alloc_tag *)(module_tags.start_addr + mas.index);
+		end_tag = (struct alloc_tag *)(module_tags.start_addr + mas.last);
+		if (clean_unused_counters(start_tag, end_tag))
 			mas_erase(&mas);
 	}
 }
@@ -561,7 +575,8 @@ unlock:
 static void release_module_tags(struct module *mod, bool used)
 {
 	MA_STATE(mas, &mod_area_mt, module_tags.size, module_tags.size);
-	struct alloc_tag *tag;
+	struct alloc_tag *start_tag;
+	struct alloc_tag *end_tag;
 	struct module *val;
 
 	mas_lock(&mas);
@@ -575,15 +590,22 @@ static void release_module_tags(struct m
 	if (!used)
 		goto release_area;
 
-	/* Find out if the area is used */
-	tag = find_used_tag((struct alloc_tag *)(module_tags.start_addr + mas.index),
-			    (struct alloc_tag *)(module_tags.start_addr + mas.last));
-	if (tag) {
-		struct alloc_tag_counters counter = alloc_tag_read(tag);
-
-		pr_info("%s:%u module %s func:%s has %llu allocated at module unload\n",
-			tag->ct.filename, tag->ct.lineno, tag->ct.modname,
-			tag->ct.function, counter.bytes);
+	start_tag = (struct alloc_tag *)(module_tags.start_addr + mas.index);
+	end_tag = (struct alloc_tag *)(module_tags.start_addr + mas.last);
+	if (!clean_unused_counters(start_tag, end_tag)) {
+		struct alloc_tag *tag;
+
+		for (tag = start_tag; tag <= end_tag; tag++) {
+			struct alloc_tag_counters counter;
+
+			if (!tag->counters)
+				continue;
+
+			counter = alloc_tag_read(tag);
+			pr_info("%s:%u module %s func:%s has %llu allocated at module unload\n",
+				tag->ct.filename, tag->ct.lineno, tag->ct.modname,
+				tag->ct.function, counter.bytes);
+		}
 	} else {
 		used = false;
 	}
@@ -596,6 +618,34 @@ out:
 	mas_unlock(&mas);
 }
 
+static void load_module(struct module *mod, struct codetag *start, struct codetag *stop)
+{
+	/* Allocate module alloc_tag percpu counters */
+	struct alloc_tag *start_tag;
+	struct alloc_tag *stop_tag;
+	struct alloc_tag *tag;
+
+	if (!mod)
+		return;
+
+	start_tag = ct_to_alloc_tag(start);
+	stop_tag = ct_to_alloc_tag(stop);
+	for (tag = start_tag; tag < stop_tag; tag++) {
+		WARN_ON(tag->counters);
+		tag->counters = alloc_percpu(struct alloc_tag_counters);
+		if (!tag->counters) {
+			while (--tag >= start_tag) {
+				free_percpu(tag->counters);
+				tag->counters = NULL;
+			}
+			shutdown_mem_profiling(true);
+			pr_err("Failed to allocate memory for allocation tag percpu counters in the module %s. Memory allocation profiling is disabled!\n",
+			       mod->name);
+			break;
+		}
+	}
+}
+
 static void replace_module(struct module *mod, struct module *new_mod)
 {
 	MA_STATE(mas, &mod_area_mt, 0, module_tags.size);
@@ -757,6 +807,7 @@ static int __init alloc_tag_init(void)
 		.needs_section_mem	= needs_section_mem,
 		.alloc_section_mem	= reserve_module_tags,
 		.free_section_mem	= release_module_tags,
+		.module_load		= load_module,
 		.module_replaced	= replace_module,
 #endif
 	};
--- a/lib/codetag.c~alloc_tag-allocate-percpu-counters-for-module-tags-dynamically
+++ a/lib/codetag.c
@@ -194,7 +194,7 @@ static int codetag_module_init(struct co
 	if (err >= 0) {
 		cttype->count += range_size(cttype, &range);
 		if (cttype->desc.module_load)
-			cttype->desc.module_load(cttype, cmod);
+			cttype->desc.module_load(mod, range.start, range.stop);
 	}
 	up_write(&cttype->mod_lock);
 
@@ -333,7 +333,8 @@ void codetag_unload_module(struct module
 		}
 		if (found) {
 			if (cttype->desc.module_unload)
-				cttype->desc.module_unload(cttype, cmod);
+				cttype->desc.module_unload(cmod->mod,
+					cmod->range.start, cmod->range.stop);
 
 			cttype->count -= range_size(cttype, &cmod->range);
 			idr_remove(&cttype->mod_idr, mod_id);
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-handle-module-codetag-load-errors-as-module-load-failures.patch

