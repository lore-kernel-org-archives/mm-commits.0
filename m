Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C82C001E0
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 18:41:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjHBSlf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 14:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjHBSlf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 14:41:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4D21BFD
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 11:41:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B720361A73
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 18:41:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14ECFC433C8;
        Wed,  2 Aug 2023 18:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691001691;
        bh=9Ru3glVRevDugutiOE3O9hhfd7pfwZAr4xfO/LBejFM=;
        h=Date:To:From:Subject:From;
        b=Xo9UbesYjw+Ea9bBJfcu9zDxYOBf80m7PetAR92dJuwdCxly5Yh/eiUavUXhELydS
         YU1fskeD4gSpDP+ZuU32ntok3a1dBVfvvxPzdyMmJaIezHQN3/rCwIHpSdEnEzX1bU
         +w9RgSDvf+qsCQqXLgY98/l5v4imALuhtpwqP1n4=
Date:   Wed, 02 Aug 2023 11:41:30 -0700
To:     mm-commits@vger.kernel.org, yuzenghui@huawei.com, will@kernel.org,
        trix@redhat.com, suzuki.poulose@arm.com, oliver.upton@linux.dev,
        ojeda@kernel.org, ndesaulniers@google.com, nathan@kernel.org,
        maz@kernel.org, linux@roeck-us.net, keescook@chromium.org,
        james.morse@arm.com, glider@google.com, dvyukov@google.com,
        catalin.marinas@arm.com, elver@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + list_debug-introduce-inline-wrappers-for-debug-checks.patch added to mm-nonmm-unstable branch
Message-Id: <20230802184131.14ECFC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: list_debug: introduce inline wrappers for debug checks
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     list_debug-introduce-inline-wrappers-for-debug-checks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/list_debug-introduce-inline-wrappers-for-debug-checks.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: list_debug: introduce inline wrappers for debug checks
Date: Wed, 2 Aug 2023 17:06:38 +0200

Turn the list debug checking functions __list_*_valid() into inline
functions that wrap the out-of-line functions.  Care is taken to ensure
the inline wrappers are always inlined, so that additional compiler
instrumentation (such as sanitizers) does not result in redundant
outlining.

This change is preparation for performing checks in the inline wrappers.

No functional change intended.

Link: https://lkml.kernel.org/r/20230802150712.3583252-2-elver@google.com
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

 arch/arm64/kvm/hyp/nvhe/list_debug.c |    6 +++---
 include/linux/list.h                 |   15 +++++++++++++--
 lib/list_debug.c                     |   11 +++++------
 3 files changed, 21 insertions(+), 11 deletions(-)

--- a/arch/arm64/kvm/hyp/nvhe/list_debug.c~list_debug-introduce-inline-wrappers-for-debug-checks
+++ a/arch/arm64/kvm/hyp/nvhe/list_debug.c
@@ -26,8 +26,8 @@ static inline __must_check bool nvhe_che
 
 /* The predicates checked here are taken from lib/list_debug.c. */
 
-bool __list_add_valid(struct list_head *new, struct list_head *prev,
-		      struct list_head *next)
+bool ___list_add_valid(struct list_head *new, struct list_head *prev,
+		       struct list_head *next)
 {
 	if (NVHE_CHECK_DATA_CORRUPTION(next->prev != prev) ||
 	    NVHE_CHECK_DATA_CORRUPTION(prev->next != next) ||
@@ -37,7 +37,7 @@ bool __list_add_valid(struct list_head *
 	return true;
 }
 
-bool __list_del_entry_valid(struct list_head *entry)
+bool ___list_del_entry_valid(struct list_head *entry)
 {
 	struct list_head *prev, *next;
 
--- a/include/linux/list.h~list_debug-introduce-inline-wrappers-for-debug-checks
+++ a/include/linux/list.h
@@ -39,10 +39,21 @@ static inline void INIT_LIST_HEAD(struct
 }
 
 #ifdef CONFIG_DEBUG_LIST
-extern bool __list_add_valid(struct list_head *new,
+extern bool ___list_add_valid(struct list_head *new,
 			      struct list_head *prev,
 			      struct list_head *next);
-extern bool __list_del_entry_valid(struct list_head *entry);
+static __always_inline bool __list_add_valid(struct list_head *new,
+					     struct list_head *prev,
+					     struct list_head *next)
+{
+	return ___list_add_valid(new, prev, next);
+}
+
+extern bool ___list_del_entry_valid(struct list_head *entry);
+static __always_inline bool __list_del_entry_valid(struct list_head *entry)
+{
+	return ___list_del_entry_valid(entry);
+}
 #else
 static inline bool __list_add_valid(struct list_head *new,
 				struct list_head *prev,
--- a/lib/list_debug.c~list_debug-introduce-inline-wrappers-for-debug-checks
+++ a/lib/list_debug.c
@@ -17,8 +17,8 @@
  * attempt).
  */
 
-bool __list_add_valid(struct list_head *new, struct list_head *prev,
-		      struct list_head *next)
+bool ___list_add_valid(struct list_head *new, struct list_head *prev,
+		       struct list_head *next)
 {
 	if (CHECK_DATA_CORRUPTION(prev == NULL,
 			"list_add corruption. prev is NULL.\n") ||
@@ -37,9 +37,9 @@ bool __list_add_valid(struct list_head *
 
 	return true;
 }
-EXPORT_SYMBOL(__list_add_valid);
+EXPORT_SYMBOL(___list_add_valid);
 
-bool __list_del_entry_valid(struct list_head *entry)
+bool ___list_del_entry_valid(struct list_head *entry)
 {
 	struct list_head *prev, *next;
 
@@ -65,6 +65,5 @@ bool __list_del_entry_valid(struct list_
 		return false;
 
 	return true;
-
 }
-EXPORT_SYMBOL(__list_del_entry_valid);
+EXPORT_SYMBOL(___list_del_entry_valid);
_

Patches currently in -mm which might be from elver@google.com are

compiler-attributes-introduce-the-__preserve_most-function-attribute.patch
list_debug-introduce-inline-wrappers-for-debug-checks.patch
list_debug-introduce-config_debug_list_minimal.patch

