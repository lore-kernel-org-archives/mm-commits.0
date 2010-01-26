From: akpm@linux-foundation.org
Subject: + proc-warn-on-non-existing-proc-entries.patch added to -mm tree
Date: Tue, 26 Jan 2010 13:56:34 -0800
Message-ID: <201001262156.o0QLuYX3022957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754768Ab0AZV4g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 16:56:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     proc: warn on non-existing proc entries
has been added to the -mm tree.  Its filename is
     proc-warn-on-non-existing-proc-entries.patch

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
Subject: proc: warn on non-existing proc entries
From: Alexey Dobriyan <adobriyan@gmail.com>

* warn if creation goes on to non-existent directory
* warn if removal goes on from non-existing directory
* warn if non-existing proc entry is removed

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN fs/proc/generic.c~proc-warn-on-non-existing-proc-entries fs/proc/generic.c
--- a/fs/proc/generic.c~proc-warn-on-non-existing-proc-entries
+++ a/fs/proc/generic.c
@@ -312,8 +312,10 @@ static int __xlate_proc_name(const char 
 			if (proc_match(len, cp, de))
 				break;
 		}
-		if (!de)
+		if (!de) {
+			WARN(1, "name '%s'\n", name);
 			return -ENOENT;
+		}
 		cp += len + 1;
 	}
 	*residual = cp;
@@ -818,8 +820,10 @@ void remove_proc_entry(const char *name,
 		}
 	}
 	spin_unlock(&proc_subdir_lock);
-	if (!de)
+	if (!de) {
+		WARN(1, "name '%s'\n", name);
 		return;
+	}
 
 	spin_lock(&de->pde_unload_lock);
 	/*
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
arm-convert-proc-cpu-aligment-to-seq_file.patch
dnotify-move-dir_notify_enable-declaration.patch
mpt-fusion-convert-to-seq_file.patch
proc-do-translation-unlink-atomically-at-remove_proc_entry.patch
proc-warn-on-non-existing-proc-entries.patch
tracehooks-kill-some-pt_ptraced-checks.patch
tracehooks-check-pt_ptraced-before-reporting-the-single-step.patch
ptrace_signal-check-pt_ptraced-before-reporting-a-signal.patch
export-__ptrace_detach-and-do_notify_parent_cldstop.patch
reorder-the-code-in-kernel-ptracec.patch
implement-utrace-ptrace.patch
utrace-core.patch

