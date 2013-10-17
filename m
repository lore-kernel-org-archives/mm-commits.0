From: akpm@linux-foundation.org
Subject: [merged]
 procfs-fix-unintended-truncation-of-returned-mapped-address.patch removed
 from -mm tree
Date: Thu, 17 Oct 2013 11:13:25 -0700
Message-ID: <526028c5.vZnMhoV9QYuwaHHZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44378 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759481Ab3JQSN0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Oct 2013 14:13:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, holzheu@linux.vnet.ibm.com, davem@davemloft.net, adobriyan@gmail.com, d.hatayama@jp.fujitsu.com

Subject: [merged] procfs-fix-unintended-truncation-of-returned-mapped-address.patch removed from -mm tree
To: d.hatayama@jp.fujitsu.com,adobriyan@gmail.com,davem@davemloft.net,holzheu@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 17 Oct 2013 11:13:25 -0700


The patch titled
     Subject: procfs: fix unintended truncation of returned mapped address
has been removed from the -mm tree.  Its filename was
     procfs-fix-unintended-truncation-of-returned-mapped-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: procfs: fix unintended truncation of returned mapped address

Currently, proc_reg_get_unmapped_area truncates upper 32-bit of the mapped
virtual address returned from get_unmapped_area method in pde->proc_fops
due to the variable rv of signed integer on x86_64.  This is too small to
have vitual address of unsigned long on x86_64 since on x86_64, signed
integer is of 4 bytes while unsigned long is of 8 bytes.  To fix this
issue, use unsigned long instead.

Fixes a regression added in c4fe24485729 ("sparc: fix PCI device proc file
mmap(2)").

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Tested-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/inode.c~procfs-fix-unintended-truncation-of-returned-mapped-address fs/proc/inode.c
--- a/fs/proc/inode.c~procfs-fix-unintended-truncation-of-returned-mapped-address
+++ a/fs/proc/inode.c
@@ -288,7 +288,7 @@ static int proc_reg_mmap(struct file *fi
 static unsigned long proc_reg_get_unmapped_area(struct file *file, unsigned long orig_addr, unsigned long len, unsigned long pgoff, unsigned long flags)
 {
 	struct proc_dir_entry *pde = PDE(file_inode(file));
-	int rv = -EIO;
+	unsigned long rv = -EIO;
 	unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
 	if (use_pde(pde)) {
 		get_unmapped_area = pde->proc_fops->get_unmapped_area;
_

Patches currently in -mm which might be from d.hatayama@jp.fujitsu.com are

origin.patch
procfs-clean-up-proc_reg_get_unmapped_area-for-80-column-limit.patch

