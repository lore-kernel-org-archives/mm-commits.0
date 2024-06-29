Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C348134C4
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628272; cv=none; b=jjr2QMokrVzh71WopZ9c5gBTI7kQOi1Mvj7/+CHdn4yDlhIK+eYQhEm2lYYSg/k7/zZpE1I1FJfTHYqOsXLIKeDC0mc/B5VDA6y/mDzozvieg1N1Wj8zee6MTn+lCbAg7kAxIqy5vpCKA+j4mu+EFV6Bfz8h41VODu7JfgLzwnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628272; c=relaxed/simple;
	bh=qYue9TpLhBFd+uO0x9mnhr8pqyBUpehWoNHsev7X5lE=;
	h=Date:To:From:Subject:Message-Id; b=Cj+J6RcvM1tb2zHAeZfoTiACJajPvl438khQWcJOf3Z+QyOep3XyhLYTINBx44cJ4hmg7LsseEGCi7IFX+agDwwROF4u6+PB7kcLBKqDNcF2pP1S43c0iZtEyhkn3n8/hCxznPe6pNq2FroykHA79xOrRCmOWoHQBXeWeGGCsbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OOW8u/1B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OOW8u/1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7279DC116B1;
	Sat, 29 Jun 2024 02:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628272;
	bh=qYue9TpLhBFd+uO0x9mnhr8pqyBUpehWoNHsev7X5lE=;
	h=Date:To:From:Subject:From;
	b=OOW8u/1BbL8xwSRHr7l9nmGjyKTpQLaUjN4C5idc2iO7vIDIRBSQvhi2ysgNGm0He
	 hayv/kDXuUBAPoXmDmRD1EFdCtdCowp52OePaxdUv+HGJXeHKP989uCj6i6KjCW2e4
	 CVctaiafSsLxsAgj2DWFmuDRiuReAcuQO+OMwlww=
Date: Fri, 28 Jun 2024 19:31:11 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-diag-unpoison-diag224-output-buffer.patch removed from -mm tree
Message-Id: <20240629023112.7279DC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390/diag: unpoison diag224() output buffer
has been removed from the -mm tree.  Its filename was
     s390-diag-unpoison-diag224-output-buffer.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: s390/diag: unpoison diag224() output buffer
Date: Fri, 21 Jun 2024 13:35:12 +0200

Diagnose 224 stores 4k bytes, which currently cannot be deduced from the
inline assembly constraints.  This leads to KMSAN false positives.

Fix the constraints by using a 4k-sized struct instead of a raw pointer. 
While at it, prettify them too.

Link: https://lkml.kernel.org/r/20240621113706.315500-29-iii@linux.ibm.com
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

 arch/s390/kernel/diag.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/arch/s390/kernel/diag.c~s390-diag-unpoison-diag224-output-buffer
+++ a/arch/s390/kernel/diag.c
@@ -278,12 +278,14 @@ int diag224(void *ptr)
 	int rc = -EOPNOTSUPP;
 
 	diag_stat_inc(DIAG_STAT_X224);
-	asm volatile(
-		"	diag	%1,%2,0x224\n"
-		"0:	lhi	%0,0x0\n"
+	asm volatile("\n"
+		"	diag	%[type],%[addr],0x224\n"
+		"0:	lhi	%[rc],0\n"
 		"1:\n"
 		EX_TABLE(0b,1b)
-		: "+d" (rc) :"d" (0), "d" (addr) : "memory");
+		: [rc] "+d" (rc)
+		, "=m" (*(struct { char buf[PAGE_SIZE]; } *)ptr)
+		: [type] "d" (0), [addr] "d" (addr));
 	return rc;
 }
 EXPORT_SYMBOL(diag224);
_

Patches currently in -mm which might be from iii@linux.ibm.com are


