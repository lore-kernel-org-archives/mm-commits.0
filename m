Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2DC1B2186
	for <mm-commits@vger.kernel.org>; Fri, 11 Jul 2025 05:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752210876; cv=none; b=h9i272rAJchOMKqEwHXs+atMFKF8IgQ12SyLzSrT5v+RAtZd0WLXP+sNgvELe3XAcKRkFasPVjDOSJnIUzFeljnIOlaNEClQWR2Hur9vIkTq4q1nnRXTipBWjSuDpirpCfqr0506Cw6mnHdd2MkNH1bfwhILCSFb1w3zK5yAgTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752210876; c=relaxed/simple;
	bh=cCLFtTK28tRwPx7QuKsb9MU82l2SRLo0AmdetRsQNnU=;
	h=Date:To:From:Subject:Message-Id; b=rX/OgdkN00Mw4N2xbz3PxNcknAnKvxzwIHTLTkIWNHMuEK8AQEwFsfctJYOBxrvKyCd1hq2L4HXowsYpiYCoZ2Ex0r5+I5s8k+VdrXycwC9C3ANKtVNc6xH+s7RDP51AZPwto+CZwI25Ue8I4RcJTTwlReUIRQVzMiiGQQ0C5Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j5jSNXX+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j5jSNXX+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA333C4CEF0;
	Fri, 11 Jul 2025 05:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752210875;
	bh=cCLFtTK28tRwPx7QuKsb9MU82l2SRLo0AmdetRsQNnU=;
	h=Date:To:From:Subject:From;
	b=j5jSNXX+heN1RomcG0M3SJOHDkPXPqK+xiXq60c//lv9RAAi4Ghzth/1mcefsBgzk
	 FzB5aNU948LfAuSKvJ67EaTzBV2dsSJ/Oqzfw4GXDhPbR37b+ipgg0Qsd2evZKqT91
	 PGJJHfw6xiHgMRrQzNDa52VHbj2aj3cUSmWU80oM=
Date: Thu, 10 Jul 2025 22:14:35 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,rostedt@goodmis.org,paulmck@kernel.org,pandoh@google.com,mjguzik@gmail.com,kuniyu@amazon.com,karolina.stolarek@oracle.com,john.ogness@linutronix.de,bhelgaas@google.com,pmladek@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] lib-make-the-ratelimit-test-more-reliable.patch removed from -mm tree
Message-Id: <20250711051435.DA333C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: make the ratelimit test more reliable
has been removed from the -mm tree.  Its filename was
     lib-make-the-ratelimit-test-more-reliable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


