Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18FF0C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 27 Feb 2022 00:58:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiB0A7A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 26 Feb 2022 19:59:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiB0A67 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 26 Feb 2022 19:58:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85F82B9BFA
        for <mm-commits@vger.kernel.org>; Sat, 26 Feb 2022 16:58:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7527CB80881
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 00:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14268C340E8;
        Sun, 27 Feb 2022 00:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645923501;
        bh=FeE714ySlAjfMfzLQfpfkEY/B0xrk2GbtDhWXREqQMU=;
        h=Date:To:From:Subject:From;
        b=E4whAFu6aCxmS3mubfs+aHG9T7AQOg3X4c8GoddgOYeT4iHb+SrHrZJBeex9+bf3n
         wKD0jvntPKENszgAEPZ7LCp4T/n52UJ/3yDZwBkkfO5EcUFcnEWD/Mp6qU6vRjefzW
         C8KYXAcr5rOzZ4KtLhuytyJlAUlPWuyOx071jqjI=
Date:   Sat, 26 Feb 2022 16:58:20 -0800
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn,
        yang.yang29@zte.com.cn, wang.yong12@zte.com.cn,
        songliubraving@fb.com, mike.kravetz@oracle.com,
        kirill@shutemov.name, hughd@google.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fix-shmem-huge-page-failed-to-set-f_seal_write-attribute-problem-fix.patch added to -mm tree
Message-Id: <20220227005821.14268C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fix-shmem-huge-page-failed-to-set-f_seal_write-attribute-problem-fix
has been added to the -mm tree.  Its filename is
     fix-shmem-huge-page-failed-to-set-f_seal_write-attribute-problem-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fix-shmem-huge-page-failed-to-set-f_seal_write-attribute-problem-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fix-shmem-huge-page-failed-to-set-f_seal_write-attribute-problem-fix.patch

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
Subject: fix-shmem-huge-page-failed-to-set-f_seal_write-attribute-problem-fix

fix clang warning

mm/memfd.c:80:2: warning: Value stored to 'count' is never read [clang-analyzer-deadcode.DeadStores]

Link: https://lkml.kernel.org/r/621a57b7.EM2OYvmyAaNzq+Ta%25lkp@intel.com
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: wangyong <wang.yong12@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/memfd.c~fix-shmem-huge-page-failed-to-set-f_seal_write-attribute-problem-fix
+++ a/mm/memfd.c
@@ -72,12 +72,11 @@ static int memfd_wait_for_pins(struct ad
 {
 	XA_STATE(xas, &mapping->i_pages, 0);
 	struct page *page;
-	int error, scan, count;
+	int error, scan;
 
 	memfd_tag_pins(&xas);
 
 	error = 0;
-	count = 0;
 	for (scan = 0; scan <= LAST_SCAN; scan++) {
 		unsigned int tagged = 0;
 
@@ -93,6 +92,8 @@ static int memfd_wait_for_pins(struct ad
 		xas_lock_irq(&xas);
 		xas_for_each_marked(&xas, page, ULONG_MAX, MEMFD_TAG_PINNED) {
 			bool clear = true;
+			int count;
+
 			if (xa_is_value(page))
 				continue;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
x86-mm-enable-arch_has_vm_get_page_prot-fix.patch
fix-shmem-huge-page-failed-to-set-f_seal_write-attribute-problem-fix.patch
mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-gpu-drm-dp-drm_dpc-fix-build.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

