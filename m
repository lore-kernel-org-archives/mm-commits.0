Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB7D8C07
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600522; cv=none; b=uuabr50PRsv6nc8C/OEIYDEhcC4QbnTf0TDfoAPHpqaQuDSN3G/SNo5PUMU6N/nvWK2mD0YuOyywmD7hcewGV+TZyv2/9z0bbhlEgPkdMo+TqDhuGTVjkrdQT3OhxUD5e6I86ysiMwOdArOUjKx7F0nbTSLWm54Sw4f36q+/w2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600522; c=relaxed/simple;
	bh=kJVd73EmoWbqf7p+NsOeFkLN8RepqEfZ7zRhJ1yI+uM=;
	h=Date:To:From:Subject:Message-Id; b=pmpCTJRqhSvU6qG7PS/nPyCRpXweW01/if2tC+qZobn/zKV8ZO1sjh+HtNd8zhja97hmZfbU6BKCYxQjJqXWs9H8L+Ml1mE2/mf79RJwI0BoZBWt0n0FdlzC/MeT0YXXlzr8YaN9ac4eGdG1LrWlAkPHp4dsespAn1dPwZ7gCo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RWjWy8mf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RWjWy8mf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B44C43390;
	Tue,  5 Mar 2024 01:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600521;
	bh=kJVd73EmoWbqf7p+NsOeFkLN8RepqEfZ7zRhJ1yI+uM=;
	h=Date:To:From:Subject:From;
	b=RWjWy8mf+Q2ABmRsic/YY231XyqcQN8Zf1tUhHNrX+qmHavcts3DZOAoz1WlcXzJB
	 aFkP3oHUO7O8ioJ+RnGPG45HWs6V5pfF0sPwso3U8qI7z2wCmW4kqzA2XSRzm+fAJx
	 y9MEdZsg8owqJvMXsLfYjPWJCyhDCS2RKmtiEj+o=
Date: Mon, 04 Mar 2024 17:02:00 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterz@infradead.org,mingo@redhat.com,luto@kernel.org,dave.hansen@intel.com,bp@alien8.de,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-mm-further-clarify-switch_mm_irqs_off-documentation.patch removed from -mm tree
Message-Id: <20240305010201.70B44C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/mm: further clarify switch_mm_irqs_off() documentation
has been removed from the -mm tree.  Its filename was
     x86-mm-further-clarify-switch_mm_irqs_off-documentation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: x86/mm: further clarify switch_mm_irqs_off() documentation
Date: Thu, 22 Feb 2024 19:09:10 +0000

Commit accf6b23d1e5a ("x86/mm: clarify "prev" usage in
switch_mm_irqs_off()") attempted to clarify x86's usage of the arguments
passed by generic code, specifically the "prev" argument the is unused by
x86.  However, it could have done a better job with the comment above
switch_mm_irqs_off().  Rewrite this comment according to Dave Hansen's
suggestion.

Link: https://lkml.kernel.org/r/20240222190911.1903054-1-yosryahmed@google.com
Fixes: 3cfd6625a6cf ("x86/mm: clarify "prev" usage in switch_mm_irqs_off()")
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Suggested-by: Dave Hansen <dave.hansen@intel.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/tlb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/mm/tlb.c~x86-mm-further-clarify-switch_mm_irqs_off-documentation
+++ a/arch/x86/mm/tlb.c
@@ -493,10 +493,10 @@ static inline void cr4_update_pce_mm(str
 #endif
 
 /*
- * The "prev" argument passed by the caller does not always match CR3. For
- * example, the scheduler passes in active_mm when switching from lazy TLB mode
- * to normal mode, but switch_mm_irqs_off() can be called from x86 code without
- * updating active_mm. Use cpu_tlbstate.loaded_mm instead.
+ * This optimizes when not actually switching mm's.  Some architectures use the
+ * 'unused' argument for this optimization, but x86 must use
+ * 'cpu_tlbstate.loaded_mm' instead because it does not always keep
+ * 'current->active_mm' up to date.
  */
 void switch_mm_irqs_off(struct mm_struct *unused, struct mm_struct *next,
 			struct task_struct *tsk)
_

Patches currently in -mm which might be from yosryahmed@google.com are


