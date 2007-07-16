From: akpm@linux-foundation.org
Subject: - make-proc-modules-use-seq_list_xxx-helpers.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:53:44 -0700
Message-ID: <200707162053.l6GKripG001672@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49357 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762741AbXGPVX0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:23:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@sw.ru, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Make /proc/modules use seq_list_xxx helpers
has been removed from the -mm tree.  Its filename was
     make-proc-modules-use-seq_list_xxx-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Make /proc/modules use seq_list_xxx helpers
From: Pavel Emelianov <xemul@sw.ru>

Here there is not need even in .show callback altering.  The original code
passes list_head in *v.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff -puN kernel/module.c~make-proc-modules-use-seq_list_xxx-helpers kernel/module.c
--- a/kernel/module.c~make-proc-modules-use-seq_list_xxx-helpers
+++ a/kernel/module.c
@@ -2232,26 +2232,13 @@ unsigned long module_kallsyms_lookup_nam
 /* Called by the /proc file system to return a list of modules. */
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
-	struct list_head *i;
-	loff_t n = 0;
-
 	mutex_lock(&module_mutex);
-	list_for_each(i, &modules) {
-		if (n++ == *pos)
-			break;
-	}
-	if (i == &modules)
-		return NULL;
-	return i;
+	return seq_list_start(&modules, *pos);
 }
 
 static void *m_next(struct seq_file *m, void *p, loff_t *pos)
 {
-	struct list_head *i = p;
-	(*pos)++;
-	if (i->next == &modules)
-		return NULL;
-	return i->next;
+	return seq_list_next(p, &modules, pos);
 }
 
 static void m_stop(struct seq_file *m, void *p)
_

Patches currently in -mm which might be from xemul@sw.ru are

origin.patch
make-input-layer-use-seq_list_xxx-helpers.patch
make-isdn-capi-use-seq_list_xxx-helpers.patch
