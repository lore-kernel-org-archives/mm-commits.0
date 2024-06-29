Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84355111A1
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628244; cv=none; b=R6Fq4AnK3MkGuenHDgt7FMPu1B1p9rcwxU7B87PALZVJzWOe3i9S9vwG9NfPbXkxQM7UL34WDm9jtkVH7ti1tKki7kvf1EK5BcMBdTwKdYkyXLdKfi9AcMKso+hX60XyF1MvSwrCQfzhnE4z4GebQK/DTFljIR9JbnhVfCWNr+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628244; c=relaxed/simple;
	bh=FaU89fvmviigr4wOCL+mmUPBmXRNjcHiPDpKQ6M3p/c=;
	h=Date:To:From:Subject:Message-Id; b=cUniSsk1eWW/aIz2n74p5upf7rdcju+lVixc2IPOaHHXWqH8BSiydLp5O8Go3qRczoKQ40XKkegSVvk4+4dAAuTmIUET6toQ5HOS8AyuphK+hJX+2YGN/U46WxuTn5ATD/2FFktvZB0LYnaHH4cS3capEmP3miUxF6LBrAMIzjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JP4tuVgk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JP4tuVgk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CFA0C116B1;
	Sat, 29 Jun 2024 02:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628244;
	bh=FaU89fvmviigr4wOCL+mmUPBmXRNjcHiPDpKQ6M3p/c=;
	h=Date:To:From:Subject:From;
	b=JP4tuVgkYXLkQ9rlOYt7u9nJcJzgo9v8N3kEwUgOaTkm8oc5aKYOr8hglRe/cOjaA
	 3aB8qm/ydhhXKQCSW60U9isaobNKD38eJE/18RaTbzOcMpPZQVZ0fMee5jN0s6iian
	 I+3z67esEEWQ2g/joxKkRCmOn0v6pdqSlGu5yXXI=
Date: Fri, 28 Jun 2024 19:30:43 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-remove-an-x86-specific-include-from-kmsanh.patch removed from -mm tree
Message-Id: <20240629023044.5CFA0C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmsan: remove an x86-specific #include from kmsan.h
has been removed from the -mm tree.  Its filename was
     kmsan-remove-an-x86-specific-include-from-kmsanh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: kmsan: remove an x86-specific #include from kmsan.h
Date: Fri, 21 Jun 2024 13:34:52 +0200

Replace the x86-specific asm/pgtable_64_types.h #include with the
linux/pgtable.h one, which all architectures have.

While at it, sort the headers alphabetically for the sake of consistency
with other KMSAN code.

Link: https://lkml.kernel.org/r/20240621113706.315500-9-iii@linux.ibm.com
Fixes: f80be4571b19 ("kmsan: add KMSAN runtime core")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Suggested-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <kasan-dev@googlegroups.com>
Cc: Marco Elver <elver@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/kmsan.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/kmsan/kmsan.h~kmsan-remove-an-x86-specific-include-from-kmsanh
+++ a/mm/kmsan/kmsan.h
@@ -10,14 +10,14 @@
 #ifndef __MM_KMSAN_KMSAN_H
 #define __MM_KMSAN_KMSAN_H
 
-#include <asm/pgtable_64_types.h>
 #include <linux/irqflags.h>
+#include <linux/mm.h>
+#include <linux/nmi.h>
+#include <linux/pgtable.h>
+#include <linux/printk.h>
 #include <linux/sched.h>
 #include <linux/stackdepot.h>
 #include <linux/stacktrace.h>
-#include <linux/nmi.h>
-#include <linux/mm.h>
-#include <linux/printk.h>
 
 #define KMSAN_ALLOCA_MAGIC_ORIGIN 0xabcd0100
 #define KMSAN_CHAIN_MAGIC_ORIGIN 0xabcd0200
_

Patches currently in -mm which might be from iii@linux.ibm.com are


