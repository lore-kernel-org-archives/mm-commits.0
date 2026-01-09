Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF812777F3
	for <mm-commits@vger.kernel.org>; Fri,  9 Jan 2026 16:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767974503; cv=none; b=TzpDGuImEPjPDkNz7KvzQ2+p8FmBMXiTnvGjpFsv0w1zpqA8YCll8Cle5uzgpT5/E9aqPojFhG6+4qdBmDZto44KxJylROlhj68dIdQhaszEsuKaSe+XNZbHE4aU4NlixRbKXJAEgUi8sMSVwRQzwHJxsVNc5L8J+dlwaZmjRjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767974503; c=relaxed/simple;
	bh=v/izjEuWU7iPEq4c7vsCkUR/W9uTdte5ABuFXdyukiQ=;
	h=Date:To:From:Subject:Message-Id; b=r12ntxIzppnz+kQHJK0Lpw+CdokKr1yaDGDCuN8N5KBmvWWUwPdZSjQANSy8JjwDwktqVUNN/7KT3zoPzBTj4tRmV9dFJVWHaNg1ly02btfFDoIcRYOqVoWNKGYG8HypaYZREAg3D+uzVRFlIAo2fgXQq+V4Y5+ztFmwJYWF/gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U+OsNXOP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U+OsNXOP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D42C4CEF1;
	Fri,  9 Jan 2026 16:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767974503;
	bh=v/izjEuWU7iPEq4c7vsCkUR/W9uTdte5ABuFXdyukiQ=;
	h=Date:To:From:Subject:From;
	b=U+OsNXOPf+3FH+5pA5lKXgDScEm/k7RrbaZP0p5b4iJMQYpAXZ6kTRAy8nvZPlmDK
	 JKd33lpKIcesoHWsZ7R6FCys+SUBJRBkvBRqfZbZWgHWgbjZwDaj8UixTFithuUfYc
	 aow19XfnEx5BBn4AzTQfTkaUnuhzs718s7dVNEoc=
Date: Fri, 09 Jan 2026 08:01:42 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,hewenliang4@huawei.com,graf@amazon.com,longwei27@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-remove-duplicate-header-file-references.patch added to mm-nonmm-unstable branch
Message-Id: <20260109160142.E4D42C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: Remove duplicate header file references
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-remove-duplicate-header-file-references.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-remove-duplicate-header-file-references.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Long Wei <longwei27@huawei.com>
Subject: kho: Remove duplicate header file references
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

kho-test-clean-up-residual-memory-upon-test_kho-module-unload.patch
kho-remove-duplicate-header-file-references.patch

