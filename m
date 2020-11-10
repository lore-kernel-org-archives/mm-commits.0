Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 673E7C388F7
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 22:55:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14B4520781
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 22:55:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="GnK2jZWe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732400AbgKJWzi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Nov 2020 17:55:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:53684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727018AbgKJWzi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Nov 2020 17:55:38 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1301A2080A;
        Tue, 10 Nov 2020 22:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605048937;
        bh=7lB4eRhIf1CEq6eQtOuXtoEp+rNH0eVEj0W0mWFG6dI=;
        h=Date:From:To:Subject:From;
        b=GnK2jZWecRQpXU2cC5DuV3ASorAUxqZBtawPuxIfVTsVFK5qf3U4jBxmNC25Md/EL
         XM1NY3AriPfPcMS8859bm+lRzoo7HevnV9Fede+2L+a7annItt5REoiFwAMIeA9YtM
         doB4+BYBzYZKELwQB13dd4I/5XqE/sK4byp5Qmaw=
Date:   Tue, 10 Nov 2020 14:55:36 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, gor@linux.ibm.com,
        kevin.brodsky@arm.com, mm-commits@vger.kernel.org,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  + kasan-split-out-shadowc-from-commonc-fix.patch added to
 -mm tree
Message-ID: <20201110225536.lipDXoepV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-split-out-shadowc-from-commonc-fix
has been added to the -mm tree.  Its filename is
     kasan-split-out-shadowc-from-commonc-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-split-out-shadowc-from-commonc-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-split-out-shadowc-from-commonc-fix.patch

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
Subject: kasan-split-out-shadowc-from-commonc-fix

retain changes from kfence-kasan-make-kfence-compatible-with-kasan.patch

Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/shadow.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/kasan/shadow.c~kasan-split-out-shadowc-from-commonc-fix
+++ a/mm/kasan/shadow.c
@@ -83,6 +83,10 @@ void kasan_poison_memory(const void *add
 	 */
 	address = reset_tag(address);
 
+	/* Skip KFENCE memory if called explicitly outside of sl*b. */
+	if (is_kfence_address(address))
+		return;
+
 	shadow_start = kasan_mem_to_shadow(address);
 	shadow_end = kasan_mem_to_shadow(address + size);
 
@@ -100,6 +104,14 @@ void kasan_unpoison_memory(const void *a
 	 */
 	address = reset_tag(address);
 
+	/*
+	 * Skip KFENCE memory if called explicitly outside of sl*b. Also note
+	 * that calls to ksize(), where size is not a multiple of machine-word
+	 * size, would otherwise poison the invalid portion of the word.
+	 */
+	if (is_kfence_address(address))
+		return;
+
 	kasan_poison_memory(address, size, tag);
 
 	if (size & KASAN_GRANULE_MASK) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kthread_worker-document-cpu-hotplug-handling-fix.patch
mm.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
linux-next-rejects.patch
kasan-split-out-shadowc-from-commonc-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

