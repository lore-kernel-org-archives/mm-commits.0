Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BB914431B
	for <mm-commits@vger.kernel.org>; Tue, 24 Sep 2024 22:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727216303; cv=none; b=LeJp8zXgzFWETWLNVG+xwFw5gMhBz4PSRYWONyaxVpXiYfnenyYgILAnfuojKP4cQ9QnRcdt5l+B9Vt1+/MGPMtpf0REw1yp1XNidY1dYNwimX96X80Tk5UoqVhnxtBP1KXvRKhAU26yF2f++D7d7eoKfBEaM8XAIQoRQOh8nqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727216303; c=relaxed/simple;
	bh=lJfifDxb5GrribuGxZVC8WEwp1IFIPJ6mzJ2WKxpGVY=;
	h=Date:To:From:Subject:Message-Id; b=AWiWoA118tOccmH7ImmqQQROAILT2CdF/Mc4H5H6qJ8hmapcb5dMfeW/ceJZk80+R4H/2uqyjssLEOvDYNUZ0LXYK+36pLm7HR3dvlHTRw4aS+2xnY4aQjkhsVc1HqjYN0QlrDS+3ibflhUYmYWlMZ9nNAy4h/0ljFRMu1MAUHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hB6CJ/zZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hB6CJ/zZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF9CC4CEC6;
	Tue, 24 Sep 2024 22:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727216303;
	bh=lJfifDxb5GrribuGxZVC8WEwp1IFIPJ6mzJ2WKxpGVY=;
	h=Date:To:From:Subject:From;
	b=hB6CJ/zZRkZufPA7Z+ZzohoLpDM55ZMBOBEfTePRKNunCS6hVw/iQQ15sGGF2RNmj
	 Tf7bs+FgLUGfLuNrfTJ88QQM1vCMZ3fCfjSzwuzFpX2g7mqS+N1W0L/AZ8hNM7/ru3
	 QNMdtAA0ougbMraVjDBJy62875JhxDxj90hPvwFg=
Date: Tue, 24 Sep 2024 15:18:22 -0700
To: mm-commits@vger.kernel.org,qiwu.chen@transsion.com,glider@google.com,elver@google.com,dvyukov@google.com,qiwuchen55@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kfence-fix-elapsed-time-for-allocated-freed-track.patch added to mm-hotfixes-unstable branch
Message-Id: <20240924221823.0EF9CC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: kfence: fix elapsed time for allocated/freed track
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-kfence-fix-elapsed-time-for-allocated-freed-track.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kfence-fix-elapsed-time-for-allocated-freed-track.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "qiwu.chen" <qiwuchen55@gmail.com>
Subject: mm: kfence: fix elapsed time for allocated/freed track
Date: Tue, 24 Sep 2024 16:50:04 +0800

Fix elapsed time for the allocated/freed track introduced by commit
62e73fd85d7bf.

Link: https://lkml.kernel.org/r/20240924085004.75401-1-qiwu.chen@transsion.com
Fixes: 62e73fd85d7bf ("mm: kfence: print the elapsed time for allocated/freed track")
Signed-off-by: qiwu.chen <qiwu.chen@transsion.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/report.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kfence/report.c~mm-kfence-fix-elapsed-time-for-allocated-freed-track
+++ a/mm/kfence/report.c
@@ -109,7 +109,7 @@ static void kfence_print_stack(struct se
 	const struct kfence_track *track = show_alloc ? &meta->alloc_track : &meta->free_track;
 	u64 ts_sec = track->ts_nsec;
 	unsigned long rem_nsec = do_div(ts_sec, NSEC_PER_SEC);
-	u64 interval_nsec = local_clock() - meta->alloc_track.ts_nsec;
+	u64 interval_nsec = local_clock() - track->ts_nsec;
 	unsigned long rem_interval_nsec = do_div(interval_nsec, NSEC_PER_SEC);
 
 	/* Timestamp matches printk timestamp format. */
_

Patches currently in -mm which might be from qiwuchen55@gmail.com are

mm-kfence-fix-elapsed-time-for-allocated-freed-track.patch

