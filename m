From: akpm@linux-foundation.org
Subject: [merged] fs-bufferc-change-type-of-max_buffer_heads-to-unsigned-long.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:55:19 -0800
Message-ID: <20130225205519.904BB31C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:41518 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755402Ab3BYUzU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:55:20 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so348060ggn.4
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:55:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/buffer.c: change type of max_buffer_heads to unsigned long
has been removed from the -mm tree.  Its filename was
     fs-bufferc-change-type-of-max_buffer_heads-to-unsigned-long.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: fs/buffer.c: change type of max_buffer_heads to unsigned long

max_buffer_heads is calculated from nr_free_buffer_pages(), so change its
type to unsigned long in case of overflow.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/buffer.c~fs-bufferc-change-type-of-max_buffer_heads-to-unsigned-long fs/buffer.c
--- a/fs/buffer.c~fs-bufferc-change-type-of-max_buffer_heads-to-unsigned-long
+++ a/fs/buffer.c
@@ -3227,7 +3227,7 @@ static struct kmem_cache *bh_cachep __re
  * Once the number of bh's in the machine exceeds this level, we start
  * stripping them in writeback.
  */
-static int max_buffer_heads;
+static unsigned long max_buffer_heads;
 
 int buffer_heads_over_limit;
 
@@ -3343,7 +3343,7 @@ EXPORT_SYMBOL(bh_submit_read);
 
 void __init buffer_init(void)
 {
-	int nrpages;
+	unsigned long nrpages;
 
 	bh_cachep = kmem_cache_create("buffer_head",
 			sizeof(struct buffer_head), 0,
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

