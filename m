From: akpm@linux-foundation.org
Subject: +
 define-find_symbol_in_section_t-as-function-type-to-simplify-the-code.patch added to -mm tree
Date: Tue, 14 Jul 2015 12:22:10 -0700
Message-ID: <55a56162.OdaPMvnRotXGQeFk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38442 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbbGNTWL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 15:22:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mnfhuang@gmail.com, namhyung@kernel.org, rob.jones@codethink.co.uk, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/module.c: define find_symbol_in_section_t as function type to simplify the code
has been added to the -mm tree.  Its filename is
     define-find_symbol_in_section_t-as-function-type-to-simplify-the-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/define-find_symbol_in_section_t-as-function-type-to-simplify-the-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/define-find_symbol_in_section_t-as-function-type-to-simplify-the-code.patch

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
Subject: kernel/module.c: define find_symbol_in_section_t as function type to simplify the code

It is not elegant if we use function directly as the argument, like
following:

bool each_symbol_section(bool (*fn)(const struct symsearch *arr,
                                   struct module *owner,
                                   void *data), void *data);

Here introduce a type defined function find_symbol_in_section_t.  Now we
can use these type defined function directly, if we want to pass the
function as the argument.

bool each_symbol_section(find_symbol_in_section_t fn, void *data);

Signed-off-by: Minfei Huang <mnfhuang@gmail.com>
Cc: Rob Jones <rob.jones@codethink.co.uk>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/module.h |    6 +++---
 kernel/module.c        |    9 ++-------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff -puN include/linux/module.h~define-find_symbol_in_section_t-as-function-type-to-simplify-the-code include/linux/module.h
--- a/include/linux/module.h~define-find_symbol_in_section_t-as-function-type-to-simplify-the-code
+++ a/include/linux/module.h
@@ -462,14 +462,14 @@ const struct kernel_symbol *find_symbol(
 					bool gplok,
 					bool warn);
 
+typedef bool (*find_symbol_in_section_t)(const struct symsearch *arr,
+		struct module *owner, void *data);
 /*
  * Walk the exported symbol table
  *
  * Must be called with module_mutex held or preemption disabled.
  */
-bool each_symbol_section(bool (*fn)(const struct symsearch *arr,
-				    struct module *owner,
-				    void *data), void *data);
+bool each_symbol_section(find_symbol_in_section_t fn, void *data);
 
 /* Returns 0 and fills in value, defined and namebuf, or -ERANGE if
    symnum out of range. */
diff -puN kernel/module.c~define-find_symbol_in_section_t-as-function-type-to-simplify-the-code kernel/module.c
--- a/kernel/module.c~define-find_symbol_in_section_t-as-function-type-to-simplify-the-code
+++ a/kernel/module.c
@@ -426,9 +426,7 @@ extern const unsigned long __start___kcr
 static bool each_symbol_in_section(const struct symsearch *arr,
 				   unsigned int arrsize,
 				   struct module *owner,
-				   bool (*fn)(const struct symsearch *syms,
-					      struct module *owner,
-					      void *data),
+				   find_symbol_in_section_t fn,
 				   void *data)
 {
 	unsigned int j;
@@ -442,10 +440,7 @@ static bool each_symbol_in_section(const
 }
 
 /* Returns true as soon as fn returns true, otherwise false. */
-bool each_symbol_section(bool (*fn)(const struct symsearch *arr,
-				    struct module *owner,
-				    void *data),
-			 void *data)
+bool each_symbol_section(find_symbol_in_section_t fn, void *data)
 {
 	struct module *mod;
 	static const struct symsearch arr[] = {
_

Patches currently in -mm which might be from mnfhuang@gmail.com are

define-find_symbol_in_section_t-as-function-type-to-simplify-the-code.patch
define-kallsyms_cmp_symbol_t-as-function-type-to-simplify-the-code.patch

