Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF60C3B14D6
	for <mm-commits@vger.kernel.org>; Tue, 28 Jul 2026 23:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785282983; cv=none; b=FUfrzMJErA+oluhrMkBpoT6pm3j2T0NZONl1Ex1CgM0K6ihTSj71CbAjV2pzk1Ay+Pp3mVE4Vq4vSgtb/guvWwhuIgE5a+Kr2Xa3KlHo7HPjrOBF9YJR7RtJi2+sWFtHBazs6AJzKnffuatPIdYS1NXsHHrN2s3pqhtanHJQYj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785282983; c=relaxed/simple;
	bh=jiAsQ60cuMWvFNH9EHIpJar45OUobERXrrrTUCJRxKU=;
	h=Date:To:From:Subject:Message-Id; b=N9Z/y7fbr1Yky7yg7PX6mhJ20CK9EginbFOTz4IkrWrTQEibByYPm9u8kAddXedU5yUdVKhgKBp7UrVI8ogYxl/4R0UUVJgce0HAUEedE7EinGHLMnQ9cVnI2Frr5OYfiJvws+ssoR1hjXOQRrrRT/22Y4LWqj4t2wu0KweIdt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MS7l+Eto; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MS7l+Eto"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FFF1F000E9;
	Tue, 28 Jul 2026 23:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785282980;
	bh=1+zjAm6gM3ivz0i45tkEqeVaKG50PTFHKw4ndvRlJKA=;
	h=Date:To:From:Subject;
	b=MS7l+Etot4T0pFbgGfWo12GBgSk0KXRQNsQsdTq88yl3u40KKQNdjZKGnceTKMMR8
	 hADPj1yLda9b9SnSHKoFUseqwKtgK8phdxPPsjmCbEk3F5YWz7BD1YuDW5UdBLVVIB
	 F69KkKkcOeaLYYg0ju315w67VoAXEWHCo5YrXCzM=
Date: Tue, 28 Jul 2026 16:56:19 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,akpm@linux-foundation.org,jakovnovak30@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-replace-mutex_lock-mutex_unlock-usage-with-guard-macro.patch added to mm-new branch
Message-Id: <20260728235619.E7FFF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: replace mutex_lock/mutex_unlock usage with guard macro
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-replace-mutex_lock-mutex_unlock-usage-with-guard-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-replace-mutex_lock-mutex_unlock-usage-with-guard-macro.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
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

mm-khugepaged-replace-mutex_lock-mutex_unlock-usage-with-guard-macro.patch

