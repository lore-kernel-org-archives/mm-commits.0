From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmpressure-dont-need-call-kfree-if-kstrndup-fails.patch removed from -mm
 tree
Date: Fri, 03 Apr 2020 13:39:43 -0700
Message-ID: <20200403203943.E9i4QlIwO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727909AbgDCUjo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:39:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david@redhat.com, mm-commits@vger.kernel.org, rientjes@google.com, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm: vmpressure: don't need call kfree if kstrndup fails
has been removed from the -mm tree.  Its filename was
     mm-vmpressure-dont-need-call-kfree-if-kstrndup-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: vmpressure: don't need call kfree if kstrndup fails

When kstrndup fails, no memory was allocated and we can exit directly.

[david@redhat.com: reword changelog]
Link: http://lkml.kernel.org/r/1581398649-125989-1-git-send-email-yang.shi@linux.alibaba.com
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmpressure.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/vmpressure.c~mm-vmpressure-dont-need-call-kfree-if-kstrndup-fails
+++ a/mm/vmpressure.c
@@ -371,10 +371,8 @@ int vmpressure_register_event(struct mem
 	int ret = 0;
 
 	spec_orig = spec = kstrndup(args, MAX_VMPRESSURE_ARGS_LEN, GFP_KERNEL);
-	if (!spec) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!spec)
+		return -ENOMEM;
 
 	/* Find required level */
 	token = strsep(&spec, ",");
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are

mm-migratec-migrate-pg_readahead-flag.patch
