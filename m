Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81518C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:13:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64CBB613C9
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbhGFTQW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:16:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231727AbhGFTQW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:16:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B0346128D;
        Tue,  6 Jul 2021 19:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598823;
        bh=GBgBRh10JlfUSnuELSs7R+ZttTs1hsem20Uz47YN89s=;
        h=Date:From:To:Subject:From;
        b=m7SwY14OrXiNIj7SXUGtIG+IXFTRG1Cy8DtBFo7v6uwjdzdtGk5BHgywl3JI99I3z
         eUHsbNi/XoTtT9/2n98UMuTyh43A/sTBJsI5rtqCSbbag27lrEfrT3IFC7/A4sIacj
         DnmkMVIvTdxp8kHk6GYgFwFr7kd/VQvR4ULXQsIc=
Date:   Tue, 06 Jul 2021 12:13:42 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, aneesh.kumar@linux.ibm.com,
        bsingharora@gmail.com, christophe.leroy@csgroup.eu, dja@axtens.net,
        dvyukov@google.com, elver@google.com, glider@google.com,
        mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com
Subject:  [merged]
 kasan-allow-architectures-to-provide-an-outline-readiness-check.patch
 removed from -mm tree
Message-ID: <20210706191342.SjU3Eoen1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: allow architectures to provide an outline readiness check
has been removed from the -mm tree.  Its filename was
     kasan-allow-architectures-to-provide-an-outline-readiness-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Axtens <dja@axtens.net>
Subject: kasan: allow architectures to provide an outline readiness check

Allow architectures to define a kasan_arch_is_ready() hook that bails out
of any function that's about to touch the shadow unless the arch says that
it is ready for the memory to be accessed.  This is fairly uninvasive and
should have a negligible performance penalty.

This will only work in outline mode, so an arch must specify
ARCH_DISABLE_KASAN_INLINE if it requires this.

Link: https://lkml.kernel.org/r/20210624034050.511391-3-dja@axtens.net
Signed-off-by: Daniel Axtens <dja@axtens.net>
Reviewed-by: Marco Elver <elver@google.com>
Suggested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c  |    3 +++
 mm/kasan/generic.c |    3 +++
 mm/kasan/kasan.h   |    6 ++++++
 mm/kasan/shadow.c  |    6 ++++++
 4 files changed, 18 insertions(+)

--- a/mm/kasan/common.c~kasan-allow-architectures-to-provide-an-outline-readiness-check
+++ a/mm/kasan/common.c
@@ -331,6 +331,9 @@ static inline bool ____kasan_slab_free(s
 	u8 tag;
 	void *tagged_object;
 
+	if (!kasan_arch_is_ready())
+		return false;
+
 	tag = get_tag(object);
 	tagged_object = object;
 	object = kasan_reset_tag(object);
--- a/mm/kasan/generic.c~kasan-allow-architectures-to-provide-an-outline-readiness-check
+++ a/mm/kasan/generic.c
@@ -163,6 +163,9 @@ static __always_inline bool check_region
 						size_t size, bool write,
 						unsigned long ret_ip)
 {
+	if (!kasan_arch_is_ready())
+		return true;
+
 	if (unlikely(size == 0))
 		return true;
 
--- a/mm/kasan/kasan.h~kasan-allow-architectures-to-provide-an-outline-readiness-check
+++ a/mm/kasan/kasan.h
@@ -449,6 +449,12 @@ static inline void kasan_poison_last_gra
 
 #endif /* CONFIG_KASAN_GENERIC */
 
+#ifndef kasan_arch_is_ready
+static inline bool kasan_arch_is_ready(void)	{ return true; }
+#elif !defined(CONFIG_KASAN_GENERIC) || !defined(CONFIG_KASAN_OUTLINE)
+#error kasan_arch_is_ready only works in KASAN generic outline mode!
+#endif
+
 /*
  * Exported functions for interfaces called from assembly or from generated
  * code. Declarations here to avoid warning about missing declarations.
--- a/mm/kasan/shadow.c~kasan-allow-architectures-to-provide-an-outline-readiness-check
+++ a/mm/kasan/shadow.c
@@ -73,6 +73,9 @@ void kasan_poison(const void *addr, size
 {
 	void *shadow_start, *shadow_end;
 
+	if (!kasan_arch_is_ready())
+		return;
+
 	/*
 	 * Perform shadow offset calculation based on untagged address, as
 	 * some of the callers (e.g. kasan_poison_object_data) pass tagged
@@ -99,6 +102,9 @@ EXPORT_SYMBOL(kasan_poison);
 #ifdef CONFIG_KASAN_GENERIC
 void kasan_poison_last_granule(const void *addr, size_t size)
 {
+	if (!kasan_arch_is_ready())
+		return;
+
 	if (size & KASAN_GRANULE_MASK) {
 		u8 *shadow = (u8 *)kasan_mem_to_shadow(addr + size);
 		*shadow = size & KASAN_GRANULE_MASK;
_

Patches currently in -mm which might be from dja@axtens.net are


