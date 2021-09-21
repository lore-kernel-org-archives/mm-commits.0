Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0577C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 21 Sep 2021 18:51:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCB9161242
	for <mm-commits@archiver.kernel.org>; Tue, 21 Sep 2021 18:51:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbhIUSwx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Sep 2021 14:52:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231615AbhIUSwt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 21 Sep 2021 14:52:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE9F961211;
        Tue, 21 Sep 2021 18:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632250281;
        bh=nrN1n9CIV0k6WVf82UgosvvEjmJ01KhXX2NHg/gl/nY=;
        h=Date:From:To:Subject:From;
        b=c63XjBNj0qmTAR4jJmLMJRqiAme4ZRJfLfyTalWlUlPVdUv4nJKBmmFGwG+vZVCEv
         O48gw8jQQmhx3jvGujIYP6jGuC3y9YJ+Lr2vBNJHfAbxQ4chru8LzLA+5K2vXDFb79
         ErSA35NWHA5zees89Bad6RfpiZYX8P30GaClTAd4=
Date:   Tue, 21 Sep 2021 11:51:20 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, jmorris@namei.org,
        keescook@chromium.org, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, serge@hallyn.com,
        steve@sk2.org, vbabka@suse.cz
Subject:  + mm-remove-hardened_usercopy_fallback.patch added to -mm
 tree
Message-ID: <20210921185120.2LdWxQnjC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove HARDENED_USERCOPY_FALLBACK
has been added to the -mm tree.  Its filename is
     mm-remove-hardened_usercopy_fallback.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-hardened_usercopy_fallback.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-hardened_usercopy_fallback.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Kitt <steve@sk2.org>
Subject: mm: remove HARDENED_USERCOPY_FALLBACK

This has served its purpose and is no longer used.  All usercopy
violations appear to have been handled by now, any remaining instances (or
new bugs) will cause copies to be rejected.

This isn't a direct revert of commit 2d891fbc3bb6 ("usercopy: Allow strict
enforcement of whitelists"); since usercopy_fallback is effectively 0, the
fallback handling is removed too.

This also removes the usercopy_fallback module parameter on slab_common.

Link: https://github.com/KSPP/linux/issues/153
Link: https://lkml.kernel.org/r/20210921061149.1091163-1-steve@sk2.org
Signed-off-by: Stephen Kitt <steve@sk2.org>
Suggested-by: Kees Cook <keescook@chromium.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E . Hallyn" <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/configs/skiroot_defconfig |    1 -
 include/linux/slab.h                   |    2 --
 mm/slab.c                              |   13 -------------
 mm/slab_common.c                       |    8 --------
 mm/slub.c                              |   14 --------------
 security/Kconfig                       |   14 --------------
 6 files changed, 52 deletions(-)

--- a/arch/powerpc/configs/skiroot_defconfig~mm-remove-hardened_usercopy_fallback
+++ a/arch/powerpc/configs/skiroot_defconfig
@@ -275,7 +275,6 @@ CONFIG_NLS_UTF8=y
 CONFIG_ENCRYPTED_KEYS=y
 CONFIG_SECURITY=y
 CONFIG_HARDENED_USERCOPY=y
-# CONFIG_HARDENED_USERCOPY_FALLBACK is not set
 CONFIG_HARDENED_USERCOPY_PAGESPAN=y
 CONFIG_FORTIFY_SOURCE=y
 CONFIG_SECURITY_LOCKDOWN_LSM=y
--- a/include/linux/slab.h~mm-remove-hardened_usercopy_fallback
+++ a/include/linux/slab.h
@@ -142,8 +142,6 @@ struct mem_cgroup;
 void __init kmem_cache_init(void);
 bool slab_is_available(void);
 
-extern bool usercopy_fallback;
-
 struct kmem_cache *kmem_cache_create(const char *name, unsigned int size,
 			unsigned int align, slab_flags_t flags,
 			void (*ctor)(void *));
--- a/mm/slab.c~mm-remove-hardened_usercopy_fallback
+++ a/mm/slab.c
@@ -4207,19 +4207,6 @@ void __check_heap_object(const void *ptr
 	    n <= cachep->useroffset - offset + cachep->usersize)
 		return;
 
