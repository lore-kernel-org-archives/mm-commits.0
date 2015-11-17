From: akpm@linux-foundation.org
Subject: + mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix.patch
 added to -mm tree
Date: Tue, 17 Nov 2015 13:58:59 -0800
Message-ID: <564ba323.w5PwYBRlVJBBYsOp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45131 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbbKQV7A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2015 16:59:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, mgorman@suse.de, n-horiguchi@ah.jp.nec.com, nyc@holomorphy.com, nzimmer@sgi.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix
has been added to the -mm tree.  Its filename is
     mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix

we'd better include rwlock.h, not spinlock.h

Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Nadia Yvette Chambers <nyc@holomorphy.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mempolicy.h~mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix
+++ a/include/linux/mempolicy.h
@@ -9,7 +9,7 @@
 #include <linux/mmzone.h>
 #include <linux/slab.h>
 #include <linux/rbtree.h>
-#include <linux/spinlock.h>
+#include <linux/rwlock.h>
 #include <linux/nodemask.h>
 #include <linux/pagemap.h>
 #include <uapi/linux/mempolicy.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
ncpfs-dont-allow-negative-timeouts-fix.patch
mm.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
mm-mmapc-remove-redundant-local-variables-for-may_expand_vm-fix.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

