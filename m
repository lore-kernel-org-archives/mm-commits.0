From: akpm@linux-foundation.org
Subject: [folded-merged] proc-add-kpageidle-file-fix-3.patch removed from
 -mm tree
Date: Wed, 09 Sep 2015 15:05:49 -0700
Message-ID: <55f0ad3d.rVGsNIYgmxZfqtRu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55671 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbbIIWFu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 18:05:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, fengguang.wu@intel.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mmu_notifier: add missing stubs for clear_young
has been removed from the -mm tree.  Its filename was
     proc-add-kpageidle-file-fix-3.patch

This patch was dropped because it was folded into proc-add-kpageidle-file.patch

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: mmu_notifier: add missing stubs for clear_young

This is a compilation fix for !CONFIG_MMU_NOTIFIER.

Fixes: mmu-notifier-add-clear_young-callback
Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/mmu_notifier.h~proc-add-kpageidle-file-fix-3 include/linux/mmu_notifier.h
--- a/include/linux/mmu_notifier.h~proc-add-kpageidle-file-fix-3
+++ a/include/linux/mmu_notifier.h
@@ -471,6 +471,8 @@ static inline void mmu_notifier_mm_destr
 
 #define ptep_clear_flush_young_notify ptep_clear_flush_young
 #define pmdp_clear_flush_young_notify pmdp_clear_flush_young
+#define ptep_clear_young_notify ptep_test_and_clear_young
+#define pmdp_clear_young_notify pmdp_test_and_clear_young
 #define	ptep_clear_flush_notify ptep_clear_flush
 #define pmdp_huge_clear_flush_notify pmdp_huge_clear_flush
 #define pmdp_huge_get_and_clear_notify pmdp_huge_get_and_clear
_

Patches currently in -mm which might be from vdavydov@parallels.com are

memcg-add-page_cgroup_ino-helper.patch
hwpoison-use-page_cgroup_ino-for-filtering-by-memcg.patch
memcg-zap-try_get_mem_cgroup_from_page.patch
proc-add-kpagecgroup-file.patch
mmu-notifier-add-clear_young-callback.patch
proc-add-kpageidle-file.patch
proc-add-kpageidle-file-fix-4.patch
proc-add-kpageidle-file-fix-5.patch
proc-add-kpageidle-file-fix-6.patch
proc-add-kpageidle-file-fix-6-fix-2.patch
proc-export-idle-flag-via-kpageflags.patch
proc-add-cond_resched-to-proc-kpage-read-write-loop.patch

