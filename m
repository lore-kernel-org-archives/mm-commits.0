Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E1E2C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:39:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbiKIBjj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:39:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiKIBip (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:38:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C576587B
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:38:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2346B81CD9
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:38:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60747C433D6;
        Wed,  9 Nov 2022 01:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957918;
        bh=aCcq0EMzrUPjMVnhYcBP1W76JWw+NWt65ybQDGdO/2s=;
        h=Date:To:From:Subject:From;
        b=WtJ/29AVpPAWkMWBaEnqEuRD0sMwmj52evuF7taTvDLrmgl+cnk7M2TTxVopiQsaC
         MHHAdnNBS2klhC0XnZF310lbrQUUy7Bhfa85vnP1E3XSwxtK2AhaqHJPBIS8OrROYT
         9OL14hJKCpZm+hpYWG68IFdMhrIkNyZcVM45G6Vo=
Date:   Tue, 08 Nov 2022 17:38:37 -0800
To:     mm-commits@vger.kernel.org, yang.lee@linux.alibaba.com,
        vbabka@suse.cz, shuah@kernel.org, rppt@kernel.org,
        peterx@redhat.com, namit@vmware.com, jhubbard@nvidia.com,
        jgg@nvidia.com, ddutile@redhat.com, crecklin@redhat.com,
        aarcange@redhat.com, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup_test-start-stop-read-functionality-for-pin-longterm-test.patch removed from -mm tree
Message-Id: <20221109013838.60747C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup_test: start/stop/read functionality for PIN LONGTERM test
has been removed from the -mm tree.  Its filename was
     mm-gup_test-start-stop-read-functionality-for-pin-longterm-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/gup_test: start/stop/read functionality for PIN LONGTERM test
Date: Tue, 27 Sep 2022 13:01:19 +0200

We want an easy way to take a R/O or R/W longterm pin on a range and be
able to observe the content of the pinned pages, so we can properly test
how longterm puns interact with our COW logic.

[david@redhat.com: silence a warning on 32-bit]
  Link: https://lkml.kernel.org/r/74adbb51-6e33-f636-8a9c-2ad87bd9007e@redhat.com
[yang.lee@linux.alibaba.com: ./mm/gup_test.c:281:2-3: Unneeded semicolon]
  Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2455
  Link: https://lkml.kernel.org/r/20221020024035.113619-1-yang.lee@linux.alibaba.com
Link: https://lkml.kernel.org/r/20220927110120.106906-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
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

 mm/gup_test.c |  141 ++++++++++++++++++++++++++++++++++++++++++++++++
 mm/gup_test.h |   12 ++++
 2 files changed, 153 insertions(+)

--- a/mm/gup_test.c~mm-gup_test-start-stop-read-functionality-for-pin-longterm-test
+++ a/mm/gup_test.c
@@ -203,6 +203,135 @@ free_pages:
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
+	}
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
+		if (copy_to_user((void __user *)(unsigned long)user_addr, addr,
+				 PAGE_SIZE))
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
@@ -217,6 +346,10 @@ static long gup_test_ioctl(struct file *
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
@@ -234,9 +367,17 @@ static long gup_test_ioctl(struct file *
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

selftests-vm-add-ksm-unmerge-tests.patch
mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch
selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch
mm-mprotect-minor-can_change_pte_writable-cleanups.patch
mm-huge_memory-try-avoiding-write-faults-when-changing-pmd-protection.patch
mm-mprotect-factor-out-check-whether-manual-pte-write-upgrades-are-required.patch
mm-autonuma-use-can_change_ptepmd_writable-to-replace-savedwrite.patch
mm-remove-unused-savedwrite-infrastructure.patch
selftests-vm-anon_cow-add-mprotect-optimization-tests.patch

