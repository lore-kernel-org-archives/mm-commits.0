Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA7A179B1
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 21:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759294; cv=none; b=X9sUYK6alrKvYScJVKveVDqMxScNBV/y0rbl/KSmlXYa9/dDqEYSmyMfIayzDPzl7LLyNM0MWlMKd/yporfXTL1iy3L+SI9zJLSz2DO6nMT0F/P13IArbLpYgNPfl/xfA5hMYR6RNoLOhZ4MCV97iIpj8aI0DcG1L1WuVLoZQlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759294; c=relaxed/simple;
	bh=vlyWtSF5Et7mW3ybqKwD+HRPlOiG5ko2EqrvhHy1fho=;
	h=Date:To:From:Subject:Message-Id; b=YxnkERxSagqzIUGfgoEmVN+ZUEoNMpUGs4lskSV/5FQVZkKMggV+szqeqd+6relWVw3e7dKcICN0oTXAvirRmn4xI/ll7Zals+8jFwzq3slclG1MT7VWMmiHCLdDz45diMbER+/vNTWQEEt8/Serc/fYKWrBu9CpoVPKF8Ss9a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W3L2Fc3P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W3L2Fc3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F552C433C7;
	Wed,  6 Mar 2024 21:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709759293;
	bh=vlyWtSF5Et7mW3ybqKwD+HRPlOiG5ko2EqrvhHy1fho=;
	h=Date:To:From:Subject:From;
	b=W3L2Fc3Pjr0oIsJrHALkkoriSEgGsPjUaieVgqj1+rt80VHvqnJhqPYs2ECUNKG4Y
	 Kj135gPV87gt3ICHMhCWol23RJBsl3rYhil3idRX/SlcDElawMApPemOUVi3Oq13q3
	 IzOaIPYROaqByvP9304qK6y0+9c5fJJ/APHodWMw=
Date: Wed, 06 Mar 2024 13:08:12 -0800
To: mm-commits@vger.kernel.org,wenyang.linux@foxmail.com,pcc@google.com,ebiederm@xmission.com,brauner@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] get_signal-dont-abuse-ksig-infosi_signo-and-ksig-sig.patch removed from -mm tree
Message-Id: <20240306210813.8F552C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: get_signal: don't abuse ksig->info.si_signo and ksig->sig
has been removed from the -mm tree.  Its filename was
     get_signal-dont-abuse-ksig-infosi_signo-and-ksig-sig.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: get_signal: don't abuse ksig->info.si_signo and ksig->sig
Date: Mon, 26 Feb 2024 17:56:47 +0100

Patch series "get_signal: minor cleanups and fix".

Lets remove this clear_siginfo() right now.  It is incomplete (and thus
looks confusing) and unnecessary.  Also, PF_USER_WORKER's already don't
get a fully initialized ksig anyway.


This patch (of 3):

Cleanup and preparation for the next changes.

get_signal() uses signr or ksig->info.si_signo or ksig->sig in a chaotic
way, this looks confusing. Change it to always use signr.

Link: https://lkml.kernel.org/r/20240226165612.GA20787@redhat.com
Link: https://lkml.kernel.org/r/20240226165647.GA20826@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Wen Yang <wenyang.linux@foxmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/signal.c~get_signal-dont-abuse-ksig-infosi_signo-and-ksig-sig
+++ a/kernel/signal.c
@@ -2842,7 +2842,7 @@ relock:
 				spin_lock_irq(&sighand->siglock);
 			}
 
-			if (likely(do_signal_stop(ksig->info.si_signo))) {
+			if (likely(do_signal_stop(signr))) {
 				/* It released the siglock.  */
 				goto relock;
 			}
@@ -2866,7 +2866,7 @@ relock:
 
 		if (sig_kernel_coredump(signr)) {
 			if (print_fatal_signals)
-				print_fatal_signal(ksig->info.si_signo);
+				print_fatal_signal(signr);
 			proc_coredump_connector(current);
 			/*
 			 * If it was able to dump core, this kills all
@@ -2890,7 +2890,7 @@ relock:
 		/*
 		 * Death signals, no core dump.
 		 */
-		do_group_exit(ksig->info.si_signo);
+		do_group_exit(signr);
 		/* NOTREACHED */
 	}
 	spin_unlock_irq(&sighand->siglock);
@@ -2900,7 +2900,7 @@ out:
 	if (!(ksig->ka.sa.sa_flags & SA_EXPOSE_TAGBITS))
 		hide_si_addr_tag_bits(ksig);
 
-	return ksig->sig > 0;
+	return signr > 0;
 }
 
 /**
_

Patches currently in -mm which might be from oleg@redhat.com are


