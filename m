From: akpm@linux-foundation.org
Subject: + coredump-escape-in-hostname-and-comm-fix.patch added to -mm tree
Date: Thu, 12 May 2011 14:11:11 -0700
Message-ID: <201105122111.p4CLBBUR001606@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758660Ab1ELVLa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 May 2011 17:11:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@suse.cz, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, john.stultz@linaro.org


The patch titled
     coredump: escape / in hostname and comm fix
has been added to the -mm tree.  Its filename is
     coredump-escape-in-hostname-and-comm-fix.patch

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
Subject: coredump: escape / in hostname and comm fix
From: Jiri Slaby <jslaby@suse.cz>

Escape comm also in failing %E case.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/exec.c~coredump-escape-in-hostname-and-comm-fix fs/exec.c
--- a/fs/exec.c~coredump-escape-in-hostname-and-comm-fix
+++ a/fs/exec.c
@@ -1563,8 +1563,8 @@ static int cn_print_exe_file(struct core
 	exe_file = get_mm_exe_file(current->mm);
 	if (!exe_file) {
 		char comm[TASK_COMM_LEN];
-		return cn_printf(cn, "%s (path unknown)", get_task_comm(comm,
-					current));
+		cn_escape(get_task_comm(comm, current));
+		return cn_printf(cn, "%s (path unknown)", comm);
 	}
 
 	pathbuf = kmalloc(PATH_MAX, GFP_TEMPORARY);
_

Patches currently in -mm which might be from jslaby@suse.cz are

linux-next.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
documentation-configfs-examples-crash-fix.patch
documentation-configfs-examples-crash-fix-checkpatch-fixes.patch
mm-extract-exe_file-handling-from-procfs.patch
coredump-add-support-for-exe_file-in-core-name.patch
coredump-use-get_task_comm-for-%e-filename-format.patch
coredump-use-task-comm-instead-of-unknown.patch
coredump-escape-in-hostname-and-comm.patch
coredump-escape-in-hostname-and-comm-fix.patch

