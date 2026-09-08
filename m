Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EC95616C8
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 22:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788908272; cv=none; b=T4Nu60JPKrXepSUKQbc2k+SzCsAxvjBK6njt9ocWb7zg6CNv+gpGa9voqLZ2W7lwvZ8wxnzn/qBY/I83K+0sqqhSF/34C7bPBuTqOsjQv73DHyUGpKRI3DnG4Ye83nNd/GsoKMglU+ukiBXer2EMv4QCW9u0so4WApwvJJ+sOAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788908272; c=relaxed/simple;
	bh=MJe9s9PfEMNNaVE0qY1AaKNdj/6BL+VfDqFZfge1APM=;
	h=Date:To:From:Subject:Message-Id; b=WEHx2OzptoBkXZxoZaRdAEZfZUq/JBwZZ9zXI2Gr6MS4CKfbkOmteIDRGPP6k/Md2HzkHpLy5FhWjiXegRMFYHD9JnJr26pjKUqrXP0ZQLG3ObcIRElf2SH6OOjDtLSvkln6WfVQ17v3eVSkSco7iHV8GpI5qK0HrYOo1MIrgsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KTT6shau; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KTT6shau"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2051F00A3A;
	Tue,  8 Sep 2026 22:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788908269;
	bh=NHXCAfhFQ7dTZVYfZcwos82GHTNtCLUHdHOA0xBSPF8=;
	h=Date:To:From:Subject;
	b=KTT6shauSn2kqLtKKfJsl7VPqVJtPEbiKRR7AJjlL4Dzpm9qO1v+STkwzrvHjXLUQ
	 pbX1GmhclHlue5wvfJ/WIBhDKSJBFBgwsfHPA6KTQIVA5Sdsxa4psFtND8GdLVxi1H
	 2uYAdTLx0yAJLdA7/5ZTmZrE0MDSuL6DBdnkf5qs=
Date: Tue, 08 Sep 2026 15:57:48 -0700
To: mm-commits@vger.kernel.org,samitolvanen@google.com,petr.pavlu@suse.com,peterz@infradead.org,ojeda@kernel.org,mhiramat@kernel.org,mcgrof@kernel.org,gregkh@linuxfoundation.org,arnd@arndb.de,atomlin@atomlin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + module-rename-module_blacklist-to-module_denylist.patch added to mm-nonmm-unstable branch
Message-Id: <20260908225749.0A2051F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: module: rename module_blacklist to module_denylist
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     module-rename-module_blacklist-to-module_denylist.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/module-rename-module_blacklist-to-module_denylist.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Aaron Tomlin <atomlin@atomlin.com>
Subject: module: rename module_blacklist to module_denylist
Date: Tue, 8 Sep 2026 16:32:30 -0400

To preserve the existing user-space ABI, "module_blacklist=" is kept as a
legacy alias pointing to the same module_denylist variable.

This patch addresses the documentation by marking "module_blacklist=" as
deprecated in admin-guide/kernel-parameters.txt, and documents the new
"module_denylist=" parameter.  All internal symbols, such as
module_is_blacklisted(), have been renamed to use "denylist" and all log
messages now use "denylisted".

Link: https://lore.kernel.org/20260908203230.401020-4-atomlin@atomlin.com
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    6 +++-
 include/linux/module.h                          |    2 -
 init/main.c                                     |   19 +++++++-------
 kernel/module/main.c                            |    4 +-
 4 files changed, 18 insertions(+), 13 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~module-rename-module_blacklist-to-module_denylist
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -4232,7 +4232,11 @@ Kernel parameters
 			Note that if CONFIG_MODULE_SIG_FORCE is set, that
 			is always true, so this option does nothing.
 
-	module_blacklist=  [KNL] Do not load a comma-separated list of
+	module_blacklist=  [KNL] (deprecated)
+			This parameter has been renamed to module_denylist=.
+			Please use module_denylist= instead.
+
+	module_denylist=  [KNL] Do not load a comma-separated list of
 			modules.  Useful for debugging problem modules.
 
 	mousedev.tap_time=
--- a/include/linux/module.h~module-rename-module_blacklist-to-module_denylist
+++ a/include/linux/module.h
@@ -879,7 +879,7 @@ static inline void module_for_each_mod(i
 }
 #endif /* CONFIG_MODULES */
 
-bool module_is_blacklisted(const char *module_name);
+bool module_is_denylisted(const char *module_name);
 
 #ifdef CONFIG_SYSFS
 extern struct kset *module_kset;
--- a/init/main.c~module-rename-module_blacklist-to-module_denylist
+++ a/init/main.c
@@ -1347,17 +1347,17 @@ static inline void do_trace_initcall_lev
 extern struct initcall_modname __start_initcall_modnames[];
 extern struct initcall_modname __stop_initcall_modnames[];
 
-/* module_blacklist is a comma-separated list of module names */
-static char *module_blacklist;
-bool __init_or_module module_is_blacklisted(const char *module_name)
+/* module_denylist is a comma-separated list of module names */
+static char *module_denylist;
+bool __init_or_module module_is_denylisted(const char *module_name)
 {
 	const char *p;
 	size_t len;
 
-	if (!module_blacklist)
+	if (!module_denylist)
 		return false;
 
-	for (p = module_blacklist; *p; p += len) {
+	for (p = module_denylist; *p; p += len) {
 		len = strcspn(p, ",");
 		if (strlen(module_name) == len && parameqn(module_name, p, len))
 			return true;
@@ -1366,7 +1366,8 @@ bool __init_or_module module_is_blacklis
 	}
 	return false;
 }
-core_param(module_blacklist, module_blacklist, charp, 0400);
+core_param(module_denylist, module_denylist, charp, 0400);
+core_param(module_blacklist, module_denylist, charp, 0400);
 
 static const char *__init get_builtin_modname(initcall_t fn)
 {
@@ -1383,10 +1384,10 @@ static void __init do_one_initcall_built
 {
 	const char *modname;
 
-	if (module_blacklist) {
+	if (module_denylist) {
 		modname = get_builtin_modname(fn);
-		if (modname && module_is_blacklisted(modname)) {
-			pr_info("Skipping initcall for blacklisted built-in module %s\n",
+		if (modname && module_is_denylisted(modname)) {
+			pr_info("Skipping initcall for denylisted built-in module %s\n",
 				modname);
 			return;
 		}
--- a/kernel/module/main.c~module-rename-module_blacklist-to-module_denylist
+++ a/kernel/module/main.c
@@ -3382,8 +3382,8 @@ static int early_mod_check(struct load_i
 	 * Now that we know we have the correct module name, check
 	 * if it's blacklisted.
 	 */
-	if (module_is_blacklisted(info->name)) {
-		pr_err("Module %s is blacklisted\n", info->name);
+	if (module_is_denylisted(info->name)) {
+		pr_err("Module %s is denylisted\n", info->name);
 		return -EPERM;
 	}
 
_

Patches currently in -mm which might be from atomlin@atomlin.com are

hung_task-reset-warning-budget-when-problem-gets-resolved.patch
hung_task-log-summary-line-when-warning-budget-is-exhausted.patch
module-treat-dashes-and-underscores-interchangeably-in-module_blacklist.patch
module-extend-module_blacklist-parameter-to-built-in-modules.patch
module-rename-module_blacklist-to-module_denylist.patch

