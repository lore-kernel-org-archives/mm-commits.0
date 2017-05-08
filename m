From: akpm@linux-foundation.org
Subject: [patch 011/114] drivers/virt/fsl_hypervisor.c: use
 get_user_pages_unlocked()
Date: Mon, 08 May 2017 15:55:02 -0700
Message-ID: <20170508225502.75fld7gK2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45784 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751828AbdEHWzD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:55:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, galak@kernel.crashing.org, gregkh@linuxfoundation.org, lstoakes@gmail.com, mhocko@kernel.org, mihai.caraman@freescale.com, mm-commits@vger.kernel.org, pbonzini@redhat.com, torvalds@linux-foundation.org

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
Cc: Greg KH <gregkh@linuxfoundation.org>
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
