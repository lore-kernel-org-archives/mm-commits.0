From: akpm@linux-foundation.org
Subject: +
 mm-disable-fault-around-on-emulated-access-bit-architecture.patch added to
 -mm tree
Date: Wed, 18 May 2016 14:24:02 -0700
Message-ID: <573cdd72.u1PUiNgxTG1yyPRK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43694 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbcERVYD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 May 2016 17:24:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: disable fault around on emulated access bit architecture
has been added to the -mm tree.  Its filename is
     mm-disable-fault-around-on-emulated-access-bit-architecture.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-disable-fault-around-on-emulated-access-bit-architecture.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-disable-fault-around-on-emulated-access-bit-architecture.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: disable fault around on emulated access bit architecture

fault_around aims to reduce minor faults of file-backed pages via
speculative ahead pte mapping and relying on readahead logic.  However, on
non-HW access bit architecture the benefit is highly limited because they
should emulate the young bit with minor faults for reclaim's page aging
algorithm.  IOW, we cannot reduce minor faults on those architectures.

I did quick a test on my ARM machine.

512M file mmap sequential every word read on eSATA drive 4 times.  stddev
is stable.

= fault_around 4096 =
elapsed time(usec): 6747645

= fault_around 65536 =
elapsed time(usec): 6709263

0.5% gain.

Even when I tested it with eMMC there is no gain because I guess with slow
storage the major fault is the dominant factor.

Also, fault_around has the side effect of shrinking slab more aggressively
and causes higher vmpressure, so if such speculation fails, it can evict
slab more which can result in page I/O (e.g., inode cache).  In the end,
it would make void any benefit of fault_around.

So let's make the default "disabled" on those architectures.

Link: http://lkml.kernel.org/r/20160518014229.GB21538@bbox
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/memory.c~mm-disable-fault-around-on-emulated-access-bit-architecture mm/memory.c
--- a/mm/memory.c~mm-disable-fault-around-on-emulated-access-bit-architecture
+++ a/mm/memory.c
@@ -2899,8 +2899,16 @@ void do_set_pte(struct vm_area_struct *v
 	update_mmu_cache(vma, address, pte);
 }
 
+/*
+ * If architecture emulates "accessed" or "young" bit without HW support,
+ * there is no much gain with fault_around.
+ */
 static unsigned long fault_around_bytes __read_mostly =
+#ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
+	PAGE_SIZE;
+#else
 	rounddown_pow_of_two(65536);
+#endif
 
 #ifdef CONFIG_DEBUG_FS
 static int fault_around_bytes_get(void *data, u64 *val)
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-disable-fault-around-on-emulated-access-bit-architecture.patch
zsmalloc-use-first_page-rather-than-page.patch
zsmalloc-clean-up-many-bug_on.patch
zsmalloc-reordering-function-parameter.patch
zsmalloc-remove-unused-pool-param-in-obj_free.patch
zram-introduce-per-device-debug_stat-sysfs-node-update.patch

