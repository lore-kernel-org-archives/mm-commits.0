From: akpm@linux-foundation.org
Subject: - likeliness-accounting-change-and-cleanup.patch removed from -mm tree
Date: Mon, 27 Oct 2008 21:34:45 -0700
Message-ID: <200810280434.m9S4YjNk018455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365AbYJ1EfV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 00:35:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, dwalker@mvista.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     likeliness accounting change and cleanup
has been removed from the -mm tree.  Its filename was
     likeliness-accounting-change-and-cleanup.patch

This patch was dropped because it was folded into profile-likely-unlikely-macros.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: likeliness accounting change and cleanup
From: Roel Kluin <12o3l@tiscali.nl>

Store __builtin_return_address (caller) rather than __func__ in likeliness
struct. 'line' and 'type' are combined in 'label'

+/- now denotes whether expectation fails in less than 5% of the tests - rather
than whether more unexpected than expected were encountered. The function at
the displayed filename & line and the caller are not necessarily the same.
A few more Likely Profiling Results changes were made.

struct seq_operations becomes static, unsigned ints true and false (shadowed)
are replaced by pos and neg.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
This should be applied after the -mm patches:
http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc5/2.6.25-rc5-mm1/broken-out/profile-likely-unlikely-macros.patch
http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc5/2.6.25-rc5-mm1/broken-out/profile-likely-unlikely-macros-fix.patch

New layout:

Likely Profiling Results
 --------------------------------------------------------------------
[+- ]Type | # True  | # False | Function@Filename:Line
 unlikely |        0|    32082| fget+0xd0/0x1d0@include/asm/arch/atomic_32.h:235

Cc: Daniel Walker <dwalker@mvista.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler.h |   16 ++++++-------
 lib/likely_prof.c        |   45 ++++++++++++++++++++-----------------
 2 files changed, 33 insertions(+), 28 deletions(-)

