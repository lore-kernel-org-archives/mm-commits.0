Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA531B423B;
	Tue, 28 Oct 2025 22:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761692055; cv=none; b=FeAv0r83UT4ETbJFLS6junjBkZ1+N2nnmbgabsli2iiyrn1ostdwOU8+4PJpIkUhIgHD4tjYlj6ks5S8YK3IzVuJzcDQTiflw3h63nkjApYZnuTAeL8ZKBS5O/OsN2lwA1HZ9kvo9VlhXQkNhKer8zGERM/zkOzdRuIWEE0we3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761692055; c=relaxed/simple;
	bh=r6cxVJmstfAl4tbo41BS0KrpXkPyrkkCbiFySiG/Ufc=;
	h=Date:To:From:Subject:Message-Id; b=NHHyg+rFrs/8sfasRVujCMsu7SKS5/Ut5a12a7WRH/CjoEPWRkNhfdTEXGzYWuCR2m3hpTD4y64dqzbAuRSSsTwdyxQDUdgufHqW0Nej5XDa6nOlpRh0FikpxfYKj0spCbk3NyFUmm7BJRcsMH+FcbDsB8bDsj5fvl57khlvANo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0wZH9Qza; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0wZH9Qza"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF865C4CEE7;
	Tue, 28 Oct 2025 22:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761692054;
	bh=r6cxVJmstfAl4tbo41BS0KrpXkPyrkkCbiFySiG/Ufc=;
	h=Date:To:From:Subject:From;
	b=0wZH9Qzaii7XazTpEIxOD/AN0p6jM/1VPuc99e2AijmdhNV8FjZ6qmkQ2NymTX2Z5
	 79xVBPu4lBcX08NM7lDfkJrL9jo6/HWQqfpSTaarUck1uNgTMrqjF5KraNI7NBFbFE
	 GsPQzTvcu2qBKWfpDRK43NWqbSlyjsQIfdTNFvO4=
Date: Tue, 28 Oct 2025 15:54:13 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,matttbe@kernel.org,oberpar@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + gcov-add-support-for-gcc-15.patch added to mm-hotfixes-unstable branch
Message-Id: <20251028225414.AF865C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: gcov: add support for GCC 15
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     gcov-add-support-for-gcc-15.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/gcov-add-support-for-gcc-15.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

gcov-add-support-for-gcc-15.patch

