Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D5D314D38
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967403; cv=none; b=tE0QZ+1D+8TIGW7WXem3GuhTdRMKMJRg1hwImsIDanToFCFgPhcJ+sMaEqH+WfWhncT1AR6cYf+RDm9+3MP7d0KFzGZ73PPB9jgU/+6GpqmJ3E6YtT+ojnlSYq9JCcbkvqPK133D7+s/LBn7LIMOpfE19z/uXedOTZIW2kHcdBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967403; c=relaxed/simple;
	bh=qnqEQlPOjEXjEymFw27QuRFJL9Vg7u44prPzaIcLdoU=;
	h=Date:To:From:Subject:Message-Id; b=DVvjM5WnEimjbudwiZmefBjEgOub2BXHkf3asFMRrdeCs8teJEb795dNL01gTQP8DvWPa3wl/r5v44lNE0hAFO/0lySwy7bPvwm7YhbNRXhmY7qOFf6pl0/e0w1ojeNpK/CF9xMKuDTVO3gbO0TCoAvOKcncosxFlV3t1O6XOs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2JKm7xuF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2JKm7xuF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56AEBC19425;
	Wed, 21 Jan 2026 03:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967403;
	bh=qnqEQlPOjEXjEymFw27QuRFJL9Vg7u44prPzaIcLdoU=;
	h=Date:To:From:Subject:From;
	b=2JKm7xuFPBPvKJ5HpvrSk01XNj+g3E9O4P4UiamQpeXbIp3dtzri941jSia1sA+p5
	 wHfbfLAobJ8vZivoc2rXMDltl4wJj6tIMB7DI3nS4v4GBVoHdZPoP0pt3wZnN3Xfz6
	 9fnrN5189dc0Tue+Qr85Yfj0/VLigmd42rezTyEE=
Date: Tue, 20 Jan 2026 19:50:02 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,hewenliang4@huawei.com,graf@amazon.com,longwei27@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-remove-duplicate-header-file-references.patch removed from -mm tree
Message-Id: <20260121035003.56AEBC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: remove duplicate header file references
has been removed from the -mm tree.  Its filename was
     kho-remove-duplicate-header-file-references.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Long Wei <longwei27@huawei.com>
Subject: kho: remove duplicate header file references
Date: Tue, 16 Dec 2025 19:44:00 +0800

kexec_handover_internal.h is included twice in kexec_handover.c.  Remove
the redundant first inclusion to eliminate the duplication.

Link: https://lkml.kernel.org/r/20251216114400.2677311-1-longwei27@huawei.com
Signed-off-by: Long Wei <longwei27@huawei.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: hewenliang <hewenliang4@huawei.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-remove-duplicate-header-file-references
+++ a/kernel/liveupdate/kexec_handover.c
@@ -25,7 +25,6 @@
 
 #include <asm/early_ioremap.h>
 
-#include "kexec_handover_internal.h"
 /*
  * KHO is tightly coupled with mm init and needs access to some of mm
  * internal APIs.
_

Patches currently in -mm which might be from longwei27@huawei.com are


