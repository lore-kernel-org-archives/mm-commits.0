Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD057CF29;
	Tue, 12 Mar 2024 15:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710257927; cv=none; b=JPA1bwwtiaXDj8PES+FrbH4lV0b2/i5eXJ3egfnN8ILSbBzDtQHH160UO0HjWacfSoavNDveZ5LETStv9JKG0OUzLTg+wB4vHmoFxKM3wNQsNB9YrhCnwy+8kuRe+kcb7GhAxDPK7KAC4X0+JAdSndDYqq9S99xNXaSolFtpZ6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710257927; c=relaxed/simple;
	bh=JEe1p4YuAcLTcqOzPOtIkFuMmTKp7ljr+tOfaoGOZp4=;
	h=Date:To:From:Subject:Message-Id; b=P4qQXTHcXT6IroOAGcXJjG3j6y3xhXE7p5HQH1Cl9su1CJtk4mFtE0fNLcYxO/UwiO/4pTH8/qFyWiAJhEGyRGoie9QSNOBpt2Ss4cBN+20ZP2B3LB2QxCBakTW6c9jS2e187A9jMnuLsNkIB99GnhN/H/46CUZHtKnoDtPN4gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=thF9tFO4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="thF9tFO4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39DDC43390;
	Tue, 12 Mar 2024 15:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710257926;
	bh=JEe1p4YuAcLTcqOzPOtIkFuMmTKp7ljr+tOfaoGOZp4=;
	h=Date:To:From:Subject:From;
	b=thF9tFO4B1Zv0TNjOkT1gCbJL3QY6IinPBEO9tqGLlvsHhKlBXRoZjPHV8yVY4b3Q
	 /l1HHVWl7bpi0/q4bA0G45nItxekDFACv+ujP6bUGbnV3F7VY/8xtvzqlYstQdODM9
	 qvDtvp5LATAeBXn6AQIsPpBRg9P6F47AL0DILHsQ=
Date: Tue, 12 Mar 2024 08:38:46 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,justinstitt@google.com,qiang4.zhang@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memtest-use-readwrite_once-in-memory-scanning.patch added to mm-unstable branch
Message-Id: <20240312153846.D39DDC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memtest: use {READ,WRITE}_ONCE in memory scanning
has been added to the -mm mm-unstable branch.  Its filename is
     memtest-use-readwrite_once-in-memory-scanning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memtest-use-readwrite_once-in-memory-scanning.patch

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
From: Qiang Zhang <qiang4.zhang@intel.com>
Subject: memtest: use {READ,WRITE}_ONCE in memory scanning
Date: Tue, 12 Mar 2024 16:04:23 +0800

memtest failed to find bad memory when compiled with clang.  So use
{WRITE,READ}_ONCE to access memory to avoid compiler over optimization.

Link: https://lkml.kernel.org/r/20240312080422.691222-1-qiang4.zhang@intel.com
Signed-off-by: Qiang Zhang <qiang4.zhang@intel.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memtest.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memtest.c~memtest-use-readwrite_once-in-memory-scanning
+++ a/mm/memtest.c
@@ -51,10 +51,10 @@ static void __init memtest(u64 pattern,
 	last_bad = 0;
 
 	for (p = start; p < end; p++)
-		*p = pattern;
+		WRITE_ONCE(*p, pattern);
 
 	for (p = start; p < end; p++, start_phys_aligned += incr) {
-		if (*p == pattern)
+		if (READ_ONCE(*p) == pattern)
 			continue;
 		if (start_phys_aligned == last_bad + incr) {
 			last_bad += incr;
_

Patches currently in -mm which might be from qiang4.zhang@intel.com are

memtest-use-readwrite_once-in-memory-scanning.patch

