From: akpm@linux-foundation.org
Subject: +
 mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch added
 to -mm tree
Date: Wed, 30 Mar 2016 14:50:29 -0700
Message-ID: <56fc4a25.QC+KN8CwUQ7b0Jda%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819AbcC3Vua (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Mar 2016 17:50:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix
has been added to the -mm tree.  Its filename is
     mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch

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
Subject: mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix

Documentation/vm/transhuge.txt too

Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/transhuge.txt |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN Documentation/vm/transhuge.txt~mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix Documentation/vm/transhuge.txt
--- a/Documentation/vm/transhuge.txt~mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix
+++ a/Documentation/vm/transhuge.txt
@@ -394,9 +394,9 @@ hugepage natively. Once finished you can
 Refcounting on THP is mostly consistent with refcounting on other compound
 pages:
 
-  - get_page()/put_page() and GUP operate in head page's ->_count.
+  - get_page()/put_page() and GUP operate in head page's ->_refcount.
 
-  - ->_count in tail pages is always zero: get_page_unless_zero() never
+  - ->_refcount in tail pages is always zero: get_page_unless_zero() never
     succeed on tail pages.
 
   - map/unmap of the pages with PTE entry increment/decrement ->_mapcount
@@ -426,15 +426,15 @@ requests to split pinned huge page: it e
 sum of mapcount of all sub-pages plus one (split_huge_page caller must
 have reference for head page).
 
-split_huge_page uses migration entries to stabilize page->_count and
+split_huge_page uses migration entries to stabilize page->_refcount and
 page->_mapcount.
 
 We safe against physical memory scanners too: the only legitimate way
 scanner can get reference to a page is get_page_unless_zero().
 
-All tail pages has zero ->_count until atomic_add(). It prevent scanner
+All tail pages has zero ->_refcount until atomic_add(). It prevent scanner
 from geting reference to tail page up to the point. After the atomic_add()
-we don't care about ->_count value.  We already known how many references
+we don't care about ->_refcount value.  We already known how many references
 with should uncharge from head page.
 
 For head page get_page_unless_zero() will succeed and we don't mind. It's
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

