Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8DE125A9
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628264; cv=none; b=tQJUEFW9Zd480voIANUL5wssI3lhGnv3JM3E/41LmFwMy28HVnGS1S4SdiYIsPElnST1wLq5e37plxzCOo+wgtPWqYwP+UgW6lO2bQJpEs84x4+/MReETaQvWEr5nWfn0ZJtPa0glqSlt2ClCPe9eCqOce0/31cm4afF56b2TOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628264; c=relaxed/simple;
	bh=k3erauCCzGFXLeQCxnULjbaF6VRhQPbMGetPHBSmBec=;
	h=Date:To:From:Subject:Message-Id; b=ojC1XqjxFKy05mjG9TogA/RDBqUhSZbM2fAeWR4PEuRn8FhmuYwpEfV+ZHDvk41HQXe/MxAZawu6mm/FRe1+WNSP0i4e36jyIqu3x46L943Uq22y2jZYMImzk83/5Rs3LdfZb6j9LO047KXXIf8C7rm91s6WFp9cG8vM4Ya9CWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DVuvTSmN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DVuvTSmN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C04C116B1;
	Sat, 29 Jun 2024 02:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628264;
	bh=k3erauCCzGFXLeQCxnULjbaF6VRhQPbMGetPHBSmBec=;
	h=Date:To:From:Subject:From;
	b=DVuvTSmNOK57Lz+hlphHIBTSyDt5d6DKxd+0+eDZ3dr1NrB713fDp6j0pedyN6dv0
	 gltwSY7SmN0eYLkmpOahTR7nK4QQmLW3bHDhkGCDebuSu5QXMRNa5g12sBSZwQNCjc
	 9vCr+P2njUuOUplhmBiU4GxutIxPKofmb31T4EN8=
Date: Fri, 28 Jun 2024 19:31:03 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-boot-turn-off-kmsan.patch removed from -mm tree
Message-Id: <20240629023103.E9C04C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390/boot: turn off KMSAN
has been removed from the -mm tree.  Its filename was
     s390-boot-turn-off-kmsan.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: s390/boot: turn off KMSAN
Date: Fri, 21 Jun 2024 13:35:06 +0200

All other sanitizers are disabled for boot as well.  While at it, add a
comment explaining why we need this.

Link: https://lkml.kernel.org/r/20240621113706.315500-23-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
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

 arch/s390/boot/Makefile |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/s390/boot/Makefile~s390-boot-turn-off-kmsan
+++ a/arch/s390/boot/Makefile
@@ -3,11 +3,13 @@
 # Makefile for the linux s390-specific parts of the memory manager.
 #
 
+# Tooling runtimes are unavailable and cannot be linked for early boot code
 KCOV_INSTRUMENT := n
 GCOV_PROFILE := n
 UBSAN_SANITIZE := n
 KASAN_SANITIZE := n
 KCSAN_SANITIZE := n
+KMSAN_SANITIZE := n
 
 KBUILD_AFLAGS := $(KBUILD_AFLAGS_DECOMPRESSOR)
 KBUILD_CFLAGS := $(KBUILD_CFLAGS_DECOMPRESSOR)
_

Patches currently in -mm which might be from iii@linux.ibm.com are


