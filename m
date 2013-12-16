From: akpm@linux-foundation.org
Subject: [merged]
 procfs-also-fix-proc_reg_get_unmapped_area-for-mmu-case.patch removed from
 -mm tree
Date: Mon, 16 Dec 2013 12:39:24 -0800
Message-ID: <52af64fc.QL6o9I/YwVmADYhm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45808 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab3LPUjZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 15:39:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, jbeulich@suse.com, davem@davemloft.net, d.hatayama@jp.fujitsu.com, adobriyan@gmail.com, JBeulich@suse.com

Subject: [merged] procfs-also-fix-proc_reg_get_unmapped_area-for-mmu-case.patch removed from -mm tree
To: JBeulich@suse.com,adobriyan@gmail.com,d.hatayama@jp.fujitsu.com,davem@davemloft.net,jbeulich@suse.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 12:39:24 -0800


The patch titled
     Subject: procfs: also fix proc_reg_get_unmapped_area() for !MMU case
has been removed from the -mm tree.  Its filename was
     procfs-also-fix-proc_reg_get_unmapped_area-for-mmu-case.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Jan Beulich" <JBeulich@suse.com>
Subject: procfs: also fix proc_reg_get_unmapped_area() for !MMU case

Commit fad1a86e ("procfs: call default get_unmapped_area on MMU-present
architectures"), as its title says, took care of only the MMU case,
leaving the !MMU side still in the regressed state (returning -EIO in all
cases where pde->proc_fops->get_unmapped_area is NULL).

From the fad1a86e changelog:

: Commit c4fe24485729 ("sparc: fix PCI device proc file mmap(2)") added
: proc_reg_get_unmapped_area in proc_reg_file_ops and
: proc_reg_file_ops_no_compat, by which now mmap always returns EIO if
: get_unmapped_area method is not defined for the target procfs file, which
: causes regression of mmap on /proc/vmcore.
: 
: To address this issue, like get_unmapped_area(), call default
: current->mm->get_unmapped_area on MMU-present architectures if
: pde->proc_fops->get_unmapped_area, i.e.  the one in actual file operation
: in the procfs file, is not defined.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: <stable@vger.kernel.org>	[3.12.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN fs/proc/inode.c~procfs-also-fix-proc_reg_get_unmapped_area-for-mmu-case fs/proc/inode.c
--- a/fs/proc/inode.c~procfs-also-fix-proc_reg_get_unmapped_area-for-mmu-case
+++ a/fs/proc/inode.c
@@ -292,16 +292,20 @@ proc_reg_get_unmapped_area(struct file *
 {
 	struct proc_dir_entry *pde = PDE(file_inode(file));
 	unsigned long rv = -EIO;
-	unsigned long (*get_area)(struct file *, unsigned long, unsigned long,
-				  unsigned long, unsigned long) = NULL;
+
 	if (use_pde(pde)) {
+		typeof(proc_reg_get_unmapped_area) *get_area;
+
+		get_area = pde->proc_fops->get_unmapped_area;
 #ifdef CONFIG_MMU
-		get_area = current->mm->get_unmapped_area;
+		if (!get_area)
+			get_area = current->mm->get_unmapped_area;
 #endif
-		if (pde->proc_fops->get_unmapped_area)
-			get_area = pde->proc_fops->get_unmapped_area;
+
 		if (get_area)
 			rv = get_area(file, orig_addr, len, pgoff, flags);
+		else
+			rv = orig_addr;
 		unuse_pde(pde);
 	}
 	return rv;
_

Patches currently in -mm which might be from JBeulich@suse.com are

lib-decompress_unlz4c-always-set-an-error-return-code-on-failures.patch

