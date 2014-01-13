From: akpm@linux-foundation.org
Subject: + fs-proc_namespacec-simplify-testing-nsp-and-nsp-mnt_ns.patch
 added to -mm tree
Date: Mon, 13 Jan 2014 12:03:12 -0800
Message-ID: <52d44680.xdA0TZW85glk/bLW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52057 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaAMUDO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jan 2014 15:03:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, axel.lin@ingics.com

Subject: + fs-proc_namespacec-simplify-testing-nsp-and-nsp-mnt_ns.patch added to -mm tree
To: axel.lin@ingics.com
From: akpm@linux-foundation.org
Date: Mon, 13 Jan 2014 12:03:12 -0800


The patch titled
     Subject: fs/proc_namespace.c: simplify testing nsp and nsp->mnt_ns
has been added to the -mm tree.  Its filename is
     fs-proc_namespacec-simplify-testing-nsp-and-nsp-mnt_ns.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc_namespacec-simplify-testing-nsp-and-nsp-mnt_ns.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc_namespacec-simplify-testing-nsp-and-nsp-mnt_ns.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Axel Lin <axel.lin@ingics.com>
Subject: fs/proc_namespace.c: simplify testing nsp and nsp->mnt_ns

Trivial cleanup to eliminate a goto.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc_namespace.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN fs/proc_namespace.c~fs-proc_namespacec-simplify-testing-nsp-and-nsp-mnt_ns fs/proc_namespace.c
--- a/fs/proc_namespace.c~fs-proc_namespacec-simplify-testing-nsp-and-nsp-mnt_ns
+++ a/fs/proc_namespace.c
@@ -234,17 +234,12 @@ static int mounts_open_common(struct ino
 
 	rcu_read_lock();
 	nsp = task_nsproxy(task);
-	if (!nsp) {
+	if (!nsp || !nsp->mnt_ns) {
 		rcu_read_unlock();
 		put_task_struct(task);
 		goto err;
 	}
 	ns = nsp->mnt_ns;
-	if (!ns) {
-		rcu_read_unlock();
-		put_task_struct(task);
-		goto err;
-	}
 	get_mnt_ns(ns);
 	rcu_read_unlock();
 	task_lock(task);
_

Patches currently in -mm which might be from axel.lin@ingics.com are

fs-ramfs-file-nommuc-make-ramfs_nommu_get_unmapped_area-and-ramfs_nommu_mmap-static.patch
fs-ramfs-move-ramfs_aops-to-inodec.patch
fs-proc_namespacec-simplify-testing-nsp-and-nsp-mnt_ns.patch
linux-next.patch

