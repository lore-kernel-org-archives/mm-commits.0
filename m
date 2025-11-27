Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906901FBEA2
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282449; cv=none; b=hslVqmv6yz3b7yoMBJFkZUUnhlAXt0a0fLNDHP1YWNwIk/2rORuF7h/CDBQtGnt75p3lKtQ0fxwXd3n8dAM+WhGRdQM4CndflZFvbdaIgc7aOnRQ4idWDuOKvZMfsC3NWh0PEd6waIUm0PBb4TpkSza3kP4h+gn6WwII0HLwLGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282449; c=relaxed/simple;
	bh=8o+d1rdTMsDxms6yRy2Cg50tlJP912UnDg08NNSWLW8=;
	h=Date:To:From:Subject:Message-Id; b=dzSsgAwXB+y+C7qOf+muDXlXzFtIzi1PIu+yOYXSpQjhhi2/dxs2dYFmuPEwd7L8I65rcWl5SsOGEyfWP0o2nxn57w75pUwHKBkSPR75v3UTy0qAAv2kDNmaqxo71p/Po5Ec2wemZmzZzbCCHfSDRvvvHjrgbe59kgVU/IeD6Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o8lqKOC9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o8lqKOC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C01C4CEF8;
	Thu, 27 Nov 2025 22:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282449;
	bh=8o+d1rdTMsDxms6yRy2Cg50tlJP912UnDg08NNSWLW8=;
	h=Date:To:From:Subject:From;
	b=o8lqKOC92lvhtV1lcX+pBZ6pb5Uy19Qkqi9QWIRqcSMWqd8AN1N93ZH5MvgWJOvaL
	 K0nibh7CVjQWdT6OZ5D8uXM4iM0fuHe6LHwifieHJ37BGXFcINplg16iUnZsrk2M6b
	 WA3dgkkJWI4scUKLagiQW3GiLNtHpP9v/xHXWkQg=
Date: Thu, 27 Nov 2025 14:27:28 -0800
To: mm-commits@vger.kernel.org,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] calibrate-update-header-inclusion.patch removed from -mm tree
Message-Id: <20251127222729.66C01C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: calibrate: update header inclusion
has been removed from the -mm tree.  Its filename was
     calibrate-update-header-inclusion.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: calibrate: update header inclusion
Date: Tue, 25 Nov 2025 00:06:06 +0100

While cleaning up some headers, I got a build error on this file:

init/calibrate.c:20:9: error: call to undeclared function 'kstrtoul'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]

Update header inclusions to follow IWYU (Include What You Use) principle.

Link: https://lkml.kernel.org/r/20251124230607.1445421-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/calibrate.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/init/calibrate.c~calibrate-update-header-inclusion
+++ a/init/calibrate.c
@@ -5,12 +5,15 @@
  *  Copyright (C) 1991, 1992  Linus Torvalds
  */
 
-#include <linux/jiffies.h>
 #include <linux/delay.h>
 #include <linux/init.h>
-#include <linux/timex.h>
-#include <linux/smp.h>
+#include <linux/jiffies.h>
+#include <linux/kstrtox.h>
 #include <linux/percpu.h>
+#include <linux/printk.h>
+#include <linux/smp.h>
+#include <linux/stddef.h>
+#include <linux/timex.h>
 
 unsigned long lpj_fine;
 unsigned long preset_lpj;
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