-	/*
-	 * If the copy is still within the allocated object, produce
-	 * a warning instead of rejecting the copy. This is intended
-	 * to be a temporary method to find any missing usercopy
-	 * whitelists.
-	 */
-	if (usercopy_fallback &&
-	    offset <= cachep->object_size &&
-	    n <= cachep->object_size - offset) {
-		usercopy_warn("SLAB object", cachep->name, to_user, offset, n);
-		return;
-	}
-
 	usercopy_abort("SLAB object", cachep->name, to_user, offset, n);
 }
 #endif /* CONFIG_HARDENED_USERCOPY */
--- a/mm/slab_common.c~mm-remove-hardened_usercopy_fallback
+++ a/mm/slab_common.c
@@ -37,14 +37,6 @@ LIST_HEAD(slab_caches);
 DEFINE_MUTEX(slab_mutex);
 struct kmem_cache *kmem_cache;
 
-#ifdef CONFIG_HARDENED_USERCOPY
-bool usercopy_fallback __ro_after_init =
-		IS_ENABLED(CONFIG_HARDENED_USERCOPY_FALLBACK);
-module_param(usercopy_fallback, bool, 0400);
-MODULE_PARM_DESC(usercopy_fallback,
-		"WARN instead of reject usercopy whitelist violations");
-#endif
-
 static LIST_HEAD(slab_caches_to_rcu_destroy);
 static void slab_caches_to_rcu_destroy_workfn(struct work_struct *work);
 static DECLARE_WORK(slab_caches_to_rcu_destroy_work,
--- a/mm/slub.c~mm-remove-hardened_usercopy_fallback
+++ a/mm/slub.c
@@ -4466,7 +4466,6 @@ void __check_heap_object(const void *ptr
 {
 	struct kmem_cache *s;
 	unsigned int offset;
-	size_t object_size;
 	bool is_kfence = is_kfence_address(ptr);
 
 	ptr = kasan_reset_tag(ptr);
@@ -4499,19 +4498,6 @@ void __check_heap_object(const void *ptr
 	    n <= s->useroffset - offset + s->usersize)
 		return;
 
-	/*
-	 * If the copy is still within the allocated object, produce
-	 * a warning instead of rejecting the copy. This is intended
-	 * to be a temporary method to find any missing usercopy
-	 * whitelists.
-	 */
-	object_size = slab_ksize(s);
-	if (usercopy_fallback &&
-	    offset <= object_size && n <= object_size - offset) {
-		usercopy_warn("SLUB object", s->name, to_user, offset, n);
-		return;
-	}
-
 	usercopy_abort("SLUB object", s->name, to_user, offset, n);
 }
 #endif /* CONFIG_HARDENED_USERCOPY */
--- a/security/Kconfig~mm-remove-hardened_usercopy_fallback
+++ a/security/Kconfig
@@ -163,20 +163,6 @@ config HARDENED_USERCOPY
 	  or are part of the kernel text. This kills entire classes
 	  of heap overflow exploits and similar kernel memory exposures.
 
-config HARDENED_USERCOPY_FALLBACK
-	bool "Allow usercopy whitelist violations to fallback to object size"
-	depends on HARDENED_USERCOPY
-	default y
-	help
-	  This is a temporary option that allows missing usercopy whitelists
-	  to be discovered via a WARN() to the kernel log, instead of
-	  rejecting the copy, falling back to non-whitelisted hardened
-	  usercopy that checks the slab allocation size instead of the
-	  whitelist size. This option will be removed once it seems like
-	  all missing usercopy whitelists have been identified and fixed.
-	  Booting with "slab_common.usercopy_fallback=Y/N" can change
-	  this setting.
-
 config HARDENED_USERCOPY_PAGESPAN
 	bool "Refuse to copy allocations that span multiple pages"
 	depends on HARDENED_USERCOPY
_

Patches currently in -mm which might be from steve@sk2.org are

mm-remove-hardened_usercopy_fallback.patch

