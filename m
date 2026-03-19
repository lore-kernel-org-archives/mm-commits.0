Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A84387368
	for <mm-commits@vger.kernel.org>; Thu, 19 Mar 2026 20:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773952634; cv=none; b=fhFiR/zGJCvHUQsjGQKnDzqQqyv9ShDiCT0PZatzcq7uPv8X8FCx9/uQDo2dGlTrcpAhp0KmgOd6Xzk9TkG58hW9vjtCQNXthAfp7C6OfYnF0gcUFhZ631vCgOcIAL52SHKjyCGJ6YwK6scBszhGYw0IUWGxdHtKueB/7QFY8Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773952634; c=relaxed/simple;
	bh=hSJD/om78uUzDSDmlBqpObkVN1MmPMNXNblseJWJjEk=;
	h=Date:To:From:Subject:Message-Id; b=Cr/LAzeGJs7upY/TU752C7NeJTO9d6ArWfZPttbjMx0MMltZbsvbhb0CPhDmpByDukTXtDIO8JEYkeEs8Rh8L2gteyAwppsc3p/ZVTfdPel3RYZhoTQ8d1Ike2Ah9+9ZVUd455GeBy8WvYkwrOC3YmwEuDnm+nkpD78EgzAEoC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mZFSDUFH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mZFSDUFH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D312BC19424;
	Thu, 19 Mar 2026 20:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773952633;
	bh=hSJD/om78uUzDSDmlBqpObkVN1MmPMNXNblseJWJjEk=;
	h=Date:To:From:Subject:From;
	b=mZFSDUFH6Rm7Aqlu0QUzQwwhQzCJg72k5eTtfK3Uqi5zjrRnWeIOewCOKOIF6AgQJ
	 hedD8bgQPCqi5VZVPiApPs55W3Q8Ok7+tbbsCcHuQQ4b3Hy2wzZLo6U78sYIKIozti
	 BihEpHb4NZLNbyCeh95f8ujbm7U/QBPxn5umYmmY=
Date: Thu, 19 Mar 2026 13:37:13 -0700
To: mm-commits@vger.kernel.org,brauner@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-fork-validate-exit_signal-in-kernel_clone-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20260319203713.D312BC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel-fork-validate-exit_signal-in-kernel_clone-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-fork-validate-exit_signal-in-kernel_clone-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-fork-validate-exit_signal-in-kernel_clone-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: kernel-fork-validate-exit_signal-in-kernel_clone-fix
Date: Thu, 19 Mar 2026 18:16:49 +0100

the comment above kernel_clone() should be updated

Link: https://lkml.kernel.org/r/abwvgU17W8wuW2-J@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 --
 1 file changed, 2 deletions(-)

--- a/kernel/fork.c~kernel-fork-validate-exit_signal-in-kernel_clone-fix
+++ a/kernel/fork.c
@@ -2615,8 +2615,6 @@ struct task_struct *create_io_thread(int
  *
  * It copies the process, and if successful kick-starts
  * it and waits for it to finish using the VM if required.
- *
- * args->exit_signal is expected to be checked for sanity by the caller.
  */
 pid_t kernel_clone(struct kernel_clone_args *args)
 {
_

Patches currently in -mm which might be from oleg@redhat.com are

exit-kill-unnecessary-thread_group_leader-checks-in-exit_notify-and-do_notify_parent.patch
complete_signal-kill-always-true-core_state-signal_group_exit-check.patch
pid-make-sub-init-creation-retryable.patch
pid-document-the-pidns_adding-checks-in-alloc_pid-and-copy_process.patch
kernel-fork-validate-exit_signal-in-kernel_clone-fix.patch
do_notify_parent-sanitize-the-valid_signal-checks.patch

