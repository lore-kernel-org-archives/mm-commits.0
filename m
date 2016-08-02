From: akpm@linux-foundation.org
Subject: [patch 087/111] kexec: add restriction on kexec_load() segment
 sizes
Date: Tue, 02 Aug 2016 14:06:22 -0700
Message-ID: <57a10b4e.NkqJqC+WGyK9Xu0H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60727 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbcHBVXz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:23:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, zhongjiang@huawei.com, dyoung@redhat.com, ebiederm@xmission.com, vgoyal@redhat.com

From: zhong jiang <zhongjiang@huawei.com>
Subject: kexec: add restriction on kexec_load() segment sizes

I hit the following issue when run trinity in my system.  The kernel is
3.4 version, but mainline has the same issue.

The root cause is that the segment size is too large so the kerenl spends
too long trying to allocate a page.  Other cases will block until the test
case quits.  Also, OOM conditions will occur.

Call Trace:
 [<ffffffff81106eac>] __alloc_pages_nodemask+0x14c/0x8f0
 [<ffffffff8124c2be>] ? trace_hardirqs_on_thunk+0x3a/0x3c
 [<ffffffff8124c2be>] ? trace_hardirqs_on_thunk+0x3a/0x3c
 [<ffffffff8124c2be>] ? trace_hardirqs_on_thunk+0x3a/0x3c
 [<ffffffff8124c2be>] ? trace_hardirqs_on_thunk+0x3a/0x3c
 [<ffffffff8124c2be>] ? trace_hardirqs_on_thunk+0x3a/0x3c
 [<ffffffff8113e5ef>] alloc_pages_current+0xaf/0x120
 [<ffffffff810a0da0>] kimage_alloc_pages+0x10/0x60
 [<ffffffff810a15ad>] kimage_alloc_control_pages+0x5d/0x270
 [<ffffffff81027e85>] machine_kexec_prepare+0xe5/0x6c0
 [<ffffffff810a0d52>] ? kimage_free_page_list+0x52/0x70
 [<ffffffff810a1921>] sys_kexec_load+0x141/0x600
 [<ffffffff8115e6b0>] ? vfs_write+0x100/0x180
 [<ffffffff8145fbd9>] system_call_fastpath+0x16/0x1b

The patch changes sanity_check_segment_list() to verify that the usage by
all segments does not exceed half of memory.

[akpm@linux-foundation.org: fix for kexec-return-error-number-directly.patch, update comment]
Link: http://lkml.kernel.org/r/1469625474-53904-1-git-send-email-zhongjiang@huawei.com
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Suggested-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff -puN kernel/kexec_core.c~kexec-add-restriction-on-kexec_load-segment-sizes kernel/kexec_core.c
--- a/kernel/kexec_core.c~kexec-add-restriction-on-kexec_load-segment-sizes
+++ a/kernel/kexec_core.c
@@ -146,6 +146,7 @@ EXPORT_SYMBOL_GPL(kexec_crash_loaded);
  * allocating pages whose destination address we do not care about.
  */
 #define KIMAGE_NO_DEST (-1UL)
+#define PAGE_COUNT(x) (((x) + PAGE_SIZE - 1) >> PAGE_SHIFT)
 
 static struct page *kimage_alloc_page(struct kimage *image,
 				       gfp_t gfp_mask,
@@ -155,6 +156,7 @@ int sanity_check_segment_list(struct kim
 {
 	int i;
 	unsigned long nr_segments = image->nr_segments;
+	unsigned long total_pages = 0;
 
 	/*
 	 * Verify we have good destination addresses.  The caller is
@@ -215,6 +217,21 @@ int sanity_check_segment_list(struct kim
 	}
 
 	/*
+	 * Verify that no more than half of memory will be consumed. If the
+	 * request from userspace is too large, a large amount of time will be
+	 * wasted allocating pages, which can cause a soft lockup.
+	 */
+	for (i = 0; i < nr_segments; i++) {
+		if (PAGE_COUNT(image->segment[i].memsz) > totalram_pages / 2)
+			return -EINVAL;
+
+		total_pages += PAGE_COUNT(image->segment[i].memsz);
+	}
+
+	if (total_pages > totalram_pages / 2)
+		return -EINVAL;
+
+	/*
 	 * Verify we have good destination addresses.  Normally
 	 * the caller is responsible for making certain we don't
 	 * attempt to load the new image into invalid or reserved
_
