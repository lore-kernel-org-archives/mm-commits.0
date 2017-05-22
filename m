From: akpm@linux-foundation.org
Subject: + sysctl-fix-lax-sysctl_check_table-sanity-check.patch added to
 -mm tree
Date: Mon, 22 May 2017 15:44:49 -0700
Message-ID: <592369e1.tj22ObkvE7KTW6fn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50652 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751426AbdEVWou (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 May 2017 18:44:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mcgrof@kernel.org, adobriyan@gmail.com, ebiederm@xmission.com, keescook@chromium.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: fix lax sysctl_check_table() sanity check
has been added to the -mm tree.  Its filename is
     sysctl-fix-lax-sysctl_check_table-sanity-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sysctl-fix-lax-sysctl_check_table-sanity-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sysctl-fix-lax-sysctl_check_table-sanity-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: sysctl: fix lax sysctl_check_table() sanity check

Patch series "sysctl: few fixes", v5.

I've been working on making kmod more deterministic, and as I did that I
couldn't help but notice a few issues with sysctl.  My end goal was just
to fix unsigned int support, which back then was completely broken. 
Liping Zhang has sent up small atomic fixes, however it still missed yet
one more fix and Alexey Dobriyan had also suggested to just drop array
support given its complexity.

I have inspected array support using Coccinelle and indeed its not that
popular, so if in fact we can avoid it for new interfaces, I agree its
best.

I did develop a sysctl stress driver but will hold that off for another
series.


This patch (of 5):

Commit 7c60c48f58a7 ("sysctl: Improve the sysctl sanity checks") improved
sanity checks considerbly, however the enhancements on
sysctl_check_table() meant adding a functional change so that only the
last table entry's sanity error is propagated.  It also changed the way
errors were propagated so that each new check reset the err value, this
means only last sanity check computed is used for an error.  This has been
in the kernel since v3.4 days.

Fix this by carrying on errors from previous checks and iterations as we
traverse the table and ensuring we keep any error from previous checks. 
We keep iterating on the table even if an error is found so we can
complain for all errors found in one shot.  This works as -EINVAL is
always returned on error anyway, and the check for error is any non-zero
value.

Fixes: 7c60c48f58a7 ("sysctl: Improve the sysctl sanity checks")
Link: http://lkml.kernel.org/r/20170519033554.18592-2-mcgrof@kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/proc/proc_sysctl.c~sysctl-fix-lax-sysctl_check_table-sanity-check fs/proc/proc_sysctl.c
--- a/fs/proc/proc_sysctl.c~sysctl-fix-lax-sysctl_check_table-sanity-check
+++ a/fs/proc/proc_sysctl.c
@@ -1066,7 +1066,7 @@ static int sysctl_check_table(const char
 	int err = 0;
 	for (; table->procname; table++) {
 		if (table->child)
-			err = sysctl_err(path, table, "Not a file");
+			err |= sysctl_err(path, table, "Not a file");
 
 		if ((table->proc_handler == proc_dostring) ||
 		    (table->proc_handler == proc_dointvec) ||
@@ -1078,15 +1078,15 @@ static int sysctl_check_table(const char
 		    (table->proc_handler == proc_doulongvec_minmax) ||
 		    (table->proc_handler == proc_doulongvec_ms_jiffies_minmax)) {
 			if (!table->data)
-				err = sysctl_err(path, table, "No data");
+				err |= sysctl_err(path, table, "No data");
 			if (!table->maxlen)
-				err = sysctl_err(path, table, "No maxlen");
+				err |= sysctl_err(path, table, "No maxlen");
 		}
 		if (!table->proc_handler)
-			err = sysctl_err(path, table, "No proc_handler");
+			err |= sysctl_err(path, table, "No proc_handler");
 
 		if ((table->mode & (S_IRUGO|S_IWUGO)) != table->mode)
-			err = sysctl_err(path, table, "bogus .mode 0%o",
+			err |= sysctl_err(path, table, "bogus .mode 0%o",
 				table->mode);
 	}
 	return err;
_

Patches currently in -mm which might be from mcgrof@kernel.org are

sysctl-fix-lax-sysctl_check_table-sanity-check.patch
sysctl-kdocify-sysctl_writes_strict.patch
sysctl-fold-sysctl_writes_strict-checks-into-helper.patch
sysctl-simplify-unsigned-int-support.patch
sysctl-add-unsigned-int-range-support.patch

