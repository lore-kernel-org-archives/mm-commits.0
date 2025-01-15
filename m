Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D3919E7ED
	for <mm-commits@vger.kernel.org>; Wed, 15 Jan 2025 23:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736984257; cv=none; b=O9Eti3M33r098rqJ9C/nYjI2Zy1kcfiiHb9lewS9NQS97AfJS0B3Mw3Fh4QE8u6YjDR1B/y2o75pjt0xLciZNTXMJnaZUIWz04ZFj+pNup9EtLfK4SJwoMZ+N/xknVqo1uLx3dYfSj9tmtr5i6G5xJGOJUaBHP79lf6ZkVb2J8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736984257; c=relaxed/simple;
	bh=23ufFJGUq/V9ZLiJXTMOSL5Ga8CpVi7mcAAfeAN59ME=;
	h=Date:To:From:Subject:Message-Id; b=kbamaDTXWk7nUAtqYSE6smmmwzfgUM0U4l/xdsYuQL+m4olp6TVCbEVKAZzdO0eH+Q6ET7lCl9q2UFroNs4tGJV9UQxtZazdCnNgU0HzmOCspvAjgLSM/D8bU9TrEUuiHaIhRVXfovTszkt1ZpwUH2P5MTLDsC6tit11P6HYSk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kjj/I9BI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kjj/I9BI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335DDC4CED1;
	Wed, 15 Jan 2025 23:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736984257;
	bh=23ufFJGUq/V9ZLiJXTMOSL5Ga8CpVi7mcAAfeAN59ME=;
	h=Date:To:From:Subject:From;
	b=kjj/I9BI4Lq2MxWw7/ea5AAs09OPp+pOApZDNonqUwOZQVYuyzbEPWdHvM94ot/8j
	 miBaK/siaZtkLYgfu4I2C4n3E27quMfpftsU98LEDXasRWyo/ENlM7hPsz6ZdAsnma
	 Xn39pBehr+UplEpV4RLZm1GCU4Ax/RBvfvkwIjwM=
Date: Wed, 15 Jan 2025 15:37:36 -0800
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,jserv@ccns.ncku.edu.tw,corbet@lwn.net,richard120310@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-physical-memory-remove-zone_t.patch added to mm-unstable branch
Message-Id: <20250115233737.335DDC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs/mm: physical memory: Remove zone_t
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-physical-memory-remove-zone_t.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-physical-memory-remove-zone_t.patch

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
From: I Hsin Cheng <richard120310@gmail.com>
Subject: docs/mm: physical memory: Remove zone_t
Date: Wed, 15 Jan 2025 15:03:55 +0800

"zone_t" doesn't exist in current code base anymore, remove the
description of it.

Link: https://lkml.kernel.org/r/20250115070355.41769-1-richard120310@gmail.com
Signed-off-by: I Hsin Cheng <richard120310@gmail.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/physical_memory.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/mm/physical_memory.rst~docs-mm-physical-memory-remove-zone_t
+++ a/Documentation/mm/physical_memory.rst
@@ -33,7 +33,7 @@ The entire physical address space is par
 called zones which represent ranges within memory. These ranges are usually
 determined by architectural constraints for accessing the physical memory.
 The memory range within a node that corresponds to a particular zone is
-described by a ``struct zone``, typedeffed to ``zone_t``. Each zone has
+described by a ``struct zone``. Each zone has
 one of the types described below.
 
 * ``ZONE_DMA`` and ``ZONE_DMA32`` historically represented memory suitable for
_

Patches currently in -mm which might be from richard120310@gmail.com are

docs-mm-physical-memory-remove-zone_t.patch

