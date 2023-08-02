Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE721C00528
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 20:07:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjHBUHG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 16:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbjHBUHF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 16:07:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2702510C3
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 13:07:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8705361AFE
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 20:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E0AC433C8;
        Wed,  2 Aug 2023 20:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691006822;
        bh=8CmG582SoZs/xjaSxBrzASlXC8DK+qXa44huh/LoknA=;
        h=Date:To:From:Subject:From;
        b=sBUEQ6dUhgBaMs/2usnNOQ77GDXHktcMj8aS6IxI0np6085x4vy9+PtGgKgeS6GQh
         ZONo5YduR/K+kE0DDwXlof4U1U/eBt2ZT1X4snxsmhf5Azp2s//anV3mJpAozog1Si
         ckbRrjF2ZNGvL0ol6//SgNLgyV9fw/Vd+JWaxC4o=
Date:   Wed, 02 Aug 2023 13:07:02 -0700
To:     mm-commits@vger.kernel.org, yuzenghui@huawei.com, will@kernel.org,
        trix@redhat.com, suzuki.poulose@arm.com, oliver.upton@linux.dev,
        ojeda@kernel.org, ndesaulniers@google.com, nathan@kernel.org,
        maz@kernel.org, linux@roeck-us.net, keescook@chromium.org,
        james.morse@arm.com, glider@google.com, dvyukov@google.com,
        catalin.marinas@arm.com, elver@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] list_debug-introduce-config_debug_list_minimal.patch removed from -mm tree
Message-Id: <20230802200702.D7E0AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: list_debug: introduce CONFIG_DEBUG_LIST_MINIMAL
has been removed from the -mm tree.  Its filename was
     list_debug-introduce-config_debug_list_minimal.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: list_debug: introduce CONFIG_DEBUG_LIST_MINIMAL
Date: Wed, 2 Aug 2023 17:06:39 +0200

Numerous production kernel configs (see [1, 2]) are choosing to enable
CONFIG_DEBUG_LIST, which is also being recommended by KSPP for hardened
configs [3]. The feature has never been designed with performance in
mind, yet common list manipulation is happening across hot paths all
over the kernel.

Introduce CONFIG_DEBUG_LIST_MINIMAL, which performs list pointer
checking inline, and only upon list corruption delegates to the
reporting slow path.

To generate optimal machine code with CONFIG_DEBUG_LIST_MINIMAL:

  1. Elide checking for pointer values which upon dereference would
     result in an immediate access fault -- therefore "minimal" checks.
     The trade-off is lower-quality error reports.

  2. Use the newly introduced __preserve_most function attribute
     (available with Clang, but not yet with GCC) to minimize the code
     footprint for calling the reporting slow path. As a result,
     function size of callers is reduced by avoiding saving registers
     before calling the rarely called reporting slow path.

  3. Because the inline checks are a subset of the full set of checks in
     ___list_*_valid(), always return false if the inline checks failed.
     This avoids redundant compare and conditional branch right after
     return from the slow path.

As a side-effect of the checks being inline, if the compiler can prove
some condition to always be true, it can completely elide some checks.

Running netperf with CONFIG_DEBUG_LIST_MINIMAL (using a Clang compiler
with "preserve_most") shows throughput improvements, in my case of ~7%
on average (up to 20-30% on some test cases).

Link: https://r.android.com/1266735 [1]
Link: https://gitlab.archlinux.org/archlinux/packaging/packages/linux/-/blob/main/config [2]
Link: https://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project/Recommended_Settings [3]
Link: https://lkml.kernel.org/r/20230802150712.3583252-3-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: James Morse <james.morse@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Tom Rix <trix@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kvm/hyp/nvhe/list_debug.c |    2 
 include/linux/list.h                 |   56 ++++++++++++++++++++++---
 lib/Kconfig.debug                    |   15 ++++++
 lib/list_debug.c                     |    2 
 4 files changed, 69 insertions(+), 6 deletions(-)

--- a/arch/arm64/kvm/hyp/nvhe/list_debug.c~list_debug-introduce-config_debug_list_minimal
+++ a/arch/arm64/kvm/hyp/nvhe/list_debug.c
@@ -26,6 +26,7 @@ static inline __must_check bool nvhe_che
 
 /* The predicates checked here are taken from lib/list_debug.c. */
 
