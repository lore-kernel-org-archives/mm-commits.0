Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B975F8480
	for <mm-commits@vger.kernel.org>; Mon, 17 Jun 2024 21:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718660176; cv=none; b=WDs5zKw1L0HKHzSTMpWo4h84QhTw2HPn7B5cSIrgXwouirw/zpoS2TIBu8JQHmIUwdpeZPGcSjpzN04zTMmOPwtcdZL2V52b8/V28mQxULdgY1z/AuUNshdx3n/oOBozblP+kd+PmRr2whUK4Z71mKjgN7vLbpeYwtgZlKqycwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718660176; c=relaxed/simple;
	bh=wulCkV/Z2Mz4jJJJ7HTt2GBKUf2f7Oe+DpvbPgEr2fs=;
	h=Date:To:From:Subject:Message-Id; b=UcPzC2ixgn0bEH6owX5TA6VDWX20EyP2lSAltGVE8ok5Eq6w5rA2OzQsKZoQIXnuUpZIkJkRzwQC27EUVwbIxlYb6QstXQbSW7P6iAfMH9iVOpC2OPIENkT4QH6mnDyKD5VDILfKCJz8u/mcYoBzWGLWmOfVh1D1ntof7tOmemI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l9p8q0tJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l9p8q0tJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA21C2BD10;
	Mon, 17 Jun 2024 21:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718660176;
	bh=wulCkV/Z2Mz4jJJJ7HTt2GBKUf2f7Oe+DpvbPgEr2fs=;
	h=Date:To:From:Subject:From;
	b=l9p8q0tJAumTXCqW+9LOwuHNaq/egBPH0UHQz7+Jt8JanhkVLKyh/7gN4rrNC7sx2
	 b+v3VSutnuQlutQbOJQDIRc5AJn8CPW41iKQN1U3fSfClZncBaU6OuSxvV8RuKb9iy
	 iivxIVOTnqoMAxbEIzXTVYNcb9w3x3iF3cB17VmM=
Date: Mon, 17 Jun 2024 14:36:15 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-dump_stack-report-process-uid-in-dump_stack_print_info.patch added to mm-nonmm-unstable branch
Message-Id: <20240617213616.2FA21C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/dump_stack: report process UID in dump_stack_print_info()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-dump_stack-report-process-uid-in-dump_stack_print_info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-dump_stack-report-process-uid-in-dump_stack_print_info.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: lib/dump_stack: report process UID in dump_stack_print_info()
Date: Fri, 14 Jun 2024 21:13:58 -0700

To make it easier to identify the crashing process, report effective UID
when dumping the stack.

Link: https://lkml.kernel.org/r/20240615041358.103791-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dump_stack.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/lib/dump_stack.c~lib-dump_stack-report-process-uid-in-dump_stack_print_info
+++ a/lib/dump_stack.c
@@ -54,8 +54,10 @@ void __init dump_stack_set_arch_desc(con
  */
 void dump_stack_print_info(const char *log_lvl)
 {
-	printk("%sCPU: %d PID: %d Comm: %.20s %s%s %s %.*s" BUILD_ID_FMT "\n",
-	       log_lvl, raw_smp_processor_id(), current->pid, current->comm,
+	printk("%sCPU: %d UID: %u PID: %d Comm: %.20s %s%s %s %.*s" BUILD_ID_FMT "\n",
+	       log_lvl, raw_smp_processor_id(),
+	       __kuid_val(current_real_cred()->euid),
+	       current->pid, current->comm,
 	       kexec_crash_loaded() ? "Kdump: loaded " : "",
 	       print_tainted(),
 	       init_utsname()->release,
_

Patches currently in -mm which might be from surenb@google.com are

mm-slab-fix-variable-obj_exts-set-but-not-used-warning.patch
mm-handle-profiling-for-fake-memory-allocations-during-compaction.patch
lib-dump_stack-report-process-uid-in-dump_stack_print_info.patch

