From: akpm@linux-foundation.org
Subject: + mm-internalh-dont-split-printk-call-in-two.patch added to -mm
 tree
Date: Wed, 04 Feb 2015 15:51:15 -0800
Message-ID: <54d2b073.nFBeShwYBvQHe6tr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48812 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823AbbBDXvR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Feb 2015 18:51:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, hughd@google.com, iamjoonsoo.kim@lge.com, lizefan@huawei.com, mgorman@suse.de, mina86@mina86.com, paul.gortmaker@windriver.com, peterz@infradead.org, pintu.k@samsung.com, riel@redhat.com, rientjes@google.com, tim.c.chen@linux.intel.co, tj@kernel.org, vbabka@suse.cz, vishnu.ps@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/internal.h: don't split printk call in two
has been added to the -mm tree.  Its filename is
     mm-internalh-dont-split-printk-call-in-two.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-internalh-dont-split-printk-call-in-two.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-internalh-dont-split-printk-call-in-two.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: mm/internal.h: don't split printk call in two

All users of mminit_dprintk pass a compile-time constant as level, so this
just makes gcc emit a single printk call instead of two.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vishnu Pratap Singh <vishnu.ps@samsung.com>
Cc: Pintu Kumar <pintu.k@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tim Chen <tim.c.chen@linux.intel.co
Cc: Hugh Dickins <hughd@google.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/internal.h~mm-internalh-dont-split-printk-call-in-two mm/internal.h
--- a/mm/internal.h~mm-internalh-dont-split-printk-call-in-two
+++ a/mm/internal.h
@@ -351,8 +351,10 @@ extern int mminit_loglevel;
 #define mminit_dprintk(level, prefix, fmt, arg...) \
 do { \
 	if (level < mminit_loglevel) { \
-		printk(level <= MMINIT_WARNING ? KERN_WARNING : KERN_DEBUG); \
-		printk(KERN_CONT "mminit::" prefix " " fmt, ##arg); \
+		if (level <= MMINIT_WARNING) \
+			printk(KERN_WARNING "mminit::" prefix " " fmt, ##arg); \
+		else \
+			printk(KERN_DEBUG "mminit::" prefix " " fmt, ##arg); \
 	} \
 } while (0)
 
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

mm-internalh-dont-split-printk-call-in-two.patch
mm-page_allocc-pull-out-init-code-from-build_all_zonelists.patch
mm-mm_initc-mark-mminit_verify_zonelist-as-__init.patch
mm-mm_initc-mark-mminit_loglevel-__meminitdata.patch
kernel-cpusetc-mark-cpuset_init_current_mems_allowed-as-__init.patch
kernelh-remove-ancient-__function__-hack.patch
kernelh-remove-ancient-__function__-hack-fix.patch
lib-vsprintfc-consume-p-in-format_decode.patch
lib-vsprintfc-improve-sanity-check-in-vsnprintf.patch
lib-vsprintfc-replace-while-with-do-while-in-skip_atoi.patch
lib-string_get_size-remove-redundant-prefixes.patch
lib-string_get_size-use-32-bit-arithmetic-when-possible.patch
lib-string_get_size-return-void.patch
lib-bitmap-more-signed-unsigned-conversions.patch
linux-nodemaskh-update-bitmap-wrappers-to-take-unsigned-int.patch
linux-cpumaskh-update-bitmap-wrappers-to-take-unsigned-int.patch
lib-bitmap-update-bitmap_onto-to-unsigned.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
lib-bitmap-simplify-bitmap_pos_to_ord.patch
lib-bitmap-simplify-bitmap_ord_to_pos.patch
lib-bitmap-make-the-bits-parameter-of-bitmap_remap-unsigned.patch
lib-remove-strnicmp.patch
lib-interval_treec-simplify-includes.patch
lib-sortc-use-simpler-includes.patch
lib-dynamic_queue_limitsc-simplify-includes.patch
lib-halfmd4c-simplify-includes.patch
lib-idrc-remove-redundant-include.patch
lib-genallocc-remove-redundant-include.patch
lib-list_sortc-rearrange-includes.patch
lib-md5c-simplify-include.patch
lib-llistc-remove-redundant-include.patch
lib-kobject_ueventc-remove-redundant-include.patch
lib-nlattrc-remove-redundant-include.patch
lib-plistc-remove-redundant-include.patch
lib-radix-treec-change-to-simpler-include.patch
lib-show_memc-remove-redundant-include.patch
lib-sortc-move-include-inside-if-0.patch
lib-stmp_devicec-replace-moduleh-include.patch
lib-strncpy_from_userc-replace-moduleh-include.patch
lib-percpu_idac-remove-redundant-includes.patch
lib-lcmc-replace-include.patch
lib-bitmapc-change-prototype-of-bitmap_copy_le.patch
lib-bitmapc-elide-bitmap_copy_le-on-little-endian.patch
lib-bitmap-change-bitmap_shift_right-to-take-unsigned-parameters.patch
lib-bitmap-eliminate-branch-in-__bitmap_shift_right.patch
lib-bitmap-remove-redundant-code-from-__bitmap_shift_right.patch
lib-bitmap-yet-another-simplification-in-__bitmap_shift_right.patch
lib-bitmap-change-bitmap_shift_left-to-take-unsigned-parameters.patch
lib-bitmap-eliminate-branch-in-__bitmap_shift_left.patch
lib-bitmap-remove-redundant-code-from-__bitmap_shift_left.patch
lib-stringc-improve-strrchr.patch
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch
linux-next.patch

