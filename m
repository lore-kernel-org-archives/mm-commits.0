Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C6012CD89
	for <mm-commits@vger.kernel.org>; Mon, 26 Feb 2024 18:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708972101; cv=none; b=h/Uo/L/6gDUerDp9LZ7Dc4x9QItOds/Ol7YBQ+RDgODtnJZ3ISPZZzYod1LSrI1qq9ttebzdwLbZT4P+6cIe1u1casmmK/cCUi2m4EzQ7H2/n5e5lWH8t1XK/P1KfSFNrAsFg8oO8laGyhdkp2TtedIb8AWib+qx19cXom7w3VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708972101; c=relaxed/simple;
	bh=4+NQrBcmQflRXD42ht1lepeyDGVTZ2uLJs261pRNWwU=;
	h=Date:To:From:Subject:Message-Id; b=RcPI5CMm69KFJjlswr5muWcFjw6pzQzGgceHMM+rfIXepD5FEpWyjfKXeYhmSGqK4FcykGs8d4pErXb+apJJNmBz9WuVVjBB82XOiNbgQnw2q5D74xAVQv1AgnaiR8Fl1Wg5q2bhtux2/Yd0SJnMEK71gX1338ngABVAZM0KLwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RlERR8u5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RlERR8u5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E0AC433F1;
	Mon, 26 Feb 2024 18:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708972101;
	bh=4+NQrBcmQflRXD42ht1lepeyDGVTZ2uLJs261pRNWwU=;
	h=Date:To:From:Subject:From;
	b=RlERR8u5JlCKeyvmFVz9/MHQU13sCBtuv4XmNQV6XVaKruPinzokVdH8dKI7ch5zt
	 a+r3IPsiPJYma9Y5v7lPlYvZ/cHtl3NaSXBdNQsSzyQWUFkC11H5yYVyuI/G+ytGdm
	 BE9P/Gz+t16WsHg0roUXisPTrPOrtwPBSDleohVs=
Date: Mon, 26 Feb 2024 10:28:20 -0800
To: mm-commits@vger.kernel.org,wenyang.linux@foxmail.com,pcc@google.com,ebiederm@xmission.com,brauner@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + get_signal-hide_si_addr_tag_bits-fix-the-usage-of-uninitialized-ksig.patch added to mm-nonmm-unstable branch
Message-Id: <20240226182821.46E0AC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: get_signal: hide_si_addr_tag_bits: fix the usage of uninitialized ksig
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     get_signal-hide_si_addr_tag_bits-fix-the-usage-of-uninitialized-ksig.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/get_signal-hide_si_addr_tag_bits-fix-the-usage-of-uninitialized-ksig.patch

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
Subject: get_signal: hide_si_addr_tag_bits: fix the usage of uninitialized ksig
Date: Mon, 26 Feb 2024 17:56:50 +0100

ksig->ka and ksig->info are not initialized if get_signal() returns 0 or
if the caller is PF_USER_WORKER.

Check signr != 0 before SA_EXPOSE_TAGBITS and move the "out" label down.

The latter means that ksig->sig won't be initialized if a PF_USER_WORKER
thread gets a fatal signal but this is fine, PF_USER_WORKER's don't use
ksig. And there is nothing new, in this case ksig->ka and ksig-info are
not initialized anyway. Add a comment.

Link: https://lkml.kernel.org/r/20240226165650.GA20829@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Wen Yang <wenyang.linux@foxmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/kernel/signal.c~get_signal-hide_si_addr_tag_bits-fix-the-usage-of-uninitialized-ksig
+++ a/kernel/signal.c
@@ -2881,8 +2881,9 @@ relock:
 
 		/*
 		 * PF_USER_WORKER threads will catch and exit on fatal signals
-		 * themselves. They have cleanup that must be performed, so
-		 * we cannot call do_exit() on their behalf.
+		 * themselves. They have cleanup that must be performed, so we
+		 * cannot call do_exit() on their behalf. Note that ksig won't
+		 * be properly initialized, PF_USER_WORKER's shouldn't use it.
 		 */
 		if (current->flags & PF_USER_WORKER)
 			goto out;
@@ -2894,12 +2895,12 @@ relock:
 		/* NOTREACHED */
 	}
 	spin_unlock_irq(&sighand->siglock);
-out:
+
 	ksig->sig = signr;
 
-	if (!(ksig->ka.sa.sa_flags & SA_EXPOSE_TAGBITS))
+	if (signr && !(ksig->ka.sa.sa_flags & SA_EXPOSE_TAGBITS))
 		hide_si_addr_tag_bits(ksig);
-
+out:
 	return signr > 0;
 }
 
_

Patches currently in -mm which might be from oleg@redhat.com are

get_signal-dont-abuse-ksig-infosi_signo-and-ksig-sig.patch
get_signal-hide_si_addr_tag_bits-fix-the-usage-of-uninitialized-ksig.patch
get_signal-dont-initialize-ksig-info-if-signal_group_exit-group_exec_task.patch

