Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242233A6F11
	for <mm-commits@vger.kernel.org>; Thu, 30 Jul 2026 22:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451388; cv=none; b=kW8DkmbccT9JPFGmsJB2iZO/vD/gSsLXE3odJuc6HO09MkMFCv+vnqiIL8e/l3ZOg+mpgRaSVxYKqm13V8kacQFEjmbM/gu33sWQ8/cjJZZrCQz+AM2NVvD4NJpBg8avSjHCKcU7W4LfcYenRNGWe21HmmeXhqXsFyNPhIAxjVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451388; c=relaxed/simple;
	bh=w4bwvRtJrxZLsbd20IzzHrI32b0zCCIYGQZKNPbd9gk=;
	h=Date:To:From:Subject:Message-Id; b=NMYGo2v/jynaARgo5JGnZaRFDOMZonUaYXnjglS4H6VQM0hZRmvucilA71hiHoeQTQt75fazICMub3ZGFu+oFWmk9njbfCixHQq6fyq8NwML8UEPHtpsjD1MeNOUFLblukP3lBle6YkfTW+G52CUZDgI+ZkbQd1tM+XLpeQaSLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hUAJLbRO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hUAJLbRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D511F00A3A;
	Thu, 30 Jul 2026 22:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785451386;
	bh=2r6a1tQlwr22Rm8llWPhpFtNI0zfdVDuzvvRUoxrNGk=;
	h=Date:To:From:Subject;
	b=hUAJLbROe/tDuNwrHLGVhsi3dmv8FlbxSTI+L/gOVyse2nftYyOnlLyTNv87IHDOm
	 RIIHIRphjtnjj9IYG5IWJlCsaK+DOpFNvzEeUxuIaIikW6eZ7EDWeabGonQkpIhF7/
	 jjjU7uQSDK3k2ZH73Gle0lJ1o7aAnvxaRiZJchCg=
Date: Thu, 30 Jul 2026 15:43:06 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,akpm@linux-foundation.org,jakovnovak30@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-replace-mutex_lock-mutex_unlock-usage-with-guard-macro.patch added to mm-unstable branch
Message-Id: <20260730224306.A2D511F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: replace mutex_lock/mutex_unlock usage with guard macro
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-replace-mutex_lock-mutex_unlock-usage-with-guard-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-replace-mutex_lock-mutex_unlock-usage-with-guard-macro.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
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

mm-khugepaged-replace-mutex_lock-mutex_unlock-usage-with-guard-macro.patch

