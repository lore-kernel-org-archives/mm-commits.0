From: akpm@linux-foundation.org
Subject: - hibernate-replace-unnecessary-evaluation-of-pfn_to_page.patch removed from -mm tree
Date: Mon, 29 Dec 2008 11:18:33 -0800
Message-ID: <200812291918.mBTJIX9r030852@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752107AbYL2TTf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Dec 2008 14:19:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, lenb@kernel.org, pavel@suse.cz, mm-commits@vger.kernel.org


The patch titled
     hibernate: replace unnecessary evaluation of pfn_to_page()
has been removed from the -mm tree.  Its filename was
     hibernate-replace-unnecessary-evaluation-of-pfn_to_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hibernate: replace unnecessary evaluation of pfn_to_page()
From: Rafael J. Wysocki <rjw@sisk.pl>

Replace one evaluation of pfn_to_page() in copy_data_pages() with
the value of a local variable containing the right number already.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@suse.cz>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/snapshot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/power/snapshot.c~hibernate-replace-unnecessary-evaluation-of-pfn_to_page kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~hibernate-replace-unnecessary-evaluation-of-pfn_to_page
+++ a/kernel/power/snapshot.c
@@ -981,7 +981,7 @@ static void copy_data_page(unsigned long
 			 * data modified by kmap_atomic()
 			 */
 			safe_copy_page(buffer, s_page);
-			dst = kmap_atomic(pfn_to_page(dst_pfn), KM_USER0);
+			dst = kmap_atomic(d_page, KM_USER0);
 			memcpy(dst, buffer, PAGE_SIZE);
 			kunmap_atomic(dst, KM_USER0);
 		} else {
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
linux-next.patch
vfs-fix-switch_names-breakage-in-short-to-short-case.patch
shrink_slab-handle-bad-shrinkers.patch

