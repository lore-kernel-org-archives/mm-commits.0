Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCA8161302
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742235; cv=none; b=ZuxIC1UdBM0MH6PjA5ZRMDd1IkOzluHMw+ArlKcJLCceeLQMg7Njhz5jsTrsrRJIdi2jlCZpd5x0QW87eC2MJv8xvWDhP/dFG5EGwQWXbwXRbWwCQ4wdHsgPFNtnTkR4z2ojGjLHjoDpE545vGKEU4ETkCpFGEE6brRg9hMoMeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742235; c=relaxed/simple;
	bh=NF5P49ur/JaA4tNH7qc8JohtaSs/4q+yEUgTc+qAtJM=;
	h=Date:To:From:Subject:Message-Id; b=ItaC+JY6ZUhmn7ItXHS47ayD6is3PDFwQBHMBLubxkx8x/I8fAWk1VXQS++MYzBQqQ713TUT9ZFPpBlxG4+imgoaj4NjFVwGXKUmO9sxSXDezy1nKrkUbb77G7+lrHVVbPFHrI+X2rpK+Ccx12f+4IF7JV22HM4pzQfxmdO7oqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vGQrPQx2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vGQrPQx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE47EC4CED6;
	Mon, 13 Jan 2025 04:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742235;
	bh=NF5P49ur/JaA4tNH7qc8JohtaSs/4q+yEUgTc+qAtJM=;
	h=Date:To:From:Subject:From;
	b=vGQrPQx2Y0PW8tVIy8/qs5kPtm5u7TlCJONpyti4B11lNb9xws6Ls9fmbPFLDNvvv
	 COS4i0DNQXKqm4QE9J4A+5E57aY9zc5YE+Kwb4auvNJIMs+REXQrrUCYAKszNcL1/q
	 CpFx/037XuvHVP0b28tS32e7O+58do/MVVvzCWHk=
Date: Sun, 12 Jan 2025 20:23:54 -0800
To: mm-commits@vger.kernel.org,vgupta@kernel.org,tursulin@ursulin.net,torvalds@linux-foundation.org,tglx@linutronix.de,simona@ffwll.ch,serge@hallyn.com,rodrigo.vivi@intel.com,pmladek@suse.com,peterz@infradead.org,paul@paul-moore.com,ogabbay@kernel.org,mingo@redhat.com,lyude@redhat.com,kvalo@kernel.org,kherbst@redhat.com,kees@kernel.org,joonas.lahtinen@linux.intel.com,johannes@sipsolutions.net,jmorris@namei.org,jirislaby@kernel.org,jani.nikula@linux.intel.com,hpa@zytor.com,gregkh@linuxfoundation.org,dvhart@infradead.org,dave@stgolabs.net,dave.hansen@linux.intel.com,dakr@redhat.com,bp@alien8.de,andriy.shevchenko@linux.intel.com,andrealmeid@igalia.com,airlied@gmail.com,laoar.shao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-remove-get_task_comm-and-print-task-comm-directly.patch removed from -mm tree
Message-Id: <20250113042354.DE47EC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel: remove get_task_comm() and print task comm directly
has been removed from the -mm tree.  Its filename was
     kernel-remove-get_task_comm-and-print-task-comm-directly.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: kernel: remove get_task_comm() and print task comm directly
Date: Thu, 19 Dec 2024 10:34:48 +0800

Patch series "Remove get_task_comm() and print task comm directly", v2.

Since task->comm is guaranteed to be NUL-terminated, we can print it
directly without the need to copy it into a separate buffer.  This
simplifies the code and avoids unnecessary operations.


This patch (of 5):

Since task->comm is guaranteed to be NUL-terminated, we can print it
directly without the need to copy it into a separate buffer.  This
simplifies the code and avoids unnecessary operations.

Link: https://lkml.kernel.org/r/20241219023452.69907-1-laoar.shao@gmail.com
Link: https://lkml.kernel.org/r/20241219023452.69907-2-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Serge Hallyn <serge@hallyn.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "André Almeida" <andrealmeid@igalia.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Danilo Krummrich <dakr@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Airlie <airlied@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: James Morris <jmorris@namei.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Oded Gabbay <ogabbay@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/capability.c     |    8 ++------
 kernel/futex/waitwake.c |    3 +--
 2 files changed, 3 insertions(+), 8 deletions(-)

--- a/kernel/capability.c~kernel-remove-get_task_comm-and-print-task-comm-directly
+++ a/kernel/capability.c
@@ -38,10 +38,8 @@ __setup("no_file_caps", file_caps_disabl
 
 static void warn_legacy_capability_use(void)
 {
-	char name[sizeof(current->comm)];
-
 	pr_info_once("warning: `%s' uses 32-bit capabilities (legacy support in use)\n",
-		     get_task_comm(name, current));
+		     current->comm);
 }
 
 /*
@@ -62,10 +60,8 @@ static void warn_legacy_capability_use(v
 
 static void warn_deprecated_v2(void)
 {
-	char name[sizeof(current->comm)];
-
 	pr_info_once("warning: `%s' uses deprecated v2 capabilities in a way that may be insecure\n",
-		     get_task_comm(name, current));
+		     current->comm);
 }
 
 /*
--- a/kernel/futex/waitwake.c~kernel-remove-get_task_comm-and-print-task-comm-directly
+++ a/kernel/futex/waitwake.c
@@ -210,13 +210,12 @@ static int futex_atomic_op_inuser(unsign
 
 	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28)) {
 		if (oparg < 0 || oparg > 31) {
-			char comm[sizeof(current->comm)];
 			/*
 			 * kill this print and return -EINVAL when userspace
 			 * is sane again
 			 */
 			pr_info_ratelimited("futex_wake_op: %s tries to shift op by %d; fix this program\n",
-					get_task_comm(comm, current), oparg);
+					    current->comm, oparg);
 			oparg &= 31;
 		}
 		oparg = 1 << oparg;
_

Patches currently in -mm which might be from laoar.shao@gmail.com are


