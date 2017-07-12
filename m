From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix-2.patch removed from -mm tree
Date: Wed, 12 Jul 2017 14:22:52 -0700
Message-ID: <5966932c.BT4ie2sKfTmWk4qZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52748 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752614AbdGLVWx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:22:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, mgorman@suse.de, neilb@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject:  mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix
has been removed from the -mm tree.  Its filename was
     mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix-2.patch

This patch was dropped because it was folded into mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject:  mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix

- GFP_KERNEL - both background and direct reclaim are allowed and the
  _default_ page allocator behavior is used. That means that !costly
  allocation requests are basically nofail but there is no guarantee
  of that behavior so failures have to be checked properly by callers
  (e.g. OOM killer victim is allowed to fail currently).

Link: http://lkml.kernel.org/r/20170626123847.GM11534@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: NeilBrown <neilb@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN include/linux/gfp.h~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix-2 include/linux/gfp.h
--- a/include/linux/gfp.h~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix-2
+++ a/include/linux/gfp.h
@@ -25,7 +25,7 @@ struct vm_area_struct;
 #define ___GFP_FS		0x80u
 #define ___GFP_COLD		0x100u
 #define ___GFP_NOWARN		0x200u
-#define ___GFP_RETRY_MAYFAIL		0x400u
+#define ___GFP_RETRY_MAYFAIL	0x400u
 #define ___GFP_NOFAIL		0x800u
 #define ___GFP_NORETRY		0x1000u
 #define ___GFP_MEMALLOC		0x2000u
@@ -139,10 +139,11 @@ struct vm_area_struct;
  * The default allocator behavior depends on the request size. We have a concept
  * of so called costly allocations (with order > PAGE_ALLOC_COSTLY_ORDER).
  * !costly allocations are too essential to fail so they are implicitly
- * non-failing (with some exceptions like OOM victims might fail) by default while
- * costly requests try to be not disruptive and back off even without invoking
- * the OOM killer. The following three modifiers might be used to override some of
- * these implicit rules
+ * non-failing by default (with some exceptions like OOM victims might fail so
+ * the caller still has to check for failures) while costly requests try to be
+ * not disruptive and back off even without invoking the OOM killer.
+ * The following three modifiers might be used to override some of these
+ * implicit rules
  *
  * __GFP_NORETRY: The VM implementation will try only very lightweight
  *   memory direct reclaim to get some memory under memory pressure (thus
_

Patches currently in -mm which might be from mhocko@suse.com are

netfilter-use-kvmalloc-xt_alloc_table_info.patch
mips-do-not-use-__gfp_repeat-for-order-0-request.patch
mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic.patch
xfs-map-km_mayfail-to-__gfp_retry_mayfail.patch
mm-kvmalloc-support-__gfp_retry_mayfail-for-all-sizes.patch
drm-i915-use-__gfp_retry_mayfail.patch
mm-migration-do-not-trigger-oom-killer-when-migrating-memory.patch

