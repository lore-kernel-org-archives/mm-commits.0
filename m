From: akpm@linux-foundation.org
Subject: [merged]
 init-mainc-fix-initcall_blacklisted-on-ia64-ppc64-and-parisc64.patch
 removed from -mm tree
Date: Tue, 28 Jun 2016 19:03:22 -0700
Message-ID: <57732c6a.yVb1lLLgt05sHJ4E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41650 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbcF2CF0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jun 2016 22:05:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, pmladek@suse.com, prarit@redhat.com, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: init/main.c: fix initcall_blacklisted on ia64, ppc64 and parisc64
has been removed from the -mm tree.  Its filename was
     init-mainc-fix-initcall_blacklisted-on-ia64-ppc64-and-parisc64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: init/main.c: fix initcall_blacklisted on ia64, ppc64 and parisc64

When I replaced kasprintf("%pf") with a direct call to
sprint_symbol_no_offset I must have broken the initcall blacklisting
feature on the arches where dereference_function_descriptor() is
non-trivial.

Fixes: c8cdd2be213f (init/main.c: simplify initcall_blacklisted())
Link: http://lkml.kernel.org/r/1466027283-4065-1-git-send-email-linux@rasmusvillemoes.dk
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN init/main.c~init-mainc-fix-initcall_blacklisted-on-ia64-ppc64-and-parisc64 init/main.c
--- a/init/main.c~init-mainc-fix-initcall_blacklisted-on-ia64-ppc64-and-parisc64
+++ a/init/main.c
@@ -708,11 +708,13 @@ static bool __init_or_module initcall_bl
 {
 	struct blacklist_entry *entry;
 	char fn_name[KSYM_SYMBOL_LEN];
+	unsigned long addr;
 
 	if (list_empty(&blacklisted_initcalls))
 		return false;
 
-	sprint_symbol_no_offset(fn_name, (unsigned long)fn);
+	addr = (unsigned long) dereference_function_descriptor(fn);
+	sprint_symbol_no_offset(fn_name, addr);
 
 	list_for_each_entry(entry, &blacklisted_initcalls, next) {
 		if (!strcmp(fn_name, entry->buf)) {
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are


