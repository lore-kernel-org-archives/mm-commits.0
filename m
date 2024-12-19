Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209F31B6D11
	for <mm-commits@vger.kernel.org>; Thu, 19 Dec 2024 23:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734651847; cv=none; b=fqhJ/7DO2SYYruTCn4i82czZk8Gs6eRu6NEUCvVrrm6KzhKZOZ3CpBx1x5y29g8TQuIG1Ot51hq42D4DmuYOTs2oWpkHw7OZjQsy5BIASejoVK1jVy7ZZN9goeMCOoDdvMSt0fMUshM91EGqPTC2fujN6nf1mN1zLPoNFDDVIqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734651847; c=relaxed/simple;
	bh=9M/89Biah1hY/uODlaGcJWVVIvVEkoq93c0mYIeCCZg=;
	h=Date:To:From:Subject:Message-Id; b=hS1uBM38yr2L2TSXhq4cNq8Y92D9wUJ8EsR0tbM7y6l+Z6VNwOo9J1zyzEgMucrc6byKAUiVUvKDvBYj8KNU2FPx2WA3BRhBbwTNmFJvGtPPrqkK/q67jGbzJJcL1VL1FyDpJ4ylPnhKNelXaBTiosXR56p8XVbDcqF3TRHCKBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aLlreVh7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aLlreVh7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9650CC4CECE;
	Thu, 19 Dec 2024 23:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734651846;
	bh=9M/89Biah1hY/uODlaGcJWVVIvVEkoq93c0mYIeCCZg=;
	h=Date:To:From:Subject:From;
	b=aLlreVh7Of7dWWEJ+fB7ccygehtG4ijGApPfbA3tYPG803z+OUb0s4a/K9MiSYS/D
	 z3LLIr2f64SQURixWfaAab4mObcgQNLckCXnAotltvTlpBzN7V0vu8TCfV2eaL5Ss7
	 6ne/wKy7GXrKXc/VrCND+CA2rruYqHr+m9bGQas8=
Date: Thu, 19 Dec 2024 15:44:06 -0800
To: mm-commits@vger.kernel.org,vgupta@kernel.org,tursulin@ursulin.net,torvalds@linux-foundation.org,tglx@linutronix.de,simona@ffwll.ch,serge@hallyn.com,rodrigo.vivi@intel.com,pmladek@suse.com,peterz@infradead.org,paul@paul-moore.com,ogabbay@kernel.org,mingo@redhat.com,lyude@redhat.com,kvalo@kernel.org,kherbst@redhat.com,kees@kernel.org,joonas.lahtinen@linux.intel.com,johannes@sipsolutions.net,jmorris@namei.org,jirislaby@kernel.org,jani.nikula@linux.intel.com,hpa@zytor.com,gregkh@linuxfoundation.org,dvhart@infradead.org,dave@stgolabs.net,dave.hansen@linux.intel.com,dakr@redhat.com,bp@alien8.de,andriy.shevchenko@linux.intel.com,andrealmeid@igalia.com,airlied@gmail.com,laoar.shao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + net-remove-get_task_comm-and-print-task-comm-directly.patch added to mm-nonmm-unstable branch
Message-Id: <20241219234406.9650CC4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: net: remove get_task_comm() and print task comm directly
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     net-remove-get_task_comm-and-print-task-comm-directly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/net-remove-get_task_comm-and-print-task-comm-directly.patch

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
Subject: net: remove get_task_comm() and print task comm directly
Date: Thu, 19 Dec 2024 10:34:50 +0800

Since task->comm is guaranteed to be NUL-terminated, we can print it
directly without the need to copy it into a separate buffer.  This
simplifies the code and avoids unnecessary operations.

Link: https://lkml.kernel.org/r/20241219023452.69907-4-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
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
Cc: James Morris <jmorris@namei.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
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
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/wireless/wext-core.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/wireless/wext-core.c~net-remove-get_task_comm-and-print-task-comm-directly
+++ a/net/wireless/wext-core.c
@@ -640,10 +640,8 @@ EXPORT_SYMBOL(wireless_send_event);
 #ifdef CONFIG_CFG80211_WEXT
 static void wireless_warn_cfg80211_wext(void)
 {
-	char name[sizeof(current->comm)];
-
 	pr_warn_once("warning: `%s' uses wireless extensions which will stop working for Wi-Fi 7 hardware; use nl80211\n",
-		     get_task_comm(name, current));
+		     current->comm);
 }
 #endif
 
_

Patches currently in -mm which might be from laoar.shao@gmail.com are

mm-readahead-fix-large-folio-support-in-async-readahead.patch
kernel-remove-get_task_comm-and-print-task-comm-directly.patch
arch-remove-get_task_comm-and-print-task-comm-directly.patch
net-remove-get_task_comm-and-print-task-comm-directly.patch
security-remove-get_task_comm-and-print-task-comm-directly.patch
drivers-remove-get_task_comm-and-print-task-comm-directly.patch

