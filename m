From: akpm@linux-foundation.org
Subject: [nacked] coredump-use-task-comm-instead-of-unknown.patch removed from -mm tree
Date: Fri, 27 May 2011 12:55:10 -0700
Message-ID: <201105271953.p4RJrGrs017315@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42025 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932148Ab1E0Tx3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:53:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, john.stultz@linaro.org, mm-commits@vger.kernel.org


The patch titled
     coredump: use task comm instead of (unknown)
has been removed from the -mm tree.  Its filename was
     coredump-use-task-comm-instead-of-unknown.patch

This patch was dropped because it was nacked

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
@@ -1630,8 +1630,11 @@ static int cn_print_exe_file(struct core
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

origin.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch

