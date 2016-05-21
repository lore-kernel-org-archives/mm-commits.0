From: akpm@linux-foundation.org
Subject: [patch 159/162] init/main.c: simplify initcall_blacklisted()
Date: Fri, 20 May 2016 17:04:27 -0700
Message-ID: <573fa60b.OpJTErPTWsI+TOSQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53219 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbcEUAE3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:04:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, linux@rasmusvillemoes.dk, oleg@redhat.com, prarit@redhat.com, rusty@rustcorp.com.au

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
