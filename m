From: akpm@linux-foundation.org
Subject: [folded] coredump-escape-in-hostname-and-comm-fix.patch removed from -mm tree
Date: Thu, 26 May 2011 16:18:49 -0700
Message-ID: <201105262318.p4QNInOV026457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754820Ab1EZXTN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 May 2011 19:19:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, john.stultz@linaro.org, mm-commits@vger.kernel.org


The patch titled
     coredump: escape / in hostname and comm fix
has been removed from the -mm tree.  Its filename was
     coredump-escape-in-hostname-and-comm-fix.patch

This patch was dropped because it was folded into coredump-escape-in-hostname-and-comm.patch

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

origin.patch
documentation-configfs-examples-crash-fix.patch
mm-extract-exe_file-handling-from-procfs.patch
coredump-add-support-for-exe_file-in-core-name.patch
coredump-use-get_task_comm-for-%e-filename-format.patch
coredump-use-task-comm-instead-of-unknown.patch
coredump-escape-in-hostname-and-comm.patch

