From: akpm@linux-foundation.org
Subject: + bsdacct-switch-credentials-for-writing-to-the-accounting-file.patch added to -mm tree
Date: Mon, 24 Aug 2009 14:31:10 -0700
Message-ID: <200908242131.n7OLVBSJ007997@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752637AbZHXVcK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Aug 2009 17:32:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mschmidt@redhat.com, dhowells@redhat.com, jmorris@namei.org, sds@tycho.nsa.gov, serue@us.ibm.com


The patch titled
     bsdacct: switch credentials for writing to the accounting file
has been added to the -mm tree.  Its filename is
     bsdacct-switch-credentials-for-writing-to-the-accounting-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bsdacct: switch credentials for writing to the accounting file
From: Michal Schmidt <mschmidt@redhat.com>

When process accounting is enabled, every exiting process writes a log to
the account file.  In addition, every once in a while one of the exiting
processes checks whether there's enough free space for the log.

SELinux policy may or may not allow the exiting process to stat the fs. 
So unsuspecting processes start generating AVC denials just because
someone enabled process accounting.

For these filesystem operations, the exiting process's credentials should
be temporarily switched to that of the process which enabled accounting,
because it's really that process which wanted to have the accounting
information logged.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Acked-by: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/acct.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN kernel/acct.c~bsdacct-switch-credentials-for-writing-to-the-accounting-file kernel/acct.c
--- a/kernel/acct.c~bsdacct-switch-credentials-for-writing-to-the-accounting-file
+++ a/kernel/acct.c
@@ -491,13 +491,17 @@ static void do_acct_process(struct bsd_a
 	u64 run_time;
 	struct timespec uptime;
 	struct tty_struct *tty;
+	const struct cred *orig_cred;
+
+	/* Perform file operations on behalf of whoever enabled accounting */
+	orig_cred = override_creds(file->f_cred);
 
 	/*
 	 * First check to see if there is enough free_space to continue
 	 * the process accounting system.
 	 */
 	if (!check_free_space(acct, file))
-		return;
+		goto out;
 
 	/*
 	 * Fill the accounting struct with the needed info as recorded
@@ -578,6 +582,8 @@ static void do_acct_process(struct bsd_a
 			       sizeof(acct_t), &file->f_pos);
 	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = flim;
 	set_fs(fs);
+out:
+	revert_creds(orig_cred);
 }
 
 /**
_

Patches currently in -mm which might be from mschmidt@redhat.com are

bsdacct-switch-credentials-for-writing-to-the-accounting-file.patch

