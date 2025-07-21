Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903DB22F769;
	Mon, 21 Jul 2025 21:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753132433; cv=none; b=In47pInL5QLITqprf1SZeERtHDWoDd07ZFscGhPjx+e9aXZWCKDIpjuDdYbp8UTVajoQBXslwujFknSvSU1Pex5WRhmB7AXNgN9MyipvL2O8n+C+ROBWg8N8ojNqVVrNOgUCniwAoC9KPaH7Zqu1C3SQGXHnbZZKkYFayONPcqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753132433; c=relaxed/simple;
	bh=muEoqnl86fUMwlE5ZPYWPgQ0W/tAcAhaGJZykTvXUsA=;
	h=Date:To:From:Subject:Message-Id; b=PkJ2eF7I+QGVPhU46C1LX2kYtPuNTstdnb9nVTuESGX3oze+jBce3yXVbA5eJQlOBgw8XdcUI8lV4JG09yRAZHFGFriKac5PU8Lkdbqy6uBP/FIWpODCq4ivJBFkbPvynin30aWevrD/2+MY+0jbdX73b+4W3YqHcRiOv5UG2rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EQSVgant; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EQSVgant"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41334C4CEED;
	Mon, 21 Jul 2025 21:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753132433;
	bh=muEoqnl86fUMwlE5ZPYWPgQ0W/tAcAhaGJZykTvXUsA=;
	h=Date:To:From:Subject:From;
	b=EQSVgantomMPE0TGzGJEbL2ZjiMpCjQU7ldndbW5Ybx88Z+PmRD3C3azb9QDDMfPb
	 ULBY0wDylFl63ktKGgz9dg2yVOLFdP2fh5OGVpffYmBsj8gBzfy40Y67feUYxYJKyZ
	 hWqciZhwTA6q6BEFpVEAZ4NmASovhubolKpElE8I=
Date: Mon, 21 Jul 2025 14:13:52 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,senozhatsky@chromium.org,rostedt@goodmis.org,pmladek@suse.com,linux@rasmusvillemoes.dk,herbert@gondor.apana.org.au,andriy.shevchenko@linux.intel.com,sfr@canb.auug.org.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sprintfh-requires-stdargh.patch added to mm-hotfixes-unstable branch
Message-Id: <20250721211353.41334C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sprintf.h requires stdarg.h
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     sprintfh-requires-stdargh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sprintfh-requires-stdargh.patch

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

sprintfh-requires-stdargh.patch

