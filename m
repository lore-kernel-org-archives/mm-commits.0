From: akpm@osdl.org
Subject: - i386-msr-remove-unused-variable.patch removed from -mm tree
Date: Wed, 06 Dec 2006 14:24:02 -0800
Message-ID: <200612062224.kB6MO2t6018579@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48291 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937732AbWLFWYK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 17:24:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@cs.washington.edu, dcb314@hotmail.com, hpa@zytor.com, mm-commits@vger.kernel.org


The patch titled
     i386 msr: remove unused variable
has been removed from the -mm tree.  Its filename was
     i386-msr-remove-unused-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386 msr: remove unused variable
From: David Rientjes <rientjes@cs.washington.edu>

Remove unused variable in msr_write().

Reported by D Binderman <dcb314@hotmail.com>.

Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: David Rientjes <rientjes@cs.washington.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/msr.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/i386/kernel/msr.c~i386-msr-remove-unused-variable arch/i386/kernel/msr.c
--- a/arch/i386/kernel/msr.c~i386-msr-remove-unused-variable
+++ a/arch/i386/kernel/msr.c
@@ -195,7 +195,6 @@ static ssize_t msr_write(struct file *fi
 {
 	const u32 __user *tmp = (const u32 __user *)buf;
 	u32 data[2];
-	size_t rv;
 	u32 reg = *ppos;
 	int cpu = iminor(file->f_dentry->d_inode);
 	int err;
@@ -203,7 +202,7 @@ static ssize_t msr_write(struct file *fi
 	if (count % 8)
 		return -EINVAL;	/* Invalid chunk size */
 
-	for (rv = 0; count; count -= 8) {
+	for (; count; count -= 8) {
 		if (copy_from_user(&data, tmp, 8))
 			return -EFAULT;
 		err = do_wrmsr(cpu, reg, data[0], data[1]);
_

Patches currently in -mm which might be from rientjes@cs.washington.edu are

pci-quirks-remove-redundant-check.patch
memory-page_alloc-zonelist-caching-speedup.patch
fs-remove-unused-variable.patch
sys-remove-unused-variable.patch
video-sis-remove-unnecessary-variables-in-sis_ddc2delay.patch
hrtimers-clean-up-locking-fix.patch

