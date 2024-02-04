Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C7DB66F
	for <mm-commits@vger.kernel.org>; Sun,  4 Feb 2024 07:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707031247; cv=none; b=k3vMvgqfSpGKBvFt7pzZtRbGoDeJnn9Bk+igq8azn5c9Vebeqn4PwI7/rPvPC2OrXnIQxF9nx5mRHJ8f0j7HzXSwkgt1aM5s5vC8Zq6lsy1nCwIPI3gCKGq3Z+LLsVqiluH4WB76LMlcgZCuNs+sQnh2q7mbCc+MtbW8o0sx1Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707031247; c=relaxed/simple;
	bh=winJ6awoeudcsjWo63yMvqwrPlfymAmL8dER6/V5V+E=;
	h=Date:To:From:Subject:Message-Id; b=eNkF/esykz4y6bFAJI78WLMj4hswbqBZe6fgBYPHSLrpPZ8+NZugsNaM+/ZMFMRqyz0sb1CrwCgmpC8jTO3fC/MrRL6AS8/qeTPP6QjkiAIl8Z7EDVXTOurJ/gD8FbxNedvwSvk1eJDvaM2ZhI4aBJmjh9JviFWvXenL2CFiWp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tm1clnUz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tm1clnUz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82044C43390;
	Sun,  4 Feb 2024 07:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707031247;
	bh=winJ6awoeudcsjWo63yMvqwrPlfymAmL8dER6/V5V+E=;
	h=Date:To:From:Subject:From;
	b=Tm1clnUzZ3uZPBL3W+nelHPqI1B2KgKL1H5C3HtM+bLMEb0842Yz7jK3NL4YBP0Xf
	 JDwYcMTeKDYUr8BTWqshYRRXiw8rvpEMvEoShFM6f5FXVw7Nw7/LNSSupHQzg7t3dd
	 rCz1BLDHXPCj3DhDzTdPBvNn9HQsS1F9d8ZDyPtc=
Date: Sat, 03 Feb 2024 23:20:46 -0800
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,peterz@infradead.org,jpoimboe@kernel.org,gpiccoli@igalia.com,feng.tang@intel.com,corbet@lwn.net,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-add-option-to-dump-blocked-tasks-in-panic_print-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20240204072047.82044C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic-add-option-to-dump-blocked-tasks-in-panic_print-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-add-option-to-dump-blocked-tasks-in-panic_print-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-add-option-to-dump-blocked-tasks-in-panic_print-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: panic-add-option-to-dump-blocked-tasks-in-panic_print-fix
Date: Sat Feb  3 04:31:14 AM PST 2024

clarify documentation a little

Cc: Feng Tang <feng.tang@intel.com>
Cc: Guilherme G. Piccoli <gpiccoli@igalia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    2 +-
 Documentation/admin-guide/sysctl/kernel.rst     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~panic-add-option-to-dump-blocked-tasks-in-panic_print-fix
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -4182,7 +4182,7 @@
 			bit 4: print ftrace buffer
 			bit 5: print all printk messages in buffer
 			bit 6: print all CPUs backtrace (if available in the arch)
-			bit 7: print tasks in uninterruptible (blocked) state
+			bit 7: print only tasks in uninterruptible (blocked) state
 			*Be aware* that this option may print a _lot_ of lines,
 			so there are risks of losing older messages in the log.
 			Use this option carefully, maybe worth to setup a
--- a/Documentation/admin-guide/sysctl/kernel.rst~panic-add-option-to-dump-blocked-tasks-in-panic_print-fix
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -853,7 +853,7 @@ bit 3  print locks info if ``CONFIG_LOCK
 bit 4  print ftrace buffer
 bit 5  print all printk messages in buffer
 bit 6  print all CPUs backtrace (if available in the arch)
-bit 7  print tasks in uninterruptible (blocked) state
+bit 7  print only tasks in uninterruptible (blocked) state
 =====  ============================================
 
 So for example to print tasks and memory info on panic, user can::
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kexec-split-crashkernel-reservation-code-out-from-crash_corec-fix.patch
mm-memory_hotplug-export-mhp_supports_memmap_on_memory-fix.patch
mm-ptdump-have-ptdump_check_wx-return-bool-fix.patch
kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer-fix.patch
panic-add-option-to-dump-blocked-tasks-in-panic_print-fix.patch

