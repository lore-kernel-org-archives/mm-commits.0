From: akpm@linux-foundation.org
Subject: [merged] net-change-type-of-virtio_chan-p9_max_pages.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:55:28 -0800
Message-ID: <20130225205528.AC2A931C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:45932 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759572Ab3BYUz3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:55:29 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so159430yen.3
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:55:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhangyanfei@cn.fujitsu.com, davem@davemloft.net, ericvh@gmail.com, lucho@ionkov.net, rminnich@sandia.gov, mm-commits@vger.kernel.org


The patch titled
     Subject: net: change type of virtio_chan->p9_max_pages
has been removed from the -mm tree.  Its filename was
     net-change-type-of-virtio_chan-p9_max_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: net: change type of virtio_chan->p9_max_pages

This member of struct virtio_chan is calculated from nr_free_buffer_pages
so change its type to unsigned long in case of overflow.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: David Miller <davem@davemloft.net>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/9p/trans_virtio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/9p/trans_virtio.c~net-change-type-of-virtio_chan-p9_max_pages net/9p/trans_virtio.c
--- a/net/9p/trans_virtio.c~net-change-type-of-virtio_chan-p9_max_pages
+++ a/net/9p/trans_virtio.c
@@ -87,7 +87,7 @@ struct virtio_chan {
 	/* This is global limit. Since we don't have a global structure,
 	 * will be placing it in each channel.
 	 */
-	int p9_max_pages;
+	unsigned long p9_max_pages;
 	/* Scatterlist: can be too big for stack. */
 	struct scatterlist sg[VIRTQUEUE_NUM];
 
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

origin.patch
ipvs-change-type-of-netns_ipvs-sysctl_sync_qlen_max.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix.patch
kexec-get-rid-of-duplicate-check-for-hole_end.patch
kexec-prevent-double-free-on-image-allocation-failure.patch
kexec-fix-memory-leak-in-function-kimage_normal_alloc.patch
kexec-avoid-freeing-null-pointer-in-function-kimage_crash_alloc.patch

