Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13AEF235C01;
	Wed, 21 May 2025 20:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747859329; cv=none; b=aB2xyzH8ez7EgN5GcngESkKyqs2Hfg/JTa+C0KrkvpvwPfncAztjszxw1RrlroKl99VhjrF7gyqqL0sL5fVyvY+58tJG08HPjXLus8DcCXda3icVEzy7r+4PU54qr6cW9O6SSUW5EsBp027dUX+k+wxhj6TQ+E+9YOyDWRREZkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747859329; c=relaxed/simple;
	bh=Kq7BvnyEGNvIh+rwZWopLz5QVtC0Qw0b4Eq8gRjtJE4=;
	h=Date:To:From:Subject:Message-Id; b=F0cag/t0wB7eCLisa/8GSAKtm2Umr9sg87hfmhrANOti6CbfsiQFFd/E5KHuv4pFPxfzGb2JjT/CR+tblmYcddSMN1nQZ6h+2MeHLSuc/hA37o4DLN9VXIxzBGN0HlaOgJ2DE5Cs3EAyQHG23ieMd+FaRlDSlXrEvHvvZd4+G5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gGjNp7E/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gGjNp7E/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE1AC4CEE4;
	Wed, 21 May 2025 20:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747859328;
	bh=Kq7BvnyEGNvIh+rwZWopLz5QVtC0Qw0b4Eq8gRjtJE4=;
	h=Date:To:From:Subject:From;
	b=gGjNp7E/pZ9sFf6fcgYzRwXIM8GuSIOTdCFbpe5IBkhV5vvl7K0HXOef/5N/zKuIj
	 qtFBWbvis5giMP8wXNCgmj07NOiT8jfWLaLDyG9k1t/ZHn6ZJQx8+EEJJQkE5+ZLv5
	 oOs+oyUTQJOOm1yM8n1NgpbSeNmiVmyKKRWdhUw4=
Date: Wed, 21 May 2025 13:28:47 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,samitolvanen@google.com,petr.pavlu@suse.com,mcgrof@kernel.org,kent.overstreet@linux.dev,da.gomez@samsung.com,cachen@purestorage.com,00107082@163.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-handle-module-codetag-load-errors-as-module-load-failures.patch added to mm-hotfixes-unstable branch
Message-Id: <20250521202848.5FE1AC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: handle module codetag load errors as module load failures
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     alloc_tag-handle-module-codetag-load-errors-as-module-load-failures.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-handle-module-codetag-load-errors-as-module-load-failures.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Suren Baghdasaryan <surenb@google.com>
Subject: alloc_tag: handle module codetag load errors as module load failures
Date: Wed, 21 May 2025 09:06:02 -0700

Failures inside codetag_load_module() are currently ignored.  As a result
an error there would not cause a module load failure and freeing of the
associated resources.  Correct this behavior by propagating the error code
to the caller and handling possible errors.  With this change, error to
allocate percpu counters, which happens at this stage, will not be ignored
and will cause a module load failure and freeing of resources.  With this
change we also do not need to disable memory allocation profiling when
this error happens, instead we fail to load the module.

Link: https://lkml.kernel.org/r/20250521160602.1940771-1-surenb@google.com
Fixes: 10075262888b ("alloc_tag: allocate percpu counters for module tags dynamically")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: Casey Chen <cachen@purestorage.com>
Closes: https://lore.kernel.org/all/20250520231620.15259-1-cachen@purestorage.com/
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: David Wang <00107082@163.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/codetag.h |    8 ++++----
 kernel/module/main.c    |    5 +++--
 lib/alloc_tag.c         |   12 +++++++-----
 lib/codetag.c           |   34 +++++++++++++++++++++++++---------
 4 files changed, 39 insertions(+), 20 deletions(-)

