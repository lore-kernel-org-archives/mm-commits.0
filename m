Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3803312C486
	for <mm-commits@vger.kernel.org>; Tue, 23 Jul 2024 02:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721701050; cv=none; b=EkM91E55Q71WajL5C5se/V+gM+P5Yx4u3QW3GtMWBXEb04dcWCzYi0swjd/8jTQEV+mfWhjDGHaehx6JCDLDUto13ewEVqZbyx7RFWugerwEmHZakanVLUXUo0//h4cbMfUkCa3QIsi7VFCTaTQWjhDzwn4GHRnC243OHG6hfZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721701050; c=relaxed/simple;
	bh=x69wCmpZ4qnsZFWdv4Wab4ESZivlJ2pVrNIUv4WYD+I=;
	h=Date:To:From:Subject:Message-Id; b=Pvg9Ho1vPiFn7VIHN2feHvzBOu/evpMUm4TBNbtxnQTppoLleF+lDSm81xTJo6itvxZUGdIF1ZP6cAzC5ssvmmc5RNoD46IasBySJyBzn5aZdoEvd8jGI5Wxvm6s/i+dHgK0AKxCkQOl9sD3VLfarntdFF5R3OxUKsqLg/1/gBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F0IiKm8B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F0IiKm8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8895C116B1;
	Tue, 23 Jul 2024 02:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721701049;
	bh=x69wCmpZ4qnsZFWdv4Wab4ESZivlJ2pVrNIUv4WYD+I=;
	h=Date:To:From:Subject:From;
	b=F0IiKm8BFoaarAqkEAloYmnNOOtHS3P8IH+U4Mc6aE4kqridk1xPhtNAo5VmDP+Yc
	 lrtKwKpjFwE7/We/oNyk9JJqktQ6she8FW4WuBvsDDLT3HatK57MHTwD+swntZ5CAc
	 jmH35hsfQPde2NW3OrunWSiUqETZxqrCJTgygreQ=
Date: Mon, 22 Jul 2024 19:17:29 -0700
To: mm-commits@vger.kernel.org,ebiederm@xmission.com,bhe@redhat.com,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-use-atomic_try_cmpxchg_acquire-in-kexec_trylock.patch added to mm-nonmm-unstable branch
Message-Id: <20240723021729.D8895C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec: use atomic_try_cmpxchg_acquire() in kexec_trylock()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-use-atomic_try_cmpxchg_acquire-in-kexec_trylock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-use-atomic_try_cmpxchg_acquire-in-kexec_trylock.patch

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
From: Uros Bizjak <ubizjak@gmail.com>
Subject: kexec: use atomic_try_cmpxchg_acquire() in kexec_trylock()
Date: Fri, 19 Jul 2024 12:38:52 +0200

Use atomic_try_cmpxchg_acquire(*ptr, &old, new) instead of
atomic_cmpxchg_acquire(*ptr, old, new) == old in kexec_trylock().
x86 CMPXCHG instruction returns success in ZF flag, so
this change saves a compare after cmpxchg.

Link: https://lkml.kernel.org/r/20240719103937.53742-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_internal.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/kexec_internal.h~kexec-use-atomic_try_cmpxchg_acquire-in-kexec_trylock
+++ a/kernel/kexec_internal.h
@@ -23,7 +23,8 @@ int kimage_is_destination_range(struct k
 extern atomic_t __kexec_lock;
 static inline bool kexec_trylock(void)
 {
-	return atomic_cmpxchg_acquire(&__kexec_lock, 0, 1) == 0;
+	int old = 0;
+	return atomic_try_cmpxchg_acquire(&__kexec_lock, &old, 1);
 }
 static inline void kexec_unlock(void)
 {
_

Patches currently in -mm which might be from ubizjak@gmail.com are

kexec-use-atomic_try_cmpxchg_acquire-in-kexec_trylock.patch

