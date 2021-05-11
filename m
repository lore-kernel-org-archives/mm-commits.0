Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3502C433B4
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 01:59:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAD966147D
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 01:59:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhEKCBC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 22:01:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:59038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229948AbhEKCBC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 22:01:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DADF46147E;
        Tue, 11 May 2021 01:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620698396;
        bh=7Y+VZ0XlVOYNyzgI+kgWui8s/E1ea+wN5JIapBehdPw=;
        h=Date:From:To:Subject:From;
        b=cQRPN/+hNRuzEJlQ9foidmM53k5ss6N2e8buOW8wvGLij5UX2eCguR6Rf8/TYTQFx
         sIgL+r4SX0qui/POkkVR8oCYseUTU1UPBJH1qT2fe6SZZfDlCR/UcnOjmkgSRebypK
         aZhgKumqGYrUdAgjbBLY/I4xGr+mi9a/YkWk3RZM=
Date:   Mon, 10 May 2021 18:59:55 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        swboyd@chromium.org
Subject:  +
 module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
 added to -mm tree
Message-ID: <20210511015955.j3w372K37%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix
has been added to the -mm tree.  Its filename is
     module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch

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
Subject: module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix

fix build with CONFIG_MODULES=n, tweak code layout

Cc: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/module.h |    1 +
 kernel/module.c        |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/module.h~module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix
+++ a/include/linux/module.h
@@ -746,6 +746,7 @@ static inline const char *module_address
 					  unsigned long *symbolsize,
 					  unsigned long *offset,
 					  char **modname,
+					  const unsigned char **modbuildid,
 					  char *namebuf)
 {
 	return NULL;
--- a/kernel/module.c~module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix
+++ a/kernel/module.c
@@ -4267,7 +4267,8 @@ void * __weak dereference_module_functio
 const char *module_address_lookup(unsigned long addr,
 			    unsigned long *size,
 			    unsigned long *offset,
-			    char **modname, const unsigned char **modbuildid,
+			    char **modname,
+			    const unsigned char **modbuildid,
 			    char *namebuf)
 {
 	const char *ret = NULL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-improve-mprotectrw-efficiency-on-pages-referenced-once-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

