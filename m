From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dma-buf-free-dmabuf-name-in-dma_buf_release.patch added
 to -mm tree
Date: Tue, 25 Feb 2020 17:55:04 -0800
Message-ID: <20200226015504.7GW9ptoIA%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729395AbgBZBzF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 Feb 2020 20:55:05 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengc@google.com, ghackmann@google.com, mm-commits@vger.kernel.org, sumit.semwal@linaro.org, xiyou.wangcong@gmail.com


The patch titled
     Subject: dma-buf: free dmabuf->name in dma_buf_release()
has been added to the -mm tree.  Its filename is
     dma-buf-free-dmabuf-name-in-dma_buf_release.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-buf-free-dmabuf-name-in-dma_buf_release.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-buf-free-dmabuf-name-in-dma_buf_release.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

dma-buf-free-dmabuf-name-in-dma_buf_release.patch
