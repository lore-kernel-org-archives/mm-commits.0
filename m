From: akpm@linux-foundation.org
Subject: +
 procfs-call-default-get_unmapped_area-on-mmu-present-architectures.patch
 added to -mm tree
Date: Mon, 14 Oct 2013 14:53:22 -0700
Message-ID: <525c67d2.evtR0d8pEp3TEM6Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43623 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757555Ab3JNVxX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Oct 2013 17:53:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, holzheu@linux.vnet.ibm.com, davem@davemloft.net, adobriyan@gmail.com, d.hatayama@jp.fujitsu.com

Subject: + procfs-call-default-get_unmapped_area-on-mmu-present-architectures.patch added to -mm tree
To: d.hatayama@jp.fujitsu.com,adobriyan@gmail.com,davem@davemloft.net,holzheu@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Mon, 14 Oct 2013 14:53:22 -0700


The patch titled
     From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
has been added to the -mm tree.  Its filename is
     procfs-call-default-get_unmapped_area-on-mmu-present-architectures.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/procfs-call-default-get_unmapped_area-on-mmu-present-architectures.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/procfs-call-default-get_unmapped_area-on-mmu-present-architectures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: procfs: Call default get_unmapped_area on MMU-present architectures

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

procfs-fix-unintended-truncation-of-returned-mapped-address.patch
procfs-call-default-get_unmapped_area-on-mmu-present-architectures.patch
procfs-clean-up-proc_reg_get_unmapped_area-for-80-column-limit.patch

