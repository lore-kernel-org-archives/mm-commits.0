From: akpm@linux-foundation.org
Subject: + acct-eliminate-compile-warning.patch added to -mm tree
Date: Tue, 26 Aug 2014 16:25:30 -0700
Message-ID: <53fd176a.k++lg/E6hrE4mz/n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:42053 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaHZXZb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 19:25:31 -0400
Received: by mail-yh0-f73.google.com with SMTP id f73so1837341yha.0
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 16:25:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.xue@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: acct: eliminate compile warning
has been added to the -mm tree.  Its filename is
     acct-eliminate-compile-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/acct-eliminate-compile-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/acct-eliminate-compile-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ying Xue <ying.xue@windriver.com>
Subject: acct: eliminate compile warning

If ACCT_VERSION is not defined to 3, below warning appears:
  CC      kernel/acct.o
  kernel/acct.c: In function `do_acct_process':
  kernel/acct.c:475:24: warning: unused variable `ns' [-Wunused-variable]

Signed-off-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/acct.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/acct.c~acct-eliminate-compile-warning kernel/acct.c
--- a/kernel/acct.c~acct-eliminate-compile-warning
+++ a/kernel/acct.c
@@ -472,7 +472,6 @@ static void do_acct_process(struct bsd_a
 	acct_t ac;
 	unsigned long flim;
 	const struct cred *orig_cred;
-	struct pid_namespace *ns = acct->ns;
 	struct file *file = acct->file;
 
 	/*
@@ -500,9 +499,10 @@ static void do_acct_process(struct bsd_a
 	ac.ac_gid16 = ac.ac_gid;
 #endif
 #if ACCT_VERSION == 3
-	ac.ac_pid = task_tgid_nr_ns(current, ns);
+	ac.ac_pid = task_tgid_nr_ns(current, acct->ns);
 	rcu_read_lock();
-	ac.ac_ppid = task_tgid_nr_ns(rcu_dereference(current->real_parent), ns);
+	ac.ac_ppid = task_tgid_nr_ns(rcu_dereference(current->real_parent),
+				     acct->ns);
 	rcu_read_unlock();
 #endif
 	/*
_

Patches currently in -mm which might be from ying.xue@windriver.com are

acct-eliminate-compile-warning.patch
acct-eliminate-compile-warning-fix.patch
linux-next.patch

