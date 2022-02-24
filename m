Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CF94C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 24 Feb 2022 02:58:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbiBXC7W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Feb 2022 21:59:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbiBXC7V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Feb 2022 21:59:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E879FE02F5
        for <mm-commits@vger.kernel.org>; Wed, 23 Feb 2022 18:58:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7597361527
        for <mm-commits@vger.kernel.org>; Thu, 24 Feb 2022 02:58:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4094C340E7;
        Thu, 24 Feb 2022 02:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645671531;
        bh=g3dvwdr7loSeyzNYaMDfS/pFc/WxxMQci1tqyJFbFhs=;
        h=Date:To:From:Subject:From;
        b=jCkkNa0cNdUjuoe4jI9x7l8tFEPGL8VN4t7hUScfxCPZDn2P+g4h4iwhTA0YN7pVs
         quYl3641dEfSwqEvbd7Hpxf2ZXS3gkZgw1z42gltIOenM77XAPQhBQ15PWGkv3s+BM
         pnc61/ebJ8gw3jHjXqAKXAugl0Lkhh2V2S61oAFU=
Date:   Wed, 23 Feb 2022 18:58:51 -0800
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hch@infradead.org, anshuman.khandual@arm.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-enable-arch_has_vm_get_page_prot-fix.patch added to -mm tree
Message-Id: <20220224025851.C4094C340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86-mm-enable-arch_has_vm_get_page_prot-fix
has been added to the -mm tree.  Its filename is
     x86-mm-enable-arch_has_vm_get_page_prot-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/x86-mm-enable-arch_has_vm_get_page_prot-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-enable-arch_has_vm_get_page_prot-fix.patch

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
Subject: x86-mm-enable-arch_has_vm_get_page_prot-fix

fix build

arch/x86/mm/mem_encrypt_amd.c: In function 'sme_early_init':
arch/x86/mm/mem_encrypt_amd.c:182:22: error: unused variable 'i' [-Werror=unused-variable]
  182 |         unsigned int i;

Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/mem_encrypt_amd.c |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/x86/mm/mem_encrypt_amd.c~x86-mm-enable-arch_has_vm_get_page_prot-fix
+++ a/arch/x86/mm/mem_encrypt_amd.c
@@ -179,8 +179,6 @@ void __init sme_map_bootdata(char *real_
 
 void __init sme_early_init(void)
 {
-	unsigned int i;
-
 	if (!sme_me_mask)
 		return;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
x86-mm-enable-arch_has_vm_get_page_prot-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-next-rejects.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

