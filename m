From: akpm@linux-foundation.org
Subject: + lib-plistc-remove-redundant-include.patch added to -mm tree
Date: Fri, 02 Jan 2015 14:56:43 -0800
Message-ID: <54a7222b.1AreTyEXYF1ZI3r1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34133 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbbABW4o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jan 2015 17:56:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/plist.c: remove redundant include
has been added to the -mm tree.  Its filename is
     lib-plistc-remove-redundant-include.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-plistc-remove-redundant-include.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-plistc-remove-redundant-include.patch

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
Subject: lib/plist.c: remove redundant include

Removing the include of linux/spinlock.h produces byte-identical output
for {allno,def}config, and identical objdump -d output for allyesconfig. 
In the former two cases, more than a 100 lines are eliminated from the
generated dependency file.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/plist.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN lib/plist.c~lib-plistc-remove-redundant-include lib/plist.c
--- a/lib/plist.c~lib-plistc-remove-redundant-include
+++ a/lib/plist.c
@@ -25,7 +25,6 @@
 
 #include <linux/bug.h>
 #include <linux/plist.h>
-#include <linux/spinlock.h>
 
 #ifdef CONFIG_DEBUG_PI_LIST
 
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

lib-string_get_size-remove-redundant-prefixes.patch
lib-string_get_size-use-32-bit-arithmetic-when-possible.patch
lib-string_get_size-return-void.patch
lib-bitmap-more-signed-unsigned-conversions.patch
linux-nodemaskh-update-bitmap-wrappers-to-take-unsigned-int.patch
linux-cpumaskh-update-bitmap-wrappers-to-take-unsigned-int.patch
lib-bitmap-update-bitmap_onto-to-unsigned.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned.patch
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
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch
linux-next.patch

