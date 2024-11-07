Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF52217447;
	Thu,  7 Nov 2024 22:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731017735; cv=none; b=pzkHumGmzdvYl4yc2g7XK28aJG1nzghjkWSAStuRhFdTGE0z473xiNnzvrCSL93LREkqBOWsk1UR7T2B70BomX1H/lzyn2KG5LA+bFAV9ryIPVblMypE3DhZCK2WDg67SWveFJyxb2809Qs+U7sPJPDbCamBnIr1WU9Ftr2uzbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731017735; c=relaxed/simple;
	bh=CGp8HBCqssB5vm+9F5oC/kgwQhZ4iE5pQoKj/q0kzFU=;
	h=Date:To:From:Subject:Message-Id; b=SzTYmajHqOalvmna1WObn7T8Q+nA3RRf/TBmGsJXDqELMjm2zZ7/N43697jrqBk9lQ+huuS7UHnzvOEhgwuwViDhTBTvgIM6VuW4tM+g/Ag5Jf/C4wpEFyUnPdD5k9Qd/Dti1dgHXIRG0M+OMUJfQ4GahbZZUWE9+3yZG7YoUHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ulAIpCci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ulAIpCci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B86C4CECE;
	Thu,  7 Nov 2024 22:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731017734;
	bh=CGp8HBCqssB5vm+9F5oC/kgwQhZ4iE5pQoKj/q0kzFU=;
	h=Date:To:From:Subject:From;
	b=ulAIpCciyeh7YPueHSyNHXo1nsIT1S/kEqe5VjrDNAjg7SPFWfygjYDh+ZA+EMnsX
	 C9hfrIe4rMjf31rhc95qH3Uipo6yzPc+/wDkn9Vdyjw6WsdRiX7YrbeTo5L5Y77qLK
	 wa+Yz7u7RIIENvMq1Jtuxi9SVr7xP55qRajKRJN4=
Date: Thu, 07 Nov 2024 14:15:34 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,oleg@redhat.com,legion@kernel.org,kees@kernel.org,ebiederm@xmission.com,avagin@google.com,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] signal-restore-the-override_rlimit-logic.patch removed from -mm tree
Message-Id: <20241107221534.B5B86C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: signal: restore the override_rlimit logic
has been removed from the -mm tree.  Its filename was
     signal-restore-the-override_rlimit-logic.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: signal: restore the override_rlimit logic
Date: Mon, 4 Nov 2024 19:54:19 +0000

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

Link: https://lkml.kernel.org/r/20241104195419.3962584-1-roman.gushchin@linux.dev
Fixes: d64696905554 ("Reimplement RLIMIT_SIGPENDING on top of ucounts")
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Co-developed-by: Andrei Vagin <avagin@google.com>
Signed-off-by: Andrei Vagin <avagin@google.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Alexey Gladkov <legion@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/user_namespace.h |    3 ++-
 kernel/signal.c                |    3 ++-
 kernel/ucount.c                |    6 ++++--
 3 files changed, 8 insertions(+), 4 deletions(-)

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
@@ -320,7 +321,8 @@ long inc_rlimit_get_ucounts(struct ucoun
 			goto dec_unwind;
 		if (iter == ucounts)
 			ret = new;
-		max = get_userns_rlimit_max(iter->ns, type);
+		if (!override_rlimit)
+			max = get_userns_rlimit_max(iter->ns, type);
 		/*
 		 * Grab an extra ucount reference for the caller when
 		 * the rlimit count was previously 0.
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-page_alloc-move-mlocked-flag-clearance-into-free_pages_prepare.patch

