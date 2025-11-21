Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6F4158535
	for <mm-commits@vger.kernel.org>; Fri, 21 Nov 2025 02:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763690419; cv=none; b=hBKhs+moJD89eL6uw2HQJEzDtwquSqTU3g4q8EsA5vW5PPcdyAC3py65B0s4aKYQ/clP3DeInF3FoNzfjnD16+wMwd2/2dMppqxYCl22Oz4eIbKp4PUYPdlooNhPA10jtpOTaaO4q+bRUvz1vieJSjDZtcZY6JT7KwD8IvZx/Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763690419; c=relaxed/simple;
	bh=Tnx348ONnTXmYMrv4s83pR6wHlmwmI2AauGoRV0bLMU=;
	h=Date:To:From:Subject:Message-Id; b=XCWXsDYXa52+mXxa//5LB62IF+xQCenssSF/fenHZL9oEvM6foQuCn3WM3MRoxp0e8VwNseFJgcheuMzF7kASOaOJOcM1d+YjRLiuCusv1zcVJX+ANQEmU7IJ6VO6CWwbkG8vX+BGG6oLPgre63w0UXcxNzmV7z+GTVKrhBbTp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nFvYmZv5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nFvYmZv5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1BF7C4CEF1;
	Fri, 21 Nov 2025 02:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763690418;
	bh=Tnx348ONnTXmYMrv4s83pR6wHlmwmI2AauGoRV0bLMU=;
	h=Date:To:From:Subject:From;
	b=nFvYmZv5kOMM0gY4p0fMN6x8K/rqXSRiroDJWWked+TiGIgMulEu7d8+WId0eqCSP
	 5Hp+FfnTGSwcRKU1woQZ+CYHP+A2Zi8k5JHN7H9KXH+VODn7jYRQo2n7Uqk1FJK52M
	 Ae6L4k1HP7AQJmx+Oquv4eYIOqMvR5BTVaVm6w5g=
Date: Thu, 20 Nov 2025 18:00:17 -0800
To: mm-commits@vger.kernel.org,ywen.chen@foxmail.com,senozhatsky@chromium.org,richardycc@google.com,minchan@google.com,bgeffon@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-writeback-batch-size-device-attr-fix.patch added to mm-unstable branch
Message-Id: <20251121020018.A1BF7C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram-add-writeback-batch-size-device-attr-fix
has been added to the -mm mm-unstable branch.  Its filename is
     zram-add-writeback-batch-size-device-attr-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-add-writeback-batch-size-device-attr-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: zram-add-writeback-batch-size-device-attr-fix
Date: Thu Nov 20 05:59:13 PM PST 2025

s/down_read/down_write/ in writeback_batch_size_store()

Cc: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Richard Chang <richardycc@google.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Yuwen Chen <ywen.chen@foxmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-add-writeback-batch-size-device-attr-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -602,9 +602,9 @@ static ssize_t writeback_batch_size_stor
 	if (!val)
 		val = 1;
 
-	down_read(&zram->init_lock);
+	down_write(&zram->init_lock);
 	zram->wb_batch_size = val;
-	up_read(&zram->init_lock);
+	up_write(&zram->init_lock);
 	ret = len;
 
 	return ret;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
mm-huge_memory-introduce-enum-split_type-for-clarity-fix.patch
mm-correctly-handle-uffd-pte-markers-fix.patch
zram-add-writeback-batch-size-device-attr-fix.patch
mm-huge_memoryc-introduce-folio_split_unmapped-v2-fix-fix.patch
memblock-unpreserve-memory-in-case-of-error-fix.patch

