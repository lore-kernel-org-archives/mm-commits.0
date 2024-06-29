Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0438134C4
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628269; cv=none; b=E9fuMnq/7Zm3gMvsFE5WwmWVyqLbVsenxRo6oxD49rt6M+a34dj5KonYLJUc/q25tMq0mmsYoqq0a51D07VVCq/gqwZgPlMNQvsDAMAvvK4tHAVz6dAdFTWHV7c9lgGZNi31zUL9K0Bj+iQluCRYA8asotVHVRna/iGzivJSxvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628269; c=relaxed/simple;
	bh=1DT+mfudJCb2n84gKL4eGcMgwhK07NRFA1Z0/Ic6kZs=;
	h=Date:To:From:Subject:Message-Id; b=um/S4KQxVfsZ1rXOjjPMz280BnhLQ8fKvVwiE8mYsCKxJG0iEXR1Pmex+1nefjzTmgL5Dr1qKDHnMGOROc0+qd21tq5d7khJ7ke8VGDdbdRD/fD9s+U0oEzyvBIMvWjSTFVwXZ42a9w5teFwlrquewbAOI96W+TGrMPPfN8n524=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b5WsbHNb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b5WsbHNb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94555C116B1;
	Sat, 29 Jun 2024 02:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628269;
	bh=1DT+mfudJCb2n84gKL4eGcMgwhK07NRFA1Z0/Ic6kZs=;
	h=Date:To:From:Subject:From;
	b=b5WsbHNbwt+xid1cMaa05fVpJ8+jiKq8XBHbNZh5v13bILsT3AIaLbqHw+l5SZBhW
	 NKfy7+zJlCYXBbSe852mxSUJffBK3ckFoaGNgHYI2+BLfYMLXOZvOVldr2fY8Y3cOI
	 gKVouvlsmH0lrck//D8JD+t0DA++UIbI4V2n8WCo=
Date: Fri, 28 Jun 2024 19:31:09 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-cpacf-unpoison-the-results-of-cpacf_trng.patch removed from -mm tree
Message-Id: <20240629023109.94555C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390/cpacf: unpoison the results of cpacf_trng()
has been removed from the -mm tree.  Its filename was
     s390-cpacf-unpoison-the-results-of-cpacf_trng.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: s390/cpacf: unpoison the results of cpacf_trng()
Date: Fri, 21 Jun 2024 13:35:10 +0200

Prevent KMSAN from complaining about buffers filled by cpacf_trng() being
uninitialized.

Link: https://lkml.kernel.org/r/20240621113706.315500-27-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Tested-by: Alexander Gordeev <agordeev@linux.ibm.com>
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

 arch/s390/include/asm/cpacf.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/s390/include/asm/cpacf.h~s390-cpacf-unpoison-the-results-of-cpacf_trng
+++ a/arch/s390/include/asm/cpacf.h
@@ -12,6 +12,7 @@
 #define _ASM_S390_CPACF_H
 
 #include <asm/facility.h>
+#include <linux/kmsan-checks.h>
 
 /*
  * Instruction opcodes for the CPACF instructions
@@ -542,6 +543,8 @@ static inline void cpacf_trng(u8 *ucbuf,
 		: [ucbuf] "+&d" (u.pair), [cbuf] "+&d" (c.pair)
 		: [fc] "K" (CPACF_PRNO_TRNG), [opc] "i" (CPACF_PRNO)
 		: "cc", "memory", "0");
+	kmsan_unpoison_memory(ucbuf, ucbuf_len);
+	kmsan_unpoison_memory(cbuf, cbuf_len);
 }
 
 /**
_

Patches currently in -mm which might be from iii@linux.ibm.com are


