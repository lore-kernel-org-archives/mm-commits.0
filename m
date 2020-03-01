From: akpm@linux-foundation.org
Subject: [merged]
 dma-buf-free-dmabuf-name-in-dma_buf_release.patch removed from -mm tree
Date: Sat, 29 Feb 2020 17:52:01 -0800
Message-ID: <20200301015201.JcACTR4Xk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726786AbgCABwC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 29 Feb 2020 20:52:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengc@google.com, ghackmann@google.com, mm-commits@vger.kernel.org, stable@vger.kernel.org, sumit.semwal@linaro.org, xiyou.wangcong@gmail.com


The patch titled
     Subject: dma-buf: free dmabuf->name in dma_buf_release()
has been removed from the -mm tree.  Its filename was
     dma-buf-free-dmabuf-name-in-dma_buf_release.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: dma-buf: free dmabuf->name in dma_buf_release()

dma-buff name can be set via DMA_BUF_SET_NAME ioctl, but once set
it never gets freed.

Free it in dma_buf_release().

Link: http://lkml.kernel.org/r/20200225204446.11378-1-xiyou.wangcong@gmail.com
Fixes: bb2bb9030425 ("dma-buf: add DMA_BUF_SET_NAME ioctls")
Reported-by: syzbot+b2098bc44728a4efb3e9@syzkaller.appspotmail.com
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Chenbo Feng <fengc@google.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Greg Hackmann <ghackmann@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma-buf/dma-buf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/dma-buf/dma-buf.c~dma-buf-free-dmabuf-name-in-dma_buf_release
+++ a/drivers/dma-buf/dma-buf.c
@@ -108,6 +108,7 @@ static int dma_buf_release(struct inode
 		dma_resv_fini(dmabuf->resv);
 
 	module_put(dmabuf->owner);
+	kfree(dmabuf->name);
 	kfree(dmabuf);
 	return 0;
 }
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are
