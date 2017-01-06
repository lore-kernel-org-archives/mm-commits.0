From: akpm@linux-foundation.org
Subject: + rapidio-use-get_user_pages_unlocked.patch added to -mm tree
Date: Thu, 05 Jan 2017 16:20:32 -0800
Message-ID: <586ee2d0.sSNKc3Vu6d1Usp9N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58696 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S969490AbdAFATO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2017 19:19:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lstoakes@gmail.com, alexandre.bounine@idt.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: use get_user_pages_unlocked()
has been added to the -mm tree.  Its filename is
     rapidio-use-get_user_pages_unlocked.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-use-get_user_pages_unlocked.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-use-get_user_pages_unlocked.patch

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
Subject: rapidio: use get_user_pages_unlocked()

Moving from get_user_pages() to get_user_pages_unlocked() simplifies the code
and takes advantage of VM_FAULT_RETRY functionality when faulting in pages.

Link: http://lkml.kernel.org/r/20170103205024.6704-1-lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>
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

Patches currently in -mm which might be from lstoakes@gmail.com are

rapidio-use-get_user_pages_unlocked.patch

