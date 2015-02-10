From: akpm@linux-foundation.org
Subject: + x86_64-add-kasan-support-fix.patch added to -mm tree
Date: Tue, 10 Feb 2015 12:07:22 -0800
Message-ID: <54da64fa.np+iEnavASwJ6Zd2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48957 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbbBJUHX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Feb 2015 15:07:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, jim.epost@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86_64-add-kasan-support-fix
has been added to the -mm tree.  Its filename is
     x86_64-add-kasan-support-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86_64-add-kasan-support-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86_64-add-kasan-support-fix.patch

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
Subject: x86_64-add-kasan-support-fix

Combination of CONFIG_SPARSEMEM_VMEMMAP=n, CONFIG_KASAN=y
cause build error:
	arch/x86/built-in.o: In function `populate_zero_shadow':
	kasan_init_64.c:(.init.text+0xe2cc): undefined reference to
	`vmemmap_alloc_block'
	kasan_init_64.c:(.init.text+0xe3ab): undefined reference to
	`vmemmap_alloc_block'
	kasan_init_64.c:(.init.text+0xe483): undefined reference to
	`vmemmap_alloc_block'
	arch/x86/built-in.o: In function `kasan_init':
	(.init.text+0xe65d): undefined reference to `vmemmap_populate'
	arch/x86/built-in.o: In function `kasan_init':
	(.init.text+0xe6ea): undefined reference to `vmemmap_populate'
	make: *** [vmlinux] Error 1

x86_64-specific part of KASAN depends on SPARSEMEM_VMEMMAP.
Express this in Kconfig.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Reported-by: Jim Davis <jim.epost@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/Kconfig~x86_64-add-kasan-support-fix arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86_64-add-kasan-support-fix
+++ a/arch/x86/Kconfig
@@ -84,7 +84,7 @@ config X86
 	select HAVE_CMPXCHG_LOCAL
 	select HAVE_CMPXCHG_DOUBLE
 	select HAVE_ARCH_KMEMCHECK
-	select HAVE_ARCH_KASAN if X86_64
+	select HAVE_ARCH_KASAN if X86_64 && SPARSEMEM_VMEMMAP
 	select HAVE_USER_RETURN_NOTIFIER
 	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select HAVE_ARCH_JUMP_LABEL
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
linux-next.patch

