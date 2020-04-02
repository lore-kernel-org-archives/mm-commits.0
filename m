From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 119/155] mm: vmpressure: don't need call kfree if
 kstrndup fails
Date: Wed, 01 Apr 2020 21:09:59 -0700
Message-ID: <20200402040959.vsz6GKk9m%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgDBEKA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:10:00 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, rientjes@google.com, torvalds@linux-foundation.org, yang.shi@linux.alibaba.com

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
