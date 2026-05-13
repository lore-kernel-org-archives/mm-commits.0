Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7016C30B50D
	for <mm-commits@vger.kernel.org>; Wed, 13 May 2026 02:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778638814; cv=none; b=pMtDGnFEUOo6BjzpBBEeKBKw4PksjH3IsV7ZWkeiQASjH7CSYHUZ0zf45bLZRAc26O9zjovJIslB6EYn/y9E1jlYusOtq8v/UNYkydlvGAZXZisB1GENrHV2Y3NM/BuAXmMGsBUp3lgaQ9ikwuSi2b4G66MOFnIAiI4mO7db/+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778638814; c=relaxed/simple;
	bh=zn00F7gRP/BIrwuEZlrBJMAy6z71fkOQ7nCiA0GOb2U=;
	h=Date:To:From:Subject:Message-Id; b=A7mu3Cppxgif7B8x7CIjtOpr4mxTngUITQSl5htSUCQfIjyEMkukj0dAYmjW9BEOGAf1OxJMcihUSRnk9k4Gxd9u9xx8aGLLvBK7ewNdC4WHQ4Qb4jF3Y3XQqzaPyGwcPpSs2toSaa99PD6DIXi72bchgd/PTiF2yzxoGf2KZKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Uku1Rfre; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Uku1Rfre"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1377CC2BCB0;
	Wed, 13 May 2026 02:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778638814;
	bh=zn00F7gRP/BIrwuEZlrBJMAy6z71fkOQ7nCiA0GOb2U=;
	h=Date:To:From:Subject:From;
	b=Uku1Rfrek2JfLzBeClJyxbb/aHEH4sgsWaOkkoAFm8HUKf9yblMAyvGv6b+N38O6Z
	 CvKipbWHiKj/A86+9qdkZngI1FM20VQohshzDty7os9ov7fNikHlSX1wV/2lQPWFmt
	 Fji2qwRd+ghKlKjSyyouOTqL7YRqXj2urOiR2j8k=
Date: Tue, 12 May 2026 19:20:13 -0700
To: mm-commits@vger.kernel.org,lucasp.linux@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-bug-cleanup-comment-style-types-and-modernize-logging.patch added to mm-nonmm-unstable branch
Message-Id: <20260513022014.1377CC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/bug: cleanup comment style, types and modernize logging
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-bug-cleanup-comment-style-types-and-modernize-logging.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-bug-cleanup-comment-style-types-and-modernize-logging.patch

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

lib-bug-cleanup-comment-style-types-and-modernize-logging.patch

