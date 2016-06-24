From: akpm@linux-foundation.org
Subject: + init-allow-blacklisting-of-module_init-functions.patch added to -mm tree
Date: Fri, 24 Jun 2016 13:28:29 -0700
Message-ID: <576d97ed.l7llgL35o4R54RNb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbcFXU2a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 16:28:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: prarit@redhat.com, aryabinin@virtuozzo.com, baiyaowei@cmss.chinamobile.com, keescook@chromium.org, linux@rasmusvillemoes.dk, mgorman@suse.de, mingo@kernel.org, rusty@rustcorp.com.au, tglx@linutronix.de, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: init: allow blacklisting of module_init functions
has been added to the -mm tree.  Its filename is
     init-allow-blacklisting-of-module_init-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/init-allow-blacklisting-of-module_init-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/init-allow-blacklisting-of-module_init-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 init/main.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN init/main.c~init-allow-blacklisting-of-module_init-functions init/main.c
--- a/init/main.c~init-allow-blacklisting-of-module_init-functions
+++ a/init/main.c
@@ -713,6 +713,11 @@ static bool __init_or_module initcall_bl
 		return false;
 
 	sprint_symbol_no_offset(fn_name, (unsigned long)fn);
+	/*
+	 * fn will be "function_name [module_name]" where [module_name] is not
+	 * displayed for built-in init functions.  Strip off the [module_name].
+	 */
+	strreplace(fn_name, ' ', '\0');
 
 	list_for_each_entry(entry, &blacklisted_initcalls, next) {
 		if (!strcmp(fn_name, entry->buf)) {
_

Patches currently in -mm which might be from prarit@redhat.com are

lib-switch-config_printk_time-to-int.patch
printk-allow-different-timestamps-for-printktime.patch
init-allow-blacklisting-of-module_init-functions.patch

