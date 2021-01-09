Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB6CBC433DB
	for <mm-commits@archiver.kernel.org>; Sat,  9 Jan 2021 22:35:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F5BB23888
	for <mm-commits@archiver.kernel.org>; Sat,  9 Jan 2021 22:35:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbhAIWfd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 9 Jan 2021 17:35:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:43226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbhAIWfc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 9 Jan 2021 17:35:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C53023741;
        Sat,  9 Jan 2021 22:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610231692;
        bh=FMx3EBoefkJhLi6eiOw9Xc0S7WCFNfTlJb85XQOPTvQ=;
        h=Date:From:To:Subject:From;
        b=aX1Lg9roiPhWOP98Tb47l58NAbrQpmEKehBa7hfPXY+cpQwvIHEKCLVYrq51fSBhv
         kh1pwlMU2B/CkbzYmVqV72JPM1FxBTZzSTJRWAkkozkz6Njs6nuI7XyVfJ/ZX2BeQR
         c1psSjzbySklU0LoSLLLk4OmPDTYBjEbxMC9Uob8=
Date:   Sat, 09 Jan 2021 14:34:51 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, axboe@kernel.dk, hch@lst.de,
        me@kylehuey.com, mm-commits@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  + mm-process_vm_accessc-include-compath.patch added to
 -mm tree
Message-ID: <20210109223451.qaB8SWAS4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/process_vm_access.c: include compat.h
has been added to the -mm tree.  Its filename is
     mm-process_vm_accessc-include-compath.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-process_vm_accessc-include-compath.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-process_vm_accessc-include-compath.patch

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
Subject: mm/process_vm_access.c: include compat.h

mm/process_vm_access.c:277:5: error: implicit declaration of function 'in_compat_syscall'; did you mean 'in_ia32_syscall'? [-Werror=implicit-function-declaration]

Fixes: 38dc5079da7081e "Fix compat regression in process_vm_rw()"
Reported-by: syzbot+5b0d0de84d6c65b8dd2b@syzkaller.appspotmail.com
Cc: Kyle Huey <me@kylehuey.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/process_vm_access.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/process_vm_access.c~mm-process_vm_accessc-include-compath
+++ a/mm/process_vm_access.c
@@ -9,6 +9,7 @@
 #include <linux/mm.h>
 #include <linux/uio.h>
 #include <linux/sched.h>
+#include <linux/compat.h>
 #include <linux/sched/mm.h>
 #include <linux/highmem.h>
 #include <linux/ptrace.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-add-a-missing-mm_page_alloc_zone_locked-tracepoint-fix.patch
mm-process_vm_accessc-include-compath.patch
mm.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fix.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch
kasan-fix-bug-detection-via-ksize-for-hw_tags-mode-fix.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

