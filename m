From: akpm@linux-foundation.org
Subject: [merged] init-allow-blacklisting-of-module_init-functions.patch
 removed from -mm tree
Date: Wed, 03 Aug 2016 11:14:52 -0700
Message-ID: <57a2349c.oJhCTSFJMGyBLdoZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33648 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276AbcHCSOx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:14:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: prarit@redhat.com, aryabinin@virtuozzo.com, baiyaowei@cmss.chinamobile.com, keescook@chromium.org, linux@rasmusvillemoes.dk, mgorman@suse.de, mingo@kernel.org, rusty@rustcorp.com.au, tglx@linutronix.de, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: init: allow blacklisting of module_init functions
has been removed from the -mm tree.  Its filename was
     init-allow-blacklisting-of-module_init-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Prarit Bhargava <prarit@redhat.com>
Subject: init: allow blacklisting of module_init functions

sprint_symbol_no_offset() returns the string "function_name [module_name]"
where [module_name] is not printed for built in kernel functions.  This
means that the blacklisting code will fail when comparing module function
names with the extended string.  This patch adds the functionality to
block a module's module_init() function by finding the space in the string
and truncating the comparison to that length.

Link: http://lkml.kernel.org/r/1466124387-20446-1-git-send-email-prarit@redhat.com
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN init/main.c~init-allow-blacklisting-of-module_init-functions init/main.c
--- a/init/main.c~init-allow-blacklisting-of-module_init-functions
+++ a/init/main.c
@@ -716,6 +716,12 @@ static bool __init_or_module initcall_bl
 	addr = (unsigned long) dereference_function_descriptor(fn);
 	sprint_symbol_no_offset(fn_name, addr);
 
+	/*
+	 * fn will be "function_name [module_name]" where [module_name] is not
+	 * displayed for built-in init functions.  Strip off the [module_name].
+	 */
+	strreplace(fn_name, ' ', '\0');
+ 
 	list_for_each_entry(entry, &blacklisted_initcalls, next) {
 		if (!strcmp(fn_name, entry->buf)) {
 			pr_debug("initcall %s blacklisted\n", fn_name);
_

Patches currently in -mm which might be from prarit@redhat.com are


