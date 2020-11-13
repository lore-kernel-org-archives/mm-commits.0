Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAD88C2D0E4
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 01:26:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73AC222201
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 01:26:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="qYvp631s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgKMB0Q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Nov 2020 20:26:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:41472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbgKMB0O (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Nov 2020 20:26:14 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D997C221E9;
        Fri, 13 Nov 2020 01:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605230773;
        bh=2Y5mFOHEkFGpZgkYPKqPrwlQHDQl+ipRcUcu6Lix6ME=;
        h=Date:From:To:Subject:From;
        b=qYvp631sFgmcHVTEfaWqTSCU9ZQ+eM+xq4k41He6GLl/urLCLKAxD17vbKQlsafoL
         7zfs8sTIHsh02m9Wo+pIZD1D3kr9aoTVRCb3kLEWfhgReeRA52h0wIr/Uo+HH0Nlzo
         mon1NsBDXPmg4bNKIUe5vSKql8e+UQ7h8jII/IQk=
Date:   Thu, 12 Nov 2020 17:26:12 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andreyknvl@google.com, cai@redhat.com,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au
Subject:  + kasan-mm-rename-kasan_poison_kfree-temp-fix.patch added
 to -mm tree
Message-ID: <20201113012612.n9-JWNllY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-mm-rename-kasan_poison_kfree-temp-fix
has been added to the -mm tree.  Its filename is
     kasan-mm-rename-kasan_poison_kfree-temp-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-mm-rename-kasan_poison_kfree-temp-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-mm-rename-kasan_poison_kfree-temp-fix.patch

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
Subject: kasan-mm-rename-kasan_poison_kfree-temp-fix

carry forward kasan-simplify-kasan_poison_kfree-temp-fix.patch

Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Qian Cai <cai@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/kasan/common.c~kasan-mm-rename-kasan_poison_kfree-temp-fix
+++ a/mm/kasan/common.c
@@ -345,6 +345,10 @@ void __kasan_slab_free_mempool(void *ptr
 	struct page *page;
 
 	page = virt_to_head_page(ptr);
+
+	if (!PageSlab(page))
+		return;
+
 	____kasan_slab_free(page->slab_cache, ptr, ip, false);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kthread_worker-document-cpu-hotplug-handling-fix.patch
mm.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
linux-next-rejects.patch
kasan-split-out-shadowc-from-commonc-fix.patch
kasan-mm-check-kasan_enabled-in-annotations-fix.patch
kasan-mm-rename-kasan_poison_kfree-temp-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

