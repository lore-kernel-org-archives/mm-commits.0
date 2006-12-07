From: akpm@osdl.org
Subject: - kernel-proc-kallsyms-reports-lower-case.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:01:17 -0800
Message-ID: <200612072301.kB7N1HQo029738@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51506 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163755AbWLGXBY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:01:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: abj@novell.com, mm-commits@vger.kernel.org


The patch titled
     /proc/kallsyms reports lower-case types for some non-exported symbols
has been removed from the -mm tree.  Its filename was
     kernel-proc-kallsyms-reports-lower-case.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: /proc/kallsyms reports lower-case types for some non-exported symbols
From: Adam B. Jerome <abj@novell.com>

This patch addresses incorrect symbol type information reported through
/proc/kallsyms.  A lowercase character should designate the symbol as local
(or non-exported).  An uppercase character should designate the symbol as
global (or external).

Without this patch, some non-exported symbols are incorrectly assigned an
upper-case designation in /proc/kallsyms.  This patch corrects this
condition by converting non-exported symbols types to lower case when
appropriate and eliminates the superfluous upcase_if_global function

Signed-off-by: Adam B. Jerome <abj@novell.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/kallsyms.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN kernel/kallsyms.c~kernel-proc-kallsyms-reports-lower-case kernel/kallsyms.c
--- a/kernel/kallsyms.c~kernel-proc-kallsyms-reports-lower-case
+++ a/kernel/kallsyms.c
@@ -20,6 +20,7 @@
 #include <linux/proc_fs.h>
 #include <linux/sched.h>	/* for cond_resched */
 #include <linux/mm.h>
+#include <linux/ctype.h>
 
 #include <asm/sections.h>
 
@@ -301,13 +302,6 @@ struct kallsym_iter
 	char name[KSYM_NAME_LEN+1];
 };
 
-/* Only label it "global" if it is exported. */
-static void upcase_if_global(struct kallsym_iter *iter)
-{
-	if (is_exported(iter->name, iter->owner))
-		iter->type += 'A' - 'a';
-}
-
 static int get_ksymbol_mod(struct kallsym_iter *iter)
 {
 	iter->owner = module_get_kallsym(iter->pos - kallsyms_num_syms,
@@ -316,7 +310,10 @@ static int get_ksymbol_mod(struct kallsy
 	if (iter->owner == NULL)
 		return 0;
 
-	upcase_if_global(iter);
+	/* Label it "global" if it is exported, "local" if not exported. */
+	iter->type = is_exported(iter->name, iter->owner)
+		? toupper(iter->type) : tolower(iter->type);
+
 	return 1;
 }
 
_

Patches currently in -mm which might be from abj@novell.com are

origin.patch

