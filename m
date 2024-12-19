Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6561B6D11
	for <mm-commits@vger.kernel.org>; Thu, 19 Dec 2024 23:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734651844; cv=none; b=JAmbrIkIs2bnxZu0McAFPBFZZx0PYougCqBFS4DWvzi+pdXyEYZC32/VEdmm3sLtmJX6F/9DoNyJ+Mw7srHDl1vT1GxSuEqwHz9yyeuiTXRtSptfwu0O8BtzsMTfPtrQae6E+Rp20A9E5LrDBgeoiWzV2uIkMJDHuqUeTtul978=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734651844; c=relaxed/simple;
	bh=7HQ+th89+LT2TTevMd7fIFskO1b9ZT4cer91M6otvM8=;
	h=Date:To:From:Subject:Message-Id; b=CaRLsXDjBx9gMECg4aDzXuBZSPuwxefimzGZRhOI9rBS+dNG0G8TRI0jAMnIFGaaSjQLGgzAYIMVD+NF2mfTx2I00ps38K2suBFyq9JcW3fcxr9TkRSuTrRq2ludRKw/4B/BJT2rwKayH6krOeSBFO0Zhe4/2ViP0HY3lZ9nl0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SNAq5EDg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SNAq5EDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69667C4CECE;
	Thu, 19 Dec 2024 23:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734651843;
	bh=7HQ+th89+LT2TTevMd7fIFskO1b9ZT4cer91M6otvM8=;
	h=Date:To:From:Subject:From;
	b=SNAq5EDgAzl6xTVcwmFlstnP8pU1GaHenRtRiQW9ImHyhs5ZlhgGOe+lCOk1iYtSN
	 dMwhgfcxjZM0astt4dF42mqlLFDgEJi767A6QjJtmqmDsM/TFhJfnvTKs+Mh2EWeI9
	 qTDZSMT1Zwenrk7VpV/GDUbLurT1rE8L47yO8sJw=
Date: Thu, 19 Dec 2024 15:44:02 -0800
To: mm-commits@vger.kernel.org,vgupta@kernel.org,tursulin@ursulin.net,torvalds@linux-foundation.org,tglx@linutronix.de,simona@ffwll.ch,serge@hallyn.com,rodrigo.vivi@intel.com,pmladek@suse.com,peterz@infradead.org,paul@paul-moore.com,ogabbay@kernel.org,mingo@redhat.com,lyude@redhat.com,kvalo@kernel.org,kherbst@redhat.com,kees@kernel.org,joonas.lahtinen@linux.intel.com,johannes@sipsolutions.net,jmorris@namei.org,jirislaby@kernel.org,jani.nikula@linux.intel.com,hpa@zytor.com,gregkh@linuxfoundation.org,dvhart@infradead.org,dave@stgolabs.net,dave.hansen@linux.intel.com,dakr@redhat.com,bp@alien8.de,andriy.shevchenko@linux.intel.com,andrealmeid@igalia.com,airlied@gmail.com,laoar.shao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-remove-get_task_comm-and-print-task-comm-directly.patch added to mm-nonmm-unstable branch
Message-Id: <20241219234403.69667C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel: remove get_task_comm() and print task comm directly
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-remove-get_task_comm-and-print-task-comm-directly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-remove-get_task_comm-and-print-task-comm-directly.patch

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

mm-readahead-fix-large-folio-support-in-async-readahead.patch
kernel-remove-get_task_comm-and-print-task-comm-directly.patch
arch-remove-get_task_comm-and-print-task-comm-directly.patch
net-remove-get_task_comm-and-print-task-comm-directly.patch
security-remove-get_task_comm-and-print-task-comm-directly.patch
drivers-remove-get_task_comm-and-print-task-comm-directly.patch

