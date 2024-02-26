Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DECE12CD89
	for <mm-commits@vger.kernel.org>; Mon, 26 Feb 2024 18:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708972100; cv=none; b=WQggiIFEEn6d8cCK/XQ9C9NLV0ChWv3Lt8gfN5ySO7G7pA8XQrh4CJqUE+jq7Wgbu37N5JevuP8+c+yVRm9wDMNBoq8tH0ehKfccoqO1FkRO3snNsO1qJxFUwVp8qQ0mAzH35GenjkesbuicWvrEWGOF5+4XLYQooemL6SFdKog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708972100; c=relaxed/simple;
	bh=+A+doNhOJ5VG7kO0O7ehKb/ToyAFHjgLOxQXCJLSJrc=;
	h=Date:To:From:Subject:Message-Id; b=Yn1KUYagdXeQ8prBN9i+uxu0h+rCdN0Sw5ADHWAqpzxTQx1DRV9odMNGqmcszmvKeiPli2a6FWi92fcGKQX1LKPVXfwuHDUz9zlws1z+QiEtzbxOORiheS0GWAE8XW/QHuNvvoUGg/OaoVLWSH/fBSWNxq3pGt0VuSLC5gQNid8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZhQ5xwpw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZhQ5xwpw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF043C433C7;
	Mon, 26 Feb 2024 18:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708972100;
	bh=+A+doNhOJ5VG7kO0O7ehKb/ToyAFHjgLOxQXCJLSJrc=;
	h=Date:To:From:Subject:From;
	b=ZhQ5xwpwoLL7LYPIKmJ7fixrnDhNinngxf106ReCjKfW3DTJLAiMd+4d2/Qpya2cM
	 3IRXAMCGjwH1vxPcLPEMw7LeiHtmGUMPF0H+ao8aKjDV85FYb4jcGvAU1sZUjgk3Nk
	 kZC5LRl7pvKkCBakxYpD7uHqWNbIEtn/1HNuu78U=
Date: Mon, 26 Feb 2024 10:28:18 -0800
To: mm-commits@vger.kernel.org,wenyang.linux@foxmail.com,pcc@google.com,ebiederm@xmission.com,brauner@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + get_signal-dont-abuse-ksig-infosi_signo-and-ksig-sig.patch added to mm-nonmm-unstable branch
Message-Id: <20240226182819.CF043C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: get_signal: don't abuse ksig->info.si_signo and ksig->sig
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     get_signal-dont-abuse-ksig-infosi_signo-and-ksig-sig.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/get_signal-dont-abuse-ksig-infosi_signo-and-ksig-sig.patch

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

get_signal-dont-abuse-ksig-infosi_signo-and-ksig-sig.patch
get_signal-hide_si_addr_tag_bits-fix-the-usage-of-uninitialized-ksig.patch
get_signal-dont-initialize-ksig-info-if-signal_group_exit-group_exec_task.patch

