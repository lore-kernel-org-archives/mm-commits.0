From: akpm@linux-foundation.org
Subject: [folded-merged]
 add-kernel-address-sanitizer-infrastructure-fix.patch removed from -mm tree
Date: Fri, 13 Feb 2015 14:29:16 -0800
Message-ID: <54de7abc.XcHtCkerAwHe53Zu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51193 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbbBMW3R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 17:29:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix build warnings
has been removed from the -mm tree.  Its filename was
     add-kernel-address-sanitizer-infrastructure-fix.patch

This patch was dropped because it was folded into add-kernel-address-sanitizer-infrastructure.patch

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: kasan: fix build warnings

Some versions of gcc produce warning instead of error when
-fsanitize flag uses unsupported argument:
	https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61065

This breaks our detection of whether -fsanitize=kernel-address
is supported by compiler or not. Thus we have tons of build
warnings like this:
	x86_64-linux-gcc: warning: unrecognized argument to -fsanitize= option: 'kernel-address'

Passing -Werror into $(call cc-option) will fix this problem
as gcc will error out now.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.kasan |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/Makefile.kasan~add-kernel-address-sanitizer-infrastructure-fix scripts/Makefile.kasan
--- a/scripts/Makefile.kasan~add-kernel-address-sanitizer-infrastructure-fix
+++ a/scripts/Makefile.kasan
@@ -5,13 +5,13 @@ else
 	call_threshold := 0
 endif
 
-CFLAGS_KASAN_MINIMAL := $(call cc-option, -fsanitize=kernel-address)
+CFLAGS_KASAN_MINIMAL := -fsanitize=kernel-address
 
 CFLAGS_KASAN := $(call cc-option, -fsanitize=kernel-address \
 		-fasan-shadow-offset=$(CONFIG_KASAN_SHADOW_OFFSET) \
 		--param asan-instrumentation-with-call-threshold=$(call_threshold))
 
-ifeq ($(CFLAGS_KASAN_MINIMAL),)
+ifeq ($(call cc-option, $(CFLAGS_KASAN_MINIMAL) -Werror),)
         $(warning Cannot use CONFIG_KASAN: \
             -fsanitize=kernel-address is not supported by compiler)
 else
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

origin.patch
module_device_table-fix-some-callsites.patch
compiler-introduce-__aliassymbol-shortcut.patch
add-kernel-address-sanitizer-infrastructure.patch
kasan-disable-memory-hotplug.patch
x86_64-add-kasan-support.patch
x86_64-add-kasan-support-fix.patch
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

