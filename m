Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8EC3612D2
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966093; cv=none; b=bXWGSYS/j4oNyyR200IR93+Y6vSzrYfCPSjkadzuzqai4SOMIYQx1upfO15MyeumxyvJbrnQ/AWQJ0kPb0MWxbw7RbAy7EoHQXlH67jI7f7g6ctfy1XPH5HLtfMXPIeNj9tH4Nvauwa0V6jR6IIrQAyGjN9wjh5JdRn+A3iXDcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966093; c=relaxed/simple;
	bh=O8ls8BTdNlWtdFqxTA2gx49IiTNQuviuWymiSPCrtcI=;
	h=Date:To:From:Subject:Message-Id; b=TjSDbRVD31kiqKFvHV5qw6+KwFFtjozI8WGfeO0x2mR464GfdDMT1sXL64JDiM7ZKPcQOHgaMviFhCX6OGc1nUi0vIPEMlCQlyQPVHW1u9/W9btBtLkHVJSPFLnZVEnupTcw6JkQFQhweJ1bS1xZBVVQjR3ilkJS2RpSY8em78k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hEQA2Pa+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hEQA2Pa+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C4AC16AAE;
	Wed, 21 Jan 2026 03:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966092;
	bh=O8ls8BTdNlWtdFqxTA2gx49IiTNQuviuWymiSPCrtcI=;
	h=Date:To:From:Subject:From;
	b=hEQA2Pa+IGvgg9PJI6eG5QC0fL4fk2nOF1nIlhWf4H9LaSKGoNVS6OBxmVf1PlR8M
	 kkOtKAmOsTBloyRyOW+ogOp50aY4FLsjWvSxHEbm0KXAco84Rk3E0R+Oaw/rD30KWU
	 IzkQRja2QVd0MWw3Kp8utM03lfQdws3g8nqWAkv8=
Date: Tue, 20 Jan 2026 19:28:12 -0800
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,axboe@kernel.dk,hca@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-remove-kmsg_component-macro.patch removed from -mm tree
Message-Id: <20260121032812.98C4AC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: remove KMSG_COMPONENT macro
has been removed from the -mm tree.  Its filename was
     zram-remove-kmsg_component-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


