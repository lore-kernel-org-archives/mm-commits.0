Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0B52494FE
	for <mm-commits@vger.kernel.org>; Wed, 17 Dec 2025 21:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766006591; cv=none; b=qWCDBr56FcWAq+sbTsG9VrljCs9raFR3dSz5seUre8IlF/BAYvIVpO0gq6ERrT3y4Ws0v+QQShJYHYNJARdD64JOFxzVFfTP3mihRrc3tgv8Ql9/puHtK4PAjNqeneKWtRe/OXYtHf/DrTKLXsFMr2w3IzqAXv7fAHBkq2T1kBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766006591; c=relaxed/simple;
	bh=BigMcTVqoeTc5UP6y5/DycosaRzhVEM6+OXgwhnrvdI=;
	h=Date:To:From:Subject:Message-Id; b=Xvnu+sOKPznXNJgcQeDL5PQj9bhLPoAgfDQQeH+V0tKSvzIW5nwLHnj4T/TM0Hc4j44XvV2tHqytnk5x7u/bND42Ekf8rMKRezXqmmDg5hdDeDLXoLuZKTGyf2R/ZCV6qnziJIp4ckDJJzaH8hsaBppMbgGmzIA+rgdEDmVJGTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2i5x+mE7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2i5x+mE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44966C4CEF5;
	Wed, 17 Dec 2025 21:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766006590;
	bh=BigMcTVqoeTc5UP6y5/DycosaRzhVEM6+OXgwhnrvdI=;
	h=Date:To:From:Subject:From;
	b=2i5x+mE7nqsFHfXBdQKh02qn6nW5a3O79xrRUcYJMmK3dSUKfYvtQTlWGU/+bfiRJ
	 crQha276UljizM1GuppeLCU13TsBWj4E/b5YRUtHrMvH7Eh8/C9Pgegkjawmbz2I1g
	 DdEoeIuA36RD88I4sqa+jSjqZc41YTl5/D7OXKz0=
Date: Wed, 17 Dec 2025 13:23:09 -0800
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,axboe@kernel.dk,hca@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-remove-kmsg_component-macro.patch added to mm-new branch
Message-Id: <20251217212310.44966C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: remove KMSG_COMPONENT macro
has been added to the -mm mm-new branch.  Its filename is
     zram-remove-kmsg_component-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-remove-kmsg_component-macro.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Heiko Carstens <hca@linux.ibm.com>
Subject: zram: remove KMSG_COMPONENT macro
Date: Wed, 26 Nov 2025 15:36:02 +0100

The KMSG_COMPONENT macro is a leftover of the s390 specific "kernel
message catalog" from 2008 [1] which never made it upstream.

The macro was added to s390 code to allow for an out-of-tree patch which
used this to generate unique message ids.  Also this out-of-tree doesn't
exist anymore.

The pattern of how the KMSG_COMPONENT is used was partially also used for
non s390 specific code, for whatever reasons.

Remove the macro in order to get rid of a pointless indirection.

Link: https://lkml.kernel.org/r/20251126143602.2207435-1-hca@linux.ibm.com
Link: https://lwn.net/Articles/292650/ [1]
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-remove-kmsg_component-macro
+++ a/drivers/block/zram/zram_drv.c
@@ -12,8 +12,7 @@
  *
  */
 
-#define KMSG_COMPONENT "zram"
-#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
+#define pr_fmt(fmt) "zram: " fmt
 
 #include <linux/module.h>
 #include <linux/kernel.h>
_

Patches currently in -mm which might be from hca@linux.ibm.com are

zram-remove-kmsg_component-macro.patch

