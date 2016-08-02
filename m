From: akpm@linux-foundation.org
Subject: [folded-merged]
 kexec-add-restriction-on-kexec_load-segment-sizes-fix.patch removed from
 -mm tree
Date: Tue, 02 Aug 2016 13:46:20 -0700
Message-ID: <57a1069c.A+UY8nemX8xTUDnD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322AbcHBUqV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 16:46:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dyoung@redhat.com, ebiederm@xmission.com, vgoyal@redhat.com, zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec-add-restriction-on-kexec_load-segment-sizes-fix
has been removed from the -mm tree.  Its filename was
     kexec-add-restriction-on-kexec_load-segment-sizes-fix.patch

This patch was dropped because it was folded into kexec-add-restriction-on-kexec_load-segment-sizes.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kexec-add-restriction-on-kexec_load-segment-sizes-fix

fix for kexec-return-error-number-directly.patch, update comment

Cc: zhong jiang <zhongjiang@huawei.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN kernel/kexec_core.c~kexec-add-restriction-on-kexec_load-segment-sizes-fix kernel/kexec_core.c
--- a/kernel/kexec_core.c~kexec-add-restriction-on-kexec_load-segment-sizes-fix
+++ a/kernel/kexec_core.c
@@ -217,20 +217,19 @@ int sanity_check_segment_list(struct kim
 	}
 
 	/*
-	 * Verify that no segment is larger than half of memory.
-	 * If a segment from userspace is too large, a large amount
-	 * of time will be wasted allocating pages, which can cause
-	 * * a soft lockup.
+	 * Verify that no more than half of memory will be consumed. If the
+	 * request from userspace is too large, a large amount of time will be
+	 * wasted allocating pages, which can cause a soft lockup.
 	 */
 	for (i = 0; i < nr_segments; i++) {
 		if (PAGE_COUNT(image->segment[i].memsz) > totalram_pages / 2)
-			return result;
+			return -EINVAL;
 
 		total_pages += PAGE_COUNT(image->segment[i].memsz);
 	}
 
 	if (total_pages > totalram_pages / 2)
-		return result;
+		return -EINVAL;
 
 	/*
 	 * Verify we have good destination addresses.  Normally
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kexec-add-restriction-on-kexec_load-segment-sizes.patch
powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix.patch

