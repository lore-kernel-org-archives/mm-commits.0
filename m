Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F522125A9
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628265; cv=none; b=uqM7gqObNYQZ34qL67RI9C+WebNNkG3GuODBWRltjngnm9ero433KJ6pmeYmlxpxZubkEf/az3DdwY2mFxctxRTdSmow4LbobmX3Sse5CqJUIRUz0qAEg6MKA5wjLgXKEOKrA1xJMqs6bg/laXvDazwAkw1QwBuzwDFoJhRIV8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628265; c=relaxed/simple;
	bh=IBEKYiukDeAc/VTDPkBuUn/pDnC7Ni7WNi9UWQbaWDQ=;
	h=Date:To:From:Subject:Message-Id; b=R254ityqwyvNtYnQSsjYV7ZwFmKMCKzm+Z2D1w1Ys0IEJu00TtgXVCwGs3f3cHekpivdQ3hDBxGu2554rpL4C7vQrlI48m8jFgvDDFb2hkVt7s6rDp/sXNmT6jNQ4RyReq6Gomm5p0fKtfhriFJMmULu/XEz6GZnG/gK/XjoCxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qWFOjcXD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qWFOjcXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C38C116B1;
	Sat, 29 Jun 2024 02:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628265;
	bh=IBEKYiukDeAc/VTDPkBuUn/pDnC7Ni7WNi9UWQbaWDQ=;
	h=Date:To:From:Subject:From;
	b=qWFOjcXDvAnk0k6f6V7crlDLelCSnBUDVOwZmCBffuuhQTuqZjH+EK+4Y51QFi7oH
	 zuFLQW89e0QGHx5JpB0P/gXt2fdoih45l26MnvW1DHxRmfS2PTUKtAlY052qikkmGs
	 E/lnYf2jQmOpBfe1EAKu6/YnGpn0vQY7LQs/RO+w=
Date: Fri, 28 Jun 2024 19:31:04 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-use-a-larger-stack-for-kmsan.patch removed from -mm tree
Message-Id: <20240629023105.56C38C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390: use a larger stack for KMSAN
has been removed from the -mm tree.  Its filename was
     s390-use-a-larger-stack-for-kmsan.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: s390: use a larger stack for KMSAN
Date: Fri, 21 Jun 2024 13:35:07 +0200

Adjust the stack size for the KMSAN-enabled kernel like it was done for
the KASAN-enabled one in commit 7fef92ccadd7 ("s390/kasan: double the
stack size").  Both tools have similar requirements.

Link: https://lkml.kernel.org/r/20240621113706.315500-24-iii@linux.ibm.com
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

 arch/s390/Makefile                  |    2 +-
 arch/s390/include/asm/thread_info.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/include/asm/thread_info.h~s390-use-a-larger-stack-for-kmsan
+++ a/arch/s390/include/asm/thread_info.h
@@ -16,7 +16,7 @@
 /*
  * General size of kernel stacks
  */
-#ifdef CONFIG_KASAN
+#if defined(CONFIG_KASAN) || defined(CONFIG_KMSAN)
 #define THREAD_SIZE_ORDER 4
 #else
 #define THREAD_SIZE_ORDER 2
--- a/arch/s390/Makefile~s390-use-a-larger-stack-for-kmsan
+++ a/arch/s390/Makefile
@@ -36,7 +36,7 @@ KBUILD_CFLAGS_DECOMPRESSOR += $(if $(CON
 KBUILD_CFLAGS_DECOMPRESSOR += $(if $(CONFIG_CC_NO_ARRAY_BOUNDS),-Wno-array-bounds)
 
 UTS_MACHINE	:= s390x
-STACK_SIZE	:= $(if $(CONFIG_KASAN),65536,16384)
+STACK_SIZE	:= $(if $(CONFIG_KASAN),65536,$(if $(CONFIG_KMSAN),65536,16384))
 CHECKFLAGS	+= -D__s390__ -D__s390x__
 
 export LD_BFD
_

Patches currently in -mm which might be from iii@linux.ibm.com are


