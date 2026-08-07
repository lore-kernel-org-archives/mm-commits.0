Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150FA3C062F
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068166; cv=none; b=fKfKnrINj93tLbXwQWCC4f0uONdke+jbvrEpXRHDjcS8EmAWHbOHBt+IY2QCDA2B2GKvS1STzX3vUtsra95+KMkSKtt99kyJ58Hg2RqyY7PxfV/lwmtIYcf7sRTC0DF5jDlA8Df/sIuSh0Dd7kF6bNjn7zyJ5ENJpIqD7TwNQK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068166; c=relaxed/simple;
	bh=v/gQvqy3r9bwt2bh43j9/dZbPMCpioCYemFPfNmvgrY=;
	h=Date:To:From:Subject:Message-Id; b=rm2MkawxeI/JD83yutj9x5N/HdE3cYULdpC63nbrYgKniMfbeCOC8UUf8Vnn3w4OJihYmJOVxb1w6ZclzHmjNaX0wxAV8uU5hNGrQ8GnYh7woK/EKQeQjCaKnwtTwGQE2iK4nZ1JLy7xAf0uDUPubJcXIDRruQnRntEP32qI+Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s0xM/YKg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s0xM/YKg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFEDF1F00A3A;
	Fri,  7 Aug 2026 02:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068165;
	bh=KZfyQY96kOWhbzDKwOrw4umwu9ki8MXcZJSZbIK73xE=;
	h=Date:To:From:Subject;
	b=s0xM/YKgKAultmgKdGX2dNRkzeo0jWOidtDrPhl3l/lDrKaa4nnGDoifai4NxTD+N
	 JR94IU9k0LC8HqVHLWxeUWMP+5uakiwVu8AYLjbUc5/k4yBX/GWdPGmgaT7+/NaD5L
	 fLeOrM8pjZrnPuetychdTc1wY4M1eC5m9fhDmlLs=
Date: Thu, 06 Aug 2026 19:02:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,akpm@linux-foundation.org,jakovnovak30@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-replace-mutex_lock-mutex_unlock-usage-with-guard-macro.patch removed from -mm tree
Message-Id: <20260807020244.DFEDF1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: replace mutex_lock/mutex_unlock usage with guard macro
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-replace-mutex_lock-mutex_unlock-usage-with-guard-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jakov Novak <jakovnovak30@gmail.com>
Subject: mm/khugepaged: replace mutex_lock/mutex_unlock usage with guard macro
Date: Thu, 30 Jul 2026 22:47:24 +0200

Currently, khugepaged locks the khugepaged_mutex in two functions:
start_stop_khugepaged and khugepaged_min_free_kbytes_update.  Remove
mutex_lock/mutex_unlock usage in these functions and replace it with the
guard macro.  This makes the code more readable (removing a goto
statement) and makes it harder to introduce bugs in the future.  No
functional changes introduced.

Link: https://lore.kernel.org/20260730204724.16912-1-jakovnovak30@gmail.com
Signed-off-by: Jakov Novak <jakovnovak30@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-replace-mutex_lock-mutex_unlock-usage-with-guard-macro
+++ a/mm/khugepaged.c
@@ -23,6 +23,7 @@
 #include <linux/ksm.h>
 #include <linux/pgalloc.h>
 #include <linux/backing-dev.h>
+#include <linux/cleanup.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -3115,18 +3116,19 @@ update_wmarks:
 
 int start_stop_khugepaged(void)
 {
-	int err = 0;
-
-	mutex_lock(&khugepaged_mutex);
+	guard(mutex)(&khugepaged_mutex);
 	if (hugepage_enabled()) {
-		if (!khugepaged_thread)
-			khugepaged_thread = kthread_run(khugepaged, NULL,
-							"khugepaged");
-		if (IS_ERR(khugepaged_thread)) {
-			pr_err("khugepaged: kthread_run(khugepaged) failed\n");
-			err = PTR_ERR(khugepaged_thread);
-			khugepaged_thread = NULL;
-			goto fail;
+		if (!khugepaged_thread) {
+			struct task_struct *new_thread = kthread_run(khugepaged,
+								     NULL,
+								     "khugepaged");
+
+			if (IS_ERR(new_thread)) {
+				pr_err("khugepaged: kthread_run(khugepaged) failed\n");
+				return PTR_ERR(new_thread);
+			}
+
+			khugepaged_thread = new_thread;
 		}
 
 		if (!list_empty(&khugepaged_scan.mm_head))
@@ -3136,17 +3138,14 @@ int start_stop_khugepaged(void)
 		khugepaged_thread = NULL;
 	}
 	set_recommended_min_free_kbytes();
-fail:
-	mutex_unlock(&khugepaged_mutex);
-	return err;
+	return 0;
 }
 
 void khugepaged_min_free_kbytes_update(void)
 {
-	mutex_lock(&khugepaged_mutex);
+	guard(mutex)(&khugepaged_mutex);
 	if (hugepage_enabled() && khugepaged_thread)
 		set_recommended_min_free_kbytes();
-	mutex_unlock(&khugepaged_mutex);
 }
 
 bool current_is_khugepaged(void)
_

Patches currently in -mm which might be from jakovnovak30@gmail.com are


