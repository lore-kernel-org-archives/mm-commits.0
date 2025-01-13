Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9704325761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742236; cv=none; b=WYrw4cGvUCAnbf5qQu1sVutaDY0J7OY9SH2I5i7bRUUCvly02tlGbw2HCmnrVBEaFLMfYTAbsCaHUw4ziicvNB6wjPdDI7++kbqykUAEHDjUIGSev2vQ9F3xAifpnoR6KkNM0kLO/Qmdsvi0DAqVt71Qovra3P7DZRWfwiaguwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742236; c=relaxed/simple;
	bh=ArtpTx9fpysUPPmsMFlMhX0np8befMv0UrJF9BRBx/s=;
	h=Date:To:From:Subject:Message-Id; b=HnxA1W3mmyll55VbuHHkx0fCGLbnBimo5hjs/U1hajcbovtQqzXiKQz8NMkLxou85kzgXKRdeIJGGRkpUrYJiLiDml2iYOwEG18bNsyoDMQwDKaaqq1wOrkoZ6PCV0UjPdOU6pzDF4sbKSGlwCkC1nGHDnTdV5K2pN19AvvwMR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xJOAtkeq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xJOAtkeq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57BFDC4CED6;
	Mon, 13 Jan 2025 04:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742236;
	bh=ArtpTx9fpysUPPmsMFlMhX0np8befMv0UrJF9BRBx/s=;
	h=Date:To:From:Subject:From;
	b=xJOAtkeqFmPe/Kp/Hvh7atj19D3eQ4Hblf7s67Jv4vnVOgRCYg5loYfl9ZYmum7Tl
	 uRHrQpNEXR2AEo5BDM33ylgDe/8WM1ln+6XINDYuTc0p3JahFP2qrB4Kjmd+RZKXYt
	 FWc7E2ityM0T/J62NnKlbAjiXjfaGfEKu+zt1JyQ=
Date: Sun, 12 Jan 2025 20:23:55 -0800
To: mm-commits@vger.kernel.org,vgupta@kernel.org,tursulin@ursulin.net,torvalds@linux-foundation.org,tglx@linutronix.de,simona@ffwll.ch,serge@hallyn.com,rodrigo.vivi@intel.com,pmladek@suse.com,peterz@infradead.org,paul@paul-moore.com,ogabbay@kernel.org,mingo@redhat.com,lyude@redhat.com,kvalo@kernel.org,kherbst@redhat.com,kees@kernel.org,joonas.lahtinen@linux.intel.com,johannes@sipsolutions.net,jmorris@namei.org,jirislaby@kernel.org,jani.nikula@linux.intel.com,hpa@zytor.com,gregkh@linuxfoundation.org,dvhart@infradead.org,dave@stgolabs.net,dave.hansen@linux.intel.com,dakr@redhat.com,bp@alien8.de,andriy.shevchenko@linux.intel.com,andrealmeid@igalia.com,airlied@gmail.com,laoar.shao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] arch-remove-get_task_comm-and-print-task-comm-directly.patch removed from -mm tree
Message-Id: <20250113042356.57BFDC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arch: remove get_task_comm() and print task comm directly
has been removed from the -mm tree.  Its filename was
     arch-remove-get_task_comm-and-print-task-comm-directly.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: arch: remove get_task_comm() and print task comm directly
Date: Thu, 19 Dec 2024 10:34:49 +0800

Since task->comm is guaranteed to be NUL-terminated, we can print it
directly without the need to copy it into a separate buffer.  This
simplifies the code and avoids unnecessary operations.

Link: https://lkml.kernel.org/r/20241219023452.69907-3-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "André Almeida" <andrealmeid@igalia.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Danilo Krummrich <dakr@redhat.com>
Cc: Darren Hart <dvhart@infradead.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: James Morris <jmorris@namei.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Oded Gabbay <ogabbay@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/kernel/unaligned.c |    5 ++---
 arch/x86/kernel/vm86_32.c   |    5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

--- a/arch/arc/kernel/unaligned.c~arch-remove-get_task_comm-and-print-task-comm-directly
+++ a/arch/arc/kernel/unaligned.c
@@ -200,7 +200,6 @@ int misaligned_fixup(unsigned long addre
 		     struct callee_regs *cregs)
 {
 	struct disasm_state state;
-	char buf[TASK_COMM_LEN];
 
 	/* handle user mode only and only if enabled by sysadmin */
 	if (!user_mode(regs) || !unaligned_enabled)
@@ -212,11 +211,11 @@ int misaligned_fixup(unsigned long addre
 			     " performance significantly\n. To enable further"
 			     " logging of such instances, please \n"
 			     " echo 0 > /proc/sys/kernel/ignore-unaligned-usertrap\n",
-			     get_task_comm(buf, current), task_pid_nr(current));
+			     current->comm, task_pid_nr(current));
 	} else {
 		/* Add rate limiting if it gets down to it */
 		pr_warn("%s(%d): unaligned access to/from 0x%lx by PC: 0x%lx\n",
-			get_task_comm(buf, current), task_pid_nr(current),
+			current->comm, task_pid_nr(current),
 			address, regs->ret);
 
 	}
--- a/arch/x86/kernel/vm86_32.c~arch-remove-get_task_comm-and-print-task-comm-directly
+++ a/arch/x86/kernel/vm86_32.c
@@ -246,9 +246,8 @@ static long do_sys_vm86(struct vm86plus_
 
 	/* VM86_SCREEN_BITMAP had numerous bugs and appears to have no users. */
 	if (v.flags & VM86_SCREEN_BITMAP) {
-		char comm[TASK_COMM_LEN];
-
-		pr_info_once("vm86: '%s' uses VM86_SCREEN_BITMAP, which is no longer supported\n", get_task_comm(comm, current));
+		pr_info_once("vm86: '%s' uses VM86_SCREEN_BITMAP, which is no longer supported\n",
+			     current->comm);
 		return -EINVAL;
 	}
 
_

Patches currently in -mm which might be from laoar.shao@gmail.com are


