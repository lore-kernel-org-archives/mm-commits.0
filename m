Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E512857CB
	for <mm-commits@vger.kernel.org>; Wed, 20 Aug 2025 21:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755725123; cv=none; b=Mwjt2VthAxW87YSc7eJH8aogu/XoQaaae6TtonYG016bzdq/GoKsSNj4jrOGnqKxBJSSXUfqI66T+ITsNddNpJjXcPoFMMwbHyVCpIOOcr0Qia85SSwfSgTNuN/Tzo/mfFbuh4kbIcqXu1CLcgeXQV1QqbxIZz6G/Wyav6MYunQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755725123; c=relaxed/simple;
	bh=k+ovkKaIDFy9+xmK+eGDRIjoGbf1BMXd7Q7WsPKkLRU=;
	h=Date:To:From:Subject:Message-Id; b=mpggvFaFP8WQ5Ej0s9Hr5hT3vP0BF/JJ+zA8ZEqvs6ZchWCnwdgaU6O0qihNTgwwJfWw31jXztv1jFLYg35g1lrGoSZUHJbsS3BFtf/xJc0MiGoqdmySD1DH3dzW8krS6N01uYc3iR3Aaf99NLeOYIaRTNSVsnjg73ZNZdzkK/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CF80Jo0E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CF80Jo0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBD6C4CEE7;
	Wed, 20 Aug 2025 21:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755725123;
	bh=k+ovkKaIDFy9+xmK+eGDRIjoGbf1BMXd7Q7WsPKkLRU=;
	h=Date:To:From:Subject:From;
	b=CF80Jo0E4Ol/hhfq6W1QwcmOLobwHTrdPOWDKZ7p5t2oqw9R64Rmh4fA7H8q/4IpP
	 CMznwyODGYwTOUSPCm/rUyuQFKxiD9M3sGF+OzHt72/Jw05Z5tTzRY4i2z0ItSATZ1
	 JaY+nnuS7Jaobmf3We65cvrgZKtRrIRBrNZdKw/U=
Date: Wed, 20 Aug 2025 14:25:22 -0700
To: mm-commits@vger.kernel.org,kees@kernel.org,brauner@kernel.org,axboe@kernel.dk,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fork-kill-the-pointless-lower_32_bits-in-create_io_thread-kernel_thread-and-user_mode_thread.patch added to mm-nonmm-unstable branch
Message-Id: <20250820212523.3EBD6C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fork: kill the pointless lower_32_bits() in create_io_thread(), kernel_thread(), and user_mode_thread()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fork-kill-the-pointless-lower_32_bits-in-create_io_thread-kernel_thread-and-user_mode_thread.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fork-kill-the-pointless-lower_32_bits-in-create_io_thread-kernel_thread-and-user_mode_thread.patch

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
From: Oleg Nesterov <oleg@redhat.com>
Subject: fork: kill the pointless lower_32_bits() in create_io_thread(), kernel_thread(), and user_mode_thread()
Date: Wed, 20 Aug 2025 18:39:46 +0200

Unlike sys_clone(), these helpers have only in kernel users which should
pass the correct "flags" argument.  lower_32_bits(flags) just adds the
unnecessary confusion and doesn't allow to use the CLONE_ flags which
don't fit into 32 bits.

create_io_thread() looks especially confusing because:

	- "flags" is a compile-time constant, so lower_32_bits() simply
	  has no effect

	- .exit_signal = (lower_32_bits(flags) & CSIGNAL) is harmless but
	  doesn't look right, copy_process(CLONE_THREAD) will ignore this
	  argument anyway.

None of these helpers actually need CLONE_UNTRACED or "& ~CSIGNAL", but
their presence does not add any confusion and improves code clarity.

Link: https://lkml.kernel.org/r/20250820163946.GA18549@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/kernel/fork.c~fork-kill-the-pointless-lower_32_bits-in-create_io_thread-kernel_thread-and-user_mode_thread
+++ a/kernel/fork.c
@@ -2540,11 +2540,9 @@ struct task_struct * __init fork_idle(in
 struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
 {
 	unsigned long flags = CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|
-				CLONE_IO;
+			      CLONE_IO|CLONE_VM|CLONE_UNTRACED;
 	struct kernel_clone_args args = {
-		.flags		= ((lower_32_bits(flags) | CLONE_VM |
-				    CLONE_UNTRACED) & ~CSIGNAL),
-		.exit_signal	= (lower_32_bits(flags) & CSIGNAL),
+		.flags		= flags,
 		.fn		= fn,
 		.fn_arg		= arg,
 		.io_thread	= 1,
@@ -2656,9 +2654,8 @@ pid_t kernel_thread(int (*fn)(void *), v
 		    unsigned long flags)
 {
 	struct kernel_clone_args args = {
-		.flags		= ((lower_32_bits(flags) | CLONE_VM |
-				    CLONE_UNTRACED) & ~CSIGNAL),
-		.exit_signal	= (lower_32_bits(flags) & CSIGNAL),
+		.flags		= ((flags | CLONE_VM | CLONE_UNTRACED) & ~CSIGNAL),
+		.exit_signal	= (flags & CSIGNAL),
 		.fn		= fn,
 		.fn_arg		= arg,
 		.name		= name,
@@ -2674,9 +2671,8 @@ pid_t kernel_thread(int (*fn)(void *), v
 pid_t user_mode_thread(int (*fn)(void *), void *arg, unsigned long flags)
 {
 	struct kernel_clone_args args = {
-		.flags		= ((lower_32_bits(flags) | CLONE_VM |
-				    CLONE_UNTRACED) & ~CSIGNAL),
-		.exit_signal	= (lower_32_bits(flags) & CSIGNAL),
+		.flags		= ((flags | CLONE_VM | CLONE_UNTRACED) & ~CSIGNAL),
+		.exit_signal	= (flags & CSIGNAL),
 		.fn		= fn,
 		.fn_arg		= arg,
 	};
_

Patches currently in -mm which might be from oleg@redhat.com are

fork-kill-the-pointless-lower_32_bits-in-create_io_thread-kernel_thread-and-user_mode_thread.patch

