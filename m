Return-Path: <SRS0=09mD=BO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABD8DC433DF
	for <mm-commits@archiver.kernel.org>; Tue,  4 Aug 2020 19:45:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90C38207FC
	for <mm-commits@archiver.kernel.org>; Tue,  4 Aug 2020 19:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596570302;
	bh=tGRNb2rNv3OJzWS+gQi5MlNlzn9tioliAURw/1Hik2U=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=lrOI694Qhh56b6nBnvbZHqztI4OMz//e7+cIZena1Mdj0UrtOpSDvGEHbxu2WYVek
	 4IQaQEmLFoaqIN5i3cesSGeCD4ygVmBj9H6SDh4SUxKLxIO73DRfuidewCFXQ19bZE
	 r71vUgRmKdVb9qdLSkR0WFwqU27m66hI2L3ynOf8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgHDTpC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Aug 2020 15:45:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgHDTpC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 Aug 2020 15:45:02 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 124CB2076E;
        Tue,  4 Aug 2020 19:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596570301;
        bh=tGRNb2rNv3OJzWS+gQi5MlNlzn9tioliAURw/1Hik2U=;
        h=Date:From:To:Subject:From;
        b=BWj9o9IvlE27F9RYaOYdfkGs5i7R0Vriimg+FibwTHR0AUreBdgvqNstQCcqKypLp
         qWpmPXEEJR7hmu4vgVy4DcoyQTU/hXaNCiyeDzquNXQDyRcsKGoXFo1Nw/gYG3p0l6
         oSYOMRjL1htLQ9Q+YhGOtvxbapADD65210lFdhHk=
Date:   Tue, 04 Aug 2020 12:45:00 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, ardb@kernel.org, aryabinin@virtuozzo.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        glider@google.com, lenaptr@google.com, lkp@intel.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        walter-zh.wu@mediatek.com
Subject:  +
 efi-provide-empty-efi_enter_virtual_mode-implementation.patch added to -mm
 tree
Message-ID: <20200804194500.OFQTZtB6M%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: efi: provide empty efi_enter_virtual_mode implementation
has been added to the -mm tree.  Its filename is
     efi-provide-empty-efi_enter_virtual_mode-implementation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/efi-provide-empty-efi_enter_virtual_mode-implementation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/efi-provide-empty-efi_enter_virtual_mode-implementation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: efi: provide empty efi_enter_virtual_mode implementation

When CONFIG_EFI is not enabled, we might get an undefined reference to
efi_enter_virtual_mode() error, if this efi_enabled() call isn't inlined
into start_kernel().  This happens in particular, if start_kernel() is
annodated with __no_sanitize_address.

Link: http://lkml.kernel.org/r/6514652d3a32d3ed33d6eb5c91d0af63bf0d1a0c.1596544734.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Elena Petrova <lenaptr@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Walter Wu <walter-zh.wu@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/efi.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/efi.h~efi-provide-empty-efi_enter_virtual_mode-implementation
+++ a/include/linux/efi.h
@@ -606,7 +606,11 @@ extern void *efi_get_pal_addr (void);
 extern void efi_map_pal_code (void);
 extern void efi_memmap_walk (efi_freemem_callback_t callback, void *arg);
 extern void efi_gettimeofday (struct timespec64 *ts);
+#ifdef CONFIG_EFI
 extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if possible */
+#else
+static inline void efi_enter_virtual_mode (void) {}
+#endif
 #ifdef CONFIG_X86
 extern efi_status_t efi_query_variable_store(u32 attributes,
 					     unsigned long size,
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-dont-tag-stacks-allocated-with-pagealloc.patch
efi-provide-empty-efi_enter_virtual_mode-implementation.patch
kasan-arm64-dont-instrument-functions-that-enable-kasan.patch
kasan-arm64-dont-instrument-functions-that-enable-kasan-v2.patch
kasan-allow-enabling-stack-tagging-for-tag-based-mode.patch
kasan-adjust-kasan_stack_oob-for-tag-based-mode.patch