+__list_valid_slowpath
 bool ___list_add_valid(struct list_head *new, struct list_head *prev,
 		       struct list_head *next)
 {
@@ -37,6 +38,7 @@ bool ___list_add_valid(struct list_head
 	return true;
 }
 
+__list_valid_slowpath
 bool ___list_del_entry_valid(struct list_head *entry)
 {
 	struct list_head *prev, *next;
--- a/include/linux/list.h~list_debug-introduce-config_debug_list_minimal
+++ a/include/linux/list.h
@@ -39,20 +39,64 @@ static inline void INIT_LIST_HEAD(struct
 }
 
 #ifdef CONFIG_DEBUG_LIST
-extern bool ___list_add_valid(struct list_head *new,
-			      struct list_head *prev,
-			      struct list_head *next);
+
+#ifdef CONFIG_DEBUG_LIST_MINIMAL
+# define __list_valid_slowpath __cold __preserve_most
+#else
+# define __list_valid_slowpath
+#endif
+
+extern bool __list_valid_slowpath ___list_add_valid(struct list_head *new,
+						    struct list_head *prev,
+						    struct list_head *next);
 static __always_inline bool __list_add_valid(struct list_head *new,
 					     struct list_head *prev,
 					     struct list_head *next)
 {
-	return ___list_add_valid(new, prev, next);
+	bool ret = true;
+
+	if (IS_ENABLED(CONFIG_DEBUG_LIST_MINIMAL)) {
+		/*
+		 * In the minimal config, elide checking if next and prev are
+		 * NULL, since the immediate dereference of them below would
+		 * result in a fault if NULL.
+		 *
+		 * With the minimal config we can afford to inline the checks,
+		 * which also gives the compiler a chance to elide some of them
+		 * completely if they can be proven at compile-time. If one of
+		 * the pre-conditions does not hold, the slow-path will show a
+		 * report which pre-condition failed.
+		 */
+		if (likely(next->prev == prev && prev->next == next && new != prev && new != next))
+			return true;
+		ret = false;
+	}
+
+	ret &= ___list_add_valid(new, prev, next);
+	return ret;
 }
 
-extern bool ___list_del_entry_valid(struct list_head *entry);
+extern bool __list_valid_slowpath ___list_del_entry_valid(struct list_head *entry);
 static __always_inline bool __list_del_entry_valid(struct list_head *entry)
 {
-	return ___list_del_entry_valid(entry);
+	bool ret = true;
+
+	if (IS_ENABLED(CONFIG_DEBUG_LIST_MINIMAL)) {
+		struct list_head *prev = entry->prev;
+		struct list_head *next = entry->next;
+
+		/*
+		 * In the minimal config, elide checking if next and prev are
+		 * NULL, LIST_POISON1 or LIST_POISON2, since the immediate
+		 * dereference of them below would result in a fault.
+		 */
+		if (likely(prev->next == entry && next->prev == entry))
+			return true;
+		ret = false;
+	}
+
+	ret &= ___list_del_entry_valid(entry);
+	return ret;
 }
 #else
 static inline bool __list_add_valid(struct list_head *new,
--- a/lib/Kconfig.debug~list_debug-introduce-config_debug_list_minimal
+++ a/lib/Kconfig.debug
@@ -1680,6 +1680,21 @@ config DEBUG_LIST
 
 	  If unsure, say N.
 
+config DEBUG_LIST_MINIMAL
+	bool "Minimal linked list debug checks"
+	default !DEBUG_KERNEL
+	depends on DEBUG_LIST
+	help
+	  Only perform the minimal set of checks in the linked-list walking
+	  routines to catch corruptions that are not guaranteed to result in an
+	  immediate access fault.
+
+	  This trades lower quality error reports for improved performance: the
+	  generated code should be more optimal and provide trade-offs that may
+	  better serve safety- and performance- critical environments.
+
+	  If unsure, say Y.
+
 config DEBUG_PLIST
 	bool "Debug priority linked list manipulation"
 	depends on DEBUG_KERNEL
--- a/lib/list_debug.c~list_debug-introduce-config_debug_list_minimal
+++ a/lib/list_debug.c
@@ -17,6 +17,7 @@
  * attempt).
  */
 
+__list_valid_slowpath
 bool ___list_add_valid(struct list_head *new, struct list_head *prev,
 		       struct list_head *next)
 {
@@ -39,6 +40,7 @@ bool ___list_add_valid(struct list_head
 }
 EXPORT_SYMBOL(___list_add_valid);
 
+__list_valid_slowpath
 bool ___list_del_entry_valid(struct list_head *entry)
 {
 	struct list_head *prev, *next;
_

Patches currently in -mm which might be from elver@google.com are


