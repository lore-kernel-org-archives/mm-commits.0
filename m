Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C148B171C2
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628286; cv=none; b=JEd10GoPmTyCpaxWrQ5xZUWhdUlahDkiNyw26OWW2I2S/3cG08i6nGoh8crzHFFq1nIu1X+n02dUigyH4xRG1nAnQPnQjTCAvlPDnI3Zl9np3BN4OADv19QDGHIEdXSPBC6/JUL+W+T3ljHl+9LFnOGkghUOQbU272c/OR3Fm7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628286; c=relaxed/simple;
	bh=g+91MC9daAt+d6Ue6NS6SKBpDJA9kynIxGGp28qII4o=;
	h=Date:To:From:Subject:Message-Id; b=Zp/b6k0I4Cc35ys4lUCwHi3/4rOqoiBw8fvuUS2N4Rrtd2ixzPfrOaOM4OEBqvrQBaHVbm90p2V0usnP2SPVCwFO/sVsDODo4lHqzrwWoqSi2kIDXY/kmeWJyWS9wlWksMrvRxINbSvvlgpAOyf/AXIQhPZK2OJgGR5mGZE1o2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DzchPq4c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DzchPq4c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9767DC116B1;
	Sat, 29 Jun 2024 02:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628286;
	bh=g+91MC9daAt+d6Ue6NS6SKBpDJA9kynIxGGp28qII4o=;
	h=Date:To:From:Subject:From;
	b=DzchPq4c8NJuJWaJm0jFlvbJwUrsP+0+3rNN79b+/U9MZguUATeXAEluWUhNjWiTA
	 Kywp62OB7LnMzMnJi0428KbOPadQEoD5goPeQ1hJxGAJtc35NSIibVEarqZvsAOPx7
	 HzjJdfqpuLZsk6mfWNu2c3eip7M4eIUB9dz1UUxU=
Date: Fri, 28 Jun 2024 19:31:26 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-enable-on-s390.patch removed from -mm tree
Message-Id: <20240629023126.9767DC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmsan: enable on s390
has been removed from the -mm tree.  Its filename was
     kmsan-enable-on-s390.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: kmsan: enable on s390
Date: Fri, 21 Jun 2024 13:35:22 +0200

Now that everything else is in place, enable KMSAN in Kconfig.

Link: https://lkml.kernel.org/r/20240621113706.315500-39-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
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

 arch/s390/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/Kconfig~kmsan-enable-on-s390
+++ a/arch/s390/Kconfig
@@ -158,6 +158,7 @@ config S390
 	select HAVE_ARCH_KASAN
 	select HAVE_ARCH_KASAN_VMALLOC
 	select HAVE_ARCH_KCSAN
+	select HAVE_ARCH_KMSAN
 	select HAVE_ARCH_KFENCE
 	select HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
 	select HAVE_ARCH_SECCOMP_FILTER
_

Patches currently in -mm which might be from iii@linux.ibm.com are


