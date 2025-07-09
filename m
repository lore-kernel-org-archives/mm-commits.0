Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F65321ABD0
	for <mm-commits@vger.kernel.org>; Wed,  9 Jul 2025 22:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752101108; cv=none; b=b2XwXQAKO2KnyNwHIWUFRu0lEhjYKM+je+nBpxweK4rVZSv5fN1vYAcIQdLpMV+LtiFrnid7x64Z0fpL1qnQ8kBREgcUfY1Ypfczqt6RIMLe+ug18xXsd9/9Jz5lcb9aG5ei/Iq/lfLvG+iNvUkYNLnzwP009uMAzM/WLXMRJN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752101108; c=relaxed/simple;
	bh=XfOOcnCfE7uF+5GW8Syv2IVMu+DhKvN2CKBKFxkPw8Y=;
	h=Date:To:From:Subject:Message-Id; b=pQUGqfDKZ3DdO4spf3MpDlIeCPLkVa7k09umPoQmd4jjNz0bOYeoXEuMFrThU1zYF+y/uKepxi2vbwhnbs0EDEOuknjLtoy9cQjVn0gIo4lFQFO1c9AVd7C6+uE1deUmTVm+q+BPKj+ENreDgBM0BQeg25Jc/DNET5wS2PKUUSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rRqQhWFk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rRqQhWFk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66416C4CEEF;
	Wed,  9 Jul 2025 22:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752101108;
	bh=XfOOcnCfE7uF+5GW8Syv2IVMu+DhKvN2CKBKFxkPw8Y=;
	h=Date:To:From:Subject:From;
	b=rRqQhWFkKNEjRjWsT2PL7/OXiYNA2H0V88FN8liDmsui7AUSf0rjgTqEzTg4mAFmu
	 W/43ayZth/1DBIAIx/vZIM8hH5IhoPy8/grtogYlabpkxVp5YH0KFaAnQYcaG15voE
	 zn0y0Hht8cRYGb5GuKkM/7Nv3RI07PoJqtBigivo=
Date: Wed, 09 Jul 2025 15:45:07 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,rostedt@goodmis.org,paulmck@kernel.org,pandoh@google.com,mjguzik@gmail.com,kuniyu@amazon.com,karolina.stolarek@oracle.com,john.ogness@linutronix.de,bhelgaas@google.com,pmladek@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-make-the-ratelimit-test-more-reliable.patch added to mm-nonmm-unstable branch
Message-Id: <20250709224508.66416C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: make the ratelimit test more reliable
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-make-the-ratelimit-test-more-reliable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-make-the-ratelimit-test-more-reliable.patch

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
From: Petr Mladek <pmladek@suse.com>
Subject: lib: make the ratelimit test more reliable
Date: Wed, 9 Jul 2025 11:03:34 -0700

The selftest fails most of the times when running in qemu with a kernel
configured with CONFIG_HZ = 250:

>  test_ratelimit_smoke: 1 callbacks suppressed
>  # test_ratelimit_smoke: ASSERTION FAILED at lib/tests/test_ratelimit.c:28
>                    Expected ___ratelimit(&testrl, "test_ratelimit_smoke") == (false), but
>                        ___ratelimit(&testrl, "test_ratelimit_smoke") == 1 (0x1)
>                        (false) == 0 (0x0)

Try to make the test slightly more reliable by calling the problematic
ratelimit in the middle of the interval.

Link: https://lkml.kernel.org/r/20250709180335.1716384-2-paulmck@kernel.org
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Jon Pan-Doh <pandoh@google.com>
Cc: Karolina Stolarek <karolina.stolarek@oracle.com>
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/tests/test_ratelimit.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/lib/tests/test_ratelimit.c~lib-make-the-ratelimit-test-more-reliable
+++ a/lib/tests/test_ratelimit.c
@@ -24,19 +24,19 @@ static void test_ratelimit_smoke(struct
 	test_ratelimited(test, true);
 	test_ratelimited(test, false);
 
-	schedule_timeout_idle(TESTRL_INTERVAL - 40);
+	schedule_timeout_idle(TESTRL_INTERVAL / 2);
 	test_ratelimited(test, false);
 
-	schedule_timeout_idle(50);
+	schedule_timeout_idle(TESTRL_INTERVAL * 3 / 4);
 	test_ratelimited(test, true);
 
 	schedule_timeout_idle(2 * TESTRL_INTERVAL);
 	test_ratelimited(test, true);
 	test_ratelimited(test, true);
 
-	schedule_timeout_idle(TESTRL_INTERVAL - 40);
+	schedule_timeout_idle(TESTRL_INTERVAL / 2 );
 	test_ratelimited(test, true);
-	schedule_timeout_idle(50);
+	schedule_timeout_idle(TESTRL_INTERVAL * 3 / 4);
 	test_ratelimited(test, true);
 	test_ratelimited(test, true);
 	test_ratelimited(test, true);
_

Patches currently in -mm which might be from pmladek@suse.com are

lib-make-the-ratelimit-test-more-reliable.patch

