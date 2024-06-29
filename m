Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F27AD55
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628234; cv=none; b=DJ9AaNbTrj0AreEhjzY+IIZDYABYheTiyO7u4z6sBET+hUZAPnRkNkMVcw/WHCwIWVi36dsnJgXfL0V91LtxcTCfQkguOPQQhtHU11mZUWgB7o08bEGx91Km7QaMIMvE3HAQvcLKdGEW55BGD/x/xvD1QRIfB80oRnov0BIPBdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628234; c=relaxed/simple;
	bh=bpXnnbMOBRweIzyA86m8yFbCQoZQyOiCpdXeN8Vf/qk=;
	h=Date:To:From:Subject:Message-Id; b=cng71xtU6mD/0BKE7Rh8sb/ul2kp9x6NLDLdMCAoYPtRFd8soo1bapw7D96eb0lgT2n2S+wCrGHf5GipUdvxKM+XNY/QnHuUIhmjdivvX/XqqCSdRuv+RBRI2iLKc5jPoT9B0RWGFs+YyHNRts3FZ0HWx+f3O0bydEWjERQu23E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SRv/oYKU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SRv/oYKU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58833C116B1;
	Sat, 29 Jun 2024 02:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628234;
	bh=bpXnnbMOBRweIzyA86m8yFbCQoZQyOiCpdXeN8Vf/qk=;
	h=Date:To:From:Subject:From;
	b=SRv/oYKUthedBKm7sYBQ3khVnjPiFMGBsQX5bagvRCZCJ5wlJsBrj6TnHzESG8h42
	 llgJ0G+nXVpq8TzefLZswFQOQALaYgGXAVsV/TER8yPI9Jrr048UX9wx0Vd4xoR3sO
	 97PXEj57T90S2oq13CxwsD61hJzJtJPWHuQYSXvg=
Date: Fri, 28 Jun 2024 19:30:33 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ftrace-unpoison-ftrace_regs-in-ftrace_ops_list_func.patch removed from -mm tree
Message-Id: <20240629023034.58833C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ftrace: unpoison ftrace_regs in ftrace_ops_list_func()
has been removed from the -mm tree.  Its filename was
     ftrace-unpoison-ftrace_regs-in-ftrace_ops_list_func.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: ftrace: unpoison ftrace_regs in ftrace_ops_list_func()
Date: Fri, 21 Jun 2024 13:34:45 +0200

Patch series "kmsan: Enable on s390", v7.


Architectures use assembly code to initialize ftrace_regs and call
ftrace_ops_list_func().  Therefore, from the KMSAN's point of view,
ftrace_regs is poisoned on ftrace_ops_list_func entry().  This causes
KMSAN warnings when running the ftrace testsuite.

Fix by trusting the architecture-specific assembly code and always
unpoisoning ftrace_regs in ftrace_ops_list_func.

The issue was not encountered on x86_64 so far only by accident:
assembly-allocated ftrace_regs was overlapping a stale partially
unpoisoned stack frame.  Poisoning stack frames before returns [1] makes
the issue appear on x86_64 as well.

[1] https://github.com/iii-i/llvm-project/commits/msan-poison-allocas-before-returning-2024-06-12/

Link: https://lkml.kernel.org/r/20240621113706.315500-1-iii@linux.ibm.com
Link: https://lkml.kernel.org/r/20240621113706.315500-2-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
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
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/ftrace.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/trace/ftrace.c~ftrace-unpoison-ftrace_regs-in-ftrace_ops_list_func
+++ a/kernel/trace/ftrace.c
@@ -7407,6 +7407,7 @@ out:
 void arch_ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
 			       struct ftrace_ops *op, struct ftrace_regs *fregs)
 {
+	kmsan_unpoison_memory(fregs, sizeof(*fregs));
 	__ftrace_ops_list_func(ip, parent_ip, NULL, fregs);
 }
 #else
_

Patches currently in -mm which might be from iii@linux.ibm.com are


