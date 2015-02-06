From: akpm@linux-foundation.org
Subject: + kasan-enable-instrumentation-of-global-variables-fix-2.patch
 added to -mm tree
Date: Fri, 06 Feb 2015 13:03:13 -0800
Message-ID: <54d52c11.m//1Vo5HomU1VkN/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52785 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbbBFVDP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2015 16:03:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-enable-instrumentation-of-global-variables-fix-2
has been added to the -mm tree.  Its filename is
     kasan-enable-instrumentation-of-global-variables-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-enable-instrumentation-of-global-variables-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-enable-instrumentation-of-global-variables-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: kasan-enable-instrumentation-of-global-variables-fix-2

Disable broken globals instrumentation for GCC 4.9.2

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.kasan |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/Makefile.kasan~kasan-enable-instrumentation-of-global-variables-fix-2 scripts/Makefile.kasan
--- a/scripts/Makefile.kasan~kasan-enable-instrumentation-of-global-variables-fix-2
+++ a/scripts/Makefile.kasan
@@ -5,7 +5,7 @@ else
 	call_threshold := 0
 endif
 
-CFLAGS_KASAN_MINIMAL := -fsanitize=kernel-address --param asan-globals=1
+CFLAGS_KASAN_MINIMAL := -fsanitize=kernel-address
 
 CFLAGS_KASAN := $(call cc-option, -fsanitize=kernel-address \
 		-fasan-shadow-offset=$(CONFIG_KASAN_SHADOW_OFFSET) \
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

hugetlb-sysctl-pass-extra1-=-null-rather-then-extra1-=-zero.patch
mm-hugetlb-fix-type-of-hugetlb_treat_as_movable-variable.patch
proc-pagemap-walk-page-tables-under-pte-lock.patch
module_device_table-fix-some-callsites.patch
module_device_table-fix-some-callsites-fix.patch
compiler-introduce-__aliassymbol-shortcut.patch
add-kernel-address-sanitizer-infrastructure.patch
add-kernel-address-sanitizer-infrastructure-fix.patch
kasan-disable-memory-hotplug.patch
x86_64-add-kasan-support.patch
mm-page_alloc-add-kasan-hooks-on-alloc-and-free-paths.patch
mm-slub-introduce-virt_to_obj-function.patch
mm-slub-share-object_err-function.patch
mm-slub-introduce-metadata_access_enable-metadata_access_disable.patch
mm-slub-add-kernel-address-sanitizer-support-for-slub-allocator.patch
fs-dcache-manually-unpoison-dname-after-allocation-to-shut-up-kasans-reports.patch
kmemleak-disable-kasan-instrumentation-for-kmemleak.patch
lib-add-kasan-test-module.patch
x86_64-kasan-add-interceptors-for-memset-memmove-memcpy-functions.patch
kasan-enable-stack-instrumentation.patch
mm-vmalloc-add-flag-preventing-guard-hole-allocation.patch
mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range.patch
kernel-add-support-for-init_array-constructors.patch
module-fix-types-of-device-tables-aliases.patch
kasan-enable-instrumentation-of-global-variables.patch
kasan-enable-instrumentation-of-global-variables-fix.patch
kasan-enable-instrumentation-of-global-variables-fix-2.patch
kasan-enable-instrumentation-of-global-variables-fix-2-fix.patch
linux-next.patch

