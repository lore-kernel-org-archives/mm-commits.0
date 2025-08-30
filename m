Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665B822B8B6
	for <mm-commits@vger.kernel.org>; Sat, 30 Aug 2025 03:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756525113; cv=none; b=AdpjiMkX48fJI3XR73mHo8TfjC0211M3QDIf1wH9W7q5ZI3axtbcZUMZTrlvjmL/23Vp11JAW/xK/QmW8urvdxwpZB2hvZ1wEyu5x2lF5hW+pRcOdBnwHLSJh28U+x/21z+2fOcWe9BlAFvNdrmfzXnNTHcEvnCCYhAHHO2JZNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756525113; c=relaxed/simple;
	bh=mCFk4PGhU9CKge9hKdtQgLCpd3CnfUym3Fh8nKFnOBQ=;
	h=Date:To:From:Subject:Message-Id; b=U43/bg0bGTyM30up3TVB0dgmFBfILoC5M5MUuEKbDZSI+rpQF/VE4ByC2DLqy2B3Tj6D4zimgp1KG+ASgCAXuBbUGn/wOGqiHnRSEzlEM5MLFBKLwfR2Z9Mf+cdsKGTfvU6hmPfdfc0xRjkOpZFwHGOC+75WTDM8+G6YJWr/23k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JLNTzw/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JLNTzw/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3244C4CEF0;
	Sat, 30 Aug 2025 03:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756525112;
	bh=mCFk4PGhU9CKge9hKdtQgLCpd3CnfUym3Fh8nKFnOBQ=;
	h=Date:To:From:Subject:From;
	b=JLNTzw/a+T3jJ5aKxSqhJhen5XOoL95mZoYTdf/BgQ5HOd+jca4+f0NkBt5myb4sL
	 h/v2aMG+/DvvHZr88kdiE+j92E9H/MOk0l0CLS6TbXtML6o7LkCRobe15zjnGnZYe/
	 tXsj2bBcW/BtyI9UoNa+0AVEszHCw7z/ZPirUL/c=
Date: Fri, 29 Aug 2025 20:38:32 -0700
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,lorenzo.stoakes@oracle.com,linus.walleij@linaro.org,Liam.Howlett@oracle.com,kees@kernel.org,juri.lelli@redhat.com,dietmar.eggemann@arm.com,david@redhat.com,bsegall@google.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fork-check-charging-success-before-zeroing-stack.patch added to mm-new branch
Message-Id: <20250830033832.C3244C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fork: check charging success before zeroing stack
has been added to the -mm mm-new branch.  Its filename is
     fork-check-charging-success-before-zeroing-stack.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fork-check-charging-success-before-zeroing-stack.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: fork: check charging success before zeroing stack
Date: Fri, 29 Aug 2025 13:44:40 +0200

Patch series "mm: task_stack: Stack handling cleanups".

These are some small cleanups for the fork code that was split off from
Pasha:s dynamic stack patch series, they are generally nice on their own
so let's propose them for merging.


This patch (of 2):

No need to do zero cached stack if memcg charge fails, so move the
charging attempt before the memset operation.

Link: https://lkml.kernel.org/r/20250829-fork-cleanups-for-dynstack-v1-0-3bbaadce1f00@linaro.org
Link: https://lkml.kernel.org/r/20250829-fork-cleanups-for-dynstack-v1-1-3bbaadce1f00@linaro.org
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Link: https://lore.kernel.org/20240311164638.2015063-6-pasha.tatashin@soleen.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Ben Segall <bsegall@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mel Gorman <mgorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/kernel/fork.c~fork-check-charging-success-before-zeroing-stack
+++ a/kernel/fork.c
@@ -290,6 +290,11 @@ static int alloc_thread_stack_node(struc
 		if (!vm_area)
 			continue;
 
+		if (memcg_charge_kernel_stack(vm_area)) {
+			vfree(vm_area->addr);
+			return -ENOMEM;
+		}
+
 		/* Reset stack metadata. */
 		kasan_unpoison_range(vm_area->addr, THREAD_SIZE);
 
@@ -298,11 +303,6 @@ static int alloc_thread_stack_node(struc
 		/* Clear stale pointers from reused stack. */
 		memset(stack, 0, THREAD_SIZE);
 
-		if (memcg_charge_kernel_stack(vm_area)) {
-			vfree(vm_area->addr);
-			return -ENOMEM;
-		}
-
 		tsk->stack_vm_area = vm_area;
 		tsk->stack = stack;
 		return 0;
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

fork-check-charging-success-before-zeroing-stack.patch
task_stackh-clean-up-stack_not_used-implementation.patch

