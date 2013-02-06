From: akpm@linux-foundation.org
Subject: + debugging-keep-track-of-page-owner-now-depends-on-stacktrace_support.patch added to -mm tree
Date: Wed, 06 Feb 2013 12:31:03 -0800
Message-ID: <20130206203103.D224A31C102@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:43548 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756968Ab3BFUbE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 15:31:04 -0500
Received: by mail-ye0-f202.google.com with SMTP id r9so194634yen.1
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 12:31:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dave@linux.vnet.ibm.com, fengguang.wu@intel.com


The patch titled
     Subject: PAGE_OWNER now depends on STACKTRACE_SUPPORT
has been added to the -mm tree.  Its filename is
     debugging-keep-track-of-page-owner-now-depends-on-stacktrace_support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: PAGE_OWNER now depends on STACKTRACE_SUPPORT

One of the enhancements I made to the PAGE_OWNER code was to make
it use the generic stack trace support.  However, there are some
architectures that do not support it, like m68k.  So, make
PAGE_OWNER also depend on having STACKTRACE_SUPPORT.

This isn't ideal since it restricts the number of places
PAGE_OWNER runs now, but it at least hits all the major
architectures.

tree:   git://git.cmpxchg.org/linux-mmotm.git master
head:   83b324c5ff5cca85bbeb2ba913d465f108afe472
commit: 2a561c9d47c295ed91984c2b916a4dd450ee0279 [484/499] debugging-keep-track-of-page-owners-fix
config: make ARCH=m68k allmodconfig

All warnings:

warning: (PAGE_OWNER && STACK_TRACER && BLK_DEV_IO_TRACE && KMEMCHECK) selects STACKTRACE which has unmet direct dependencies (STACKTRACE_SUPPORT)

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/Kconfig.debug~debugging-keep-track-of-page-owner-now-depends-on-stacktrace_support lib/Kconfig.debug
--- a/lib/Kconfig.debug~debugging-keep-track-of-page-owner-now-depends-on-stacktrace_support
+++ a/lib/Kconfig.debug
@@ -101,7 +101,7 @@ config UNUSED_SYMBOLS
 
 config PAGE_OWNER
 	bool "Track page owner"
-	depends on DEBUG_KERNEL
+	depends on DEBUG_KERNEL && STACKTRACE_SUPPORT
 	select DEBUG_FS
 	select STACKTRACE
 	help
_

Patches currently in -mm which might be from dave@linux.vnet.ibm.com are

linux-next.patch
mm-add-section_in_page_flags.patch
mm-add-use-zone_end_pfn-and-zone_spans_pfn.patch
mm-add-zone_is_empty-and-zone_is_initialized.patch
mm-page_alloc-add-a-vm_bug-in-__free_one_page-if-the-zone-is-uninitialized.patch
mmzone-add-pgdat_end_pfnis_empty-helpers-consolidate.patch
mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries.patch
mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries-fix.patch
mm-add-helper-ensure_zone_is_initialized.patch
mm-memory_hotplug-use-ensure_zone_is_initialized.patch
mm-memory_hotplug-use-pgdat_end_pfn-instead-of-open-coding-the-same.patch
drop_caches-add-some-documentation-and-info-messsge.patch
debugging-keep-track-of-page-owners-fix.patch
debugging-keep-track-of-page-owners-fix-2.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix.patch
debugging-keep-track-of-page-owner-now-depends-on-stacktrace_support.patch

