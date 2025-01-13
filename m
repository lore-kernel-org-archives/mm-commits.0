Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A2B25761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742239; cv=none; b=d35j/4gojefdYVSeto9stMYpKmjF9YiO4czwtDOZwaZAcGXkUFNUu1Joo4TwD9Rw7nvpFA0X6Huvstb3+NF+3eIyCkHSURX3fM67JnW2D2LcCyrDuhSfl5CdbB3ZQBZGD8msd6Zabuye3Jk40sykVa1djCIrFhR/gFDyLU6sed0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742239; c=relaxed/simple;
	bh=OGZD4NP9jSNuxRW50XC8zm6gtiG8nAqGMZ2aCVN69V4=;
	h=Date:To:From:Subject:Message-Id; b=RL/aDsggtTrbgUz0CVljjY5d0khaxRjdRIRBnVeVE4ED7Q0VKW5y4zoKtcho4Gf4MzRTdTckXtCC2ysxeOSloaDu/Y9StDhSRw5NNl8UcFKuYWC6WTtJsjSBO46uZ8ezFmX//6979ukAVFgFdqfFU7rXwNqHTXsPqbq8e2ri3i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZLvQZ3BY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZLvQZ3BY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43171C4CED6;
	Mon, 13 Jan 2025 04:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742239;
	bh=OGZD4NP9jSNuxRW50XC8zm6gtiG8nAqGMZ2aCVN69V4=;
	h=Date:To:From:Subject:From;
	b=ZLvQZ3BYuodhVDJ4QAhzICCGMk4L9tx8alyYYKtvcSnegXoBfSnXETKxkjnjAtK6d
	 DNouBUb3zfy4i03qeYpR2Yp8RMWcFn603G4jo2A3AuOea2x+kiLdkaACrLxzREiEOx
	 cVbWN+CFd4FZBKmhpIR3BVn+lGAl+b5FSDfNlcGQ=
Date: Sun, 12 Jan 2025 20:23:58 -0800
To: mm-commits@vger.kernel.org,vgupta@kernel.org,tursulin@ursulin.net,torvalds@linux-foundation.org,tglx@linutronix.de,simona@ffwll.ch,serge@hallyn.com,rodrigo.vivi@intel.com,pmladek@suse.com,peterz@infradead.org,paul@paul-moore.com,ogabbay@kernel.org,mingo@redhat.com,lyude@redhat.com,kvalo@kernel.org,kherbst@redhat.com,kees@kernel.org,joonas.lahtinen@linux.intel.com,johannes@sipsolutions.net,jmorris@namei.org,jirislaby@kernel.org,jani.nikula@linux.intel.com,hpa@zytor.com,gregkh@linuxfoundation.org,dvhart@infradead.org,dave@stgolabs.net,dave.hansen@linux.intel.com,dakr@redhat.com,bp@alien8.de,andriy.shevchenko@linux.intel.com,andrealmeid@igalia.com,airlied@gmail.com,laoar.shao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] security-remove-get_task_comm-and-print-task-comm-directly.patch removed from -mm tree
Message-Id: <20250113042359.43171C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: security: remove get_task_comm() and print task comm directly
has been removed from the -mm tree.  Its filename was
     security-remove-get_task_comm-and-print-task-comm-directly.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


