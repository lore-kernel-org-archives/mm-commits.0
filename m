Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D146BA3D;
	Fri, 25 Jul 2025 00:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753405114; cv=none; b=FW3RRpOw0IGaZeSIhzv20oC3SpNJoYGbA2CvAi6BO5X3740CAfCP2u2iLYZN4LmXnQWYDQ5UcYYaDUeorl8SppK7Skdp0Sy5JJAYnNYbKS9U3jU6bhU3S7U/8dgM8o2xIY1CwWXNgveeXcXdi3a2mhcroLhk0xZwJPNfKarzkd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753405114; c=relaxed/simple;
	bh=zvXYrAI1SQv4U+ZFGo0Gf9ewLL/nHTCZThClfO2JKAI=;
	h=Date:To:From:Subject:Message-Id; b=kdGyAVTF4eQBgFV0tueV7pvSnqRfLJLjFw1RAL4FB7hT0rvHeqnLJWoUt8EdKho7uzf+txuZTwx5q1VWfMy7R3Shxs3WMGQNGqe/gx0KaKFDrnGi6sEDfimhXOaoau8+5rjIGHCiWH9jKAczjUBJqJgeTOPx10AON0NjG6WxQeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WTt5y3xH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WTt5y3xH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A34C4CEED;
	Fri, 25 Jul 2025 00:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753405113;
	bh=zvXYrAI1SQv4U+ZFGo0Gf9ewLL/nHTCZThClfO2JKAI=;
	h=Date:To:From:Subject:From;
	b=WTt5y3xHxVBQuGw5VuHSl1TC5ZaD7rAf6xbPAHIdRxvAKaGL2dk0wKcf9uVAUWRXg
	 Y7TGJ3lgUooN/3Vqw0kygpf6mk2tDUjN9xfKZNIorVLKpr4hSoVnT6vNlEwp88+Jdx
	 bKqu+wvyz447rNY6LwCj+LGAFnBzGxTcafgrFToI=
Date: Thu, 24 Jul 2025 17:58:33 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,senozhatsky@chromium.org,rostedt@goodmis.org,pmladek@suse.com,linux@rasmusvillemoes.dk,herbert@gondor.apana.org.au,andriy.shevchenko@linux.intel.com,sfr@canb.auug.org.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] sprintfh-requires-stdargh.patch removed from -mm tree
Message-Id: <20250725005833.D1A34C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sprintf.h requires stdarg.h
has been removed from the -mm tree.  Its filename was
     sprintfh-requires-stdargh.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: sprintf.h requires stdarg.h
Date: Mon, 21 Jul 2025 16:15:57 +1000

In file included from drivers/crypto/intel/qat/qat_common/adf_pm_dbgfs_utils.c:4:
include/linux/sprintf.h:11:54: error: unknown type name 'va_list'
   11 | __printf(2, 0) int vsprintf(char *buf, const char *, va_list);
      |                                                      ^~~~~~~
include/linux/sprintf.h:1:1: note: 'va_list' is defined in header '<stdarg.h>'; this is probably fixable by adding '#include <stdarg.h>'

Link: https://lkml.kernel.org/r/20250721173754.42865913@canb.auug.org.au
Fixes: 39ced19b9e60 ("lib/vsprintf: split out sprintf() and friends")
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sprintf.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/sprintf.h~sprintfh-requires-stdargh
+++ a/include/linux/sprintf.h
@@ -4,6 +4,7 @@
 
 #include <linux/compiler_attributes.h>
 #include <linux/types.h>
+#include <linux/stdarg.h>
 
 int num_to_str(char *buf, int size, unsigned long long num, unsigned int width);
 
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are


