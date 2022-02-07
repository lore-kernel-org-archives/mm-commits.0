Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4DDBC43219
	for <mm-commits@archiver.kernel.org>; Mon,  7 Feb 2022 21:00:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbiBGVAy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Feb 2022 16:00:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbiBGVA1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Feb 2022 16:00:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F36C0401D1
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 13:00:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22277B816FF
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 21:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDEF2C004E1;
        Mon,  7 Feb 2022 21:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644267623;
        bh=jP9ofZaGXLvf66Ig2G8hUqXm25gtBebXDz/a+AUBJE8=;
        h=Date:To:From:Subject:From;
        b=krQpugo7Dj3ddD5KVf/wJkpXvH+V8M9sAOUnV7uJ+FWa5tL7c1/Ha2OKWzepB5fup
         Pa+LOAqvsgQ0pltPlHjlJ7uYwmjq1GP9zJY6NVox9+O0avxhz4pIIbpkcL1igkCjA9
         ansDTnr8zlIHwOpSGVbNZEnN/UisXc5rzUjtp/Z0=
Date:   Mon, 07 Feb 2022 13:00:23 -0800
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com, david@redhat.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch added to -mm tree
Message-Id: <20220207210023.BDEF2C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch

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
Subject: mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix

remove the comment altogether, per David

Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix
+++ a/mm/memory_hotplug.c
@@ -295,9 +295,6 @@ struct page *pfn_to_online_page(unsigned
 }
 EXPORT_SYMBOL_GPL(pfn_to_online_page);
 
-/*
- * Reasonably generic function for adding memory.
- */
 int __ref __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
 		struct mhp_params *params)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-move-page-writeback-sysctls-to-is-own-file-checkpatch-fixes.patch
mm-move-page-writeback-sysctls-to-is-own-file-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
numa-balancing-optimize-page-placement-for-memory-tiering-system-fix.patch
numa-balancing-optimize-page-placement-for-memory-tiering-system-fix-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
mm-outline-copy_overflow-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-next-rejects.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

