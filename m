From: akpm@linux-foundation.org
Subject: +
 fs-dcache-manually-unpoison-dname-after-allocation-to-shut-up-kasans-reports.patch added to -mm tree
Date: Tue, 03 Feb 2015 15:05:15 -0800
Message-ID: <54d1542b.sGL/jTHIJq8ji1/x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54638 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbbBCXFR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2015 18:05:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, adech.fo@gmail.com, andi@firstfloor.org, cl@linux.com, dave.hansen@intel.com, dmitryc@google.com, dvyukov@google.com, hpa@zytor.com, iamjoonsoo.kim@lge.com, kcc@google.com, koct9i@gmail.com, mingo@elte.hu, penberg@kernel.org, rientjes@google.com, sasha.levin@oracle.com, tetra2005@gmail.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: dcache: manually unpoison dname after allocation to shut up kasan's reports
has been added to the -mm tree.  Its filename is
     fs-dcache-manually-unpoison-dname-after-allocation-to-shut-up-kasans-reports.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-dcache-manually-unpoison-dname-after-allocation-to-shut-up-kasans-reports.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-dcache-manually-unpoison-dname-after-allocation-to-shut-up-kasans-reports.patch

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
Subject: fs: dcache: manually unpoison dname after allocation to shut up kasan's reports

We need to manually unpoison rounded up allocation size for dname to avoid
kasan's reports in dentry_string_cmp().  When CONFIG_DCACHE_WORD_ACCESS=y
dentry_string_cmp may access few bytes beyound requested in kmalloc()
size.

dentry_string_cmp() relates on that fact that dentry allocated using
kmalloc and kmalloc internally round up allocation size.  So this is not a
bug, but this makes kasan to complain about such accesses.  To avoid such
reports we mark rounded up allocation size in shadow as accessible.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Konstantin Serebryany <kcc@google.com>
Cc: Dmitry Chernenkov <dmitryc@google.com>
Cc: Andrey Konovalov <adech.fo@gmail.com>
Cc: Yuri Gribov <tetra2005@gmail.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/dcache.c~fs-dcache-manually-unpoison-dname-after-allocation-to-shut-up-kasans-reports fs/dcache.c
--- a/fs/dcache.c~fs-dcache-manually-unpoison-dname-after-allocation-to-shut-up-kasans-reports
+++ a/fs/dcache.c
@@ -38,6 +38,8 @@
 #include <linux/prefetch.h>
 #include <linux/ratelimit.h>
 #include <linux/list_lru.h>
+#include <linux/kasan.h>
+
 #include "internal.h"
 #include "mount.h"
 
@@ -1430,6 +1432,9 @@ struct dentry *__d_alloc(struct super_bl
 		}
 		atomic_set(&p->u.count, 1);
 		dname = p->name;
+		if (IS_ENABLED(CONFIG_DCACHE_WORD_ACCESS))
+			kasan_unpoison_shadow(dname,
+				round_up(name->len + 1,	sizeof(unsigned long)));
 	} else  {
 		dname = dentry->d_iname;
 	}	
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

compiler-introduce-__aliassymbol-shortcut.patch
add-kernel-address-sanitizer-infrastructure.patch
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
hugetlb-sysctl-pass-extra1-=-null-rather-then-extra1-=-zero.patch
mm-hugetlb-fix-type-of-hugetlb_treat_as_movable-variable.patch
proc-pagemap-walk-page-tables-under-pte-lock.patch
linux-next.patch

