From: akpm@linux-foundation.org
Subject: [merged]
 thp-do-not-adjust-zone-water-marks-if-khugepaged-is-not-started.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 09:52:23 -0700
Message-ID: <552fe8c7.MYgibzdfcEC+i8le%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42765 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbbDPQqy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:46:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: do not adjust zone water marks if khugepaged is not started
has been removed from the -mm tree.  Its filename was
     thp-do-not-adjust-zone-water-marks-if-khugepaged-is-not-started.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: do not adjust zone water marks if khugepaged is not started

set_recommended_min_free_kbytes() adjusts zone water marks to be suitable
for khugepaged. We avoid doing this if khugepaged is disabled, but don't
catch the case when khugepaged is failed to start.

Let's address this by checking khugepaged_thread instead of
khugepaged_enabled() in set_recommended_min_free_kbytes().
It's NULL if the kernel thread is stopped or failed to start.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/huge_memory.c~thp-do-not-adjust-zone-water-marks-if-khugepaged-is-not-started mm/huge_memory.c
--- a/mm/huge_memory.c~thp-do-not-adjust-zone-water-marks-if-khugepaged-is-not-started
+++ a/mm/huge_memory.c
@@ -110,7 +110,8 @@ static int set_recommended_min_free_kbyt
 	int nr_zones = 0;
 	unsigned long recommended_min;
 
-	if (!khugepaged_enabled())
+	/* khugepaged thread has stopped to failed to start */
+	if (!khugepaged_thread)
 		return 0;
 
 	for_each_populated_zone(zone)
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
linux-next.patch

