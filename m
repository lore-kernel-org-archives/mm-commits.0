From: akpm@linux-foundation.org
Subject: + proc-misplaced-export-of-find_get_pid.patch added to -mm tree
Date: Wed, 25 Jun 2008 17:41:42 -0700
Message-ID: <200806260041.m5Q0fgbH002341@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52549 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753151AbYFZAlt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Jun 2008 20:41:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dsterba@suse.cz


The patch titled
     proc: misplaced export of find_get_pid
has been added to the -mm tree.  Its filename is
     proc-misplaced-export-of-find_get_pid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: misplaced export of find_get_pid
From: David Sterba <dsterba@suse.cz>

Move EXPORT_SYMBOL right after the func

Signed-off-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/pid.c~proc-misplaced-export-of-find_get_pid kernel/pid.c
--- a/kernel/pid.c~proc-misplaced-export-of-find_get_pid
+++ a/kernel/pid.c
@@ -435,6 +435,7 @@ struct pid *find_get_pid(pid_t nr)
 
 	return pid;
 }
+EXPORT_SYMBOL_GPL(find_get_pid);
 
 pid_t pid_nr_ns(struct pid *pid, struct pid_namespace *ns)
 {
@@ -497,7 +498,6 @@ struct pid *find_ge_pid(int nr, struct p
 
 	return pid;
 }
-EXPORT_SYMBOL_GPL(find_get_pid);
 
 /*
  * The pid hash table is scaled according to the amount of memory in the
_

Patches currently in -mm which might be from dsterba@suse.cz are

proc-misplaced-export-of-find_get_pid.patch

