Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5C61CDFCC;
	Fri,  1 Nov 2024 18:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730485310; cv=none; b=FiwYD5nq8eeerBbK42PZq5bwBbKVi0IjHyfHtHl0XW/pe/ePf/HIFQWlAKyw5AmDnBHfxF1bf+qnW+zNgNbPrQQpS5r0WE20T5UbUGk4jJsH89v+TXbd2Pii4x48cMcRFomRRw/M/BxembfyzqOpXEMUUJ7T99xKjA0kDzL4oO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730485310; c=relaxed/simple;
	bh=1KDKzXlJPQ+weeLc7W4Ot4kX06EB1IRfuKm0Wpe40Sg=;
	h=Date:To:From:Subject:Message-Id; b=bEcQVwfYGh6U5vJ5+VWCdZ8BIFT0BHVHhJLkXwiEcmWpUeQe2zyXEnF8SpvKU/rx4/Fqs21yoOPBXukE3ss+/5/EQ+0x7e5Sw5DyCsdw/AoLx8j23SvPAK+PBXwMmW8NaX44CJ2BqYy7dy+xwEu2eMKmCaDMQ/JX1WTs2lAwHRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CjW+6dOz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CjW+6dOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0A9C4CECD;
	Fri,  1 Nov 2024 18:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730485310;
	bh=1KDKzXlJPQ+weeLc7W4Ot4kX06EB1IRfuKm0Wpe40Sg=;
	h=Date:To:From:Subject:From;
	b=CjW+6dOz7qGowtEPpR2apODr/YDQj3tKhA/oEd6YZC81rW3XJWJmf2F3EatBZmc6R
	 91xwT84yiT4moCXI+4GlWMpWe8W+nEU7AjkwlY4ixXvtXiUp9Rx68XRy5ShrVx578J
	 PO7q1DTUH3Az0FEYFch/gMUdp9S4pVfzPVgC2Pm0=
Date: Fri, 01 Nov 2024 11:21:49 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,oleg@redhat.com,legion@kernel.org,kees@kernel.org,ebiederm@xmission.com,avagin@google.com,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + signal-restore-the-override_rlimit-logic.patch added to mm-hotfixes-unstable branch
Message-Id: <20241101182149.ED0A9C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: signal: restore the override_rlimit logic
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     signal-restore-the-override_rlimit-logic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/signal-restore-the-override_rlimit-logic.patch

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
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: signal: restore the override_rlimit logic
Date: Thu, 31 Oct 2024 20:04:38 +0000

Prior to commit d64696905554 ("Reimplement RLIMIT_SIGPENDING on top of
ucounts") UCOUNT_RLIMIT_SIGPENDING rlimit was not enforced for a class of
signals.  However now it's enforced unconditionally, even if
override_rlimit is set.  This behavior change caused production issues.

For example, if the limit is reached and a process receives a SIGSEGV
signal, sigqueue_alloc fails to allocate the necessary resources for the
signal delivery, preventing the signal from being delivered with siginfo. 
This prevents the process from correctly identifying the fault address and
handling the error.  From the user-space perspective, applications are
unaware that the limit has been reached and that the siginfo is
effectively 'corrupted'.  This can lead to unpredictable behavior and
crashes, as we observed with java applications.

Fix this by passing override_rlimit into inc_rlimit_get_ucounts() and skip
the comparison to max there if override_rlimit is set.  This effectively
restores the old behavior.

Link: https://lkml.kernel.org/r/20241031200438.2951287-1-roman.gushchin@linux.dev
Fixes: d64696905554 ("Reimplement RLIMIT_SIGPENDING on top of ucounts")
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Co-developed-by: Andrei Vagin <avagin@google.com>
Signed-off-by: Andrei Vagin <avagin@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Gladkov <legion@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/user_namespace.h |    3 ++-
 kernel/signal.c                |    3 ++-
 kernel/ucount.c                |    5 +++--
 3 files changed, 7 insertions(+), 4 deletions(-)

--- a/include/linux/user_namespace.h~signal-restore-the-override_rlimit-logic
+++ a/include/linux/user_namespace.h
@@ -141,7 +141,8 @@ static inline long get_rlimit_value(stru
 
 long inc_rlimit_ucounts(struct ucounts *ucounts, enum rlimit_type type, long v);
 bool dec_rlimit_ucounts(struct ucounts *ucounts, enum rlimit_type type, long v);
-long inc_rlimit_get_ucounts(struct ucounts *ucounts, enum rlimit_type type);
+long inc_rlimit_get_ucounts(struct ucounts *ucounts, enum rlimit_type type,
+			    bool override_rlimit);
 void dec_rlimit_put_ucounts(struct ucounts *ucounts, enum rlimit_type type);
 bool is_rlimit_overlimit(struct ucounts *ucounts, enum rlimit_type type, unsigned long max);
 
--- a/kernel/signal.c~signal-restore-the-override_rlimit-logic
+++ a/kernel/signal.c
@@ -419,7 +419,8 @@ __sigqueue_alloc(int sig, struct task_st
 	 */
 	rcu_read_lock();
 	ucounts = task_ucounts(t);
-	sigpending = inc_rlimit_get_ucounts(ucounts, UCOUNT_RLIMIT_SIGPENDING);
+	sigpending = inc_rlimit_get_ucounts(ucounts, UCOUNT_RLIMIT_SIGPENDING,
+					    override_rlimit);
 	rcu_read_unlock();
 	if (!sigpending)
 		return NULL;
--- a/kernel/ucount.c~signal-restore-the-override_rlimit-logic
+++ a/kernel/ucount.c
@@ -307,7 +307,8 @@ void dec_rlimit_put_ucounts(struct ucoun
 	do_dec_rlimit_put_ucounts(ucounts, NULL, type);
 }
 
-long inc_rlimit_get_ucounts(struct ucounts *ucounts, enum rlimit_type type)
+long inc_rlimit_get_ucounts(struct ucounts *ucounts, enum rlimit_type type,
+			    bool override_rlimit)
 {
 	/* Caller must hold a reference to ucounts */
 	struct ucounts *iter;
@@ -316,7 +317,7 @@ long inc_rlimit_get_ucounts(struct ucoun
 
 	for (iter = ucounts; iter; iter = iter->ns->ucounts) {
 		long new = atomic_long_add_return(1, &iter->rlimit[type]);
-		if (new < 0 || new > max)
+		if (new < 0 || (!override_rlimit && (new > max)))
 			goto unwind;
 		if (iter == ucounts)
 			ret = new;
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

signal-restore-the-override_rlimit-logic.patch

