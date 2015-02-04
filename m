From: akpm@linux-foundation.org
Subject: + add-kernel-address-sanitizer-infrastructure-fix.patch added to
 -mm tree
Date: Wed, 04 Feb 2015 14:00:52 -0800
Message-ID: <54d29694.3SqneLnyM0QSh0Va%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46858 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927AbbBDWAx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Feb 2015 17:00:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix build warnings
has been added to the -mm tree.  Its filename is
     add-kernel-address-sanitizer-infrastructure-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/add-kernel-address-sanitizer-infrastructure-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/add-kernel-address-sanitizer-infrastructure-fix.patch

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

hugetlb-sysctl-pass-extra1-=-null-rather-then-extra1-=-zero.patch
mm-hugetlb-fix-type-of-hugetlb_treat_as_movable-variable.patch
proc-pagemap-walk-page-tables-under-pte-lock.patch
module_device_table-fix-some-callsites.patch
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
linux-next.patch

