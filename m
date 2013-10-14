From: akpm@linux-foundation.org
Subject: +
 procfs-fix-unintended-truncation-of-returned-mapped-address.patch added to
 -mm tree
Date: Mon, 14 Oct 2013 14:51:46 -0700
Message-ID: <525c6772.sf9enB1OMLsWRDvq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43615 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189Ab3JNVvr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Oct 2013 17:51:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, davem@davemloft.net, adobriyan@gmail.com, d.hatayama@jp.fujitsu.com

Subject: + procfs-fix-unintended-truncation-of-returned-mapped-address.patch added to -mm tree
To: d.hatayama@jp.fujitsu.com,adobriyan@gmail.com,davem@davemloft.net
From: akpm@linux-foundation.org
Date: Mon, 14 Oct 2013 14:51:46 -0700


The patch titled
     Subject: procfs: fix unintended truncation of returned mapped address
has been added to the -mm tree.  Its filename is
     procfs-fix-unintended-truncation-of-returned-mapped-address.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/procfs-fix-unintended-truncation-of-returned-mapped-address.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/procfs-fix-unintended-truncation-of-returned-mapped-address.patch

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

procfs-fix-unintended-truncation-of-returned-mapped-address.patch

