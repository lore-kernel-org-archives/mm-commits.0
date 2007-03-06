From: akpm@linux-foundation.org
Subject: - profile_likely-export-do_check_likely.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:20:52 -0800
Message-ID: <200703060220.l262Kq2Q009283@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47408 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965751AbXCFCVE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:21:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, dwalker@mvista.com, hzhong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     profile_likely: export do_check_likely
has been removed from the -mm tree.  Its filename was
     profile_likely-export-do_check_likely.patch

This patch was dropped because it was folded into profile-likely-unlikely-macros.patch

------------------------------------------------------
Subject: profile_likely: export do_check_likely
From: Randy Dunlap <randy.dunlap@oracle.com>

I see MODPOST warnings for all modules in some (random) configs; e.g.:
(This is a short list; I see >100 of these.)

WARNING: "do_check_likely" [net/sched/cls_basic.ko] undefined!
WARNING: "do_check_likely" [net/netfilter/x_tables.ko] undefined!
WARNING: "do_check_likely" [net/key/af_key.ko] undefined!
WARNING: "do_check_likely" [kernel/rcutorture.ko] undefined!
WARNING: "do_check_likely" [fs/xfs/xfs.ko] undefined!
WARNING: "do_check_likely" [fs/sysv/sysv.ko] undefined!
WARNING: "do_check_likely" [fs/reiserfs/reiserfs.ko] undefined!
WARNING: "do_check_likely" [fs/ntfs/ntfs.ko] undefined!
WARNING: "do_check_likely" [fs/minix/minix.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Daniel Walker <dwalker@mvista.com>
Cc: Hua Zhong <hzhong@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 lib/likely_prof.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN lib/likely_prof.c~profile_likely-export-do_check_likely lib/likely_prof.c
--- a/lib/likely_prof.c~profile_likely-export-do_check_likely
+++ a/lib/likely_prof.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/fs.h>
 #include <linux/seq_file.h>
@@ -50,6 +51,7 @@ int do_check_likely(struct likeliness *l
 
 	return ret;
 }
+EXPORT_SYMBOL(do_check_likely);
 
 static void * lp_seq_start(struct seq_file *out, loff_t *pos)
 {
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
atyfb-fix-kconfig-error-part-2.patch
git-drm.patch
phy-layer-add-kernel-doc-docbook.patch
fusion-kernel-doc-warning-fixes.patch
scripts-kernel-doc-whitespace-cleanup.patch
profile-likely-unlikely-macros.patch
profile_likely-export-do_check_likely.patch
