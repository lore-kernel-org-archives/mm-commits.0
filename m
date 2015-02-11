From: akpm@linux-foundation.org
Subject: [merged]
 hugetlb-sysctl-pass-extra1-=-null-rather-then-extra1-=-zero.patch removed
 from -mm tree
Date: Wed, 11 Feb 2015 12:23:09 -0800
Message-ID: <54dbba2d.UCBfozvuoHBetgXs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41048 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbbBKUXK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:23:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, dvyukov@google.com, manfred@colorfullife.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlb: remove unnecessary lower bound on sysctl handlers"?
has been removed from the -mm tree.  Its filename was
     hugetlb-sysctl-pass-extra1-=-null-rather-then-extra1-=-zero.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: mm, hugetlb: remove unnecessary lower bound on sysctl handlers"?

Commit ed4d4902ebdd ("mm, hugetlb: remove hugetlb_zero and
hugetlb_infinity") replaced 'unsigned long hugetlb_zero' with 'int zero'
leading to out-of-bounds access in proc_doulongvec_minmax().  Use '.extra1
= NULL' instead of '.extra1 = &zero'.  Passing NULL is equivalent to
passing minimal value, which is 0 for unsigned types.

Fixes: ed4d4902ebdd ("mm, hugetlb: remove hugetlb_zero and hugetlb_infinity")
Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Suggested-by: Manfred Spraul <manfred@colorfullife.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN kernel/sysctl.c~hugetlb-sysctl-pass-extra1-=-null-rather-then-extra1-=-zero kernel/sysctl.c
--- a/kernel/sysctl.c~hugetlb-sysctl-pass-extra1-=-null-rather-then-extra1-=-zero
+++ a/kernel/sysctl.c
@@ -1248,7 +1248,6 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= hugetlb_sysctl_handler,
-		.extra1		= &zero,
 	},
 #ifdef CONFIG_NUMA
 	{
@@ -1257,7 +1256,6 @@ static struct ctl_table vm_table[] = {
 		.maxlen         = sizeof(unsigned long),
 		.mode           = 0644,
 		.proc_handler   = &hugetlb_mempolicy_sysctl_handler,
-		.extra1		= &zero,
 	},
 #endif
 	 {
@@ -1280,7 +1278,6 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= hugetlb_overcommit_handler,
-		.extra1		= &zero,
 	},
 #endif
 	{
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

origin.patch
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

