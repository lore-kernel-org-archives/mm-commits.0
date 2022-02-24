Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCD46C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 24 Feb 2022 03:59:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiBXEAB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Feb 2022 23:00:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiBXEAB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Feb 2022 23:00:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F150725D26F
        for <mm-commits@vger.kernel.org>; Wed, 23 Feb 2022 19:59:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76FC9616B4
        for <mm-commits@vger.kernel.org>; Thu, 24 Feb 2022 03:59:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6092C340E9;
        Thu, 24 Feb 2022 03:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645675170;
        bh=Q/c7vLGXGgno7jY4+eIkhI7ZE/gTVTD7sRQlw2k9LGc=;
        h=Date:To:From:Subject:From;
        b=Xcho0n6IReNb96c2BSSHLKNuY66lMTjRZYO9j3gatBOApILOKyxsLeiSHcN3C1C+p
         Kn9QlkFXI5lBo+997lalX8DArNr93mpKFweexDlPiHWtzpomvWW6+Ar0IJOwilnz68
         fV128hSbBGrJ4EUptazOrAqQQe1sa4B09V18oVKY=
Date:   Wed, 23 Feb 2022 19:59:30 -0800
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch added to -mm tree
Message-Id: <20220224035930.C6092C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix
has been added to the -mm tree.  Its filename is
     mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch

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
Subject: mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix

export is_free_buddy_page() to modules

ERROR: modpost: "is_free_buddy_page" [mm/hwpoison-inject.ko] undefined!

Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page_alloc.c~mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix
+++ a/mm/page_alloc.c
@@ -9520,6 +9520,7 @@ bool is_free_buddy_page(struct page *pag
 
 	return order < MAX_ORDER;
 }
+EXPORT_SYMBOL(is_free_buddy_page);
 
 #ifdef CONFIG_MEMORY_FAILURE
 /*
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
drivers-gpu-drm-dp-drm_dpc-fix-build.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch

