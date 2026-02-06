Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905923090E0
	for <mm-commits@vger.kernel.org>; Fri,  6 Feb 2026 23:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770421684; cv=none; b=Az834Kx9BIwMxumVTVFwN/ukG6nrUrrApvowwR3PXjBFb9onxSnQHdI0YVJWoziKVzgni30FY7tfpsu1sVYfmS2E++PQQVeF8nLU4Y0IgJ80FyJu5KJLsucynvhEul6go7tNS5pM9IZ4gPhebDrs+ppRMoOPqXh860dvEDMwpwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770421684; c=relaxed/simple;
	bh=WgRq98JYtRY3TnrKf+dCuzo44x55MzOQgTLOVyNDnzk=;
	h=Date:To:From:Subject:Message-Id; b=OL7qpsjG6v37nR9rIqpE2dry4zyCHj9o0TiHOxS7AI7bznO13e616KpRHoiaSF6OCkTnQiVVGJTY8ielwzrOie/HjW6K9QcN/ibRJGEitSLIGK1fxaIyKRCXrRtbT3hA9uZCgwBJjN515OrnlUWgT4QmK1mAFgEGKkxRFfjPe7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ukld99ps; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ukld99ps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B838C116C6;
	Fri,  6 Feb 2026 23:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770421684;
	bh=WgRq98JYtRY3TnrKf+dCuzo44x55MzOQgTLOVyNDnzk=;
	h=Date:To:From:Subject:From;
	b=ukld99psRHvyJfbNI4iUsdKyh1fVZbYl142GzvaU42Eez7BT2ZOoioC9bmmFCHN3I
	 ap87/dNmvSKXMFxDPbOJtE5aulLd4i6K+S7udXRb9Zfpwhv2AHBfiQ4ko8YaxTALlB
	 oda411vMoB/0XU/9QsbEMCxjC74ShcrmmMvSv3Ic=
Date: Fri, 06 Feb 2026 15:48:03 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,akpm@linux-foundation.org,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cma-replace-snprintf-with-strscpy-in-cma_new_area.patch removed from -mm tree
Message-Id: <20260206234804.0B838C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/cma: replace snprintf with strscpy in cma_new_area
has been removed from the -mm tree.  Its filename was
     mm-cma-replace-snprintf-with-strscpy-in-cma_new_area.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: mm/cma: replace snprintf with strscpy in cma_new_area
Date: Mon, 26 Jan 2026 18:45:15 +0100

Replace snprintf("%s", ...) with the faster and more direct strscpy().

Link: https://lkml.kernel.org/r/20260126174516.236968-1-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/cma.c~mm-cma-replace-snprintf-with-strscpy-in-cma_new_area
+++ a/mm/cma.c
@@ -22,6 +22,7 @@
 #include <linux/mm.h>
 #include <linux/sizes.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/string_choices.h>
 #include <linux/log2.h>
 #include <linux/cma.h>
@@ -233,7 +234,7 @@ static int __init cma_new_area(const cha
 	cma_area_count++;
 
 	if (name)
-		snprintf(cma->name, CMA_MAX_NAME, "%s", name);
+		strscpy(cma->name, name);
 	else
 		snprintf(cma->name, CMA_MAX_NAME,  "cma%d\n", cma_area_count);
 
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are


