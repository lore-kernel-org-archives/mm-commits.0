Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25D715624D
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 20:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712176531; cv=none; b=gI6x556YDE+ZsdIyP5EBC+OPjhuTrDMQkHbhmmZAWz8ADFYL6W0mMGv6Ei1EYyDobw3xqji1sr8bCnOGo1/gR8skinE8EZf3vVu4yGM0iyq1t7N9LTKTiGLvEYiWcY6pyrwwHhH8aD0Koreb5V/vnWmRUw5J8VLDGoxs1KLKhng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712176531; c=relaxed/simple;
	bh=siou/EiKH0PQd9yoJfROnyP7+rPa/6UOVOHxcTi6+dA=;
	h=Date:To:From:Subject:Message-Id; b=qkclVwE0FYtCzKefEl/eJjDz1cI2vIhX6g3D2bCFg9fnQ0LrJxIH0IufeV5crOf//iU95+MXY+LCUEvXuld2cE/P/IL3SWfH9KVB5aGJgCP2klPG6WlFCvColdEkxOIM3CBnvkYzl+1vs7NF/RlZjp4Ril71qtTpZ9Jzu23zT0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IgMHXCyr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IgMHXCyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BD1C433A6;
	Wed,  3 Apr 2024 20:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712176530;
	bh=siou/EiKH0PQd9yoJfROnyP7+rPa/6UOVOHxcTi6+dA=;
	h=Date:To:From:Subject:From;
	b=IgMHXCyr9R9/oiYtHenEow6ILW2KO2oN3KmYN8PqAgbz3p/+4zuOrjrG5SninppYd
	 vdWCaO/C7z6Sms9zQsIAYUlxWyirV+caCosBFLi0rh3Oa3pcQ3+pHxWO7OCsVGcifC
	 ybilbncGHbD3+ZsbLjlHve8TsMNRkuOWSJWe7l/k=
Date: Wed, 03 Apr 2024 13:35:29 -0700
To: mm-commits@vger.kernel.org,pstanner@redhat.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + devres-dont-use-proxy-headers.patch added to mm-nonmm-unstable branch
Message-Id: <20240403203530.51BD1C433A6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: devres: don't use "proxy" headers
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     devres-dont-use-proxy-headers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/devres-dont-use-proxy-headers.patch

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
Subject: devres: don't use "proxy" headers
Date: Wed, 3 Apr 2024 13:46:57 +0300

Update header inclusions to follow IWYU (Include What You Use) principle.

Link: https://lkml.kernel.org/r/20240403104820.557487-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Philipp Stanner <pstanner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/devres.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/lib/devres.c~devres-dont-use-proxy-headers
+++ a/lib/devres.c
@@ -1,10 +1,13 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/bug.h>
 #include <linux/device.h>
-#include <linux/err.h>
-#include <linux/io.h>
-#include <linux/gfp.h>
+#include <linux/errno.h>
 #include <linux/export.h>
+#include <linux/gfp_types.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
 #include <linux/of_address.h>
+#include <linux/types.h>
 
 enum devm_ioremap_type {
 	DEVM_IOREMAP = 0,
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

devres-switch-to-use-dev_err_probe-for-unification.patch
devres-dont-use-proxy-headers.patch

