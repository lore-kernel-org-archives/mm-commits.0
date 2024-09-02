Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498A44A0F;
	Mon,  2 Sep 2024 00:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725238790; cv=none; b=RjGfyxvgzjwi3SunvuMxiwqhEet7yjS10VGqs7wX9zl7UPGbMiuzYBgUohPQQcNOt/sh3HZuwoFPDG6j4NbECfXqQhYAtB2c4onLw3f0v9e77XThdId/bHOwcf098U0lhlxq+7ciPtsnyJeHoRkv43kchNPh8lRKxErKztOaom4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725238790; c=relaxed/simple;
	bh=fQt6aUknUi4+WUPE9ICg1g9dE+1VNdAPuPR0YT36K5k=;
	h=Date:To:From:Subject:Message-Id; b=gPM3BfDC8U7lFmNpp5LZC8f7Bg/GB8ARocOka1BkHno2uQtcSZKtxYLH+IACrD6jrN3NKvNYH1D3AI7V6zYeFlguCv12WcQDT28SVojyB/oGDKGaPmkYVCGqh6GWVSVceWKBd0cNUBEb/reohQ4FNMftHA/L8nZVEtnTmTovdb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MBtGtjbf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MBtGtjbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081E9C4CEC3;
	Mon,  2 Sep 2024 00:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725238790;
	bh=fQt6aUknUi4+WUPE9ICg1g9dE+1VNdAPuPR0YT36K5k=;
	h=Date:To:From:Subject:From;
	b=MBtGtjbfV+JPj6LMbMgxd4G+VW9q1jycW5A7x3iyQrPmHfju3nfxrxUilNfFe6FyP
	 tw9FoeCVjWuNx9hoO87slV5t1FMszPKlhfLDnQcxWS4GlWBFBLTSc2MvCutrz1Ai/k
	 LfOlRzf7mTdKViMfee7A7LEazGj82Xf9iC6ab4fM=
Date: Sun, 01 Sep 2024 17:59:49 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,souravpanda@google.com,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,keescook@chromium.org,david@redhat.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] alloc_tag-fix-allocation-tag-reporting-when-config_modules=n.patch removed from -mm tree
Message-Id: <20240902005950.081E9C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: fix allocation tag reporting when CONFIG_MODULES=n
has been removed from the -mm tree.  Its filename was
     alloc_tag-fix-allocation-tag-reporting-when-config_modules=n.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: alloc_tag: fix allocation tag reporting when CONFIG_MODULES=n
Date: Wed, 28 Aug 2024 16:15:36 -0700

codetag_module_init() is used to initialize sections containing allocation
tags.  This function is used to initialize module sections as well as core
kernel sections, in which case the module parameter is set to NULL.  This
function has to be called even when CONFIG_MODULES=n to initialize core
kernel allocation tag sections.  When CONFIG_MODULES=n, this function is a
NOP, which is wrong.  This leads to /proc/allocinfo reported as empty. 
Fix this by making it independent of CONFIG_MODULES.

Link: https://lkml.kernel.org/r/20240828231536.1770519-1-surenb@google.com
Fixes: 916cc5167cc6 ("lib: code tagging framework")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>	[6.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/codetag.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/lib/codetag.c~alloc_tag-fix-allocation-tag-reporting-when-config_modules=n
+++ a/lib/codetag.c
@@ -125,7 +125,6 @@ static inline size_t range_size(const st
 			cttype->desc.tag_size;
 }
 
-#ifdef CONFIG_MODULES
 static void *get_symbol(struct module *mod, const char *prefix, const char *name)
 {
 	DECLARE_SEQ_BUF(sb, KSYM_NAME_LEN);
@@ -155,6 +154,15 @@ static struct codetag_range get_section_
 	};
 }
 
+static const char *get_mod_name(__maybe_unused struct module *mod)
+{
+#ifdef CONFIG_MODULES
+	if (mod)
+		return mod->name;
+#endif
+	return "(built-in)";
+}
+
 static int codetag_module_init(struct codetag_type *cttype, struct module *mod)
 {
 	struct codetag_range range;
@@ -164,8 +172,7 @@ static int codetag_module_init(struct co
 	range = get_section_range(mod, cttype->desc.section);
 	if (!range.start || !range.stop) {
 		pr_warn("Failed to load code tags of type %s from the module %s\n",
-			cttype->desc.section,
-			mod ? mod->name : "(built-in)");
+			cttype->desc.section, get_mod_name(mod));
 		return -EINVAL;
 	}
 
@@ -199,6 +206,7 @@ static int codetag_module_init(struct co
 	return 0;
 }
 
+#ifdef CONFIG_MODULES
 void codetag_load_module(struct module *mod)
 {
 	struct codetag_type *cttype;
@@ -248,9 +256,6 @@ bool codetag_unload_module(struct module
 
 	return unload_ok;
 }
-
-#else /* CONFIG_MODULES */
-static int codetag_module_init(struct codetag_type *cttype, struct module *mod) { return 0; }
 #endif /* CONFIG_MODULES */
 
 struct codetag_type *
_

Patches currently in -mm which might be from surenb@google.com are


