Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCE0134C4
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628274; cv=none; b=L0UKg/jcJya/k9S4x86r0EHkEv6X+xl41pWGNyak/XuDzWRiwJRxIwhHSIZgsyBEIXfwVjXmgc4SVuQkSFThBVdAbdKkuwWoI9OFWRFApb07pp4vDmo8J6kFLP5ytZKdgbJssVIgJS8ER/ZKls36yRtDcqbvkebsleBfHs4UQ6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628274; c=relaxed/simple;
	bh=kAaRPEXAXJ55SohxA8kUpYqmsXn7RWBjm1WKNwyLFQE=;
	h=Date:To:From:Subject:Message-Id; b=Kywrn8WygJmMAeaQYGNFSjGmOONkWypS4OY1oa7RwD6KouNevUya1pkveA4NPo2R620NIDg7IcQsJlJBpHrmdpqpCSlif1pd61OA4C6HGNtXp+p/KW6DUZLEOQelED9KnyM80r3u0lFCLMMqkSoJ+A16NZI8qTMz0ieIA3EWRdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s2/ieGGM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s2/ieGGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6724C116B1;
	Sat, 29 Jun 2024 02:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628273;
	bh=kAaRPEXAXJ55SohxA8kUpYqmsXn7RWBjm1WKNwyLFQE=;
	h=Date:To:From:Subject:From;
	b=s2/ieGGMAel/sBLAje9HzjKvJxeWd21ioOQffDQr6d7sIos8r67iDQekw8hBHWEIE
	 L4ZltQEJXmaPJ5VZpnXwWDVFRbm2I8g+h6p8KtxmhkiRQ2sOKibCaswfKfbmwpGCSR
	 PyzmmLn9IH/OSuxAwVavEJiwnZLQ6gGUWQxb/6xM=
Date: Fri, 28 Jun 2024 19:31:13 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-ftrace-unpoison-ftrace_regs-in-kprobe_ftrace_handler.patch removed from -mm tree
Message-Id: <20240629023113.D6724C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390/ftrace: unpoison ftrace_regs in kprobe_ftrace_handler()
has been removed from the -mm tree.  Its filename was
     s390-ftrace-unpoison-ftrace_regs-in-kprobe_ftrace_handler.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: s390/ftrace: unpoison ftrace_regs in kprobe_ftrace_handler()
Date: Fri, 21 Jun 2024 13:35:13 +0200

s390 uses assembly code to initialize ftrace_regs and call
kprobe_ftrace_handler().  Therefore, from the KMSAN's point of view,
ftrace_regs is poisoned on kprobe_ftrace_handler() entry.  This causes
KMSAN warnings when running the ftrace testsuite.

Fix by trusting the assembly code and always unpoisoning ftrace_regs in
kprobe_ftrace_handler().

Link: https://lkml.kernel.org/r/20240621113706.315500-30-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
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

 arch/s390/kernel/ftrace.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/s390/kernel/ftrace.c~s390-ftrace-unpoison-ftrace_regs-in-kprobe_ftrace_handler
+++ a/arch/s390/kernel/ftrace.c
@@ -12,6 +12,7 @@
 #include <linux/ftrace.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
+#include <linux/kmsan-checks.h>
 #include <linux/kprobes.h>
 #include <linux/execmem.h>
 #include <trace/syscall.h>
@@ -303,6 +304,7 @@ void kprobe_ftrace_handler(unsigned long
 	if (bit < 0)
 		return;
 
+	kmsan_unpoison_memory(fregs, sizeof(*fregs));
 	regs = ftrace_get_regs(fregs);
 	p = get_kprobe((kprobe_opcode_t *)ip);
 	if (!regs || unlikely(!p) || kprobe_disabled(p))
_

Patches currently in -mm which might be from iii@linux.ibm.com are


