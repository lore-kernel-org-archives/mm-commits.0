Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A618C00140
	for <mm-commits@archiver.kernel.org>; Sun, 21 Aug 2022 23:38:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiHUXi3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 21 Aug 2022 19:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbiHUXi2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 21 Aug 2022 19:38:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727E0AE76
        for <mm-commits@vger.kernel.org>; Sun, 21 Aug 2022 16:38:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CC2060D57
        for <mm-commits@vger.kernel.org>; Sun, 21 Aug 2022 23:38:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 665D8C433D6;
        Sun, 21 Aug 2022 23:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661125105;
        bh=B13G5tukUzEc75k3XOwH6oW/vIG2sHnJ9N/2e/+EZUw=;
        h=Date:To:From:Subject:From;
        b=c/JNKAc5UkvUhv4B85Q9sGG5NVhWUSWH/61m2/jMG4JHaHprfblzuMxa1OQqSHI6j
         NN9xYDdSUK4yH98wEb0Jggt7aS2WZ6yKshgTf0d/xxQTFSpEbmZV69pK+rOJZBeTF7
         7GxdIaUk2b4TzJmIhdPx0G5Q/LyIo0chdWB1L/0s=
Date:   Sun, 21 Aug 2022 16:38:24 -0700
To:     mm-commits@vger.kernel.org, ira.weiny@intel.com, bhe@redhat.com,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-replace-kmap-with-kmap_local_page.patch added to mm-nonmm-unstable branch
Message-Id: <20220821233825.665D8C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: replace kmap() with kmap_local_page()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-replace-kmap-with-kmap_local_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-replace-kmap-with-kmap_local_page.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: kexec: replace kmap() with kmap_local_page()
Date: Sun, 21 Aug 2022 20:25:19 +0200

kmap() is being deprecated in favor of kmap_local_page().

There are two main problems with kmap(): (1) It comes with an overhead as
mapping space is restricted and protected by a global lock for
synchronization and (2) it also requires global TLB invalidation when the
kmap's pool wraps and it might block when the mapping space is fully
utilized until a slot becomes available.

With kmap_local_page() the mappings are per thread, CPU local, can take
page faults, and can be called from any context (including interrupts). 
It is faster than kmap() in kernels with HIGHMEM enabled.  Furthermore,
the tasks can be preempted and, when they are scheduled to run again, the
kernel virtual addresses are restored and are still valid.

Since its use in kexec_core.c is safe everywhere, it should be preferred.

Therefore, replace kmap() with kmap_local_page() in kexec_core.c.

Tested on a QEMU/KVM x86_32 VM, 6GB RAM, booting a kernel with
HIGHMEM64GB enabled.

Link: https://lkml.kernel.org/r/20220821182519.9483-1-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Suggested-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Acked-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/kexec_core.c~kexec-replace-kmap-with-kmap_local_page
+++ a/kernel/kexec_core.c
@@ -809,7 +809,7 @@ static int kimage_load_normal_segment(st
 		if (result < 0)
 			goto out;
 
-		ptr = kmap(page);
+		ptr = kmap_local_page(page);
 		/* Start with a clear page */
 		clear_page(ptr);
 		ptr += maddr & ~PAGE_MASK;
@@ -822,7 +822,7 @@ static int kimage_load_normal_segment(st
 			memcpy(ptr, kbuf, uchunk);
 		else
 			result = copy_from_user(ptr, buf, uchunk);
-		kunmap(page);
+		kunmap_local(ptr);
 		if (result) {
 			result = -EFAULT;
 			goto out;
@@ -873,7 +873,7 @@ static int kimage_load_crash_segment(str
 			goto out;
 		}
 		arch_kexec_post_alloc_pages(page_address(page), 1, 0);
-		ptr = kmap(page);
+		ptr = kmap_local_page(page);
 		ptr += maddr & ~PAGE_MASK;
 		mchunk = min_t(size_t, mbytes,
 				PAGE_SIZE - (maddr & ~PAGE_MASK));
@@ -889,7 +889,7 @@ static int kimage_load_crash_segment(str
 		else
 			result = copy_from_user(ptr, buf, uchunk);
 		kexec_flush_icache_page(page);
-		kunmap(page);
+		kunmap_local(ptr);
 		arch_kexec_pre_free_pages(page_address(page), 1);
 		if (result) {
 			result = -EFAULT;
_

Patches currently in -mm which might be from fmdefrancesco@gmail.com are

hfsplus-unmap-the-page-in-the-fail_page-label.patch
hfsplus-convert-kmap-to-kmap_local_page-in-bnodec.patch
hfsplus-convert-kmap-to-kmap_local_page-in-bitmapc.patch
hfsplus-convert-kmap-to-kmap_local_page-in-btreec.patch
fs-isofs-replace-kmap-with-kmap_local_page.patch
kexec-replace-kmap-with-kmap_local_page.patch

