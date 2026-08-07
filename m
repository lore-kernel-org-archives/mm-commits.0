Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5E232B989
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068110; cv=none; b=apodgew52DaRU8HjDsgULW0GyFl8h5lp0wAZ4hVmDGfaaqlaK7Kl9EqlPd4P8bAYX9eAesWmiFGOPI9WCtLZqSG8PCevAqNJKlSXYBKY2AU9qVt1IMS0JK3nxYirxaKWtMQ46SDYKQU0a0TaQLGcVgM09IqV/qYpkKn4rmEAcLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068110; c=relaxed/simple;
	bh=q97mH0+RTabdgr4IRXTGHqsz+iaZsiUUjMQYSd95Lak=;
	h=Date:To:From:Subject:Message-Id; b=MIXAeCHh9KgQYid4xqyVE7KzzrHjpEJ+kv/1bUJrpKbhfjCN4WHbqPyrf5cH1ukzZS+p43V9Pn+FRZh2FBJ2dcAi9W7gt/uLyXXCci/eOJwsbRc7CDEh13KwugCM9u3+o9f0TnHdZNbJ4M0r7Uuv7WhSkAWjqLHAZitSdGhwRbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AaEe2l64; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AaEe2l64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0344D1F000E9;
	Fri,  7 Aug 2026 02:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068109;
	bh=EmHvxdHfdD24uziVjUF8KD0Sg472pT5Mvz65bCNSbLk=;
	h=Date:To:From:Subject;
	b=AaEe2l64m5gNo6/8pJQFiUniKrwVz2nnxZiRHXD0OtzUvJdOqcy6rdywlfzH2wZSp
	 3xla4ieXj+9xgD6D8D57J4slE4nk/wq/XvqQZdQBUz6MnlgVPEXRjqO+1cKcHQzyVX
	 2++GXyNdZlz9qCYlZf0f4lAlcqpJcbO2klnyMBPE=
Date: Thu, 06 Aug 2026 19:01:48 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mincore-replace-__get_free_page-with-kmalloc.patch removed from -mm tree
Message-Id: <20260807020149.0344D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mincore: replace __get_free_page() with kmalloc()
has been removed from the -mm tree.  Its filename was
     mm-mincore-replace-__get_free_page-with-kmalloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: mincore: replace __get_free_page() with kmalloc()
Date: Fri, 17 Jul 2026 17:13:44 +0800

Remove ugly casts by using the more natural kmalloc/kfree allocation, also
replace GFP_USER(pointless here) with GFP_KERNEL.

Link: https://lore.kernel.org/20260717091347.1144789-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/mincore.c~mm-mincore-replace-__get_free_page-with-kmalloc
+++ a/mm/mincore.c
@@ -12,6 +12,7 @@
 #include <linux/gfp.h>
 #include <linux/pagewalk.h>
 #include <linux/mman.h>
+#include <linux/slab.h>
 #include <linux/syscalls.h>
 #include <linux/swap.h>
 #include <linux/leafops.h>
@@ -328,7 +329,7 @@ SYSCALL_DEFINE3(mincore, unsigned long,
 	if (!access_ok(vec, pages))
 		return -EFAULT;
 
-	tmp = (void *) __get_free_page(GFP_USER);
+	tmp = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!tmp)
 		return -EAGAIN;
 
@@ -353,6 +354,6 @@ SYSCALL_DEFINE3(mincore, unsigned long,
 		start += retval << PAGE_SHIFT;
 		retval = 0;
 	}
-	free_page((unsigned long) tmp);
+	kfree(tmp);
 	return retval;
 }
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


