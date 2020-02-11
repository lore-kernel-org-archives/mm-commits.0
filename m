From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-vmpressure-dont-need-call-kfree-if-kstrndup-fails.patch added to -mm
 tree
Date: Mon, 10 Feb 2020 21:33:27 -0800
Message-ID: <20200211053327.Ce7FzjC-p%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728180AbgBKFd2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Feb 2020 00:33:28 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm: vmpressure: don't need call kfree if kstrndup fails
has been added to the -mm tree.  Its filename is
     mm-vmpressure-dont-need-call-kfree-if-kstrndup-fails.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmpressure-dont-need-call-kfree-if-kstrndup-fails.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmpressure-dont-need-call-kfree-if-kstrndup-fails.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: vmpressure: don't need call kfree if kstrndup fails

When kstrndup fails (returns NULL) there is no memory is allocated by
kmalloc, so no need to call kfree().

Link: http://lkml.kernel.org/r/1581398649-125989-1-git-send-email-yang.shi@linux.alibaba.com
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-vmpressure-dont-need-call-kfree-if-kstrndup-fails.patch
