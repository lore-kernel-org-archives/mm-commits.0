Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A27B0C4321E
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 01:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbiJRBIv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 21:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbiJRBIh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 21:08:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2071A86809
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 18:08:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF8896132D
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 01:08:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F95C433C1;
        Tue, 18 Oct 2022 01:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666055315;
        bh=/5Tt2PQ3Psg2dmAkolvpxbcR9n73mFocEVr+AeMHvXY=;
        h=Date:To:From:Subject:From;
        b=JE/yvuZzrOPR2doApXQam02dNQmSaW+Ms8VV01PnQBneT5zsp5eZ029lefvEzGtMR
         0LRUyVhuni1rjBmUDJnxCYAu/k3u01gzUhCkwTjBiyPrzEKfaYYW5bqSndttvC9GIL
         01jDn8GYSCOy9L7l8kDbvqd3P/mO/6QdVHNFj7sU=
Date:   Mon, 17 Oct 2022 18:08:34 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, shuah@kernel.org,
        rppt@kernel.org, peterx@redhat.com, namit@vmware.com,
        jhubbard@nvidia.com, jgg@nvidia.com, ddutile@redhat.com,
        crecklin@redhat.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup_test-start-stop-read-functionality-for-pin-longterm-test.patch added to mm-unstable branch
Message-Id: <20221018010835.04F95C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup_test: start/stop/read functionality for PIN LONGTERM test
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup_test-start-stop-read-functionality-for-pin-longterm-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup_test-start-stop-read-functionality-for-pin-longterm-test.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/gup_test: start/stop/read functionality for PIN LONGTERM test
Date: Tue, 27 Sep 2022 13:01:19 +0200

We want an easy way to take a R/O or R/W longterm pin on a range and be
able to observe the content of the pinned pages, so we can properly test
how longterm puns interact with our COW logic.

Link: https://lkml.kernel.org/r/20220927110120.106906-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph von Recklinghausen <crecklin@redhat.com>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nadav Amit <namit@vmware.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup_test.c |  140 ++++++++++++++++++++++++++++++++++++++++++++++++
 mm/gup_test.h |   12 ++++
 2 files changed, 152 insertions(+)

--- a/mm/gup_test.c~mm-gup_test-start-stop-read-functionality-for-pin-longterm-test
+++ a/mm/gup_test.c
@@ -203,6 +203,134 @@ free_pages:
 	return ret;
 }
 