--- a/include/linux/codetag.h~alloc_tag-handle-module-codetag-load-errors-as-module-load-failures
+++ a/include/linux/codetag.h
@@ -36,8 +36,8 @@ union codetag_ref {
 struct codetag_type_desc {
 	const char *section;
 	size_t tag_size;
-	void (*module_load)(struct module *mod,
-			    struct codetag *start, struct codetag *end);
+	int (*module_load)(struct module *mod,
+			   struct codetag *start, struct codetag *end);
 	void (*module_unload)(struct module *mod,
 			      struct codetag *start, struct codetag *end);
 #ifdef CONFIG_MODULES
@@ -89,7 +89,7 @@ void *codetag_alloc_module_section(struc
 				   unsigned long align);
 void codetag_free_module_sections(struct module *mod);
 void codetag_module_replaced(struct module *mod, struct module *new_mod);
-void codetag_load_module(struct module *mod);
+int codetag_load_module(struct module *mod);
 void codetag_unload_module(struct module *mod);
 
 #else /* defined(CONFIG_CODE_TAGGING) && defined(CONFIG_MODULES) */
@@ -103,7 +103,7 @@ codetag_alloc_module_section(struct modu
 			     unsigned long align) { return NULL; }
 static inline void codetag_free_module_sections(struct module *mod) {}
 static inline void codetag_module_replaced(struct module *mod, struct module *new_mod) {}
-static inline void codetag_load_module(struct module *mod) {}
+static inline int codetag_load_module(struct module *mod) { return 0; }
 static inline void codetag_unload_module(struct module *mod) {}
 
 #endif /* defined(CONFIG_CODE_TAGGING) && defined(CONFIG_MODULES) */
--- a/kernel/module/main.c~alloc_tag-handle-module-codetag-load-errors-as-module-load-failures
+++ a/kernel/module/main.c
@@ -3399,11 +3399,12 @@ static int load_module(struct load_info
 			goto sysfs_cleanup;
 	}
 
+	if (codetag_load_module(mod))
+		goto sysfs_cleanup;
+
 	/* Get rid of temporary copy. */
 	free_copy(info, flags);
 
-	codetag_load_module(mod);
-
 	/* Done! */
 	trace_module_load(mod);
 
--- a/lib/alloc_tag.c~alloc_tag-handle-module-codetag-load-errors-as-module-load-failures
+++ a/lib/alloc_tag.c
@@ -618,15 +618,16 @@ out:
 	mas_unlock(&mas);
 }
 
-static void load_module(struct module *mod, struct codetag *start, struct codetag *stop)
+static int load_module(struct module *mod, struct codetag *start, struct codetag *stop)
 {
 	/* Allocate module alloc_tag percpu counters */
 	struct alloc_tag *start_tag;
 	struct alloc_tag *stop_tag;
 	struct alloc_tag *tag;
 
+	/* percpu counters for core allocations are already statically allocated */
 	if (!mod)
-		return;
+		return 0;
 
 	start_tag = ct_to_alloc_tag(start);
 	stop_tag = ct_to_alloc_tag(stop);
@@ -638,12 +639,13 @@ static void load_module(struct module *m
 				free_percpu(tag->counters);
 				tag->counters = NULL;
 			}
-			shutdown_mem_profiling(true);
-			pr_err("Failed to allocate memory for allocation tag percpu counters in the module %s. Memory allocation profiling is disabled!\n",
+			pr_err("Failed to allocate memory for allocation tag percpu counters in the module %s\n",
 			       mod->name);
-			break;
+			return -ENOMEM;
 		}
 	}
+
+	return 0;
 }
 
 static void replace_module(struct module *mod, struct module *new_mod)
--- a/lib/codetag.c~alloc_tag-handle-module-codetag-load-errors-as-module-load-failures
+++ a/lib/codetag.c
@@ -167,6 +167,7 @@ static int codetag_module_init(struct co
 {
 	struct codetag_range range;
 	struct codetag_module *cmod;
+	int mod_id;
 	int err;
 
 	range = get_section_range(mod, cttype->desc.section);
@@ -190,11 +191,20 @@ static int codetag_module_init(struct co
 	cmod->range = range;
 
 	down_write(&cttype->mod_lock);
-	err = idr_alloc(&cttype->mod_idr, cmod, 0, 0, GFP_KERNEL);
-	if (err >= 0) {
-		cttype->count += range_size(cttype, &range);
-		if (cttype->desc.module_load)
-			cttype->desc.module_load(mod, range.start, range.stop);
+	mod_id = idr_alloc(&cttype->mod_idr, cmod, 0, 0, GFP_KERNEL);
+	if (mod_id >= 0) {
+		if (cttype->desc.module_load) {
+			err = cttype->desc.module_load(mod, range.start, range.stop);
+			if (!err)
+				cttype->count += range_size(cttype, &range);
+			else
+				idr_remove(&cttype->mod_idr, mod_id);
+		} else {
+			cttype->count += range_size(cttype, &range);
+			err = 0;
+		}
+	} else {
+		err = mod_id;
 	}
 	up_write(&cttype->mod_lock);
 
@@ -295,17 +305,23 @@ void codetag_module_replaced(struct modu
 	mutex_unlock(&codetag_lock);
 }
 
-void codetag_load_module(struct module *mod)
+int codetag_load_module(struct module *mod)
 {
 	struct codetag_type *cttype;
+	int ret = 0;
 
 	if (!mod)
-		return;
+		return 0;
 
 	mutex_lock(&codetag_lock);
-	list_for_each_entry(cttype, &codetag_types, link)
-		codetag_module_init(cttype, mod);
+	list_for_each_entry(cttype, &codetag_types, link) {
+		ret = codetag_module_init(cttype, mod);
+		if (ret)
+			break;
+	}
 	mutex_unlock(&codetag_lock);
+
+	return ret;
 }
 
 void codetag_unload_module(struct module *mod)
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-allocate-percpu-counters-for-module-tags-dynamically.patch
alloc_tag-handle-module-codetag-load-errors-as-module-load-failures.patch

