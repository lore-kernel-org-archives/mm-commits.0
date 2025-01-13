Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE039155C97
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742196; cv=none; b=ni30qPHT4Pshm7H4cZcsQqi8bvF/P+GoQFYg20zQflBYw0wOPGjqC2zRaIgiz0G7/YOh5r8dew6aPXHKW/SCtkT8u5FEHDNnn24sWFc4NWAxk2fglEektYBbDQyVVcj952Qcyx/99z0AWcvZj/B9Y8jOpnZsreabP0+CNOHYqOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742196; c=relaxed/simple;
	bh=HaoGvueBLoh4PY2qwUWS2+pFPy56RmWAW3/3DOD5ok8=;
	h=Date:To:From:Subject:Message-Id; b=qns1cszaEpuDX1VdGPEbsr1kgO5zGQ/LDytmg2twOs1NTU3S19XAlg6VeAAnfzdDk672Ac/8U96Rut3XUJwsgxSI2iPTYd4uiJMxVZimxQCrLY8fGEZFbPdYIOf5EL1Z5FYdXXkv3YblcMAE6a9ME/hkHmZ4ck/KL0LZd75CIQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ix59Xb+Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ix59Xb+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4EC8C4CED6;
	Mon, 13 Jan 2025 04:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742195;
	bh=HaoGvueBLoh4PY2qwUWS2+pFPy56RmWAW3/3DOD5ok8=;
	h=Date:To:From:Subject:From;
	b=Ix59Xb+QOy111yLHPcw32bE2SlPh+CSUpJxALZpFa1FAOKOMFJV83D7xVD+MkaC4W
	 h+KI5cnJkhLp+hBiiphtcH7pdCVcZMaPC6FKnFpW1eTwhsbddvBKC4neHiyxoUsneR
	 GAGzS1sihSqXkbWlCMMI1oLRHdKG7NEhmzq9PxJs=
Date: Sun, 12 Jan 2025 20:23:15 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,surenb@google.com,richard.henderson@linaro.org,pasha.tatashin@soleen.com,mattst88@gmail.com,kent.overstreet@linux.dev,arnd@arndb.de,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] alpha-remove-duplicate-included-header-file.patch removed from -mm tree
Message-Id: <20250113042315.C4EC8C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alpha: remove duplicate included header file
has been removed from the -mm tree.  Its filename was
     alpha-remove-duplicate-included-header-file.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: alpha: remove duplicate included header file
Date: Tue, 26 Nov 2024 12:47:26 +0100

Remove duplicate included header file asm/fpu.h

Link: https://lkml.kernel.org/r/20241126114728.139029-1-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/lib/fpreg.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/alpha/lib/fpreg.c~alpha-remove-duplicate-included-header-file
+++ a/arch/alpha/lib/fpreg.c
@@ -10,7 +10,6 @@
 #include <linux/preempt.h>
 #include <asm/fpu.h>
 #include <asm/thread_info.h>
-#include <asm/fpu.h>
 
 #if defined(CONFIG_ALPHA_EV6) || defined(CONFIG_ALPHA_EV67)
 #define STT(reg,val)  asm volatile ("ftoit $f"#reg",%0" : "=r"(val));
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are


