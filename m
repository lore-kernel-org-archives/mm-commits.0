From: akpm@linux-foundation.org
Subject: [merged] proc-remove-proc_tty_ldisc-variable.patch removed from
 -mm tree
Date: Tue, 12 Aug 2014 12:39:54 -0700
Message-ID: <53ea6d8a.hMazg8NPLDYdXH9J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:50998 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755053AbaHLTjz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:39:55 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so1920254obb.0
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:39:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: remove proc_tty_ldisc variable
has been removed from the -mm tree.  Its filename was
     proc-remove-proc_tty_ldisc-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: remove proc_tty_ldisc variable

/proc/tty/ldisc appear to be unused as a directory and
it had been always that way.

But it is userspace visible thing.

Cowardly remove only in-kernel variable holding it.

[akpm@linux-foundation.org: add comment]
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_tty.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/proc_tty.c~proc-remove-proc_tty_ldisc-variable fs/proc/proc_tty.c
--- a/fs/proc/proc_tty.c~proc-remove-proc_tty_ldisc-variable
+++ a/fs/proc/proc_tty.c
@@ -18,7 +18,7 @@
 /*
  * The /proc/tty directory inodes...
  */
-static struct proc_dir_entry *proc_tty_ldisc, *proc_tty_driver;
+static struct proc_dir_entry *proc_tty_driver;
 
 /*
  * This is the handler for /proc/tty/drivers
@@ -176,7 +176,7 @@ void __init proc_tty_init(void)
 {
 	if (!proc_mkdir("tty", NULL))
 		return;
-	proc_tty_ldisc = proc_mkdir("tty/ldisc", NULL);
+	proc_mkdir("tty/ldisc", NULL);	/* Preserved: it's userspace visible */
 	/*
 	 * /proc/tty/driver/serial reveals the exact character counts for
 	 * serial links which is just too easy to abuse for inferring
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch

