Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5FC37269B
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028778; cv=none; b=pB0aB1J5TcroaBW1ng/0QWiRNvVJXQBhUXR2pMiIHE1EEHXyzXWkCxxQw0p/irRgrWFKBu8z7o3qKrz/e6cTyvwLoSs6IBuWLFBY5tZ63AruJlt2r0zUXgoVb2zPnfLvSkXG/Cq8LutOnXLIozgHZ/J0HQjPwc+SXN1QCK+tlCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028778; c=relaxed/simple;
	bh=oNAZkHfvkbDjJ9yITP9aLg429JkGu+Umg4ea901mneo=;
	h=Date:To:From:Subject:Message-Id; b=aXu/aNzaTI86bIgl2DZCNewgozSq9M94pZdtyjAOZ2y5RxTylJUoM7Zyrfo8LDL0qadZ2CiHCwmlHlduqvRAFlpKNLFGK9trgvWnXYsMpP1FKo+qHyBiJvB0eu6V6uzq/O3oteQ47h2O3EAZ5ELydEgTzZymbLAl25Yoxvm+6bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w1jhbnt2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w1jhbnt2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E561F00893;
	Fri, 29 May 2026 04:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028777;
	bh=9hSaIDb/XjL9hGEJ7sH/UbIWatnsTMRJMBVOIRVNzJ0=;
	h=Date:To:From:Subject;
	b=w1jhbnt2a7M6QGhM46UD3fRZzpmdHZXryP1E58EPqjKJK5xsdjQTk4J+dzbv29Vbk
	 PDwJ9SyDAAJWF3XDPXF+D5Q5Bw/Muvn6DmqqzCwRqKrp2dHzLLUKcwVTCTeQcxWyS8
	 ufBL6M23XlTjMw3+QQt9CllW5UxF/9wiXtIuL8AU=
Date: Thu, 28 May 2026 21:26:16 -0700
To: mm-commits@vger.kernel.org,lucasp.linux@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-bug-cleanup-comment-style-types-and-modernize-logging.patch removed from -mm tree
Message-Id: <20260529042617.26E561F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/bug: cleanup comment style, types and modernize logging
has been removed from the -mm tree.  Its filename was
     lib-bug-cleanup-comment-style-types-and-modernize-logging.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lucas Poupeau <lucasp.linux@gmail.com>
Subject: lib/bug: cleanup comment style, types and modernize logging
Date: Mon, 4 May 2026 22:16:07 +0200

Improve the overall code quality of lib/bug.c by:
- Reformatting the main documentation block to follow the standard
  kernel multi-line comment style.
- Replacing 'unsigned' with the preferred 'unsigned int'.
- Converting legacy printk() calls to modern pr_warn() and pr_info()
  macros to include proper facility levels and satisfy checkpatch.

Link: https://lore.kernel.org/20260504201607.56932-1-lucasp.linux@gmail.com
Signed-off-by: Lucas Poupeau <lucasp.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bug.c |   80 ++++++++++++++++++++++++++--------------------------
 1 file changed, 40 insertions(+), 40 deletions(-)

--- a/lib/bug.c~lib-bug-cleanup-comment-style-types-and-modernize-logging
+++ a/lib/bug.c
@@ -1,41 +1,41 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
-  Generic support for BUG()
-
-  This respects the following config options:
-
-  CONFIG_BUG - emit BUG traps.  Nothing happens without this.
-  CONFIG_GENERIC_BUG - enable this code.
-  CONFIG_GENERIC_BUG_RELATIVE_POINTERS - use 32-bit relative pointers for bug_addr and file
-  CONFIG_DEBUG_BUGVERBOSE - emit full file+line information for each BUG
-
-  CONFIG_BUG and CONFIG_DEBUG_BUGVERBOSE are potentially user-settable
-  (though they're generally always on).
-
-  CONFIG_GENERIC_BUG is set by each architecture using this code.
-
-  To use this, your architecture must:
-
-  1. Set up the config options:
-     - Enable CONFIG_GENERIC_BUG if CONFIG_BUG
-
-  2. Implement BUG (and optionally BUG_ON, WARN, WARN_ON)
-     - Define HAVE_ARCH_BUG
-     - Implement BUG() to generate a faulting instruction
-     - NOTE: struct bug_entry does not have "file" or "line" entries
-       when CONFIG_DEBUG_BUGVERBOSE is not enabled, so you must generate
-       the values accordingly.
-
-  3. Implement the trap
-     - In the illegal instruction trap handler (typically), verify
-       that the fault was in kernel mode, and call report_bug()
-     - report_bug() will return whether it was a false alarm, a warning,
-       or an actual bug.
-     - You must implement the is_valid_bugaddr(bugaddr) callback which
-       returns true if the eip is a real kernel address, and it points
-       to the expected BUG trap instruction.
-
-    Jeremy Fitzhardinge <jeremy@goop.org> 2006
+ *  Generic support for BUG()
+ *
+ *  This respects the following config options:
+ *
+ *  CONFIG_BUG - emit BUG traps.  Nothing happens without this.
+ *  CONFIG_GENERIC_BUG - enable this code.
+ *  CONFIG_GENERIC_BUG_RELATIVE_POINTERS - use 32-bit relative pointers for bug_addr and file
+ *  CONFIG_DEBUG_BUGVERBOSE - emit full file+line information for each BUG
+ *
+ *  CONFIG_BUG and CONFIG_DEBUG_BUGVERBOSE are potentially user-settable
+ *  (though they're generally always on).
+ *
+ *  CONFIG_GENERIC_BUG is set by each architecture using this code.
+ *
+ *  To use this, your architecture must:
+ *
+ *  1. Set up the config options:
+ *     - Enable CONFIG_GENERIC_BUG if CONFIG_BUG
+ *
+ *  2. Implement BUG (and optionally BUG_ON, WARN, WARN_ON)
+ *     - Define HAVE_ARCH_BUG
+ *     - Implement BUG() to generate a faulting instruction
+ *     - NOTE: struct bug_entry does not have "file" or "line" entries
+ *       when CONFIG_DEBUG_BUGVERBOSE is not enabled, so you must generate
+ *       the values accordingly.
+ *
+ *  3. Implement the trap
+ *     - In the illegal instruction trap handler (typically), verify
+ *       that the fault was in kernel mode, and call report_bug()
+ *     - report_bug() will return whether it was a false alarm, a warning,
+ *       or an actual bug.
+ *     - You must implement the is_valid_bugaddr(bugaddr) callback which
+ *       returns true if the eip is a real kernel address, and it points
+ *       to the expected BUG trap instruction.
+ *
+ *    Jeremy Fitzhardinge <jeremy@goop.org> 2006
  */
 
 #define pr_fmt(fmt) fmt
@@ -71,7 +71,7 @@ static struct bug_entry *module_find_bug
 
 	guard(rcu)();
 	list_for_each_entry_rcu(mod, &module_bug_list, bug_list) {
-		unsigned i;
+		unsigned int i;
 
 		bug = mod->bug_table;
 		for (i = 0; i < mod->num_bugs; ++i, ++bug)
@@ -191,14 +191,14 @@ void __warn_printf(const char *fmt, stru
 	}
 #endif
 
-	printk("%s", fmt);
+	pr_warn("%s", fmt);
 }
 
 static enum bug_trap_type __report_bug(struct bug_entry *bug, unsigned long bugaddr, struct pt_regs *regs)
 {
 	bool warning, once, done, no_cut, has_args;
 	const char *file, *fmt;
-	unsigned line;
+	unsigned int line;
 
 	if (!bug) {
 		if (!is_valid_bugaddr(bugaddr))
@@ -237,7 +237,7 @@ static enum bug_trap_type __report_bug(s
 	 * extra debugging message it writes before triggering the handler.
 	 */
 	if (!no_cut) {
-		printk(KERN_DEFAULT CUT_HERE);
+		pr_info(CUT_HERE);
 		__warn_printf(fmt, has_args ? regs : NULL);
 	}
 
_

Patches currently in -mm which might be from lucasp.linux@gmail.com are


