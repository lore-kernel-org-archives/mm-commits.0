Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2770E2E8B80;
	Mon, 10 Nov 2025 05:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762752029; cv=none; b=uAs/FmsSPue31UqPbYchtIMTzLsGy60dVYokJv998VGnualWMcApHDRo7mh/iRalzsUpTHve2wHZSVPmqgmcDI3mY+hHO+pE62XYjYG8/AWRHSLzVOE6fDTXXYItuFkDk1bu4FAw59U2V/Piss3Gwj1kuyaOpGdjR3swkXGzlfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762752029; c=relaxed/simple;
	bh=SSAi5UzpyTxOmTOSlSdbsQ7rZRRE+kNGF4Jlx0gm8WI=;
	h=Date:To:From:Subject:Message-Id; b=YygHcD3/tOyseRsyXzIdUu7ysh+ERYrqOaQUzlSb1CS+UhLpFCe2oiztB+kR5CLMWrCX/YlZgwxyFfWavV7KZnIZqPnWu3VdtXZW+xXrelj4F533ntAIuY4Bif43HffGal/Aj/5uz9/0NpSjR0wzPWfDyjyEIwyhod4zCR3UETc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZW+20b/s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZW+20b/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36FBC4CEF5;
	Mon, 10 Nov 2025 05:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762752028;
	bh=SSAi5UzpyTxOmTOSlSdbsQ7rZRRE+kNGF4Jlx0gm8WI=;
	h=Date:To:From:Subject:From;
	b=ZW+20b/soE7fg4IP85SkBM9AY449fSzPRjO6tsG5jXcMULNpSkT9+eFESln2spHm7
	 JuqSSWc1VDIY6fG4nR3FU/lMZ0xTZyEVipSJ5F7DncbJ+qsnLrBOtCV3bOlQBZwHv7
	 psDXTxLGh3F3FWPYmHQHFXZrK9aHi6eeoHVQ2bqo=
Date: Sun, 09 Nov 2025 21:20:28 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,matttbe@kernel.org,oberpar@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] gcov-add-support-for-gcc-15.patch removed from -mm tree
Message-Id: <20251110052028.A36FBC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: gcov: add support for GCC 15
has been removed from the -mm tree.  Its filename was
     gcov-add-support-for-gcc-15.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Oberparleiter <oberpar@linux.ibm.com>
Subject: gcov: add support for GCC 15
Date: Tue, 28 Oct 2025 12:51:25 +0100

Using gcov on kernels compiled with GCC 15 results in truncated 16-byte
long .gcda files with no usable data.  To fix this, update GCOV_COUNTERS
to match the value defined by GCC 15.

Tested with GCC 14.3.0 and GCC 15.2.0.

Link: https://lkml.kernel.org/r/20251028115125.1319410-1-oberpar@linux.ibm.com
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reported-by: Matthieu Baerts <matttbe@kernel.org>
Closes: https://github.com/linux-test-project/lcov/issues/445
Tested-by: Matthieu Baerts <matttbe@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/gcc_4_7.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/gcov/gcc_4_7.c~gcov-add-support-for-gcc-15
+++ a/kernel/gcov/gcc_4_7.c
@@ -18,7 +18,9 @@
 #include <linux/mm.h>
 #include "gcov.h"
 
-#if (__GNUC__ >= 14)
+#if (__GNUC__ >= 15)
+#define GCOV_COUNTERS			10
+#elif (__GNUC__ >= 14)
 #define GCOV_COUNTERS			9
 #elif (__GNUC__ >= 10)
 #define GCOV_COUNTERS			8
_

Patches currently in -mm which might be from oberpar@linux.ibm.com are


