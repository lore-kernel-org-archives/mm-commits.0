Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B28FBF4
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645185; cv=none; b=fQWr62ydIGPPJIZYtNIULI7RcaKUZOJ2m11eRuNRvC4aJBUGTPNkSwxXLlDcoPrWrFrCFVlE71dZsJdISFYE//YO+lszAQWiz9vF26Qpm6JSYGQtGN8PDyACLpcX7+wfGuoOc6Wpez+7hYgd5wa7zhGNI5vrwqnaQYBWRQ/dKtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645185; c=relaxed/simple;
	bh=ylSCl4xpVDekRaJN/P4tkEIC9t/pA5KOpFmFaZkNBas=;
	h=Date:To:From:Subject:Message-Id; b=puopxBvn8ghZ2QJddkH4JBDl8bOypdGlg1dFugEwRWvPSQl/DExCvNhk2+KcSMdo3IXq0nkXIzd3NemtCmO4Q4Ir4oJZDFKApQzwDLmpDXeYATbdsvipPNU8zm9x63leV5XaJMd8PE6vdS+WmuEaJRaHPSrrgzlrY0RdaauJ4o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m1v9dq+J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m1v9dq+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA85C433F1;
	Thu, 22 Feb 2024 23:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645184;
	bh=ylSCl4xpVDekRaJN/P4tkEIC9t/pA5KOpFmFaZkNBas=;
	h=Date:To:From:Subject:From;
	b=m1v9dq+JK5a+4ELZkpyqHk1GzTLLxM2M/yB895L1iTHE7ZX66w4KImwTFTIL5RbO3
	 tbn+zJFQgUcXHATN23698LDNnlMKJ3+p2zJ5RYGm+ThLlcOUrUPO4ZI8pZlJDXBhoG
	 1P8shp/fDUyo3tGNi/qxeivOH4/0L2KSVj9O+0Os=
Date: Thu, 22 Feb 2024 15:39:43 -0800
To: mm-commits@vger.kernel.org,geert+renesas@glider.be,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-dhry-remove-unneeded-linux-mutexh.patch removed from -mm tree
Message-Id: <20240222233944.7CA85C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: dhry: remove unneeded <linux/mutex.h>
has been removed from the -mm tree.  Its filename was
     lib-dhry-remove-unneeded-linux-mutexh.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: lib: dhry: remove unneeded <linux/mutex.h>
Date: Mon, 22 Jan 2024 15:50:43 +0100

Patch series "lib: dhry: miscellaneous cleanups".

This patch series contains a few miscellaneous cleanups for the
Dhrystone benchmark test.


This patch (of 3):

The Dhrystone benchmark test does not use mutexes.

Link: https://lkml.kernel.org/r/cover.1705934853.git.geert+renesas@glider.be
Link: https://lkml.kernel.org/r/cf8fafaedccf96143f1513745c43a457480bfc24.1705934853.git.geert+renesas@glider.be
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dhry_run.c |    1 -
 1 file changed, 1 deletion(-)

--- a/lib/dhry_run.c~lib-dhry-remove-unneeded-linux-mutexh
+++ a/lib/dhry_run.c
@@ -10,7 +10,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/mutex.h>
 #include <linux/smp.h>
 
 #define DHRY_VAX	1757
_

Patches currently in -mm which might be from geert+renesas@glider.be are


