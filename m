From: akpm@linux-foundation.org
Subject: - allow-access-to-proc-pid-fd-after-setuid-update.patch removed from -mm tree
Date: Mon, 05 Mar 2007 16:57:50 -0800
Message-ID: <200703060057.l260vpq3006901@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43670 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933724AbXCFA7J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 19:59:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@openvz.org, chrisw@sous-sol.org, dev@openvz.org, drepper@redhat.com, ebiederm@xmission.com, hch@lst.de, jmorris@namei.org, oleg@tv-sign.ru, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     allow-access-to-proc-pid-fd-after-setuid-v2
has been removed from the -mm tree.  Its filename was
     allow-access-to-proc-pid-fd-after-setuid-update.patch

This patch was dropped because it was folded into allow-access-to-proc-pid-fd-after-setuid.patch

------------------------------------------------------
Subject: allow-access-to-proc-pid-fd-after-setuid-v2
From: Alexey Dobriyan <adobriyan@openvz.org>

crap, Pavel reminded that get_proc_task() can return NULL.

Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Kirill Korotaev <dev@openvz.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN fs/proc/base.c~allow-access-to-proc-pid-fd-after-setuid-update fs/proc/base.c
--- a/fs/proc/base.c~allow-access-to-proc-pid-fd-after-setuid-update
+++ a/fs/proc/base.c
@@ -1461,9 +1461,11 @@ static int proc_fd_permission(struct ino
 	if (rv == 0)
 		return 0;
 	tsk = get_proc_task(inode);
-	if (tsk == current)
-		rv = 0;
-	put_task_struct(tsk);
+	if (tsk) {
+		if (tsk == current)
+			rv = 0;
+		put_task_struct(tsk);
+	}
 	return rv;
 }
 
_

Patches currently in -mm which might be from adobriyan@openvz.org are

ia64-sync-compat-getdents-on-ia64-and-parisc.patch
parisc-sync-compat-getdents-on-ia64-and-parisc.patch
x86_64-wire-up-compat-sched_rr_get_interval2.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
allow-access-to-proc-pid-fd-after-setuid-update-2.patch
lutimesat-simplify-utime2.patch
lutimesat-extend-do_utimes-with-flags.patch
lutimesat-actual-syscall-and-wire-up-on-i386.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch
