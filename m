Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3CE2C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 19 Oct 2022 23:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbiJSXYL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Oct 2022 19:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbiJSXYD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2022 19:24:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFA315994A
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 16:24:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74C2EB82565
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 23:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30349C433D7;
        Wed, 19 Oct 2022 23:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666221838;
        bh=zI9BAxG1GDIIo37iY0sUi3gNRbL5uyca/eNpv+Io+s8=;
        h=Date:To:From:Subject:From;
        b=bL0W4/68Z4xz23LEOg1+gKUS18e6St8CZd8XlV5w8Gty5F5pkRuPDHzXlIbITqfIl
         W+O8+uzCi5qfmvCEdon5LbyAe0H26xh7Hc9EG/jANzhuB43DSuwOw+nbweTKxmE8xU
         b/TT4yyYylk5hugt9rnH8Vc3Im3h9Cwmrz6S3Rag=
Date:   Wed, 19 Oct 2022 16:23:57 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup_test-start-stop-read-functionality-for-pin-longterm-test-fix.patch added to mm-unstable branch
Message-Id: <20221019232358.30349C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-gup_test-start-stop-read-functionality-for-pin-longterm-test-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup_test-start-stop-read-functionality-for-pin-longterm-test-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup_test-start-stop-read-functionality-for-pin-longterm-test-fix.patch

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
Subject: mm-gup_test-start-stop-read-functionality-for-pin-longterm-test-fix
Date: Wed, 19 Oct 2022 14:31:15 +0200

silence a warning on 32-bit

https://lore.kernel.org/all/202210182101.XOyPZEQV-lkp@intel.com/T/#u


Link: https://lkml.kernel.org/r/74adbb51-6e33-f636-8a9c-2ad87bd9007e@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup_test.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/gup_test.c~mm-gup_test-start-stop-read-functionality-for-pin-longterm-test-fix
+++ a/mm/gup_test.c
@@ -299,7 +299,8 @@ static inline int pin_longterm_test_read
 	for (i = 0; i < pin_longterm_test_nr_pages; i++) {
 		void *addr = page_to_virt(pin_longterm_test_pages[i]);
 
-		if (copy_to_user((void __user *)user_addr, addr, PAGE_SIZE))
+		if (copy_to_user((void __user *)(unsigned long)user_addr, addr,
+				 PAGE_SIZE))
 			return -EFAULT;
 		user_addr += PAGE_SIZE;
 	}
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
mm-gup_test-start-stop-read-functionality-for-pin-longterm-test-fix.patch
selftests-vm-anon_cow-add-r-o-longterm-tests-via-gup_test.patch

