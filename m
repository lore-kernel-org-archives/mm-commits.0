Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE6177623
	for <mm-commits@vger.kernel.org>; Thu, 21 Dec 2023 21:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rg3oiJ8E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD04C433C7;
	Thu, 21 Dec 2023 21:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703194206;
	bh=MfXwOEYmh4FXIW/X3vy30t9neXEs3m27lftEyOJrZsY=;
	h=Date:To:From:Subject:From;
	b=rg3oiJ8Eih5RhgFDIWX0SEEfoDMyvpFeaaUDp8/BObd+tjZuHn+CRkdkPEnPKiyOK
	 nWyMXJhL1MXCj6lP7iWmIexvIAkLhSbBjVO/vb5KbEOHil9iItqmJVwPsFhhCjnvsX
	 a5z0BJZNF7byNbxOYTTt8aeD/hA58Ul6eLMwojfg=
Date: Thu, 21 Dec 2023 13:30:05 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,tanzirh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-replaced-asm-generic-io-with-linux-io.patch added to mm-nonmm-unstable branch
Message-Id: <20231221213006.8CD04C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/trace_readwrite.c:: replace asm-generic/io with linux/io
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-replaced-asm-generic-io-with-linux-io.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-replaced-asm-generic-io-with-linux-io.patch

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
From: Tanzir Hasan <tanzirh@google.com>
Subject: lib/trace_readwrite.c:: replace asm-generic/io with linux/io
Date: Thu, 21 Dec 2023 20:32:33 +0000

asm-generic/io.h can be replaced with linux/io.h and the file will still
build correctly.  It is an asm-generic file which should be avoided if
possible.

Link: https://lkml.kernel.org/r/20231221-tracereadwrite-v1-1-a434f25180c7@google.com
Signed-off-by: Tanzir Hasan <tanzirh@google.com>
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/trace_readwrite.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/trace_readwrite.c~lib-replaced-asm-generic-io-with-linux-io
+++ a/lib/trace_readwrite.c
@@ -7,7 +7,7 @@
 
 #include <linux/ftrace.h>
 #include <linux/module.h>
-#include <asm-generic/io.h>
+#include <linux/io.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/rwmmio.h>
_

Patches currently in -mm which might be from tanzirh@google.com are

lib-replaced-asm-generic-io-with-linux-io.patch

