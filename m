From: akpm@osdl.org
Subject: + remove-references-to-obsolete-kernel-config-option-debug_rwsems.patch added to -mm tree
Date: Wed, 24 Jan 2007 20:51:10 -0800
Message-ID: <200701250451.l0P4pAKg006168@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46741 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933222AbXAYEvq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 23:51:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, dhowells@redhat.com, mingo@elte.hu


The patch titled
     Remove references to obsolete kernel config option DEBUG_RWSEMS
has been added to the -mm tree.  Its filename is
     remove-references-to-obsolete-kernel-config-option-debug_rwsems.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove references to obsolete kernel config option DEBUG_RWSEMS
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the few references to the obsolete kernel config option
DEBUG_RWSEMS.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 lib/Kconfig.debug |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN lib/Kconfig.debug~remove-references-to-obsolete-kernel-config-option-debug_rwsems lib/Kconfig.debug
--- a/lib/Kconfig.debug~remove-references-to-obsolete-kernel-config-option-debug_rwsems
+++ a/lib/Kconfig.debug
@@ -181,19 +181,11 @@ config DEBUG_MUTEXES
 	 This feature allows mutex semantics violations to be detected and
 	 reported.
 
-config DEBUG_RWSEMS
-	bool "RW-sem debugging: basic checks"
-	depends on DEBUG_KERNEL
-	help
-	 This feature allows read-write semaphore semantics violations to
-	 be detected and reported.
-
 config DEBUG_LOCK_ALLOC
 	bool "Lock debugging: detect incorrect freeing of live locks"
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
 	select DEBUG_SPINLOCK
 	select DEBUG_MUTEXES
-	select DEBUG_RWSEMS
 	select LOCKDEP
 	help
 	 This feature will check whether any held lock (spinlock, rwlock,
@@ -209,7 +201,6 @@ config PROVE_LOCKING
 	select LOCKDEP
 	select DEBUG_SPINLOCK
 	select DEBUG_MUTEXES
-	select DEBUG_RWSEMS
 	select DEBUG_LOCK_ALLOC
 	default n
 	help
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
fix-various-kernel-doc-in-header-files.patch
git-alsa.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
get-rid-of-double-zeroing-of-allocated-pages.patch
remove-unnecessary-memset0-calls-after-kzalloc-calls.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
numerous-fixes-to-kernel-doc-info-in-source-files.patch
remove-a-couple-final-references-to-obsolete-verify_area.patch
remove-the-last-reference-to-rwlock_is_locked-macro.patch
extend-the-set-of-__attribute__-shortcut-macros.patch
remove-final-reference-to-superfluous-smp_commence.patch
replace-regular-code-with-appropriate-calls-to-container_of.patch
remove-dead-kernel-config-option-aedsp16_mpu401.patch
remove-references-to-obsolete-kernel-config-option-debug_rwsems.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
