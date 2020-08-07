Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF555C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F73D221E5
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781518;
	bh=2+Nhzl5xABO+Yn1gwNt/bgpjSRLIftyE1UqUFuyT48U=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=HxMiWwH5thpAKRSqSR1fHt1jpGECHHLdiXDipIVQ6J2f7cfpvT7qHZ5RV7FAdbduU
	 QRZbEFVXOaAaJ1PWWNlEepFUbhDXW7MgAsYdrQ2+0aFHyfOCWbnVarWpP83hkcDGEq
	 /KGPMwDABkHf1owx/LeYZn6WBxv5UfMG3BER79wQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgHGGZN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:25:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGZD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:25:03 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13243221E5;
        Fri,  7 Aug 2020 06:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781502;
        bh=2+Nhzl5xABO+Yn1gwNt/bgpjSRLIftyE1UqUFuyT48U=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=FveR/8f3KycJhLJTxbOGKpAuC3lxHZud46t/E6qQbhNot07EcYeKbnojw2D3r834x
         d0I38XACeRrWqRSFnHlf2buR9csvTOtlO2ZW8VErcp2aYduzLtKxlMTOj8xwyppnCu
         xsJ1e1EZwHfCtUNpGc2cwH5fUIb6JP6lDIZIOQ0A=
Date:   Thu, 06 Aug 2020 23:25:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com, ardb@kernel.org,
        aryabinin@virtuozzo.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, glider@google.com,
        lenaptr@google.com, linux-mm@kvack.org, lkp@intel.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vincenzo.frascino@arm.com, walter-zh.wu@mediatek.com
Subject:  [patch 137/163] efi: provide empty efi_enter_virtual_mode
 implementation
Message-ID: <20200807062501.oOZ8axz6Y%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
