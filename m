Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51E2199B8
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 21:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759295; cv=none; b=VZ0ab/1O4wpTVXXwgNYR5lgqi3WpQ/nrpbSG5ngFq/b4tE/q8OFjrr6DHOGJAsPf1cGb1MesJBMeh+qmQd789TWkskPoJruOv1ea0r+h9V1m3z6jfg0TwHNJfA+zfzT/xvo2hq/UjXCiuFxW9KF5QfQiSeQaPSL+VvTMXsKQlUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759295; c=relaxed/simple;
	bh=EzlP/tNlT9end5rv/+e0l1sPMFrXfcchMFj0sd+HffU=;
	h=Date:To:From:Subject:Message-Id; b=nfN2lIHfJPiTVG5XqyqMop0Rk1vx0cRrybO+dzN4FwlJt1KzXk9wXBGSdwLh8Am36+YHz1XP7N4DrYV0tZjgSfycsDgQQNvoWSJUSumlZHTnbuCxJ02FElplvDuwFID3YujgFCKR96eZ70LQQ7HPBGKJt34SZCK01n1Ua7o408I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uHUQ9k01; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uHUQ9k01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78BC9C433F1;
	Wed,  6 Mar 2024 21:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709759294;
	bh=EzlP/tNlT9end5rv/+e0l1sPMFrXfcchMFj0sd+HffU=;
	h=Date:To:From:Subject:From;
	b=uHUQ9k01AS2XXEH2+J2pT+jWxf1Ox7eDLnu+Uta2rAd4mJf1J2y4Au/UDJ2B1/QCu
	 DCpdk4dit+TMo4nRWuGi58ngtLthHZCZ9QG8wpQFSItd/4yCMHpE2YRM9kPCPIFf3L
	 cXGpv52AD18lbzPHOyivQP9kB/GKOfXEauEdbr48=
Date: Wed, 06 Mar 2024 13:08:13 -0800
To: mm-commits@vger.kernel.org,wenyang.linux@foxmail.com,pcc@google.com,ebiederm@xmission.com,brauner@kernel.org,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] get_signal-hide_si_addr_tag_bits-fix-the-usage-of-uninitialized-ksig.patch removed from -mm tree
Message-Id: <20240306210814.78BC9C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: get_signal: hide_si_addr_tag_bits: fix the usage of uninitialized ksig
has been removed from the -mm tree.  Its filename was
     get_signal-hide_si_addr_tag_bits-fix-the-usage-of-uninitialized-ksig.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


