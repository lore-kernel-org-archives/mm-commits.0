Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECDB19EED1
	for <mm-commits@vger.kernel.org>; Fri, 14 Jun 2024 18:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718390895; cv=none; b=Wajq6bsc/x8LHglaRd63J5MbY2ZpSvyf6/Vy8tz1MlwdDN1kcaCpoHTUiu717DPiCFpeh3qJtuh7TIPbrOwZBLdzhy2aQ9lcZb+7SoGCToISSfOC/wTLbDkWk20QE7WKtT2RgLrMKBQgR+rh7KkIlTP6jlbAwcoc3aPSkJGWBOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718390895; c=relaxed/simple;
	bh=pq9nDY2Xz/folPj2+5d/8R/F7CRgIj0vnN6bSM3+MZU=;
	h=Date:To:From:Subject:Message-Id; b=jCJhUUZ6KE/bMXfzsh32N7nrosd8nNF/kdegQswJQpWbqr4P5t74Mjwqbx0gb6QkUCgZa5RtSrP31+SgJBwrIxyBaRvIl9s86rxHhzLK/4Ik9jyAMkH3sh4x+mw6rYKrU0reQkk+gA44eG2fRZ+I72b9U0nB5ep7swJ/T6MoUuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m/DOpv00; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m/DOpv00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A312C2BD10;
	Fri, 14 Jun 2024 18:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718390895;
	bh=pq9nDY2Xz/folPj2+5d/8R/F7CRgIj0vnN6bSM3+MZU=;
	h=Date:To:From:Subject:From;
	b=m/DOpv00TYmw3lNL1DBGexudIvT4wWZgYeBw1fx2T2J5Q8iyOKHJL8wjz1cCrwWm9
	 B864Axxg7Y1PuvQLmiRvKTP4neKjZOVlH+qwIp8BGEiTyv54rE908BjkQm5qoPpsRN
	 dUXmJxjby/BNF4g6DWD5+baIDtetKDX07X2a4Rvg=
Date: Fri, 14 Jun 2024 11:48:14 -0700
To: mm-commits@vger.kernel.org,dvyukov@google.com,andreyknvl@gmail.com,nogikh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kcov-dont-lose-track-of-remote-references-during-softirqs-v2.patch added to mm-hotfixes-unstable branch
Message-Id: <20240614184815.1A312C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kcov-dont-lose-track-of-remote-references-during-softirqs-v2
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kcov-dont-lose-track-of-remote-references-during-softirqs-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kcov-dont-lose-track-of-remote-references-during-softirqs-v2.patch

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
From: Aleksandr Nogikh <nogikh@google.com>
Subject: kcov-dont-lose-track-of-remote-references-during-softirqs-v2
Date: Fri, 14 Jun 2024 19:12:21 +0200

replace WRITE_ONCE() with an ordinary assignment

Link: https://lkml.kernel.org/r/20240614171221.2837584-1-nogikh@google.com
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Tested-by: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kcov.c~kcov-dont-lose-track-of-remote-references-during-softirqs-v2
+++ a/kernel/kcov.c
@@ -632,7 +632,7 @@ static int kcov_ioctl_locked(struct kcov
 			return -EINVAL;
 		kcov->mode = mode;
 		t->kcov = kcov;
-		WRITE_ONCE(t->kcov_mode, KCOV_MODE_REMOTE);
+	        t->kcov_mode = KCOV_MODE_REMOTE;
 		kcov->t = t;
 		kcov->remote = true;
 		kcov->remote_size = remote_arg->area_size;
_

Patches currently in -mm which might be from nogikh@google.com are

kcov-dont-lose-track-of-remote-references-during-softirqs.patch
kcov-dont-lose-track-of-remote-references-during-softirqs-v2.patch

