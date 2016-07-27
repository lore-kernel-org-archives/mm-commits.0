From: akpm@linux-foundation.org
Subject: + kexec-add-restriction-on-kexec_load-segment-sizes.patch added
 to -mm tree
Date: Wed, 27 Jul 2016 14:49:22 -0700
Message-ID: <57992c62.T4RIADxwEb58WFyJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45247 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757365AbcG0VtX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 17:49:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhongjiang@huawei.com, dyoung@redhat.com, ebiederm@xmission.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: add restriction on kexec_load() segment sizes
has been added to the -mm tree.  Its filename is
     kexec-add-restriction-on-kexec_load-segment-sizes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-add-restriction-on-kexec_load-segment-sizes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-add-restriction-on-kexec_load-segment-sizes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Link: http://lkml.kernel.org/r/1469625474-53904-1-git-send-email-zhongjiang@huawei.com
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Suggested-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

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
@@ -215,6 +217,22 @@ int sanity_check_segment_list(struct kim
 	}
 
 	/*
+	 * Verify that no segment is larger than half of memory.
+	 * If a segment from userspace is too large, a large amount
+	 * of time will be wasted allocating pages, which can cause
+	 * * a soft lockup.
+	 */
+	for (i = 0; i < nr_segments; i++) {
+		if (PAGE_COUNT(image->segment[i].memsz) > totalram_pages / 2)
+			return result;
+
+		total_pages += PAGE_COUNT(image->segment[i].memsz);
+	}
+
+	if (total_pages > totalram_pages / 2)
+		return result;
+
+	/*
 	 * Verify we have good destination addresses.  Normally
 	 * the caller is responsible for making certain we don't
 	 * attempt to load the new image into invalid or reserved
_

Patches currently in -mm which might be from zhongjiang@huawei.com are

mm-hugetlb-fix-race-when-migrate-pages.patch
mm-update-the-comment-in-__isolate_free_page.patch
mm-page_owner-align-with-pageblock_nr-pages.patch
mm-walk-the-zone-in-pageblock_nr_pages-steps.patch
kexec-add-restriction-on-kexec_load-segment-sizes.patch
kexec-add-resriction-on-the-kexec_load.patch
kexec-add-resriction-on-the-kexec_load-update.patch

