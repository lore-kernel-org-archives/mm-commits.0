From: akpm@linux-foundation.org
Subject: [to-be-updated]
 kexec-add-resriction-on-the-kexec_load-update.patch removed from -mm tree
Date: Wed, 27 Jul 2016 16:09:19 -0700
Message-ID: <57993f1f.e5/bHpYeLrmke7t3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47573 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163142AbcG0XJU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 19:09:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhongjiang@huawei.com, dyoung@redhat.com, ebiederm@xmission.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: fix the add restriction on the kexec_load
has been removed from the -mm tree.  Its filename was
     kexec-add-resriction-on-the-kexec_load-update.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: zhong jiang <zhongjiang@huawei.com>
Subject: kexec: fix the add restriction on the kexec_load

Because segments size is in bytes, while totalram_pages is in pages
so we should fix it.

Link: http://lkml.kernel.org/r/579353BE.9010600@huawei.com
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/kexec_core.c~kexec-add-resriction-on-the-kexec_load-update kernel/kexec_core.c
--- a/kernel/kexec_core.c~kexec-add-resriction-on-the-kexec_load-update
+++ a/kernel/kexec_core.c
@@ -221,13 +221,13 @@ int sanity_check_segment_list(struct kim
 	 * allocating pages, which can cause a soft lockup.
 	 */
 	for (i = 0; i < nr_segments; i++) {
-		if (image->segment[i].memsz > (totalram_pages / 2))
+		if (image->segment[i].memsz > (totalram_pages << 12) / 2)
 			return -EINVAL;
 
 		total_segments += image->segment[i].memsz;
 	}
 
-	if (total_segments > (totalram_pages / 2))
+	if (total_segments > (totalram_pages << 12) / 2)
 		return -EINVAL;
 
 	/*
_

Patches currently in -mm which might be from zhongjiang@huawei.com are

mm-hugetlb-fix-race-when-migrate-pages.patch
mm-update-the-comment-in-__isolate_free_page.patch
mm-page_owner-align-with-pageblock_nr-pages.patch
mm-walk-the-zone-in-pageblock_nr_pages-steps.patch
kexec-add-restriction-on-kexec_load-segment-sizes.patch

