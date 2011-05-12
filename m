From: akpm@linux-foundation.org
Subject: + coredump-use-task-comm-instead-of-unknown.patch added to -mm tree
Date: Thu, 12 May 2011 12:30:44 -0700
Message-ID: <201105121930.p4CJUiaA028518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756975Ab1ELTkw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 May 2011 15:40:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@suse.cz, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, john.stultz@linaro.org


The patch titled
     coredump: use task comm instead of (unknown)
has been added to the -mm tree.  Its filename is
     coredump-use-task-comm-instead-of-unknown.patch

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
Subject: coredump: use task comm instead of (unknown)
From: Jiri Slaby <jslaby@suse.cz>

If we don't know the file corresponding to the binary (i.e.  exe_file is
unknown), use "task->comm (path unknown)" instead of simple "(unknown)" as
suggested by ak.

The fallback is the same as %e except it will append "(path unknown)".

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/exec.c~coredump-use-task-comm-instead-of-unknown fs/exec.c
--- a/fs/exec.c~coredump-use-task-comm-instead-of-unknown
+++ a/fs/exec.c
@@ -1554,8 +1554,11 @@ static int cn_print_exe_file(struct core
 	int ret;
 
 	exe_file = get_mm_exe_file(current->mm);
-	if (!exe_file)
-		return cn_printf(cn, "(unknown)");
+	if (!exe_file) {
+		char comm[TASK_COMM_LEN];
+		return cn_printf(cn, "%s (path unknown)", get_task_comm(comm,
+					current));
+	}
 
 	pathbuf = kmalloc(PATH_MAX, GFP_TEMPORARY);
 	if (!pathbuf) {
_

Patches currently in -mm which might be from jslaby@suse.cz are

linux-next.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
mm-extract-exe_file-handling-from-procfs.patch
coredump-add-support-for-exe_file-in-core-name.patch
coredump-use-get_task_comm-for-%e-filename-format.patch
coredump-use-task-comm-instead-of-unknown.patch
coredump-escape-in-hostname-and-comm.patch

