Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8D41B6D11
	for <mm-commits@vger.kernel.org>; Thu, 19 Dec 2024 23:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734651848; cv=none; b=t36LrGVIooHHrngVsQDM3d28yl8IMGHXiOfsYpVtuUE2WsdpsItpbHxl1eQ1OcfqpvKYhCreJ6smD0RFHAD95O1yCpYfTC+iFpQAIbQRlNbtJovF794exc8tJI8drXGlt7Fd3x3JihJFCmjExKPCXz0PUpdXIXQ0/seyEF4vWdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734651848; c=relaxed/simple;
	bh=fSWyH8A2QkhE7eARvbvvggWCleEdIYPZ5kWUprUN+2s=;
	h=Date:To:From:Subject:Message-Id; b=kr/AjiqapJRk5hW1ptIjTCSGjCELqOLj/fdOEEeR+FNCtRUYcboZw+IAUZVFy+VTSWfx5iykSDOGnxYX4hPayQ587ScmMWiFzcVkHvrBEJ5KAI4Dcj8py7n6qk+96nnkA8rrho9J9m3RaCbVO73R9MWcNnLWC7wO1KuMhvhBMNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AkWWduAg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AkWWduAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2094C4CECE;
	Thu, 19 Dec 2024 23:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734651848;
	bh=fSWyH8A2QkhE7eARvbvvggWCleEdIYPZ5kWUprUN+2s=;
	h=Date:To:From:Subject:From;
	b=AkWWduAgsCmM1UqUmBzimXlrJ0XhqpH5NQNvJHFwFTWsd6pdibKcZkQORjLYGDME8
	 Frx5n8YrJHOvfENQyPyNhX5RmKZ8SdatQOuhRu8QsZhxfa8014eTMwyiFvWD8veIdF
	 cC/YcUytTwi1BYQPp0ICWoVzZT3ZOR7DddE9h0/s=
Date: Thu, 19 Dec 2024 15:44:07 -0800
To: mm-commits@vger.kernel.org,vgupta@kernel.org,tursulin@ursulin.net,torvalds@linux-foundation.org,tglx@linutronix.de,simona@ffwll.ch,serge@hallyn.com,rodrigo.vivi@intel.com,pmladek@suse.com,peterz@infradead.org,paul@paul-moore.com,ogabbay@kernel.org,mingo@redhat.com,lyude@redhat.com,kvalo@kernel.org,kherbst@redhat.com,kees@kernel.org,joonas.lahtinen@linux.intel.com,johannes@sipsolutions.net,jmorris@namei.org,jirislaby@kernel.org,jani.nikula@linux.intel.com,hpa@zytor.com,gregkh@linuxfoundation.org,dvhart@infradead.org,dave@stgolabs.net,dave.hansen@linux.intel.com,dakr@redhat.com,bp@alien8.de,andriy.shevchenko@linux.intel.com,andrealmeid@igalia.com,airlied@gmail.com,laoar.shao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + security-remove-get_task_comm-and-print-task-comm-directly.patch added to mm-nonmm-unstable branch
Message-Id: <20241219234407.E2094C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: security: remove get_task_comm() and print task comm directly
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     security-remove-get_task_comm-and-print-task-comm-directly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/security-remove-get_task_comm-and-print-task-comm-directly.patch

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
From: Yafang Shao <laoar.shao@gmail.com>
Subject: security: remove get_task_comm() and print task comm directly
Date: Thu, 19 Dec 2024 10:34:51 +0800

Since task->comm is guaranteed to be NUL-terminated, we can print it
directly without the need to copy it into a separate buffer.  This
simplifies the code and avoids unnecessary operations.

Link: https://lkml.kernel.org/r/20241219023452.69907-5-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: Paul Moore <paul@paul-moore.com>
Acked-by: Kees Cook <kees@kernel.org>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: "André Almeida" <andrealmeid@igalia.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Danilo Krummrich <dakr@redhat.com>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Airlie <airlied@gmail.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Oded Gabbay <ogabbay@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/yama/yama_lsm.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/security/yama/yama_lsm.c~security-remove-get_task_comm-and-print-task-comm-directly
+++ a/security/yama/yama_lsm.c
@@ -76,7 +76,6 @@ static void report_access(const char *ac
 				struct task_struct *agent)
 {
 	struct access_report_info *info;
-	char agent_comm[sizeof(agent->comm)];
 
 	assert_spin_locked(&target->alloc_lock); /* for target->comm */
 
@@ -86,8 +85,7 @@ static void report_access(const char *ac
 		 */
 		pr_notice_ratelimited(
 		    "ptrace %s of \"%s\"[%d] was attempted by \"%s\"[%d]\n",
-		    access, target->comm, target->pid,
-		    get_task_comm(agent_comm, agent), agent->pid);
+		    access, target->comm, target->pid, agent->comm, agent->pid);
 		return;
 	}
 
_

Patches currently in -mm which might be from laoar.shao@gmail.com are

mm-readahead-fix-large-folio-support-in-async-readahead.patch
kernel-remove-get_task_comm-and-print-task-comm-directly.patch
arch-remove-get_task_comm-and-print-task-comm-directly.patch
net-remove-get_task_comm-and-print-task-comm-directly.patch
security-remove-get_task_comm-and-print-task-comm-directly.patch
drivers-remove-get_task_comm-and-print-task-comm-directly.patch

