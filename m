Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B01DC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 24 Feb 2022 03:06:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiBXDGz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Feb 2022 22:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiBXDGz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Feb 2022 22:06:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC7A2465E1
        for <mm-commits@vger.kernel.org>; Wed, 23 Feb 2022 19:06:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23D5FB8219E
        for <mm-commits@vger.kernel.org>; Thu, 24 Feb 2022 03:06:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF562C340E7;
        Thu, 24 Feb 2022 03:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645671983;
        bh=lOira0y/KLe1taPvqwgZzJPBY6Y6VRhc4iLJhZh/Zjg=;
        h=Date:To:From:Subject:From;
        b=na3S3tJ+Kq/2erpfC6qXVcC5SzekdHDmWC+f8x4hi6mkbK0VpjHO2m5kzDTXmRpVJ
         Qulziqt14o8Ea2+fXrFYjpt47UW7X8Seupfaqz2VUBGSHNFsVoDw+yBsP110YYd+PB
         JLz+vME8yNRYmwkytQGCXXtFrJLq3jvBdgJIphPI=
Date:   Wed, 23 Feb 2022 19:06:23 -0800
To:     mm-commits@vger.kernel.org, lkp@intel.com, elver@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-improve-vmalloc-tests-fix-3-fix.patch added to -mm tree
Message-Id: <20220224030623.AF562C340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-improve-vmalloc-tests-fix-3-fix
has been added to the -mm tree.  Its filename is
     kasan-improve-vmalloc-tests-fix-3-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-improve-vmalloc-tests-fix-3-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-improve-vmalloc-tests-fix-3-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kasan-improve-vmalloc-tests-fix-3-fix

fix build

lib/test_kasan.c: In function 'vmalloc_helpers_tags':
lib/test_kasan.c:1073:13: error: unused variable 'rv' [-Werror=unused-variable]
 1073 |         int rv;
      |             ^~
cc1: all warnings being treated as errors

Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/lib/test_kasan.c~kasan-improve-vmalloc-tests-fix-3-fix
+++ a/lib/test_kasan.c
@@ -1061,7 +1061,6 @@ static void kmalloc_double_kzfree(struct
 static void vmalloc_helpers_tags(struct kunit *test)
 {
 	void *ptr;
-	int rv;
 
 	/* This test is intended for tag-based modes. */
 	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_KASAN_GENERIC);
@@ -1080,11 +1079,15 @@ static void vmalloc_helpers_tags(struct
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, vmalloc_to_page(ptr));
 
 #if !IS_MODULE(CONFIG_KASAN_KUNIT_TEST)
-	/* Make sure vmalloc'ed memory permissions can be changed. */
-	rv = set_memory_ro((unsigned long)ptr, 1);
-	KUNIT_ASSERT_GE(test, rv, 0);
-	rv = set_memory_rw((unsigned long)ptr, 1);
-	KUNIT_ASSERT_GE(test, rv, 0);
+	{
+		int rv;
+
+		/* Make sure vmalloc'ed memory permissions can be changed. */
+		rv = set_memory_ro((unsigned long)ptr, 1);
+		KUNIT_ASSERT_GE(test, rv, 0);
+		rv = set_memory_rw((unsigned long)ptr, 1);
+		KUNIT_ASSERT_GE(test, rv, 0);
+	}
 #endif
 
 	vfree(ptr);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
x86-mm-enable-arch_has_vm_get_page_prot-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-next-rejects.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

