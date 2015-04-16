From: akpm@linux-foundation.org
Subject: [merged] zsmalloc-zsmalloc-documentation.patch removed from -mm
 tree
Date: Thu, 16 Apr 2015 09:53:39 -0700
Message-ID: <552fe913.00ztGp8yG5hwLqQG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42971 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbbDPQsK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:48:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, ddstreet@ieee.org, gunho.lee@lge.com, iamjoonsoo.kim@lge.com, jmarchan@redhat.com, juno.choi@lge.com, ngupta@vflare.org, semenzato@google.com, sergey.senozhatsky@gmail.com, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: zsmalloc documentation
has been removed from the -mm tree.  Its filename was
     zsmalloc-zsmalloc-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: zsmalloc documentation

Create zsmalloc doc which explains design concept and stat information.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Juneho Choi <juno.choi@lge.com>
Cc: Gunho Lee <gunho.lee@lge.com>
Cc: Luigi Semenzato <semenzato@google.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/zsmalloc.txt |   70 ++++++++++++++++++++++++++++++++
 MAINTAINERS                   |    1 
 mm/zsmalloc.c                 |   29 -------------
 3 files changed, 71 insertions(+), 29 deletions(-)

diff -puN /dev/null Documentation/vm/zsmalloc.txt
--- /dev/null
+++ a/Documentation/vm/zsmalloc.txt
@@ -0,0 +1,70 @@
+zsmalloc
+--------
+
+This allocator is designed for use with zram. Thus, the allocator is
+supposed to work well under low memory conditions. In particular, it
+never attempts higher order page allocation which is very likely to
+fail under memory pressure. On the other hand, if we just use single
+(0-order) pages, it would suffer from very high fragmentation --
+any object of size PAGE_SIZE/2 or larger would occupy an entire page.
+This was one of the major issues with its predecessor (xvmalloc).
+
+To overcome these issues, zsmalloc allocates a bunch of 0-order pages
+and links them together using various 'struct page' fields. These linked
+pages act as a single higher-order page i.e. an object can span 0-order
+page boundaries. The code refers to these linked pages as a single entity
+called zspage.
+
+For simplicity, zsmalloc can only allocate objects of size up to PAGE_SIZE
+since this satisfies the requirements of all its current users (in the
+worst case, page is incompressible and is thus stored "as-is" i.e. in
+uncompressed form). For allocation requests larger than this size, failure
+is returned (see zs_malloc).
+
+Additionally, zs_malloc() does not return a dereferenceable pointer.
+Instead, it returns an opaque handle (unsigned long) which encodes actual
+location of the allocated object. The reason for this indirection is that
+zsmalloc does not keep zspages permanently mapped since that would cause
+issues on 32-bit systems where the VA region for kernel space mappings
+is very small. So, before using the allocating memory, the object has to
+be mapped using zs_map_object() to get a usable pointer and subsequently
+unmapped using zs_unmap_object().
+
+stat
+----
+
+With CONFIG_ZSMALLOC_STAT, we could see zsmalloc internal information via
+/sys/kernel/debug/zsmalloc/<user name>. Here is a sample of stat output:
+
+# cat /sys/kernel/debug/zsmalloc/zram0/classes
+
+ class  size almost_full almost_empty obj_allocated   obj_used pages_used pages_per_zspage
+    ..
+    ..
+     9   176           0            1           186        129          8                4
+    10   192           1            0          2880       2872        135                3
+    11   208           0            1           819        795         42                2
+    12   224           0            1           219        159         12                4
+    ..
+    ..
+
+
+class: index
+size: object size zspage stores
+almost_empty: the number of ZS_ALMOST_EMPTY zspages(see below)
+almost_full: the number of ZS_ALMOST_FULL zspages(see below)
+obj_allocated: the number of objects allocated
+obj_used: the number of objects allocated to the user
+pages_used: the number of pages allocated for the class
+pages_per_zspage: the number of 0-order pages to make a zspage
+
+We assign a zspage to ZS_ALMOST_EMPTY fullness group when:
+      n <= N / f, where
+n = number of allocated objects
+N = total number of objects zspage can store
+f = fullness_threshold_frac(ie, 4 at the moment)
+
+Similarly, we assign zspage to:
+      ZS_ALMOST_FULL  when n > N / f
+      ZS_EMPTY        when n == 0
+      ZS_FULL         when n == N
diff -puN MAINTAINERS~zsmalloc-zsmalloc-documentation MAINTAINERS
--- a/MAINTAINERS~zsmalloc-zsmalloc-documentation
+++ a/MAINTAINERS
@@ -10972,6 +10972,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/zsmalloc.c
 F:	include/linux/zsmalloc.h
+F:	Documentation/vm/zsmalloc.txt
 
 ZSWAP COMPRESSED SWAP CACHING
 M:	Seth Jennings <sjennings@variantweb.net>
diff -puN mm/zsmalloc.c~zsmalloc-zsmalloc-documentation mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-zsmalloc-documentation
+++ a/mm/zsmalloc.c
@@ -12,35 +12,6 @@
  */
 
 /*
- * This allocator is designed for use with zram. Thus, the allocator is
- * supposed to work well under low memory conditions. In particular, it
- * never attempts higher order page allocation which is very likely to
- * fail under memory pressure. On the other hand, if we just use single
- * (0-order) pages, it would suffer from very high fragmentation --
- * any object of size PAGE_SIZE/2 or larger would occupy an entire page.
- * This was one of the major issues with its predecessor (xvmalloc).
- *
- * To overcome these issues, zsmalloc allocates a bunch of 0-order pages
- * and links them together using various 'struct page' fields. These linked
- * pages act as a single higher-order page i.e. an object can span 0-order
- * page boundaries. The code refers to these linked pages as a single entity
- * called zspage.
- *
- * For simplicity, zsmalloc can only allocate objects of size up to PAGE_SIZE
- * since this satisfies the requirements of all its current users (in the
- * worst case, page is incompressible and is thus stored "as-is" i.e. in
- * uncompressed form). For allocation requests larger than this size, failure
- * is returned (see zs_malloc).
- *
- * Additionally, zs_malloc() does not return a dereferenceable pointer.
- * Instead, it returns an opaque handle (unsigned long) which encodes actual
- * location of the allocated object. The reason for this indirection is that
- * zsmalloc does not keep zspages permanently mapped since that would cause
- * issues on 32-bit systems where the VA region for kernel space mappings
- * is very small. So, before using the allocating memory, the object has to
- * be mapped using zs_map_object() to get a usable pointer and subsequently
- * unmapped using zs_unmap_object().
- *
  * Following is how we use various fields and flags of underlying
  * struct page(s) to form a zspage.
  *
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
x86-add-pmd_-for-thp.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp-fix.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-free-swp_entry-in-madvise_free.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zram-cosmetic-zram_attr_ro-code-formatting-tweak.patch
zram-use-idr-instead-of-zram_devices-array.patch
zram-factor-out-device-reset-from-reset_store.patch
zram-reorganize-code-layout.patch
zram-add-dynamic-device-add-remove-functionality.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-remove-max_num_devices-limitation.patch
zram-report-every-added-and-removed-device.patch
zram-trivial-correct-flag-operations-comment.patch
zram-return-zram-device_id-value-from-zram_add.patch
zram-introduce-automatic-device_id-generation.patch
zram-introduce-automatic-device_id-generation-fix.patch
zram-do-not-let-user-enforce-new-device-dev_id.patch

