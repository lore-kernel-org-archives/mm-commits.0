From: akpm@linux-foundation.org
Subject: [folded] bitops-add-temporary-for_each_bit.patch removed from -mm tree
Date: Fri, 05 Mar 2010 13:13:23 -0800
Message-ID: <201003052113.o25LDNg3027881@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753235Ab0CEVQi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Mar 2010 16:16:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     bitops: add temporary for_each_bit()
has been removed from the -mm tree.  Its filename was
     bitops-add-temporary-for_each_bit.patch

This patch was dropped because it was folded into bitops-rename-for_each_bit-to-for_each_set_bit.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bitops: add temporary for_each_bit()
From: Andrew Morton <akpm@linux-foundation.org>

Keep stuff working for now.

Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitops.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/bitops.h~bitops-add-temporary-for_each_bit include/linux/bitops.h
--- a/include/linux/bitops.h~bitops-add-temporary-for_each_bit
+++ a/include/linux/bitops.h
@@ -21,6 +21,8 @@
 	     (bit) < (size); \
 	     (bit) = find_next_bit((addr), (size), (bit) + 1))
 
+/* Temporary */
+#define for_each_bit(bit, addr, size) for_each_set_bit(bit, addr, size)
 
 static __inline__ int get_bitmask_order(unsigned int count)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
bitops-add-temporary-for_each_bit.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
lib-more-scalable-list_sort-fix.patch
fs-compat_ioctlc-suppress-two-warnings.patch
sdio-introduce-api-for-special-power-management-features-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
gpio-pca953xc-add-interrupt-handling-capability.patch
gpio-pca953xc-add-interrupt-handling-capability-fix.patch
gpio-cs5535-gpio-fix-input-direction.patch

