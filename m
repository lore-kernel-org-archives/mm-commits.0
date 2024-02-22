Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3D71A5A2
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644937; cv=none; b=cb9Hc6XmTZBURp6y+cfqWBnberXJZ0I6N7JMthvuqC+a6P+B6Ejgs2aY+hMevoqQm6d7Bw83gFw+tMjvz6VjyyEKdwxNp/lRNp5CK5LKnFD9Uyz88Mfj6QYRnIQPpLBnmCb3ioQs+o5ASeg0owFvgOEYAqg2imX5oGi8fw2B2WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644937; c=relaxed/simple;
	bh=0wwvtqd7n64pzX3tEw1mfNhxQUDucKD28HfWtzBoLH8=;
	h=Date:To:From:Subject:Message-Id; b=TxjUakNRlVzcSXZfekjWH00gU4TmITrvmJS1J9umiqtcDgPZxU7lOswBAJ8dOhuynPrzNT19KwmvBa63FVS6YIAr35Te2JrRoUuhIpngRiPFItKIQrtO8K4J9MIdY+YDLUVsogD7bguybMSIqF1wBY5wdaRgnEIzTHnx/NNfPsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QOWmCfir; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QOWmCfir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F63C433F1;
	Thu, 22 Feb 2024 23:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644937;
	bh=0wwvtqd7n64pzX3tEw1mfNhxQUDucKD28HfWtzBoLH8=;
	h=Date:To:From:Subject:From;
	b=QOWmCfirHJqxUkzBvk8IyFpUAiyS0r4Jhl16VBrnRdqjgLiaxJZO9rrDCxXhQWtlY
	 2SGsexV8QkN5Xy3VW7w4Jnv9TnWFMX7cfXr+CK8wgLXO4KhSnh5NLkOQVKea7Ylbol
	 eDbbA89Qd7bTSaHeErBP4FGyiPc1I4b5pxSbtpLE=
Date: Thu, 22 Feb 2024 15:35:36 -0800
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,peterz@infradead.org,jpoimboe@kernel.org,gpiccoli@igalia.com,feng.tang@intel.com,corbet@lwn.net,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] panic-add-option-to-dump-blocked-tasks-in-panic_print-fix.patch removed from -mm tree
Message-Id: <20240222233537.32F63C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic-add-option-to-dump-blocked-tasks-in-panic_print-fix
has been removed from the -mm tree.  Its filename was
     panic-add-option-to-dump-blocked-tasks-in-panic_print-fix.patch

This patch was dropped because it was folded into panic-add-option-to-dump-blocked-tasks-in-panic_print.patch

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
arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc-fix.patch
mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases-fix.patch
hugetlb-parallelize-1g-hugetlb-initialization-fix.patch
panic-add-option-to-dump-blocked-tasks-in-panic_print.patch

