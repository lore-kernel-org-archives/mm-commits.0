Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 030ECC433DB
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D58D64F21
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:47:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhBZAr1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 19:47:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:34162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230010AbhBZAr0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 19:47:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FFF8601FD;
        Fri, 26 Feb 2021 00:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614300405;
        bh=6JfNIM+B/+s0UbLASyXVA5TsApcTs0kMEEfHNZLJRxU=;
        h=Date:From:To:Subject:From;
        b=y8GjyGMx8ezyWbrimgpaZPlhgjbXbbFed+OdUFtgCO8JdMHBfebK5sVpghz/7wue5
         Hby+0Ao8CD7O9B2A0IojnlAHRpWxnBrd+0+zp6hcQRkavyqtOlblMOUT0KSZZMvLEK
         v5zYyhaM56KiCajn0JDRqkNDxk6T8MYEBRDoy69g=
Date:   Thu, 25 Feb 2021 16:46:44 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, elver@google.com, glider@google.com,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 kfence-kasan-make-kfence-compatible-with-kasan-fix.patch removed from -mm
 tree
Message-ID: <20210226004644.WP68iQyV0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: revert kasan-remove-kfence-leftovers
has been removed from the -mm tree.  Its filename was
     kfence-kasan-make-kfence-compatible-with-kasan-fix.patch

This patch was dropped because it was folded into kfence-kasan-make-kfence-compatible-with-kasan.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert kasan-remove-kfence-leftovers

Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h  |    9 +++++++++
 mm/kasan/shadow.c |   13 +++++++++++++
 2 files changed, 22 insertions(+)

--- a/mm/kasan/kasan.h~kfence-kasan-make-kfence-compatible-with-kasan-fix
+++ a/mm/kasan/kasan.h
@@ -3,6 +3,7 @@
 #define __MM_KASAN_KASAN_H
 
 #include <linux/kasan.h>
+#include <linux/kfence.h>
 #include <linux/stackdepot.h>
 
 #ifdef CONFIG_KASAN_HW_TAGS
@@ -319,12 +320,20 @@ static inline u8 kasan_random_tag(void)
 
 static inline void kasan_poison(const void *address, size_t size, u8 value)
 {
+	/* Skip KFENCE memory if called explicitly outside of sl*b. */
+	if (is_kfence_address(address))
+		return;
+
 	hw_set_mem_tag_range(kasan_reset_tag(address),
 			round_up(size, KASAN_GRANULE_SIZE), value);
 }
 
 static inline void kasan_unpoison(const void *address, size_t size)
 {
+	/* Skip KFENCE memory if called explicitly outside of sl*b. */
+	if (is_kfence_address(address))
+		return;
+
 	hw_set_mem_tag_range(kasan_reset_tag(address),
 			round_up(size, KASAN_GRANULE_SIZE), get_tag(address));
 }
--- a/mm/kasan/shadow.c~kfence-kasan-make-kfence-compatible-with-kasan-fix
+++ a/mm/kasan/shadow.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/kasan.h>
 #include <linux/kernel.h>
+#include <linux/kfence.h>
 #include <linux/kmemleak.h>
 #include <linux/memory.h>
 #include <linux/mm.h>
@@ -84,6 +85,10 @@ void kasan_poison(const void *address, s
 	address = kasan_reset_tag(address);
 	size = round_up(size, KASAN_GRANULE_SIZE);
 
+	/* Skip KFENCE memory if called explicitly outside of sl*b. */
+	if (is_kfence_address(address))
+		return;
+
 	shadow_start = kasan_mem_to_shadow(address);
 	shadow_end = kasan_mem_to_shadow(address + size);
 
@@ -102,6 +107,14 @@ void kasan_unpoison(const void *address,
 	 */
 	address = kasan_reset_tag(address);
 
+	/*
+	 * Skip KFENCE memory if called explicitly outside of sl*b. Also note
+	 * that calls to ksize(), where size is not a multiple of machine-word
+	 * size, would otherwise poison the invalid portion of the word.
+	 */
+	if (is_kfence_address(address))
+		return;
+
 	kasan_poison(address, size, tag);
 
 	if (size & KASAN_GRANULE_MASK) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kfence-kasan-make-kfence-compatible-with-kasan.patch
lib-stackdepot-add-support-to-disable-stack-depot-fix.patch
seq_file-document-how-per-entry-resources-are-managed-fix.patch
initramfs-panic-with-memory-information-fix.patch
mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-layout-fix.patch
mm.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

