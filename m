Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91591A2C0B
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011342; cv=none; b=fwvVnXCK5s408SmuFdX7wn9ppY4GKefrzhPXm5fEskUifOGmDCX5KJlh5/FwdChPsOW/AeoX+bbHW4bEgn0R14U6Kvzbf+2J/Tj+vz2ygq+UUh43dh+4EKwb20dOq0ZjLVmm3iseyfTnapMILmzg2ba0RShPrl+zmnvcuzH7hv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011342; c=relaxed/simple;
	bh=X7pzZ8+dk/cYycZw95+YXs9P6kGT1LLKlhm4sOotnXY=;
	h=Date:To:From:Subject:Message-Id; b=efwoTi8ImFJTq5aTJbzqJuTTS3TCDzzRk/EOspFI4yjNqUjvbspp1nP8A4sQyjy3ekl4Un3hjSD3M3k2SFHCRjzxuwW9Rjhd+W6cM1Yg/uKHHcZP+KWD2LTnaFiqZXHhREgY9yzbes7rGfQxJ+aBum71ALc9+N45Ff/FJgROS44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XbHknVLm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XbHknVLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16715C4CEE4;
	Mon, 12 May 2025 00:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011342;
	bh=X7pzZ8+dk/cYycZw95+YXs9P6kGT1LLKlhm4sOotnXY=;
	h=Date:To:From:Subject:From;
	b=XbHknVLmGLT0s4h6ZkSkQji7j7jpGVXw7gzqMMaIKTQL6cGj53sbg2S5z8c2UrOJg
	 cRbsuASs8WzSWEoZSZ758GCbGSUlFJ14gjYGeJYyAXWRoPzIisMOkas3AgfU+rnXIa
	 AdeZW5w+HUGMF2medFwZeqe+6X3UjwIVdA+wpRl0=
Date: Sun, 11 May 2025 17:55:41 -0700
To: mm-commits@vger.kernel.org,linus.walleij@linaro.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] task_stackh-remove-obsolete-__have_arch_kstack_end-check.patch removed from -mm tree
Message-Id: <20250512005542.16715C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: task_stack.h: remove obsolete __HAVE_ARCH_KSTACK_END check
has been removed from the -mm tree.  Its filename was
     task_stackh-remove-obsolete-__have_arch_kstack_end-check.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: task_stack.h: remove obsolete __HAVE_ARCH_KSTACK_END check
Date: Thu, 03 Apr 2025 14:33:03 +0200

Remove __HAVE_ARCH_KSTACK_END as it has been obsolete since removal of
metag architecture in v4.17.

Link: https://lkml.kernel.org/r/20250403-kstack-end-v1-1-7798e71f34d1@linaro.org
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Link: https://lore.kernel.org/20240311164638.2015063-2-pasha.tatashin@soleen.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/task_stack.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/sched/task_stack.h~task_stackh-remove-obsolete-__have_arch_kstack_end-check
+++ a/include/linux/sched/task_stack.h
@@ -106,7 +106,6 @@ static inline unsigned long stack_not_us
 #endif
 extern void set_task_stack_end_magic(struct task_struct *tsk);
 
-#ifndef __HAVE_ARCH_KSTACK_END
 static inline int kstack_end(void *addr)
 {
 	/* Reliable end of stack detection:
@@ -114,6 +113,5 @@ static inline int kstack_end(void *addr)
 	 */
 	return !(((unsigned long)addr+sizeof(void*)-1) & (THREAD_SIZE-sizeof(void*)));
 }
-#endif
 
 #endif /* _LINUX_SCHED_TASK_STACK_H */
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

fork-clean-up-ifdef-logic-around-stack-allocation.patch
fork-clean-up-naming-of-vm_stack-vm_struct-variables-in-vmap-stacks-code.patch
fork-check-charging-success-before-zeroing-stack.patch

