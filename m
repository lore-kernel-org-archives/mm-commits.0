From: akpm@linux-foundation.org
Subject: + include-linux-gfph-fix-___gfp_nolockdep-value.patch added to
 -mm tree
Date: Tue, 16 May 2017 12:21:32 -0700
Message-ID: <591b513c.XX1WApHcZXLg7S6t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39844 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751619AbdEPTVd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2017 15:21:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, igor.stoppa@nokia.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/gfp.h: fix  ___GFP_NOLOCKDEP value
has been added to the -mm tree.  Its filename is
     include-linux-gfph-fix-___gfp_nolockdep-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-gfph-fix-___gfp_nolockdep-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-gfph-fix-___gfp_nolockdep-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: include/linux/gfp.h: fix  ___GFP_NOLOCKDEP value

Igor Stoppa has noticed that __GFP_NOLOCKDEP can use a lower bit. At the
time 7e7844226f10 ("lockdep: allow to disable reclaim lockup detection")
was written we still had __GFP_OTHER_NODE but I have removed it in
41b6167e8f74 ("mm: get rid of __GFP_OTHER_NODE") and forgot to lower the
bit value. The current value is outside of __GFP_BITS_SHIFT so it cannot
be used actually.

Fixes: 7e7844226f10 ("lockdep: allow to disable reclaim lockup detection")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Igor Stoppa <igor.stoppa@nokia.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/gfp.h~include-linux-gfph-fix-___gfp_nolockdep-value include/linux/gfp.h
--- a/include/linux/gfp.h~include-linux-gfph-fix-___gfp_nolockdep-value
+++ a/include/linux/gfp.h
@@ -41,7 +41,7 @@ struct vm_area_struct;
 #define ___GFP_WRITE		0x800000u
 #define ___GFP_KSWAPD_RECLAIM	0x1000000u
 #ifdef CONFIG_LOCKDEP
-#define ___GFP_NOLOCKDEP	0x4000000u
+#define ___GFP_NOLOCKDEP	0x2000000u
 #else
 #define ___GFP_NOLOCKDEP	0
 #endif
_

Patches currently in -mm which might be from mhocko@suse.com are

include-linux-gfph-fix-___gfp_nolockdep-value.patch
mm-remove-return-value-from-init_currently_empty_zone.patch
mm-memory_hotplug-use-node-instead-of-zone-in-can_online_high_movable.patch
mm-drop-page_initialized-check-from-get_nid_for_pfn.patch
mm-memory_hotplug-get-rid-of-is_zone_device_section.patch
mm-memory_hotplug-split-up-register_one_node.patch
mm-memory_hotplug-consider-offline-memblocks-removable.patch
mm-consider-zone-which-is-not-fully-populated-to-have-holes.patch
mm-compaction-skip-over-holes-in-__reset_isolation_suitable.patch
mm-__first_valid_page-skip-over-offline-pages.patch
mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo.patch
mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online.patch
mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory.patch
mm-memory_hotplug-fix-the-section-mismatch-warning.patch
mm-memory_hotplug-remove-unused-cruft-after-memory-hotplug-rework.patch

