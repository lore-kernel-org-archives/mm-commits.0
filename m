From: akpm@linux-foundation.org
Subject: + highmem-remove-unneeded-ifdef-config_trace_irqflags_support-for-debug_kmap_atomic.patch added to -mm tree
Date: Thu, 13 May 2010 14:15:49 -0700
Message-ID: <201005132115.o4DLFnm6020741@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752760Ab0EMVQV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 May 2010 17:16:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, akpm@linux-foundation.org


The patch titled
     highmem: remove unneeded #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT for debug_kmap_atomic()
has been added to the -mm tree.  Its filename is
     highmem-remove-unneeded-ifdef-config_trace_irqflags_support-for-debug_kmap_atomic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: highmem: remove unneeded #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT for debug_kmap_atomic()
From: Akinobu Mita <akinobu.mita@gmail.com>

In f4112de6b679d84bd9b9681c7504be7bdfb7c7d5 ("mm: introduce
debug_kmap_atomic") I said that debug_kmap_atomic() needs
CONFIG_TRACE_IRQFLAGS_SUPPORT.

It was wrong.  (I thought irqs_disabled() is only available when the
architecture has CONFIG_TRACE_IRQFLAGS_SUPPORT)

Remove the #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT check to enable
kmap_atomic() debugging for the architectures which do not have
CONFIG_TRACE_IRQFLAGS_SUPPORT.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    2 +-
 mm/highmem.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/highmem.h~highmem-remove-unneeded-ifdef-config_trace_irqflags_support-for-debug_kmap_atomic include/linux/highmem.h
--- a/include/linux/highmem.h~highmem-remove-unneeded-ifdef-config_trace_irqflags_support-for-debug_kmap_atomic
+++ a/include/linux/highmem.h
@@ -27,7 +27,7 @@ static inline void invalidate_kernel_vma
 
 #include <asm/kmap_types.h>
 
-#if defined(CONFIG_DEBUG_HIGHMEM) && defined(CONFIG_TRACE_IRQFLAGS_SUPPORT)
+#ifdef CONFIG_DEBUG_HIGHMEM
 
 void debug_kmap_atomic(enum km_type type);
 
diff -puN mm/highmem.c~highmem-remove-unneeded-ifdef-config_trace_irqflags_support-for-debug_kmap_atomic mm/highmem.c
--- a/mm/highmem.c~highmem-remove-unneeded-ifdef-config_trace_irqflags_support-for-debug_kmap_atomic
+++ a/mm/highmem.c
@@ -422,7 +422,7 @@ void __init page_address_init(void)
 
 #endif	/* defined(CONFIG_HIGHMEM) && !defined(WANT_PAGE_VIRTUAL) */
 
-#if defined(CONFIG_DEBUG_HIGHMEM) && defined(CONFIG_TRACE_IRQFLAGS_SUPPORT)
+#ifdef CONFIG_DEBUG_HIGHMEM
 
 void debug_kmap_atomic(enum km_type type)
 {
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
highmem-remove-unneeded-ifdef-config_trace_irqflags_support-for-debug_kmap_atomic.patch
cpu-hotplug-introduce-cpu_notify-__cpu_notify-cpu_notify_nofail.patch
cpu-hotplug-return-better-errno-on-cpu-hotplug-failure.patch
notifier-change-notifier_from_errno0-to-return-notify_ok.patch
x86-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
topology-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
kernel-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
slab-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
iucv-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
ehca-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
s390-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
md-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
fault-injection-add-cpu-notifier-error-injection-module.patch
fault-injection-add-cpu-notifier-error-injection-module-fix.patch

