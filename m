Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C54FC433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:39:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 280452065D
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027171;
	bh=m2lHzxg5h0RhKgXOuKR2m0i8Vzc2yJwsgFMXxNUOMmQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=aHRurSSh+XpBFGgS6MeLInKJEnCy3fLbH7Tns57n+ejVpSU5RqRwWsHzayPy8lf7j
	 XMJZKfN6paKxj83Wnf5PvFep8sKFsDl4KTA5/KVgCragbD3LSuC7ZgJ8nmZjHIOe0O
	 7jFp8sIkS+WHtYAP7b2/lb/R/NuhIT5dEZTIbp9o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgHJCja (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:39:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:42666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCja (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:39:30 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1DE9206C3;
        Mon, 10 Aug 2020 02:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027170;
        bh=m2lHzxg5h0RhKgXOuKR2m0i8Vzc2yJwsgFMXxNUOMmQ=;
        h=Date:From:To:Subject:From;
        b=UiNw333p3r7f3IlQ8hTe8PVY2kdBdhnlouasZZbDWMBODoRMiHg7kTdqC8ldeCQ6x
         d1bb6Z4VBv62j1GoFh+dSodS8eE3dK9R4TUe2o6OOU1ypBWFsyiRvzIVWFZMGUHLe/
         qJhv6ph0IheBa66boC8XHgNJxpwqKl448/3L+WSA=
Date:   Sun, 09 Aug 2020 19:39:29 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, ardb@kernel.org, aryabinin@virtuozzo.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        glider@google.com, lenaptr@google.com, lkp@intel.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        walter-zh.wu@mediatek.com
Subject:  [merged]
 efi-provide-empty-efi_enter_virtual_mode-implementation.patch removed from
 -mm tree
Message-ID: <20200810023929.xyUCDlLLz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: efi: provide empty efi_enter_virtual_mode implementation
has been removed from the -mm tree.  Its filename was
     efi-provide-empty-efi_enter_virtual_mode-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