+static DEFINE_MUTEX(pin_longterm_test_mutex);
+static struct page **pin_longterm_test_pages;
+static unsigned long pin_longterm_test_nr_pages;
+
+static inline void pin_longterm_test_stop(void)
+{
+	if (pin_longterm_test_pages) {
+		if (pin_longterm_test_nr_pages)
+			unpin_user_pages(pin_longterm_test_pages,
+					 pin_longterm_test_nr_pages);
+		kfree(pin_longterm_test_pages);
+		pin_longterm_test_pages = NULL;
+		pin_longterm_test_nr_pages = 0;
+	}
+}
+
+static inline int pin_longterm_test_start(unsigned long arg)
+{
+	long nr_pages, cur_pages, addr, remaining_pages;
+	int gup_flags = FOLL_LONGTERM;
+	struct pin_longterm_test args;
+	struct page **pages;
+	int ret = 0;
+	bool fast;
+
+	if (pin_longterm_test_pages)
+		return -EINVAL;
+
+	if (copy_from_user(&args, (void __user *)arg, sizeof(args)))
+		return -EFAULT;
+
+	if (args.flags &
+	    ~(PIN_LONGTERM_TEST_FLAG_USE_WRITE|PIN_LONGTERM_TEST_FLAG_USE_FAST))
+		return -EINVAL;
+	if (!IS_ALIGNED(args.addr | args.size, PAGE_SIZE))
+		return -EINVAL;
+	if (args.size > LONG_MAX)
+		return -EINVAL;
+	nr_pages = args.size / PAGE_SIZE;
+	if (!nr_pages)
+		return -EINVAL;
+
+	pages = kvcalloc(nr_pages, sizeof(void *), GFP_KERNEL);
+	if (!pages)
+		return -ENOMEM;
+
+	if (args.flags & PIN_LONGTERM_TEST_FLAG_USE_WRITE)
+		gup_flags |= FOLL_WRITE;
+	fast = !!(args.flags & PIN_LONGTERM_TEST_FLAG_USE_FAST);
+
+	if (!fast && mmap_read_lock_killable(current->mm)) {
+		kfree(pages);
+		return -EINTR;
+	}
+
+	pin_longterm_test_pages = pages;
+	pin_longterm_test_nr_pages = 0;
+
+	while (nr_pages - pin_longterm_test_nr_pages) {
+		remaining_pages = nr_pages - pin_longterm_test_nr_pages;
+		addr = args.addr + pin_longterm_test_nr_pages * PAGE_SIZE;
+
+		if (fast)
+			cur_pages = pin_user_pages_fast(addr, remaining_pages,
+							gup_flags, pages);
+		else
+			cur_pages = pin_user_pages(addr, remaining_pages,
+						   gup_flags, pages, NULL);
+		if (cur_pages < 0) {
+			pin_longterm_test_stop();
+			ret = cur_pages;
+			break;
+		}
+		pin_longterm_test_nr_pages += cur_pages;
+		pages += cur_pages;
+	};
+
+	if (!fast)
+		mmap_read_unlock(current->mm);
+	return ret;
+}
+
+static inline int pin_longterm_test_read(unsigned long arg)
+{
+	__u64 user_addr;
+	unsigned long i;
+
+	if (!pin_longterm_test_pages)
+		return -EINVAL;
+
+	if (copy_from_user(&user_addr, (void __user *)arg, sizeof(user_addr)))
+		return -EFAULT;
+
+	for (i = 0; i < pin_longterm_test_nr_pages; i++) {
+		void *addr = page_to_virt(pin_longterm_test_pages[i]);
+
+		if (copy_to_user((void __user *)user_addr, addr, PAGE_SIZE))
+			return -EFAULT;
+		user_addr += PAGE_SIZE;
+	}
+	return 0;
+}
+
+static long pin_longterm_test_ioctl(struct file *filep, unsigned int cmd,
+				    unsigned long arg)
+{
+	int ret = -EINVAL;
+
+	if (mutex_lock_killable(&pin_longterm_test_mutex))
+		return -EINTR;
+
+	switch (cmd) {
+	case PIN_LONGTERM_TEST_START:
+		ret = pin_longterm_test_start(arg);
+		break;
+	case PIN_LONGTERM_TEST_STOP:
+		pin_longterm_test_stop();
+		ret = 0;
+		break;
+	case PIN_LONGTERM_TEST_READ:
+		ret = pin_longterm_test_read(arg);
+		break;
+	}
+
+	mutex_unlock(&pin_longterm_test_mutex);
+	return ret;
+}
+
 static long gup_test_ioctl(struct file *filep, unsigned int cmd,
 		unsigned long arg)
 {
@@ -217,6 +345,10 @@ static long gup_test_ioctl(struct file *
 	case PIN_BASIC_TEST:
 	case DUMP_USER_PAGES_TEST:
 		break;
+	case PIN_LONGTERM_TEST_START:
+	case PIN_LONGTERM_TEST_STOP:
+	case PIN_LONGTERM_TEST_READ:
+		return pin_longterm_test_ioctl(filep, cmd, arg);
 	default:
 		return -EINVAL;
 	}
@@ -234,9 +366,17 @@ static long gup_test_ioctl(struct file *
 	return 0;
 }
 
+static int gup_test_release(struct inode *inode, struct file *file)
+{
+	pin_longterm_test_stop();
+
+	return 0;
+}
+
 static const struct file_operations gup_test_fops = {
 	.open = nonseekable_open,
 	.unlocked_ioctl = gup_test_ioctl,
+	.release = gup_test_release,
 };
 
 static int __init gup_test_init(void)
--- a/mm/gup_test.h~mm-gup_test-start-stop-read-functionality-for-pin-longterm-test
+++ a/mm/gup_test.h
@@ -10,6 +10,9 @@
 #define GUP_BASIC_TEST		_IOWR('g', 4, struct gup_test)
 #define PIN_BASIC_TEST		_IOWR('g', 5, struct gup_test)
 #define DUMP_USER_PAGES_TEST	_IOWR('g', 6, struct gup_test)
+#define PIN_LONGTERM_TEST_START	_IOW('g', 7, struct pin_longterm_test)
+#define PIN_LONGTERM_TEST_STOP	_IO('g', 8)
+#define PIN_LONGTERM_TEST_READ	_IOW('g', 9, __u64)
 
 #define GUP_TEST_MAX_PAGES_TO_DUMP		8
 
@@ -30,4 +33,13 @@ struct gup_test {
 	__u32 which_pages[GUP_TEST_MAX_PAGES_TO_DUMP];
 };
 
+#define PIN_LONGTERM_TEST_FLAG_USE_WRITE	1
+#define PIN_LONGTERM_TEST_FLAG_USE_FAST		2
+
+struct pin_longterm_test {
+	__u64 addr;
+	__u64 size;
+	__u32 flags;
+};
+
 #endif	/* __GUP_TEST_H */
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch
selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory.patch
selftests-vm-factor-out-pagemap_is_populated-into-vm_util.patch
selftests-vm-anon_cow-thp-tests.patch
selftests-vm-anon_cow-hugetlb-tests.patch
selftests-vm-anon_cow-add-liburing-test-cases.patch
mm-gup_test-start-stop-read-functionality-for-pin-longterm-test.patch
selftests-vm-anon_cow-add-r-o-longterm-tests-via-gup_test.patch

