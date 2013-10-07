From: akpm@linux-foundation.org
Subject: + printk-mark-printk_once-test-variable-__read_mostly.patch added to -mm tree
Date: Mon, 07 Oct 2013 16:44:14 -0700
Message-ID: <5253474e.d7oJYuUoyVF5aqdB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab3JGXoP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Oct 2013 19:44:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + printk-mark-printk_once-test-variable-__read_mostly.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Mon, 07 Oct 2013 16:44:14 -0700


The patch titled
     Subject: printk: mark printk_once test variable __read_mostly
has been added to the -mm tree.  Its filename is
     printk-mark-printk_once-test-variable-__read_mostly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-mark-printk_once-test-variable-__read_mostly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-mark-printk_once-test-variable-__read_mostly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk: mark printk_once test variable __read_mostly

It's only set once so mark it __read_mostly.

Neaten the alignment so it matches the rest of the pr_<level>_once
#defines too.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN include/linux/printk.h~printk-mark-printk_once-test-variable-__read_mostly include/linux/printk.h
--- a/include/linux/printk.h~printk-mark-printk_once-test-variable-__read_mostly
+++ a/include/linux/printk.h
@@ -251,17 +251,17 @@ extern asmlinkage void dump_stack(void)
  */
 
 #ifdef CONFIG_PRINTK
-#define printk_once(fmt, ...)			\
-({						\
-	static bool __print_once;		\
-						\
-	if (!__print_once) {			\
-		__print_once = true;		\
-		printk(fmt, ##__VA_ARGS__);	\
-	}					\
+#define printk_once(fmt, ...)					\
+({								\
+	static bool __print_once __read_mostly;			\
+								\
+	if (!__print_once) {					\
+		__print_once = true;				\
+		printk(fmt, ##__VA_ARGS__);			\
+	}							\
 })
 #else
-#define printk_once(fmt, ...)			\
+#define printk_once(fmt, ...)					\
 	no_printk(fmt, ##__VA_ARGS__)
 #endif
 
_

Patches currently in -mm which might be from joe@perches.com are

kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch
ksm-remove-redundant-__gfp_zero-from-kcalloc.patch
printk-report-console-names-during-cut-over.patch
kernel-printk-printkc-convert-to-pr_foo.patch
printk-mark-printk_once-test-variable-__read_mostly.patch
checkpatch-report-missing-spaces-around-trigraphs-with-strict.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-update-seq_foo-tests.patch
checkpatch-find-camelcase-definitions-of-struct-union-enum.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
checkpatch-add-rules-to-check-init-attribute-and-const-defects.patch
checkpatch-make-the-memory-barrier-test-noisier.patch
checkpatchpl-check-for-the-fsf-mailing-address.patch
kernel-modulec-use-pr_foo.patch
linux-next.patch

