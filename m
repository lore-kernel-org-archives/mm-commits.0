Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1880D2701CC
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 23:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749079326; cv=none; b=YUjPK8tFJUHuCSiLK6ALyFCzIcuBxHA57EVoWxYfAUKWMwVcqQzMcXvtQuGvpJ0RPGBq8cwf6OKWldOOv4EqcS0Cbp8cfZC+L8KM8akbIjckEHl1mL5PcH88YazE5SnhmzmNq1VES8CeF3wyHpIVc/Ehaf33k3lCj9USCQZBRNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749079326; c=relaxed/simple;
	bh=LNTyMgjulqD0IghLVN3eIyue4IdjtY0HFG/Th2FH/+A=;
	h=Date:To:From:Subject:Message-Id; b=YIAOYXBek6fO/RLpcAB5BUlc681KbEbYoOR7/VhyYHeWJ/ZonGinHhqoBpJmwOfDdHckwWaLGaUar0OaQS5tWcWYauXASd8E2lzE2IffTgnuhZpJSQZzcDqjEYdC6DYPX9rp5Nhm3/Tscb7eA01e9EVmXsH56OMRcbXvu2iSvlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JlfaLQWU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JlfaLQWU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D504C4CEEF;
	Wed,  4 Jun 2025 23:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749079325;
	bh=LNTyMgjulqD0IghLVN3eIyue4IdjtY0HFG/Th2FH/+A=;
	h=Date:To:From:Subject:From;
	b=JlfaLQWUL8+Df1VXcYZAtZUhS40PS+VEzrc6JTJhnjaGrZFPCu6kN81BsaqIfoA3k
	 vqeAy0ANWnnQubBNcQcWO/r2rM+IisNfnKN2b2vBPYv2YIN109xZq28XPCb44qjo+q
	 P98oLQDAsmJjUQJYKvJDh86UG5C/IfYUHHWbApiE=
Date: Wed, 04 Jun 2025 16:22:04 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,richard.henderson@linaro.org,mattst88@gmail.com,guoweikang.kernel@gmail.com,geert@linux-m68k.org,agordeev@linux.ibm.com,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alpha-replace-sprintf-strcpy-with-scnprintf-strscpy.patch added to mm-nonmm-unstable branch
Message-Id: <20250604232205.6D504C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alpha: replace sprintf()/strcpy() with scnprintf()/strscpy()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     alpha-replace-sprintf-strcpy-with-scnprintf-strscpy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alpha-replace-sprintf-strcpy-with-scnprintf-strscpy.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: alpha: replace sprintf()/strcpy() with scnprintf()/strscpy()
Date: Wed, 21 May 2025 14:18:38 +0200

Replace sprintf() with the safer variant scnprintf() and use its return
value instead of calculating the string length again using strlen().

Use strscpy() instead of the deprecated strcpy().

No functional changes intended.

Link: https://github.com/KSPP/linux/issues/88
Link: https://lkml.kernel.org/r/20250521121840.5653-1-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: guoweikang <guoweikang.kernel@gmail.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/core_marvel.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/arch/alpha/kernel/core_marvel.c~alpha-replace-sprintf-strcpy-with-scnprintf-strscpy
+++ a/arch/alpha/kernel/core_marvel.c
@@ -17,6 +17,7 @@
 #include <linux/vmalloc.h>
 #include <linux/mc146818rtc.h>
 #include <linux/rtc.h>
+#include <linux/string.h>
 #include <linux/module.h>
 #include <linux/memblock.h>
 
@@ -79,10 +80,12 @@ mk_resource_name(int pe, int port, char
 {
 	char tmp[80];
 	char *name;
-	
-	sprintf(tmp, "PCI %s PE %d PORT %d", str, pe, port);
-	name = memblock_alloc_or_panic(strlen(tmp) + 1, SMP_CACHE_BYTES);
-	strcpy(name, tmp);
+	size_t sz;
+
+	sz = scnprintf(tmp, sizeof(tmp), "PCI %s PE %d PORT %d", str, pe, port);
+	sz += 1; /* NUL terminator */
+	name = memblock_alloc_or_panic(sz, SMP_CACHE_BYTES);
+	strscpy(name, tmp, sz);
 
 	return name;
 }
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

alpha-replace-sprintf-strcpy-with-scnprintf-strscpy.patch

