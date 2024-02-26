Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1337412CD89
	for <mm-commits@vger.kernel.org>; Mon, 26 Feb 2024 18:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708972103; cv=none; b=dem3/jT2WRFVM7TG1O5Sr7aBCwgbLMHxAf+A048+YGyBslzKPvBgLpR0jVtdAa4HrcLubw9z2A508ji3NL2Jks+NEVLPczk6IBJPN7m966wio9oEFldgk6Q2Hn04ENwDossJoKTYmW1ZLGanTRydlUeMTF9a2DxAYJ6EBFDB0KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708972103; c=relaxed/simple;
	bh=Vw6RSjyu3AIiYoTyMAAmX/HAMQDRFsubNob1smD7WX8=;
	h=Date:To:From:Subject:Message-Id; b=DfesZwZhn79shHIo+txJviM2+sow7wAj3p3rLGiUcTS4lcQJcIBJDPWKrAAy/4g0O/yrKmM5SOTjxjG0aTJGc+zF+qgc3rQPwrsf8kWhu6nICFNJAy+z2IyMowghWpEc7JwXEhdt1bT+cPau0Dj4HFTV+kmuzOqQX2Z+Wb8PNQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Igg3VHGN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Igg3VHGN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88760C433C7;
	Mon, 26 Feb 2024 18:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708972102;
	bh=Vw6RSjyu3AIiYoTyMAAmX/HAMQDRFsubNob1smD7WX8=;
	h=Date:To:From:Subject:From;
	b=Igg3VHGN3mzQmXNaxtS6D2og/sShoLNusMV7HHEqaA00LO1POTseIgQQ6xuOA7VOg
	 drwkgktBz5h6VR2XnCyd74CPyBgtzmW6FJwAVHZBmRRcKzu3y8Qanj9ppMbrFajNTZ
	 SOiZw8xl7Mr89Q2SqQJscWvg2YPRidkbCpxsQmSk=
Date: Mon, 26 Feb 2024 10:28:21 -0800
To: mm-commits@vger.kernel.org,wenyang.linux@foxmail.com,pcc@google.com,ebiederm@xmission.com,brauner@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + get_signal-dont-initialize-ksig-info-if-signal_group_exit-group_exec_task.patch added to mm-nonmm-unstable branch
Message-Id: <20240226182822.88760C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: get_signal: don't initialize ksig->info if SIGNAL_GROUP_EXIT/group_exec_task
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     get_signal-dont-initialize-ksig-info-if-signal_group_exit-group_exec_task.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/get_signal-dont-initialize-ksig-info-if-signal_group_exit-group_exec_task.patch

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
Subject: get_signal: don't initialize ksig->info if SIGNAL_GROUP_EXIT/group_exec_task
Date: Mon, 26 Feb 2024 17:56:53 +0100

This initialization is incomplete and unnecessary, neither do_group_exit()
nor PF_USER_WORKER need ksig->info.

Link: https://lkml.kernel.org/r/20240226165653.GA20834@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Wen Yang <wenyang.linux@foxmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/kernel/signal.c~get_signal-dont-initialize-ksig-info-if-signal_group_exit-group_exec_task
+++ a/kernel/signal.c
@@ -2727,12 +2727,15 @@ relock:
 		/* Has this task already been marked for death? */
 		if ((signal->flags & SIGNAL_GROUP_EXIT) ||
 		     signal->group_exec_task) {
-			clear_siginfo(&ksig->info);
-			ksig->info.si_signo = signr = SIGKILL;
+			signr = SIGKILL;
 			sigdelset(&current->pending.signal, SIGKILL);
 			trace_signal_deliver(SIGKILL, SEND_SIG_NOINFO,
-				&sighand->action[SIGKILL - 1]);
+					     &sighand->action[SIGKILL-1]);
 			recalc_sigpending();
+			/*
+			 * implies do_group_exit() or return to PF_USER_WORKER,
+			 * no need to initialize ksig->info/etc.
+			 */
 			goto fatal;
 		}
 
_

Patches currently in -mm which might be from oleg@redhat.com are

get_signal-dont-abuse-ksig-infosi_signo-and-ksig-sig.patch
get_signal-hide_si_addr_tag_bits-fix-the-usage-of-uninitialized-ksig.patch
get_signal-dont-initialize-ksig-info-if-signal_group_exit-group_exec_task.patch