diff -puN include/linux/compiler.h~likeliness-accounting-change-and-cleanup include/linux/compiler.h
--- a/include/linux/compiler.h~likeliness-accounting-change-and-cleanup
+++ a/include/linux/compiler.h
@@ -56,25 +56,25 @@ extern void __chk_io_ptr(const volatile 
 #if defined(CONFIG_PROFILE_LIKELY) && !defined(SUPPRESS_LIKELY_PROFILING) && \
 	!(defined(CONFIG_MODULE_UNLOAD) && defined(MODULE))
 struct likeliness {
-	const char *func;
-	char *file;
-	int line;
-	int type;
+	char *const file;
+	unsigned long caller;
 	unsigned int count[2];
 	struct likeliness *next;
+	unsigned int label;
 };
 
-extern int do_check_likely(struct likeliness *likeliness, int exp);
+extern int do_check_likely(struct likeliness *likeliness, unsigned int exp);
 
+#define LP_IS_EXPECTED	1
 #define LP_UNSEEN	4
+#define LP_LINE_SHIFT	3
 
 #define __check_likely(exp, is_likely)					\
 	({								\
 		static struct likeliness likeliness = {			\
-			.func = __func__,				\
 			.file = __FILE__,				\
-			.line = __LINE__,				\
-			.type = is_likely | LP_UNSEEN,			\
+			.label = __LINE__ << LP_LINE_SHIFT |		\
+						LP_UNSEEN | is_likely,	\
 		};							\
 		do_check_likely(&likeliness, !!(exp));			\
 	})
diff -puN lib/likely_prof.c~likeliness-accounting-change-and-cleanup lib/likely_prof.c
--- a/lib/likely_prof.c~likeliness-accounting-change-and-cleanup
+++ a/lib/likely_prof.c
@@ -15,34 +15,34 @@
 #include <linux/fs.h>
 #include <linux/seq_file.h>
 #include <linux/proc_fs.h>
+#include <linux/kallsyms.h>
 
 #include <asm/bug.h>
 #include <asm/atomic.h>
 
 static struct likeliness *likeliness_head;
 
-int do_check_likely(struct likeliness *likeliness, int ret)
+int do_check_likely(struct likeliness *likeliness, unsigned int ret)
 {
 	static unsigned long likely_lock;
 
-	if (ret)
-		likeliness->count[1]++;
-	else
-		likeliness->count[0]++;
+	likeliness->count[ret]++;
 
-	if (likeliness->type & LP_UNSEEN) {
+	if (likeliness->label & LP_UNSEEN) {
 		/*
-		 * We don't simple use a spinlock because internally to the
+		 * We don't simply use a spinlock because internally to the
 		 * spinlock there is a call to unlikely which causes recursion.
 		 * We opted for this method because we didn't need a preempt/irq
 		 * disable and it was a bit cleaner then using internal __raw
 		 * spinlock calls.
 		 */
 		if (!test_and_set_bit(0, &likely_lock)) {
-			if (likeliness->type & LP_UNSEEN) {
-				likeliness->type &= (~LP_UNSEEN);
+			if (likeliness->label & LP_UNSEEN) {
+				likeliness->label &= (~LP_UNSEEN);
 				likeliness->next = likeliness_head;
 				likeliness_head = likeliness;
+				likeliness->caller = (unsigned long)
+						__builtin_return_address(0);
 			}
 			smp_mb__before_clear_bit();
 			clear_bit(0, &likely_lock);
@@ -61,8 +61,8 @@ static void * lp_seq_start(struct seq_fi
 		seq_printf(out, "Likely Profiling Results\n");
 		seq_printf(out, " --------------------------------------------"
 				"------------------------\n");
-		seq_printf(out, "[+- ] Type | # True | # False | Function:"
-				"Filename@Line\n");
+		seq_printf(out, "[+- ]Type | # True  | # False | Function@"
+				"Filename:Line\n");
 
 		out->private = likeliness_head;
 	}
@@ -86,18 +86,22 @@ static void *lp_seq_next(struct seq_file
 static int lp_seq_show(struct seq_file *out, void *p)
 {
 	struct likeliness *entry = p;
-	unsigned int true = entry->count[1];
-	unsigned int false = entry->count[0];
-
-	if (!entry->type) {
-		if (true > false)
+	unsigned int pos = entry->count[1];
+	unsigned int neg = entry->count[0];
+	char function[KSYM_SYMBOL_LEN];
+
+	/*
+	 * Balanced if the suggestion was false in less than 5% of the tests
+	 */
+	if (!(entry->label & LP_IS_EXPECTED)) {
+		if (pos + neg < 20 * pos)
 			seq_printf(out, "+");
 		else
 			seq_printf(out, " ");
 
 		seq_printf(out, "unlikely ");
 	} else {
-		if (true < false)
+		if (pos + neg < 20 * neg)
 			seq_printf(out, "-");
 		else
 			seq_printf(out, " ");
@@ -105,8 +109,9 @@ static int lp_seq_show(struct seq_file *
 		seq_printf(out, "likely   ");
 	}
 
-	seq_printf(out, "|%9u|%9u\t%s()@:%s@%d\n", true, false,
-			entry->func, entry->file, entry->line);
+	sprint_symbol(function, entry->caller);
+	seq_printf(out, "|%9u|%9u|\t%s@%s:%u\n", pos, neg, function,
+			entry->file, entry->label >> LP_LINE_SHIFT);
 
 	return 0;
 }
@@ -115,7 +120,7 @@ static void lp_seq_stop(struct seq_file 
 {
 }
 
-struct seq_operations likely_profiling_ops = {
+static struct seq_operations likely_profiling_ops = {
 	.start  = lp_seq_start,
 	.next   = lp_seq_next,
 	.stop   = lp_seq_stop,
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

profile-likely-unlikely-macros.patch
likeliness-accounting-change-and-cleanup.patch
likely_prof-update-to-test_and_set_bit_lock-clear_bit_unlock.patch

