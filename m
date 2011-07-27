From: akpm@linux-foundation.org
Subject: [merged] coredump-use-task-comm-instead-of-unknown.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:28:29 -0700
Message-ID: <201107271927.p6RJRFU9003196@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974Ab1G0T1y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:27:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, oleg@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     coredump: use task comm instead of (unknown)
has been removed from the -mm tree.  Its filename was
     coredump-use-task-comm-instead-of-unknown.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/exec.c~coredump-use-task-comm-instead-of-unknown fs/exec.c
--- a/fs/exec.c~coredump-use-task-comm-instead-of-unknown
+++ a/fs/exec.c
@@ -1657,7 +1657,7 @@ static int cn_print_exe_file(struct core
 
 	exe_file = get_mm_exe_file(current->mm);
 	if (!exe_file)
-		return cn_printf(cn, "(unknown)");
+		return cn_printf(cn, "%s (path unknown)", current->comm);
 
 	pathbuf = kmalloc(PATH_MAX, GFP_TEMPORARY);
 	if (!pathbuf) {
_

Patches currently in -mm which might be from jslaby@suse.cz are

origin.patch
linux-next.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch

