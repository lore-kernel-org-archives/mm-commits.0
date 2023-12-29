Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04A614010
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zscfNkhA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D35C433C9;
	Fri, 29 Dec 2023 20:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703881409;
	bh=rIynfuCo4e4wslXyR1tM4HT0D3tHCTY/qSNHtiUU6Zk=;
	h=Date:To:From:Subject:From;
	b=zscfNkhAaY/U5S5ogxx5QD6e/KbdWDR7ilp9gsKdjlxxQopXjI6Q/yhGYpJ7rb806
	 hfGaPTZSLAlwrny3YcV7/3DJaCfrX4JXHs32FUAvrQmef77ZE0PAKF/KUaZzrlcR4J
	 4UCXhahJYCKWr8os7URZIuBzHYXvoM95brQHTodk=
Date: Fri, 29 Dec 2023 12:23:29 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,tanzirh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-replaced-asm-generic-io-with-linux-io.patch removed from -mm tree
Message-Id: <20231229202329.B8D35C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/trace_readwrite.c:: replace asm-generic/io with linux/io
has been removed from the -mm tree.  Its filename was
     lib-replaced-asm-generic-io-with-linux-io.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


