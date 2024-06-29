Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B97C18C36
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628626; cv=none; b=JybFmDOfa4jdm/eqbba+bJN5UhFeEBj7LbHb3eDEInNqEuC5c/H8UShSqSf0yS3TySg7G93tSrcucATp+a3LaZa0qVtqlW4XtQjEckituHcl+vQiPAccXv3cSIjLTI7CWLi2JAX7IwZJCKEpwaVQW1r0YMAATtGY5GWgh7jwjC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628626; c=relaxed/simple;
	bh=e0pp2qEQw7HvmLF3CkTtnzBOFqeQaMaT8UmxSmUK1cg=;
	h=Date:To:From:Subject:Message-Id; b=fAp6TwAznaH7H7jY6T1JI/L2jtOL12B8/w0SU09bDsOcAGx+5FILoLv8KidDRyZa1rMhOMG7RSGf3yk9jrlt7XQyjIHARwIATTEckXH4i9rIlcDLDfICJ0C5v29JSVbswbmOPnTL1SllCqA5HKCxsmRcd4gPWxhzS5tbOHQxsLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JTCVse3t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JTCVse3t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999CDC116B1;
	Sat, 29 Jun 2024 02:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628625;
	bh=e0pp2qEQw7HvmLF3CkTtnzBOFqeQaMaT8UmxSmUK1cg=;
	h=Date:To:From:Subject:From;
	b=JTCVse3tPYNwlP1Kr/qdWrBoFORipRTJa1rTUqFOJqY3uHMiM/cMZuenH6tP8hID+
	 GKCKxNzIPCJo9MYN9BRsXzAo6PMX2P+lA9i3ZdzMsZDgbJL32BMMzIWlZ+tOCNq1VC
	 jyDsXY0ptnBCeGcWLI0ZITAYC7QMWoRn+9hwDKOo=
Date: Fri, 28 Jun 2024 19:37:05 -0700
To: mm-commits@vger.kernel.org,mpe@ellerman.id.au,kirill.shutemov@linux.intel.com,kbingham@kernel.org,jan.kiszka@siemens.com,kuan-ying.lee@canonical.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-rework-module-va-range.patch removed from -mm tree
Message-Id: <20240629023705.999CDC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/gdb: rework module VA range
has been removed from the -mm tree.  Its filename was
     scripts-gdb-rework-module-va-range.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Subject: scripts/gdb: rework module VA range
Date: Wed, 19 Jun 2024 15:49:07 +0800

After we enlarge the module VA range, we also change the module VA
range in gdb scripts.

Link: https://lkml.kernel.org/r/20240619074911.100434-3-kuan-ying.lee@canonical.com
Fixes: 3e35d303ab7d ("arm64: module: rework module VA range selection")
Signed-off-by: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/mm.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/gdb/linux/mm.py~scripts-gdb-rework-module-va-range
+++ a/scripts/gdb/linux/mm.py
@@ -33,7 +33,7 @@ class aarch64_page_ops():
     def __init__(self):
         self.SUBSECTION_SHIFT = 21
         self.SEBSECTION_SIZE = 1 << self.SUBSECTION_SHIFT
-        self.MODULES_VSIZE = 128 * 1024 * 1024
+        self.MODULES_VSIZE = 2 * 1024 * 1024 * 1024
 
         if constants.LX_CONFIG_ARM64_64K_PAGES:
             self.SECTION_SIZE_BITS = 29
_

Patches currently in -mm which might be from kuan-ying.lee@canonical.com are


