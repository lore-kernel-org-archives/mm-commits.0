Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BCD17741
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127147; cv=none; b=U4Pexv95fOWuoBSxXQenPn11KnWPTkPkFMUcGkN+O2Of2w8X1BxMjIEshiW4pwNMZe89+LvoRHRnyXtbOC6mFeQa7alqdnxflQxE4LFwgHhlH97+bEpIbXru/UIbQZwsiUz3wUX9iV/uB/hHrM5a10v2UnlV/fqDltuNSYwVw+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127147; c=relaxed/simple;
	bh=DhFj/Wm39hE4eHLmQrBSBtKlvkTEhZRqQMrEeW7fh+w=;
	h=Date:To:From:Subject:Message-Id; b=Jv0ryYyCri07oestvfqpw36AQrVeeG3wYYeixlc79LBNz7uXBzlPmOEseXZfrGHw0ZJrRkOccMpr/1u/gewrU1wscUHdFF+mcBxgJJAK+ql7eF3wo5Nx66IzzvysimYN+8tNJRvWdbjMk9/QqFhsXoXADmdEZfHpinGKtdR4NSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2C3Z0Fvk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2C3Z0Fvk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888D4C4CEE3;
	Thu, 10 Jul 2025 05:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752127146;
	bh=DhFj/Wm39hE4eHLmQrBSBtKlvkTEhZRqQMrEeW7fh+w=;
	h=Date:To:From:Subject:From;
	b=2C3Z0FvkxfWVd/ezSgAS6Y8QrgoVxBIQlm1DyB5fkhFRrFQxOLbFrQMu8UtpjUfAD
	 HdVukJNapUAUKNo6lv+YJmkBkppCOUOa6K7gKPH1nwcnACFVoO7enCvB1R5HzoSYBj
	 bvEo174gVHTtPTXSiR9cEYDqNS0k+FcrGbvmOo+Q=
Date: Wed, 09 Jul 2025 22:59:06 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,richard.henderson@linaro.org,mattst88@gmail.com,guoweikang.kernel@gmail.com,geert@linux-m68k.org,agordeev@linux.ibm.com,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] alpha-replace-sprintf-strcpy-with-scnprintf-strscpy.patch removed from -mm tree
Message-Id: <20250710055906.888D4C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alpha: replace sprintf()/strcpy() with scnprintf()/strscpy()
has been removed from the -mm tree.  Its filename was
     alpha-replace-sprintf-strcpy-with-scnprintf-strscpy.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-hugetlb-use-str_plural-in-report_hugepages.patch
mm-cma-use-str_plural-in-cma_declare_contiguous_multi.patch

