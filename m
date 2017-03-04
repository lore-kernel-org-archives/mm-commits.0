From: akpm@linux-foundation.org
Subject: + drivers-virt-use-get_user_pages_unlocked.patch added to -mm
 tree
Date: Fri, 03 Mar 2017 16:19:11 -0800
Message-ID: <58ba07ff.BRvrL9KEJqRecRpa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42308 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751742AbdCDATM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 19:19:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lstoakes@gmail.com, galak@kernel.crashing.org, gregkh@linuxfoundation.org, mhocko@kernel.org, mihai.caraman@freescale.com, pbonzini@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/virt/fsl_hypervisor.c: use get_user_pages_unlocked()
has been added to the -mm tree.  Its filename is
     drivers-virt-use-get_user_pages_unlocked.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-virt-use-get_user_pages_unlocked.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-virt-use-get_user_pages_unlocked.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: drivers/virt/fsl_hypervisor.c: use get_user_pages_unlocked()

Moving from get_user_pages() to get_user_pages_unlocked() simplifies the code
and takes advantage of VM_FAULT_RETRY functionality when faulting in pages.

Link: http://lkml.kernel.org/r/20161101194332.23961-1-lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Mihai Caraman <mihai.caraman@freescale.com>
Cc: Greg KH <gregkh@linuxfoundation.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virt/fsl_hypervisor.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/virt/fsl_hypervisor.c~drivers-virt-use-get_user_pages_unlocked drivers/virt/fsl_hypervisor.c
--- a/drivers/virt/fsl_hypervisor.c~drivers-virt-use-get_user_pages_unlocked
+++ a/drivers/virt/fsl_hypervisor.c
@@ -243,11 +243,8 @@ static long ioctl_memcpy(struct fsl_hv_i
 	sg_list = PTR_ALIGN(sg_list_unaligned, sizeof(struct fh_sg_list));
 
 	/* Get the physical addresses of the source buffer */
-	down_read(&current->mm->mmap_sem);
-	num_pinned = get_user_pages(param.local_vaddr - lb_offset,
-		num_pages, (param.source == -1) ? 0 : FOLL_WRITE,
-		pages, NULL);
-	up_read(&current->mm->mmap_sem);
+	num_pinned = get_user_pages_unlocked(param.local_vaddr - lb_offset,
+		num_pages, pages, (param.source == -1) ? 0 : FOLL_WRITE);
 
 	if (num_pinned != num_pages) {
 		/* get_user_pages() failed */
_

Patches currently in -mm which might be from lstoakes@gmail.com are

drivers-virt-use-get_user_pages_unlocked.patch

