Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33879134C4
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628271; cv=none; b=u4QPSgFVfmiGWUpl9m8qJB5Y6ejJmYXgBIfBGPNjIfdJpyYMOSAYQixZFQnRMqXhxZNeepUWCG5BtFSYeQc8PXXaG+9okagQT2HJGPX1PTt1wwZFQJKCnPl6FQ3AX+op5hX/PQyG/R4LbxAMquWbgf5z4Cs2gu7V4DPNmKL33UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628271; c=relaxed/simple;
	bh=EhiASeJVLa41iH4K2icTwI+F+1xXzHYHXCKmHf5ozHc=;
	h=Date:To:From:Subject:Message-Id; b=dvud0qyIbYKtu94hKTVqK5uSEG2lK+haG9swwfmYkU1jtCwewslBX4pleYrKwnyD2eOYxKez/sTd6y9e2Ai0SlvaFYE3isQuflST64fOgkrYQrzMV4eSgxDcDD3taQs9OzXygFgjMON6cfp1grRWsM0gbgHODgiTcLajJeqYwNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l3K7sHj+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l3K7sHj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6E1C116B1;
	Sat, 29 Jun 2024 02:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628271;
	bh=EhiASeJVLa41iH4K2icTwI+F+1xXzHYHXCKmHf5ozHc=;
	h=Date:To:From:Subject:From;
	b=l3K7sHj+mqNd0RhfqUnmIkWB3Yn0B2PHsMI0QhXBv/glI65eZ/CV1/z/HSuUbw4qU
	 aByx7vXMyyIvIo+dBJ3QpJcQKEmoyl81I6MC+Etzc3jLqtRRPNMg/c/3PPl3cDC5rs
	 lPiaQ1JkkowICqHV1oLEQYJonTDLEAm4VhoI5nyc=
Date: Fri, 28 Jun 2024 19:31:10 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-cpumf-unpoison-stcctm-output-buffer.patch removed from -mm tree
Message-Id: <20240629023111.0A6E1C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390/cpumf: unpoison STCCTM output buffer
has been removed from the -mm tree.  Its filename was
     s390-cpumf-unpoison-stcctm-output-buffer.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: s390/cpumf: unpoison STCCTM output buffer
Date: Fri, 21 Jun 2024 13:35:11 +0200

stcctm() uses the "Q" constraint for dest, therefore KMSAN does not
understand that it fills multiple doublewords pointed to by dest, not just
one.  This results in false positives.

Unpoison the whole dest manually with kmsan_unpoison_memory().

Link: https://lkml.kernel.org/r/20240621113706.315500-28-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reported-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
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

 arch/s390/include/asm/cpu_mf.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/s390/include/asm/cpu_mf.h~s390-cpumf-unpoison-stcctm-output-buffer
+++ a/arch/s390/include/asm/cpu_mf.h
@@ -10,6 +10,7 @@
 #define _ASM_S390_CPU_MF_H
 
 #include <linux/errno.h>
+#include <linux/kmsan-checks.h>
 #include <asm/asm-extable.h>
 #include <asm/facility.h>
 
@@ -239,6 +240,11 @@ static __always_inline int stcctm(enum s
 		: "=d" (cc)
 		: "Q" (*dest), "d" (range), "i" (set)
 		: "cc", "memory");
+	/*
+	 * If cc == 2, less than RANGE counters are stored, but it's not easy
+	 * to tell how many. Always unpoison the whole range for simplicity.
+	 */
+	kmsan_unpoison_memory(dest, range * sizeof(u64));
 	return cc;
 }
 
_

Patches currently in -mm which might be from iii@linux.ibm.com are


