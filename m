From: akpm@linux-foundation.org
Subject: + proc-do-less-stuff-under-pde_unload_lock.patch added to -mm
 tree
Date: Tue, 13 Feb 2018 15:21:49 -0800
Message-ID: <5a83730d.JhB5c/OVLNBi/mL3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58586 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965783AbeBMXVu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Feb 2018 18:21:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: do less stuff under ->pde_unload_lock
has been added to the -mm tree.  Its filename is
     proc-do-less-stuff-under-pde_unload_lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-do-less-stuff-under-pde_unload_lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-do-less-stuff-under-pde_unload_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: do less stuff under ->pde_unload_lock

ca469f35a8e9ef ("deal with races between remove_proc_entry() and
proc_reg_release()") moved too much stuff under ->pde_unload_lock making a
problem described at series "[PATCH v5] procfs: Improve Scaling in proc"
worse.

While RCU is being figured out, move kfree() out of ->pde_unload_lock.

On my potato, difference is only 0.5% speedup with concurrent
open+read+close of /proc/cmdline, but the effect should be more
noticeable on more capable machines.

$ perf stat -r 16 -- ./proc-j 16

 Performance counter stats for './proc-j 16' (16 runs):

     130569.502377      task-clock (msec)         #   15.872 CPUs utilized            ( +-  0.05% )
            19,169      context-switches          #    0.147 K/sec                    ( +-  0.18% )
                15      cpu-migrations            #    0.000 K/sec                    ( +-  3.27% )
               437      page-faults               #    0.003 K/sec                    ( +-  1.25% )
   300,172,097,675      cycles                    #    2.299 GHz                      ( +-  0.05% )
    96,793,267,308      instructions              #    0.32  insn per cycle           ( +-  0.04% )
    22,798,342,298      branches                  #  174.607 M/sec                    ( +-  0.04% )
       111,764,687      branch-misses             #    0.49% of all branches          ( +-  0.47% )

       8.226574400 seconds time elapsed                                          ( +-  0.05% )
       ^^^^^^^^^^^

$ perf stat -r 16 -- ./proc-j 16

 Performance counter stats for './proc-j 16' (16 runs):

     129866.777392      task-clock (msec)         #   15.869 CPUs utilized            ( +-  0.04% )
            19,154      context-switches          #    0.147 K/sec                    ( +-  0.66% )
                14      cpu-migrations            #    0.000 K/sec                    ( +-  1.73% )
               431      page-faults               #    0.003 K/sec                    ( +-  1.09% )
   298,556,520,546      cycles                    #    2.299 GHz                      ( +-  0.04% )
    96,525,366,833      instructions              #    0.32  insn per cycle           ( +-  0.04% )
    22,730,194,043      branches                  #  175.027 M/sec                    ( +-  0.04% )
       111,506,074      branch-misses             #    0.49% of all branches          ( +-  0.18% )

       8.183629778 seconds time elapsed                                          ( +-  0.04% )
       ^^^^^^^^^^^

Link: http://lkml.kernel.org/r/20180213132911.GA24298@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN fs/proc/inode.c~proc-do-less-stuff-under-pde_unload_lock fs/proc/inode.c
--- a/fs/proc/inode.c~proc-do-less-stuff-under-pde_unload_lock
+++ a/fs/proc/inode.c
@@ -138,7 +138,7 @@ static void unuse_pde(struct proc_dir_en
 		complete(pde->pde_unload_completion);
 }
 
-/* pde is locked */
+/* pde is locked on entry, unlocked on exit */
 static void close_pdeo(struct proc_dir_entry *pde, struct pde_opener *pdeo)
 {
 	/*
@@ -157,9 +157,10 @@ static void close_pdeo(struct proc_dir_e
 		pdeo->c = &c;
 		spin_unlock(&pde->pde_unload_lock);
 		wait_for_completion(&c);
-		spin_lock(&pde->pde_unload_lock);
 	} else {
 		struct file *file;
+		struct completion *c;
+
 		pdeo->closing = true;
 		spin_unlock(&pde->pde_unload_lock);
 		file = pdeo->file;
@@ -167,8 +168,10 @@ static void close_pdeo(struct proc_dir_e
 		spin_lock(&pde->pde_unload_lock);
 		/* After ->release. */
 		list_del(&pdeo->lh);
-		if (unlikely(pdeo->c))
-			complete(pdeo->c);
+		c = pdeo->c;
+		spin_unlock(&pde->pde_unload_lock);
+		if (unlikely(c))
+			complete(c);
 		kfree(pdeo);
 	}
 }
@@ -188,6 +191,7 @@ void proc_entry_rundown(struct proc_dir_
 		struct pde_opener *pdeo;
 		pdeo = list_first_entry(&de->pde_openers, struct pde_opener, lh);
 		close_pdeo(de, pdeo);
+		spin_lock(&de->pde_unload_lock);
 	}
 	spin_unlock(&de->pde_unload_lock);
 }
@@ -375,7 +379,7 @@ static int proc_reg_release(struct inode
 	list_for_each_entry(pdeo, &pde->pde_openers, lh) {
 		if (pdeo->file == file) {
 			close_pdeo(pde, pdeo);
-			break;
+			return 0;
 		}
 	}
 	spin_unlock(&pde->pde_unload_lock);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-do-less-stuff-under-pde_unload_lock.patch
seq_file-delete-small-value-optimization.patch

