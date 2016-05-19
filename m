From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch
 removed from -mm tree
Date: Thu, 19 May 2016 16:42:36 -0700
Message-ID: <573e4f6c.gBwqApo74gRUL9lI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44862 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375AbcESXmh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 19:42:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch

This patch was dropped because it was folded into mm-rename-_count-field-of-the-struct-page-to-_refcount.patch

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

mm-rename-_count-field-of-the-struct-page-to-_refcount.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-uninline-page_mapped.patch
mm-uninline-page_mapped-checkpatch-fixes.patch
memory_hotplug-introduce-config_memory_hotplug_default_online-fix.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path-fix.patch
mm-page_alloc-only-check-pagecompound-for-high-order-pages-fix.patch
mm-page_alloc-remove-unnecessary-initialisation-from-__alloc_pages_nodemask-fix.patch
mm-page_alloc-shorten-the-page-allocator-fast-path-fix.patch
mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix.patch
mm-page_alloc-un-inline-the-bad-part-of-free_pages_check-fix.patch
mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix-fix.patch

