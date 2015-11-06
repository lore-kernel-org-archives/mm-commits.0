From: akpm@linux-foundation.org
Subject: [merged]
 mm-kasan-rename-kasan_enabled-to-kasan_report_enabled.patch removed from
 -mm tree
Date: Fri, 06 Nov 2015 12:17:27 -0800
Message-ID: <563d0ad7.IVZACzlE50kDdsta%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49096 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162902AbbKFUR1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:17:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kasan: rename kasan_enabled() to kasan_report_enabled()
has been removed from the -mm tree.  Its filename was
     mm-kasan-rename-kasan_enabled-to-kasan_report_enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/kasan: rename kasan_enabled() to kasan_report_enabled()

The function only disable/enable reporting.  In the later patch we will be
adding a kasan early enable/disable.  Rename kasan_enabled to properly
reflect its function.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h  |    2 +-
 mm/kasan/report.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/kasan/kasan.h~mm-kasan-rename-kasan_enabled-to-kasan_report_enabled mm/kasan/kasan.h
--- a/mm/kasan/kasan.h~mm-kasan-rename-kasan_enabled-to-kasan_report_enabled
+++ a/mm/kasan/kasan.h
@@ -63,7 +63,7 @@ static inline const void *kasan_shadow_t
 		<< KASAN_SHADOW_SCALE_SHIFT);
 }
 
-static inline bool kasan_enabled(void)
+static inline bool kasan_report_enabled(void)
 {
 	return !current->kasan_depth;
 }
diff -puN mm/kasan/report.c~mm-kasan-rename-kasan_enabled-to-kasan_report_enabled mm/kasan/report.c
--- a/mm/kasan/report.c~mm-kasan-rename-kasan_enabled-to-kasan_report_enabled
+++ a/mm/kasan/report.c
@@ -220,7 +220,7 @@ void kasan_report(unsigned long addr, si
 {
 	struct kasan_access_info info;
 
-	if (likely(!kasan_enabled()))
+	if (likely(!kasan_report_enabled()))
 		return;
 
 	info.access_addr = (void *)addr;
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are


