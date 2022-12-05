Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87327C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  5 Dec 2022 20:02:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbiLEUCN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Dec 2022 15:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232491AbiLEUCF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Dec 2022 15:02:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E999EEA3
        for <mm-commits@vger.kernel.org>; Mon,  5 Dec 2022 12:02:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7C5EB811E3
        for <mm-commits@vger.kernel.org>; Mon,  5 Dec 2022 20:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4CFC433D6;
        Mon,  5 Dec 2022 20:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670270521;
        bh=iT8SCN8tPBmfwsN2SAA1GFLf52aSQBgyv6c2EQMLJU0=;
        h=Date:To:From:Subject:From;
        b=gTwh/DD33DAJ+hC2Srq64p9gL9Bn6vRoYkvtimxhp+uG7HAW+IWehJecdLloSF5Jq
         OInf8nxZ8xp6mpYmb/LbCKrPglWA/KwSKEKi2p1ng6vF9XZ0lVahqhsKM7mnEHk4VJ
         eMTmDJiydI/fGwBZNKhTDSOH4xQESSvFgMc7lv7M=
Date:   Mon, 05 Dec 2022 12:02:00 -0800
To:     mm-commits@vger.kernel.org, yang.lee@linux.alibaba.com,
        shuah@kernel.org, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup_test-fix-pin_longterm_test_read-with-highmem.patch added to mm-unstable branch
Message-Id: <20221205200201.5D4CFC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup_test: fix PIN_LONGTERM_TEST_READ with highmem
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup_test-fix-pin_longterm_test_read-with-highmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup_test-fix-pin_longterm_test_read-with-highmem.patch

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
Subject: mm/gup_test: fix PIN_LONGTERM_TEST_READ with highmem
Date: Mon, 5 Dec 2022 20:37:13 +0100

Patch series "selftests/vm: fix some tests on 32bit".

I finally had the time to run some of the selftests written by me
(especially "cow") on x86 PAE.  I found some unexpected "surprises" :)

With these changes, and with [1] on top of mm-unstable, the "cow" tests
and the "ksm_functional_tests" compile and pass as expected (expected
failures with hugetlb in the "cow" tests).  "madv_populate" has one
expected test failure -- x86 does not support softdirty tracking.

#1-#3 fix commits with stable commit ids.  #4 fixes a test that is not in
mm-stable yet.

A note that there are many other compile errors/warnings when compiling on
32bit and with older Linux headers ...  something for another day.

[1] https://lkml.kernel.org/r/20221205150857.167583-1-david@redhat.com


This patch (of 4):

...  we have to kmap()/kunmap(), otherwise this won't work as expected
with highmem.

Link: https://lkml.kernel.org/r/20221205193716.276024-1-david@redhat.com
Link: https://lkml.kernel.org/r/20221205193716.276024-2-david@redhat.com
Fixes: c77369b437f9 ("mm/gup_test: start/stop/read functionality for PIN LONGTERM test")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>,
Cc: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup_test.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/gup_test.c~mm-gup_test-fix-pin_longterm_test_read-with-highmem
+++ a/mm/gup_test.c
@@ -4,6 +4,7 @@
 #include <linux/uaccess.h>
 #include <linux/ktime.h>
 #include <linux/debugfs.h>
+#include <linux/highmem.h>
 #include "gup_test.h"
 
 static void put_back_pages(unsigned int cmd, struct page **pages,
@@ -297,10 +298,13 @@ static inline int pin_longterm_test_read
 		return -EFAULT;
 
 	for (i = 0; i < pin_longterm_test_nr_pages; i++) {
-		void *addr = page_to_virt(pin_longterm_test_pages[i]);
+		void *addr = kmap_local_page(pin_longterm_test_pages[i]);
+		unsigned long ret;
 
-		if (copy_to_user((void __user *)(unsigned long)user_addr, addr,
-				 PAGE_SIZE))
+		ret = copy_to_user((void __user *)(unsigned long)user_addr, addr,
+				   PAGE_SIZE);
+		kunmap_local(addr);
+		if (ret)
 			return -EFAULT;
 		user_addr += PAGE_SIZE;
 	}
_

Patches currently in -mm which might be from david@redhat.com are

mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit.patch
selftests-vm-add-ksm-unmerge-tests.patch
mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch
selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch
mm-gup_test-fix-pin_longterm_test_read-with-highmem.patch
selftests-vm-madv_populate-fix-missing-madv_populate_readwrite-definitions.patch
selftests-vm-cow-fix-compile-warning-on-32bit.patch
selftests-vm-ksm_functional_tests-fixes-for-32bit.patch

