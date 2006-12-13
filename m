From: akpm@osdl.org
Subject: - fix-noise-in-futexh.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:52:26 -0800
Message-ID: <200612130652.kBD6qQpG030437@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57329 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964975AbWLMGwd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:52:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Fix noise in futex.h
has been removed from the -mm tree.  Its filename was
     fix-noise-in-futexh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix noise in futex.h
From: David Woodhouse <dwmw2@infradead.org>

There are some kernel-only bits in the middle of <linux/futex.h> which
should be removed in what we export to userspace.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/Kbuild  |    2 +-
 include/linux/futex.h |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/Kbuild~fix-noise-in-futexh include/linux/Kbuild
--- a/include/linux/Kbuild~fix-noise-in-futexh
+++ a/include/linux/Kbuild
@@ -61,7 +61,6 @@ header-y += fd.h
 header-y += fdreg.h
 header-y += fib_rules.h
 header-y += fuse.h
-header-y += futex.h
 header-y += genetlink.h
 header-y += gen_stats.h
 header-y += gigaset_dev.h
@@ -203,6 +202,7 @@ unifdef-y += fb.h
 unifdef-y += fcntl.h
 unifdef-y += filter.h
 unifdef-y += flat.h
+unifdef-y += futex.h
 unifdef-y += fs.h
 unifdef-y += gameport.h
 unifdef-y += generic_serial.h
diff -puN include/linux/futex.h~fix-noise-in-futexh include/linux/futex.h
--- a/include/linux/futex.h~fix-noise-in-futexh
+++ a/include/linux/futex.h
@@ -93,6 +93,7 @@ struct robust_list_head {
  */
 #define ROBUST_LIST_LIMIT	2048
 
+#ifdef __KERNEL__
 long do_futex(u32 __user *uaddr, int op, u32 val, unsigned long timeout,
 	      u32 __user *uaddr2, u32 val2, u32 val3);
 
@@ -110,6 +111,7 @@ static inline void exit_pi_state_list(st
 {
 }
 #endif
+#endif /* __KERNEL__ */
 
 #define FUTEX_OP_SET		0	/* *(int *)UADDR2 = OPARG; */
 #define FUTEX_OP_ADD		1	/* *(int *)UADDR2 += OPARG; */
_

Patches currently in -mm which might be from dwmw2@infradead.org are

origin.patch
audit-fix-kstrdup-error-check.patch
git-mtd.patch
n_r3964-use-struct-pid-to-track-user-space-clients.patch
getting-rid-of-all-casts-of-kalloc-calls.patch
debug-shared-irqs.patch
debug-shared-irqs-kconfig-fix.patch

