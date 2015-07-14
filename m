From: akpm@linux-foundation.org
Subject: +
 define-kallsyms_cmp_symbol_t-as-function-type-to-simplify-the-code.patch
 added to -mm tree
Date: Tue, 14 Jul 2015 12:22:12 -0700
Message-ID: <55a56164.3kA+MjgpdS+OMn5G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38448 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbbGNTWN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 15:22:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mnfhuang@gmail.com, namhyung@kernel.org, rob.jones@codethink.co.uk, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/kallsyns.c: define kallsyms_cmp_symbol_t as function type to simplify the code
has been added to the -mm tree.  Its filename is
     define-kallsyms_cmp_symbol_t-as-function-type-to-simplify-the-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/define-kallsyms_cmp_symbol_t-as-function-type-to-simplify-the-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/define-kallsyms_cmp_symbol_t-as-function-type-to-simplify-the-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minfei Huang <mnfhuang@gmail.com>
Subject: kernel/kallsyns.c: define kallsyms_cmp_symbol_t as function type to simplify the code

It is not elegant if we use function directly as the argument, like
following:

int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
                                  struct module *, unsigned long),
                                  void *data);

Here introduce a type defined function kallsyms_cmp_symbol_t. Now
we can use these type defined function directly, if we want to pass
the function as the argument.

int module_kallsyms_on_each_symbol(kallsyms_cmp_symbol_t fn,
					void *data);

Signed-off-by: Minfei Huang <mnfhuang@gmail.com>
Cc: Rob Jones <rob.jones@codethink.co.uk>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kallsyms.h |   10 +++-------
 include/linux/module.h   |   13 ++++++-------
 kernel/kallsyms.c        |    4 +---
 kernel/module.c          |    4 +---
 4 files changed, 11 insertions(+), 20 deletions(-)

diff -puN include/linux/kallsyms.h~define-kallsyms_cmp_symbol_t-as-function-type-to-simplify-the-code include/linux/kallsyms.h
--- a/include/linux/kallsyms.h~define-kallsyms_cmp_symbol_t-as-function-type-to-simplify-the-code
+++ a/include/linux/kallsyms.h
@@ -8,6 +8,7 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/stddef.h>
+#include <linux/module.h>
 
 #define KSYM_NAME_LEN 128
 #define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s]") + (KSYM_NAME_LEN - 1) + \
@@ -20,9 +21,7 @@ struct module;
 unsigned long kallsyms_lookup_name(const char *name);
 
 /* Call a function on each kallsyms symbol in the core kernel */
-int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
-				      unsigned long),
-			    void *data);
+int kallsyms_on_each_symbol(kallsyms_cmp_symbol_t fn, void *data);
 
 extern int kallsyms_lookup_size_offset(unsigned long addr,
 				  unsigned long *symbolsize,
@@ -52,10 +51,7 @@ static inline unsigned long kallsyms_loo
 	return 0;
 }
 
-static inline int kallsyms_on_each_symbol(int (*fn)(void *, const char *,
-						    struct module *,
-						    unsigned long),
-					  void *data)
+static inline int kallsyms_on_each_symbol(kallsyms_cmp_symbol_t fn, void *data)
 {
 	return 0;
 }
diff -puN include/linux/module.h~define-kallsyms_cmp_symbol_t-as-function-type-to-simplify-the-code include/linux/module.h
--- a/include/linux/module.h~define-kallsyms_cmp_symbol_t-as-function-type-to-simplify-the-code
+++ a/include/linux/module.h
@@ -479,9 +479,10 @@ int module_get_kallsym(unsigned int symn
 /* Look for this name: can be of form module:name. */
 unsigned long module_kallsyms_lookup_name(const char *name);
 
-int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
-					     struct module *, unsigned long),
-				   void *data);
+typedef int (*kallsyms_cmp_symbol_t)(void *, const char *,
+		struct module *, unsigned long);
+
+int module_kallsyms_on_each_symbol(kallsyms_cmp_symbol_t fn, void *data);
 
 extern void __module_put_and_exit(struct module *mod, long code)
 	__attribute__((noreturn));
@@ -637,10 +638,8 @@ static inline unsigned long module_kalls
 	return 0;
 }
 
-static inline int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
-							   struct module *,
-							   unsigned long),
-						 void *data)
+static inline int module_kallsyms_on_each_symbol(
+		kallsyms_cmp_symbol_t fn, void *data)
 {
 	return 0;
 }
diff -puN kernel/kallsyms.c~define-kallsyms_cmp_symbol_t-as-function-type-to-simplify-the-code kernel/kallsyms.c
--- a/kernel/kallsyms.c~define-kallsyms_cmp_symbol_t-as-function-type-to-simplify-the-code
+++ a/kernel/kallsyms.c
@@ -193,9 +193,7 @@ unsigned long kallsyms_lookup_name(const
 }
 EXPORT_SYMBOL_GPL(kallsyms_lookup_name);
 
-int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
-				      unsigned long),
-			    void *data)
+int kallsyms_on_each_symbol(kallsyms_cmp_symbol_t fn, void *data)
 {
 	char namebuf[KSYM_NAME_LEN];
 	unsigned long i;
diff -puN kernel/module.c~define-kallsyms_cmp_symbol_t-as-function-type-to-simplify-the-code kernel/module.c
--- a/kernel/module.c~define-kallsyms_cmp_symbol_t-as-function-type-to-simplify-the-code
+++ a/kernel/module.c
@@ -3811,9 +3811,7 @@ unsigned long module_kallsyms_lookup_nam
 	return ret;
 }
 
-int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
-					     struct module *, unsigned long),
-				   void *data)
+int module_kallsyms_on_each_symbol(kallsyms_cmp_symbol_t fn, void *data)
 {
 	struct module *mod;
 	unsigned int i;
_

Patches currently in -mm which might be from mnfhuang@gmail.com are

define-find_symbol_in_section_t-as-function-type-to-simplify-the-code.patch
define-kallsyms_cmp_symbol_t-as-function-type-to-simplify-the-code.patch

