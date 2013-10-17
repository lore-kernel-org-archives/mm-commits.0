From: akpm@linux-foundation.org
Subject: [merged]
 procfs-call-default-get_unmapped_area-on-mmu-present-architectures.patch
 removed from -mm tree
Date: Thu, 17 Oct 2013 11:13:27 -0700
Message-ID: <526028c7.M2VBLTGsb9r2PNHE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44384 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758604Ab3JQSN2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Oct 2013 14:13:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, holzheu@linux.vnet.ibm.com, davem@davemloft.net, adobriyan@gmail.com, d.hatayama@jp.fujitsu.com

Subject: [merged] procfs-call-default-get_unmapped_area-on-mmu-present-architectures.patch removed from -mm tree
To: d.hatayama@jp.fujitsu.com,adobriyan@gmail.com,davem@davemloft.net,holzheu@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 17 Oct 2013 11:13:27 -0700


The patch titled
     Subject: procfs: call default get_unmapped_area on MMU-present architectures
has been removed from the -mm tree.  Its filename was
     procfs-call-default-get_unmapped_area-on-mmu-present-architectures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: procfs: call default get_unmapped_area on MMU-present architectures

c4fe24485729f ("sparc: fix PCI device proc file mmap(2)") added
proc_reg_get_unmapped_area in proc_reg_file_ops and
proc_reg_file_ops_no_compat, by which now mmap always returns EIO if
get_unmapped_area method is not defined for the target procfs file, which
causes regression of mmap on /proc/vmcore.

To address this issue, like get_unmapped_area(), call default
current->mm->get_unmapped_area on MMU-present architectures if
pde->proc_fops->get_unmapped_area, i.e.  the one in actual file operation
in the procfs file, is not defined.

Reported-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Tested-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN fs/proc/inode.c~procfs-call-default-get_unmapped_area-on-mmu-present-architectures fs/proc/inode.c
--- a/fs/proc/inode.c~procfs-call-default-get_unmapped_area-on-mmu-present-architectures
+++ a/fs/proc/inode.c
@@ -289,9 +289,13 @@ static unsigned long proc_reg_get_unmapp
 {
 	struct proc_dir_entry *pde = PDE(file_inode(file));
 	unsigned long rv = -EIO;
-	unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
+	unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long) = NULL;
 	if (use_pde(pde)) {
-		get_unmapped_area = pde->proc_fops->get_unmapped_area;
+#ifdef CONFIG_MMU
+		get_unmapped_area = current->mm->get_unmapped_area;
+#endif
+		if (pde->proc_fops->get_unmapped_area)
+			get_unmapped_area = pde->proc_fops->get_unmapped_area;
 		if (get_unmapped_area)
 			rv = get_unmapped_area(file, orig_addr, len, pgoff, flags);
 		unuse_pde(pde);
_

Patches currently in -mm which might be from d.hatayama@jp.fujitsu.com are

origin.patch
procfs-clean-up-proc_reg_get_unmapped_area-for-80-column-limit.patch

