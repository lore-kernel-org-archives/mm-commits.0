From: akpm@linux-foundation.org
Subject: + init-mainc-simplify-initcall_blacklisted.patch added to -mm
 tree
Date: Fri, 25 Mar 2016 12:34:28 -0700
Message-ID: <56f592c4.VTLOfthtMtbr4mcK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38549 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbcCYTe3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2016 15:34:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, oleg@redhat.com, prarit@redhat.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: init/main.c: simplify initcall_blacklisted()
has been added to the -mm tree.  Its filename is
     init-mainc-simplify-initcall_blacklisted.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/init-mainc-simplify-initcall_blacklisted.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/init-mainc-simplify-initcall_blacklisted.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: init/main.c: simplify initcall_blacklisted()

Using kasprintf to get the function name makes us look up the name twice,
along with all the vsnprintf overhead of parsing the format string etc. 
It also means there is an allocation failure case to deal with.  Since
symbol_string in vsprintf.c would anyway allocate an array of size
KSYM_SYMBOL_LEN on the stack, that might as well be done up here.

Moreover, since this is a debug feature and the blacklisted_initcalls list
is usually empty, we might as well test that and thus avoid looking up the
symbol name even once in the common case.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Prarit Bhargava <prarit@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN init/main.c~init-mainc-simplify-initcall_blacklisted init/main.c
--- a/init/main.c~init-mainc-simplify-initcall_blacklisted
+++ a/init/main.c
@@ -706,21 +706,20 @@ static int __init initcall_blacklist(cha
 static bool __init_or_module initcall_blacklisted(initcall_t fn)
 {
 	struct blacklist_entry *entry;
-	char *fn_name;
+	char fn_name[KSYM_SYMBOL_LEN];
 
-	fn_name = kasprintf(GFP_KERNEL, "%pf", fn);
-	if (!fn_name)
+	if (list_empty(&blacklisted_initcalls))
 		return false;
 
+	sprint_symbol_no_offset(fn_name, (unsigned long)fn);
+
 	list_for_each_entry(entry, &blacklisted_initcalls, next) {
 		if (!strcmp(fn_name, entry->buf)) {
 			pr_debug("initcall %s blacklisted\n", fn_name);
-			kfree(fn_name);
 			return true;
 		}
 	}
 
-	kfree(fn_name);
 	return false;
 }
 #else
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

compilerh-add-support-for-malloc-attribute.patch
include-linux-apply-__malloc-attribute.patch
init-mainc-simplify-initcall_blacklisted.patch

