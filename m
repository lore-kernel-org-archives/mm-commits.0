From: akpm@linux-foundation.org
Subject: + kcore-fix-proc-kcores-statst_size.patch added to -mm tree
Date: Wed, 01 Jul 2009 14:48:58 -0700
Message-ID: <200907012148.n61LmwZw031771@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752816AbZGAVt0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 17:49:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, amwang@redhat.com, ebiederm@xmission.com, mtk.manpages@gmail.com, tao.ma@oracle.com


The patch titled
     kcore: fix /proc/kcore's stat.st_size
has been added to the -mm tree.  Its filename is
     kcore-fix-proc-kcores-statst_size.patch

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
Subject: kcore: fix /proc/kcore's stat.st_size
From: Amerigo Wang <xiyou.wangcong@gmail.com>

In 9063c61fd5cbd ("x86, 64-bit: Clean up user address masking") Linus
fixed the wrong size of /proc/kcore problem.

But its size still looks insane, since it never equals the size of
physical memory.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tao Ma <tao.ma@oracle.com>
Cc: <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/proc/kcore.c~kcore-fix-proc-kcores-statst_size fs/proc/kcore.c
--- a/fs/proc/kcore.c~kcore-fix-proc-kcores-statst_size
+++ a/fs/proc/kcore.c
@@ -405,9 +405,6 @@ read_kcore(struct file *file, char __use
 static int __init proc_kcore_init(void)
 {
 	proc_root_kcore = proc_create("kcore", S_IRUSR, NULL, &proc_kcore_operations);
-	if (proc_root_kcore)
-		proc_root_kcore->size =
-				(size_t)high_memory - PAGE_OFFSET + PAGE_SIZE;
 	return 0;
 }
 module_init(proc_kcore_init);
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
linux-next.patch
elf-fix-multithreaded-program-core-dumping-on-arm.patch
kcore-fix-proc-kcores-statst_size.patch

