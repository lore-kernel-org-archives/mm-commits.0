Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC9233987
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810125; cv=none; b=sR14htXJ53VT/d2byYQMsfqOULr7UJhbRtA5GrXszu7iYi0M/T41FWxSz1Sskq+jaiQAlsuaerSkB/xRuZpH95g5ijb0Tpg75JlHo2i51o17iCbySda4cxE9+edHxYzlPrDoM8S0QPxWZvAXhmuyBjA3iwpFUbXMAJq0TUAgH0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810125; c=relaxed/simple;
	bh=ZjflbcbyVHRt+6xhNF+45dpQYSaQPHRg2RJNWN2JdhA=;
	h=Date:To:From:Subject:Message-Id; b=Leh54GooQhQS98Dm0QeYb/x8KSj9v/TH1u/KOEg+pOeyBQ3q4D4GFaZMKuy/HVFd8NFegAWKbkIBBpz1TBcInqe95r5w/I3DjPi0G2RKG/W1rcip4X3bAA7Xv2r90GelgulHBDMMoDdvPPIN3azFOUluuNF+HwDI1kI22qrY2WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hRlS8ETG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hRlS8ETG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DDC2C4CEEB;
	Sun, 14 Sep 2025 00:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810125;
	bh=ZjflbcbyVHRt+6xhNF+45dpQYSaQPHRg2RJNWN2JdhA=;
	h=Date:To:From:Subject:From;
	b=hRlS8ETGqJAFQp8IkLTNJnTTxRCBNeEYvuEPggSrHF030lJUpbN7vbbIXTP/LiGQZ
	 anZ8NIC9x3FC22dBKQVUg3EH0OW6JozoE+pINFv2OS4RHgrYK1TsjHBa23QYkNAr/C
	 fRKMLiVDGvjRhxLvpeATWjSuCHd9KQnsgeDSpiDk=
Date: Sat, 13 Sep 2025 17:35:25 -0700
To: mm-commits@vger.kernel.org,kees@kernel.org,brauner@kernel.org,axboe@kernel.dk,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fork-kill-the-pointless-lower_32_bits-in-create_io_thread-kernel_thread-and-user_mode_thread.patch removed from -mm tree
Message-Id: <20250914003525.8DDC2C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fork: kill the pointless lower_32_bits() in create_io_thread(), kernel_thread(), and user_mode_thread()
has been removed from the -mm tree.  Its filename was
     fork-kill-the-pointless-lower_32_bits-in-create_io_thread-kernel_thread-and-user_mode_thread.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/kernel/fork.c~fork-kill-the-pointless-lower_32_bits-in-create_io_thread-kernel_thread-and-user_mode_thread
+++ a/kernel/fork.c
@@ -2537,11 +2537,9 @@ struct task_struct * __init fork_idle(in
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
@@ -2653,9 +2651,8 @@ pid_t kernel_thread(int (*fn)(void *), v
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
@@ -2671,9 +2668,8 @@ pid_t kernel_thread(int (*fn)(void *), v
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


