Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259DF14A96
	for <mm-commits@vger.kernel.org>; Tue, 11 Jun 2024 18:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718131939; cv=none; b=rW5ce896NShizMJxL4wO8pJXuwddHlRbb7tzP5vaWiOuYJDAA2j7SZ4lJMJT74RTM1UJiXYygqDhPw5q+twvhSw5jr/3Zy7YRgNOnq5IzFr6boVUiXrojAqRwj4VMf2epjNqoksyb1lJ0bi8eWJvRPEEk19WUp5NvDdCC4FGll4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718131939; c=relaxed/simple;
	bh=VW0v4d5FRX2Mvc3p2x/ikENmsvtmbWUhB5VoB3Hg8bk=;
	h=Date:To:From:Subject:Message-Id; b=HyuHT8bHqKoYioZPNbTTzNfW5sYQZ8IKjS+AeRT4wt/fJLHg8TsOzU/tcSLkMZr2RPXT0ohyh0QwhWesM3o4zF5SsA26AzEIAQsunr2URp2cDPrKWW/swT0DQd6GiK6RQuM1TpsU5XSFlgFGVu53az7OtvHWEtMd+cvOHJEhA4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TxAkrTXl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TxAkrTXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0EEAC32786;
	Tue, 11 Jun 2024 18:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718131938;
	bh=VW0v4d5FRX2Mvc3p2x/ikENmsvtmbWUhB5VoB3Hg8bk=;
	h=Date:To:From:Subject:From;
	b=TxAkrTXl7gWldtdh3jRC123Hr6ls6zZJ699PXFTlZ4IBJ7fTucXLd51kDvpEhqiSw
	 WzBmyLvGL8MPY3Jbhj/FSgPU5Mg0hTvD6/dKGgFG9OW4oG/pZFGxlrJxF/QmgjctJk
	 F6vAEnVsLij2vnnu0jhT8G2PptwGN/YBRDdUuFZs=
Date: Tue, 11 Jun 2024 11:52:17 -0700
To: mm-commits@vger.kernel.org,glider@google.com,elver@google.com,dvyukov@google.com,arnd@arndb.de,andreyknvl@gmail.com,nogikh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kcov-dont-lose-track-of-remote-references-during-softirqs.patch added to mm-nonmm-unstable branch
Message-Id: <20240611185218.A0EEAC32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kcov: don't lose track of remote references during softirqs
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kcov-dont-lose-track-of-remote-references-during-softirqs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kcov-dont-lose-track-of-remote-references-during-softirqs.patch

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
From: Aleksandr Nogikh <nogikh@google.com>
Subject: kcov: don't lose track of remote references during softirqs
Date: Tue, 11 Jun 2024 15:32:29 +0200

In kcov_remote_start()/kcov_remote_stop(), we swap the previous KCOV
metadata of the current task into a per-CPU variable.  However, the
kcov_mode_enabled(mode) check is not sufficient in the case of remote KCOV
coverage: current->kcov_mode always remains KCOV_MODE_DISABLED for remote
KCOV objects.

If the original task that has invoked the KCOV_REMOTE_ENABLE ioctl happens
to get interrupted and kcov_remote_start() is called, it ultimately leads
to kcov_remote_stop() NOT restoring the original KCOV reference.  So when
the task exits, all registered remote KCOV handles remain active forever.

Fix it by introducing a special kcov_mode that is assigned to the task
that owns a KCOV remote object.  It makes kcov_mode_enabled() return true
and yet does not trigger coverage collection in __sanitizer_cov_trace_pc()
and write_comp_data().

Link: https://lkml.kernel.org/r/20240611133229.527822-1-nogikh@google.com
Fixes: 5ff3b30ab57d ("kcov: collect coverage from interrupts")
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kcov.h |    2 ++
 kernel/kcov.c        |    1 +
 2 files changed, 3 insertions(+)

--- a/include/linux/kcov.h~kcov-dont-lose-track-of-remote-references-during-softirqs
+++ a/include/linux/kcov.h
@@ -21,6 +21,8 @@ enum kcov_mode {
 	KCOV_MODE_TRACE_PC = 2,
 	/* Collecting comparison operands mode. */
 	KCOV_MODE_TRACE_CMP = 3,
+	/* The process owns a KCOV remote reference. */
+	KCOV_MODE_REMOTE = 4,
 };
 
 #define KCOV_IN_CTXSW	(1 << 30)
--- a/kernel/kcov.c~kcov-dont-lose-track-of-remote-references-during-softirqs
+++ a/kernel/kcov.c
@@ -632,6 +632,7 @@ static int kcov_ioctl_locked(struct kcov
 			return -EINVAL;
 		kcov->mode = mode;
 		t->kcov = kcov;
+		WRITE_ONCE(t->kcov_mode, KCOV_MODE_REMOTE);
 		kcov->t = t;
 		kcov->remote = true;
 		kcov->remote_size = remote_arg->area_size;
_

Patches currently in -mm which might be from nogikh@google.com are

kcov-dont-lose-track-of-remote-references-during-softirqs.patch

