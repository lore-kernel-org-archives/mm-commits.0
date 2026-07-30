Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49733A6F11
	for <mm-commits@vger.kernel.org>; Thu, 30 Jul 2026 22:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451339; cv=none; b=hI078yEc/gnk+QM75Hw1PcjHh7+vCf5jka6vFgGiDxIzCMm6uPy5qlVuSbCRB4e7XDxE0Yd53uybpON5grcLU1UI61+3lllKD7WTCK807rT+cidtSNYqxmLXxGDLvcpEehJSUKv2imeoZsMPl/tC65D5DfkZbnn9Qb2+HU6IZas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451339; c=relaxed/simple;
	bh=egluaM4TBlFk9pTQJnBMOnMReZzR57WuXWHcL7Apt7A=;
	h=Date:To:From:Subject:Message-Id; b=FRKJWCGLxOqLjUURIZ0zH2xgvoprrFBm0BQB8kZ2xxvdmu98RoddHQdqAMcprGDDBc7gE3WpVhuU/YUKM2tzRn8P0fQycGd645rqit3spvr01WzWXEn3/8YjVDG97/IM7BaSETEFUaFHS9JNsUs4iYYU5gphkkKJ0NcMpF9Ymfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jLJXJ51z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jLJXJ51z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42BBC1F000E9;
	Thu, 30 Jul 2026 22:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785451338;
	bh=jloptTXgJjJIDBO9veDYTzMQm1lXxy/h+hPc3wVj86I=;
	h=Date:To:From:Subject;
	b=jLJXJ51zeYJkKVshTeeBPe/y+WExIOkVfTuMTiWZ/ZX5DjFZ+0Nc3dqr3Dg/+Pve0
	 0Pa6XOQKKRfy/iV5baN1HwSk7ceGL9vuaOSO8dyz9e9Na6RHLWtqlKfGr46YwSnzo2
	 eq915Dxz7pdUzvtZyYEqWxAXRz8p8QLLsfWt6Xbw=
Date: Thu, 30 Jul 2026 15:42:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,akpm@linux-foundation.org,jakovnovak30@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-replace-mutex_lock-mutex_unlock-usage-with-guard-macro.patch removed from -mm tree
Message-Id: <20260730224218.42BBC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: replace mutex_lock/mutex_unlock usage with guard macro
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-replace-mutex_lock-mutex_unlock-usage-with-guard-macro.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Jakov Novak <jakovnovak30@gmail.com>
Subject: mm/khugepaged: replace mutex_lock/mutex_unlock usage with guard macro
Date: Tue, 28 Jul 2026 22:46:37 +0200

Currently, khugepaged locks the khugepaged_mutex in two functions:
start_stop_khugepaged and khugepaged_min_free_kbytes_update.  Remove
mutex_lock/mutex_unlock usage in these functions and replace it with the
guard macro.  This makes the code more readable (removing a goto
statement) and makes it harder to introduce bugs in the future.  No
functional changes introduced.

Link: https://lore.kernel.org/20260728204636.20998-2-jakovnovak30@gmail.com
Signed-off-by: Jakov Novak <jakovnovak30@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-replace-mutex_lock-mutex_unlock-usage-with-guard-macro
+++ a/mm/khugepaged.c
@@ -23,6 +23,7 @@
 #include <linux/ksm.h>
 #include <linux/pgalloc.h>
 #include <linux/backing-dev.h>
+#include <linux/cleanup.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -3115,18 +3116,17 @@ update_wmarks:
 
 int start_stop_khugepaged(void)
 {
-	int err = 0;
-
-	mutex_lock(&khugepaged_mutex);
+	guard(mutex)(&khugepaged_mutex);
 	if (hugepage_enabled()) {
 		if (!khugepaged_thread)
 			khugepaged_thread = kthread_run(khugepaged, NULL,
 							"khugepaged");
 		if (IS_ERR(khugepaged_thread)) {
+			int err;
 			pr_err("khugepaged: kthread_run(khugepaged) failed\n");
 			err = PTR_ERR(khugepaged_thread);
 			khugepaged_thread = NULL;
-			goto fail;
+			return err;
 		}
 
 		if (!list_empty(&khugepaged_scan.mm_head))
@@ -3136,17 +3136,14 @@ int start_stop_khugepaged(void)
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


