Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96BD32B987
	for <mm-commits@vger.kernel.org>; Tue, 25 Nov 2025 17:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093521; cv=none; b=N/s2aw6Z1wLtpXePRPODOq4Jq5edcPkulStirTtmw4WaErK1xcmkrMeODjp6OmtkVl/sugIQDnfWopzOrMIWE+gy6+4HzJB1vmXxvK9s86QX/4G2bOFUUoLiAa/lU5vBeBDp3SROLqCBRkaDkWblqlbkWqMcTWl4QTm5z4T4L+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093521; c=relaxed/simple;
	bh=AnkBTKhh79a7XiPGASEZhsnBF2eztpyr0PrY1KhquT0=;
	h=Date:To:From:Subject:Message-Id; b=MP7lkU7Wcv6hIkFAbxIiLj17uC9VCCq+Vfn1/Fc8llGvlaqGaPJIiUoNv9AdRPO4Mug7G6jkX6hEASSYP/K/HTavSGpX+AOeJESUR9QKQmZhId+JKz7MpNEyh2goMxHhj7H2bvbqioIbEZP3jf/iDZof73Q1xQ1TamqD8KxKCps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SF8av19R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SF8av19R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32780C4CEF1;
	Tue, 25 Nov 2025 17:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764093521;
	bh=AnkBTKhh79a7XiPGASEZhsnBF2eztpyr0PrY1KhquT0=;
	h=Date:To:From:Subject:From;
	b=SF8av19RM8pyEAy7mrsKn27GLlPXPgDluGZdlf7ZyqlvYjQo1/NAk9VpGb/bMfOvH
	 asBMgcJUy2/DW788cma+fnXZZxGpfFJ6o6Wy0voDobhdmgDqEYfL+DoN1yVDFgugTr
	 itOBCnDce4sVG4V1Thy3hLqI94cQnsY+o6D3fbcU=
Date: Tue, 25 Nov 2025 09:58:40 -0800
To: mm-commits@vger.kernel.org,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + calibrate-update-header-inclusion.patch added to mm-nonmm-unstable branch
Message-Id: <20251125175841.32780C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: calibrate: update header inclusion
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     calibrate-update-header-inclusion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/calibrate-update-header-inclusion.patch

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

calibrate-update-header-inclusion.patch

