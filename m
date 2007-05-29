From: akpm@linux-foundation.org
Subject: - optimize-compat_core_sys_select-by-a-using-stack-space-for-small-fd-sets.patch removed from -mm tree
Date: Tue, 29 May 2007 11:51:03 -0700
Message-ID: <200705291851.l4TIp2DN008316@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754126AbXE2Sve (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:51:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbadari@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     optimize compat_core_sys_select() by a using stack space for small fd sets
has been removed from the -mm tree.  Its filename was
     optimize-compat_core_sys_select-by-a-using-stack-space-for-small-fd-sets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: optimize compat_core_sys_select() by a using stack space for small fd sets
From: Badari Pulavarty <pbadari@us.ibm.com>

Optimize select by a using stack space for small fd sets. 
core_sys_select() already has this optimization.  This is for compat
version.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff -puN fs/compat.c~optimize-compat_core_sys_select-by-a-using-stack-space-for-small-fd-sets fs/compat.c
--- a/fs/compat.c~optimize-compat_core_sys_select-by-a-using-stack-space-for-small-fd-sets
+++ a/fs/compat.c
@@ -1544,9 +1544,10 @@ int compat_core_sys_select(int n, compat
 	compat_ulong_t __user *outp, compat_ulong_t __user *exp, s64 *timeout)
 {
 	fd_set_bits fds;
-	char *bits;
+	void *bits;
 	int size, max_fds, ret = -EINVAL;
 	struct fdtable *fdt;
+	long stack_fds[SELECT_STACK_ALLOC/sizeof(long)];
 
 	if (n < 0)
 		goto out_nofds;
@@ -1564,11 +1565,14 @@ int compat_core_sys_select(int n, compat
 	 * since we used fdset we need to allocate memory in units of
 	 * long-words.
 	 */
-	ret = -ENOMEM;
 	size = FDS_BYTES(n);
-	bits = kmalloc(6 * size, GFP_KERNEL);
-	if (!bits)
-		goto out_nofds;
+	bits = stack_fds;
+	if (size > sizeof(stack_fds) / 6) {
+		bits = kmalloc(6 * size, GFP_KERNEL);
+		ret = -ENOMEM;
+		if (!bits)
+			goto out_nofds;
+	}
 	fds.in      = (unsigned long *)  bits;
 	fds.out     = (unsigned long *) (bits +   size);
 	fds.ex      = (unsigned long *) (bits + 2*size);
@@ -1600,7 +1604,8 @@ int compat_core_sys_select(int n, compat
 	    compat_set_fd_set(n, exp, fds.res_ex))
 		ret = -EFAULT;
 out:
-	kfree(bits);
+	if (bits != stack_fds)
+		kfree(bits);
 out_nofds:
 	return ret;
 }
_

Patches currently in -mm which might be from pbadari@us.ibm.com are
