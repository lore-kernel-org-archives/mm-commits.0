Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C587F1D12FF;
	Sat, 31 Aug 2024 01:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725066851; cv=none; b=FR76ENvgQVRsnVlescifMPkQUAiLIcgwANgbTuXkPQJno3dTuWru4lCuMhRtGsx3gUg0i0A/LCqNh8tpMyfuw0TQxuHcBZghx70OFcJAASbWiXunti2NKol6xYANdyXDFNlYGSCFUEne72pB3xE1Qdr+nP/mPJQbDuuM8qN5bA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725066851; c=relaxed/simple;
	bh=rOGAbE559xd2jiSuFjaUZjkm4vO67jm4qc1SmzRoaoM=;
	h=Date:To:From:Subject:Message-Id; b=OnrP2N3VZjh5l609F7W6Tq91bMJCALuDD072maF602mUBx1CKcynrjkPK27mzkQBchjCQglVZ78ZR01oD0vZ6ICz1w6h6OTzzkKKD6APuXWKuDoSqae3ledrbdPjr8uL23VX5S23mS+jy9dIIx8ecIC1xEN1Lr7xZM8Z4NsbXZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LphuKG4e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LphuKG4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3245DC4CEC2;
	Sat, 31 Aug 2024 01:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725066851;
	bh=rOGAbE559xd2jiSuFjaUZjkm4vO67jm4qc1SmzRoaoM=;
	h=Date:To:From:Subject:From;
	b=LphuKG4eAqGKFk9+itSot7Dfo9StGddWrpLON4ylIXy6Xs+rgSmwOC2Z98k+YGuY4
	 kUOe8K6ZpcVW/TjS36ObJa4DSpDT/3w7xFl/EuZCshLN2674IeA9HvnQgrEMgEugNl
	 FdFegLZWAjNSPRM8q2OrSTmj/0cT6xjgETHFD/rk=
Date: Fri, 30 Aug 2024 18:14:10 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,souravpanda@google.com,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,keescook@chromium.org,david@redhat.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-fix-allocation-tag-reporting-when-config_modules=n.patch added to mm-hotfixes-unstable branch
Message-Id: <20240831011411.3245DC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: fix allocation tag reporting when CONFIG_MODULES=n
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     alloc_tag-fix-allocation-tag-reporting-when-config_modules=n.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-fix-allocation-tag-reporting-when-config_modules=n.patch

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

alloc_tag-fix-allocation-tag-reporting-when-config_modules=n.patch

