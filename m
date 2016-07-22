From: akpm@linux-foundation.org
Subject: + kexec-add-resriction-on-the-kexec_load.patch added to -mm tree
Date: Fri, 22 Jul 2016 12:59:03 -0700
Message-ID: <57927b07.c9ygs79W4UWRS0rt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54650 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbcGVT7E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Jul 2016 15:59:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhongjiang@huawei.com, dyoung@redhat.com, ebiederm@xmission.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: add restriction on kexec_load() segment sizes
has been added to the -mm tree.  Its filename is
     kexec-add-resriction-on-the-kexec_load.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-add-resriction-on-the-kexec_load.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-add-resriction-on-the-kexec_load.patch

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

The patch chnages sanity_check_segment_list() to verify that no segment is
larger than half of memory.

Link: http://lkml.kernel.org/r/1469165782-13193-1-git-send-email-zhongjiang@huawei.com
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN kernel/kexec_core.c~kexec-add-resriction-on-the-kexec_load kernel/kexec_core.c
--- a/kernel/kexec_core.c~kexec-add-resriction-on-the-kexec_load
+++ a/kernel/kexec_core.c
@@ -154,6 +154,7 @@ static struct page *kimage_alloc_page(st
 int sanity_check_segment_list(struct kimage *image)
 {
 	int i;
+	unsigned long total_segments = 0;
 	unsigned long nr_segments = image->nr_segments;
 
 	/*
@@ -214,6 +215,21 @@ int sanity_check_segment_list(struct kim
 			return -EINVAL;
 	}
 
+	/* Verity all segment size donnot exceed the specified size.
+	 * if segment size from user space is too large,  a large
+	 * amount of time will be wasted when allocating page. so,
+	 * softlockup may be come up.
+	 */
+	for (i = 0; i < nr_segments; i++) {
+		if (image->segment[i].memsz > (totalram_pages / 2))
+			return -EINVAL;
+
+		total_segments += image->segment[i].memsz;
+	}
+
+	if (total_segments > (totalram_pages / 2))
+		return -EINVAL;
+
 	/*
 	 * Verify we have good destination addresses.  Normally
 	 * the caller is responsible for making certain we don't
_

Patches currently in -mm which might be from zhongjiang@huawei.com are

mm-hugetlb-fix-race-when-migrate-pages.patch
mm-update-the-comment-in-__isolate_free_page.patch
mm-page_owner-align-with-pageblock_nr-pages.patch
kexec-add-resriction-on-the-kexec_load.patch

