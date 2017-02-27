From: akpm@linux-foundation.org
Subject: [patch 18/78] rapidio: use get_user_pages_unlocked()
Date: Mon, 27 Feb 2017 14:27:34 -0800
Message-ID: <58b4a7d6.T1dmLP4EzI2A9Waa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45432 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751852AbdB0Wfy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:35:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, lstoakes@gmail.com, alexandre.bounine@idt.com, mporter@kernel.crashing.org

From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: rapidio: use get_user_pages_unlocked()

Moving from get_user_pages() to get_user_pages_unlocked() simplifies the code
and takes advantage of VM_FAULT_RETRY functionality when faulting in pages.

Link: http://lkml.kernel.org/r/20170103205024.6704-1-lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/rapidio/devices/rio_mport_cdev.c~rapidio-use-get_user_pages_unlocked drivers/rapidio/devices/rio_mport_cdev.c
--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-use-get_user_pages_unlocked
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -889,17 +889,16 @@ rio_dma_transfer(struct file *filp, u32
 			goto err_req;
 		}
 
-		down_read(&current->mm->mmap_sem);
-		pinned = get_user_pages(
+		pinned = get_user_pages_unlocked(
 				(unsigned long)xfer->loc_addr & PAGE_MASK,
 				nr_pages,
-				dir == DMA_FROM_DEVICE ? FOLL_WRITE : 0,
-				page_list, NULL);
-		up_read(&current->mm->mmap_sem);
+				page_list,
+				dir == DMA_FROM_DEVICE ? FOLL_WRITE : 0);
 
 		if (pinned != nr_pages) {
 			if (pinned < 0) {
-				rmcd_error("get_user_pages err=%ld", pinned);
+				rmcd_error("get_user_pages_unlocked err=%ld",
+					   pinned);
 				nr_pages = 0;
 			} else
 				rmcd_error("pinned %ld out of %ld pages",
_
