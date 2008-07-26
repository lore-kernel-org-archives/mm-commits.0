From: akpm@linux-foundation.org
Subject: - use-warn-in-fs-proc.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:16:30 -0700
Message-ID: <200807262116.m6QLGUP9019837@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757684AbYGZVQc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:16:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Use WARN() in fs/proc/
has been removed from the -mm tree.  Its filename was
     use-warn-in-fs-proc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Use WARN() in fs/proc/
From: Arjan van de Ven <arjan@linux.intel.com>

Use WARN() instead of a printk+WARN_ON() pair; this way the message
becomes part of the warning section for better reporting/collection.
This way, the entire if() {} section can collapse into the WARN() as well.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN fs/proc/generic.c~use-warn-in-fs-proc fs/proc/generic.c
--- a/fs/proc/generic.c~use-warn-in-fs-proc
+++ a/fs/proc/generic.c
@@ -806,12 +806,9 @@ continue_removing:
 	if (S_ISDIR(de->mode))
 		parent->nlink--;
 	de->nlink = 0;
-	if (de->subdir) {
-		printk(KERN_WARNING "%s: removing non-empty directory "
+	WARN(de->subdir, KERN_WARNING "%s: removing non-empty directory "
 			"'%s/%s', leaking at least '%s'\n", __func__,
 			de->parent->name, de->name, de->subdir->name);
-		WARN_ON(1);
-	}
 	if (atomic_dec_and_test(&de->count))
 		free_proc_entry(de);
 }
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch
linux-next.patch
via-velocity-fix-sleep-with-spinlock-bug-during-mtu-change.patch
modules-extend-initcall_debug-functionality-to-the-module-loader.patch
use-warn-in-kernel-lockdepc.patch
use-warn-in-arch-x86-mm-ioremapc.patch
use-warn-in-arch-x86-mm-pageattrc.patch
use-warn-in-arch-x86-kernel.patch

