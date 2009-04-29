From: akpm@linux-foundation.org
Subject: [folded] eliminate-thousands-of-warnings-in-warn_on-with-gcc-32-build-fix.patch removed from -mm tree
Date: Wed, 29 Apr 2009 12:34:00 -0700
Message-ID: <200904291934.n3TJY0O6006894@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752520AbZD2ThG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Apr 2009 15:37:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, ak@linux.intel.com, arjan@linux.intel.com, hannes@cmpxchg.org, jesper.nilsson@axis.com, mm-commits@vger.kernel.org


The patch titled
     eliminate-thousands-of-warnings-in-warn_on-with-gcc-32-build fix
has been removed from the -mm tree.  Its filename was
     eliminate-thousands-of-warnings-in-warn_on-with-gcc-32-build-fix.patch

This patch was dropped because it was folded into eliminate-thousands-of-warnings-in-warn_on-with-gcc-32-build.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eliminate-thousands-of-warnings-in-warn_on-with-gcc-32-build fix
From: Hugh Dickins <hugh@veritas.com>

Fix oopsing WARN_ON!

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/panic.c~eliminate-thousands-of-warnings-in-warn_on-with-gcc-32-build-fix kernel/panic.c
--- a/kernel/panic.c~eliminate-thousands-of-warnings-in-warn_on-with-gcc-32-build-fix
+++ a/kernel/panic.c
@@ -356,7 +356,7 @@ void warn_slowpath_fmt(const char *file,
 	if (board)
 		printk(KERN_WARNING "Hardware name: %s\n", board);
 
-	if (*fmt) {
+	if (fmt) {
 		va_start(args, fmt);
 		vprintk(fmt, args);
 		va_end(args);
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
linux-next.patch
eliminate-thousands-of-warnings-in-warn_on-with-gcc-32-build.patch
eliminate-thousands-of-warnings-in-warn_on-with-gcc-32-build-fix.patch
mm-disable-preemption-in-apply_to_pte_range.patch
ksm-mmu_notifiers-add-set_pte_at_notify.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-page_wrprotect-write-protecting-page.patch
ksm-add-replace_page-change-the-page-pte-is-pointing-to.patch
ksm-add-ksm-kernel-shared-memory-driver.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
ksm-add-ksm-kernel-shared-memory-driver-fix-unsafe-pte-fetching.patch
ksm-add-ksm-kernel-shared-memory-driver-borked-on-non-x86.patch
page-allocator-update-nr_free_pages-only-as-necessary-fix.patch
getrusage-fill-ru_maxrss-value.patch
prio_tree-debugging-patch.patch

