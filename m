Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B0F7C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 21:13:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbiB1VOZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Feb 2022 16:14:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbiB1VOS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Feb 2022 16:14:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0D6237E1
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 13:13:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C50FFB8165B
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 21:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40845C340F1;
        Mon, 28 Feb 2022 21:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646082805;
        bh=JbiosnmO1H5gOh4Ql73nwRrMM8AArFvuMfa9ZYTzOQA=;
        h=Date:To:From:Subject:From;
        b=DNJeIzaDP4ftZpNY3dLc26juDGZ3zt+VaWEsAAK6iOHhEnY8vyMtZj/k5SgAxdvkD
         kGbarRKqp1FWa2ryBH8HUjmYrcqkPmtHlruoUWGa6q57gAIZWQqLcfr9Q6p+RBMMmh
         W8i7RwgEfgP2+heUdoWmUswfwJLWCGPryF3VZslY=
Date:   Mon, 28 Feb 2022 13:13:24 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-list_lru-replace-linear-array-with-xarray-fix.patch added to -mm tree
Message-Id: <20220228211325.40845C340F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-list_lru-replace-linear-array-with-xarray-fix
has been added to the -mm tree.  Its filename is
     mm-list_lru-replace-linear-array-with-xarray-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-list_lru-replace-linear-array-with-xarray-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-list_lru-replace-linear-array-with-xarray-fix.patch

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
Subject: mm-list_lru-replace-linear-array-with-xarray-fix

remove unused local

mm/list_lru.c: In function 'memcg_list_lru_alloc':
mm/list_lru.c:477:32: error: unused variable 'mlrus' [-Werror=unused-variable]
  477 |         struct list_lru_memcg *mlrus;
      |                                ^~~~~

Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/list_lru.c~mm-list_lru-replace-linear-array-with-xarray-fix
+++ a/mm/list_lru.c
@@ -474,7 +474,6 @@ int memcg_list_lru_alloc(struct mem_cgro
 {
 	int i;
 	unsigned long flags;
-	struct list_lru_memcg *mlrus;
 	struct list_lru_memcg_table {
 		struct list_lru_per_memcg *mlru;
 		struct mem_cgroup *memcg;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-list_lru-replace-linear-array-with-xarray-fix.patch
mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch
mm-export-pageheadhuge-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-next-rejects.patch
drivers-gpu-drm-dp-drm_dpc-fix-build.patch
arch-x86-kernel-resourcec-needs-spinlockh.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

