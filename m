From: akpm@linux-foundation.org
Subject: + make-proc-modules-use-seq_list_xxx-helpers.patch added to -mm tree
Date: Fri, 18 May 2007 10:37:52 -0700
Message-ID: <200705181737.l4IHbqaG019869@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from [207.189.120.14] ([207.189.120.14]:32937 "EHLO
	smtp2.linux-foundation.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754046AbXERRl0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 13:41:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@sw.ru, xemul@openvz.org


The patch titled
     Make /proc/modules use seq_list_xxx helpers
has been added to the -mm tree.  Its filename is
     make-proc-modules-use-seq_list_xxx-helpers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Make /proc/modules use seq_list_xxx helpers
From: Pavel Emelianov <xemul@sw.ru>

Here there is not need even in .show callback altering.  The original code
passes list_head in *v.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |   17 ++---------------
 1 files changed, 2 insertions(+), 15 deletions(-)

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

make-common-helpers-for-seq_files-that-work-with-list_head-s.patch
make-afs-use-seq_list_xxx-helpers.patch
make-atm-driver-use-seq_list_xxx-helpers.patch
make-block-layer-proc-files-use-seq_list_xxx-helpers.patch
make-crypto-api-use-seq_list_xxx-helpers.patch
make-input-layer-use-seq_list_xxx-helpers.patch
make-isdn-capi-use-seq_list_xxx-helpers.patch
make-proc-misc-use-seq_list_xxx-helpers.patch
make-proc-modules-use-seq_list_xxx-helpers.patch
make-some-network-related-proc-files-use-seq_list_xxx.patch
make-some-netfilter-related-proc-files-use-seq_list_xxx.patch
make-nfs-client-use-seq_list_xxx-helpers.patch
make-proc-tty-drivers-use-seq_list_xxx-helpers.patch
make-proc-slabinfo-use-seq_list_xxx-helpers.patch
make-proc-self-mountstats-use-seq_list_xxx-helpers.patch
