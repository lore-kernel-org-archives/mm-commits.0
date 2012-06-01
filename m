From: akpm@linux-foundation.org
Subject: [merged] proc-dont-do-dummy-rcu_read_lock-rcu_read_unlock-on-error-path.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:33:54 -0700
Message-ID: <20120601193354.5E00FA013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:52540 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759069Ab2FATdz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:33:55 -0400
Received: by mail-ey0-f202.google.com with SMTP id o13so111891eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:33:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, paulmck@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: don't do dummy rcu_read_lock/rcu_read_unlock on error path
has been removed from the -mm tree.  Its filename was
     proc-dont-do-dummy-rcu_read_lock-rcu_read_unlock-on-error-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: don't do dummy rcu_read_lock/rcu_read_unlock on error path

rcu_read_lock()/rcu_read_unlock() is nop for TINY_RCU, but is not a nop
for, say, PREEMPT_RCU.

proc_fill_cache() is called without RCU lock, there is no need to
lock/unlock on error path, simply jump out of the loop.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN fs/proc/base.c~proc-dont-do-dummy-rcu_read_lock-rcu_read_unlock-on-error-path fs/proc/base.c
--- a/fs/proc/base.c~proc-dont-do-dummy-rcu_read_lock-rcu_read_unlock-on-error-path
+++ a/fs/proc/base.c
@@ -1928,21 +1928,22 @@ static int proc_readfd_common(struct fil
 			     fd++, filp->f_pos++) {
 				char name[PROC_NUMBUF];
 				int len;
+				int rv;
 
 				if (!fcheck_files(files, fd))
 					continue;
 				rcu_read_unlock();
 
 				len = snprintf(name, sizeof(name), "%d", fd);
-				if (proc_fill_cache(filp, dirent, filldir,
-						    name, len, instantiate,
-						    p, &fd) < 0) {
-					rcu_read_lock();
-					break;
-				}
+				rv = proc_fill_cache(filp, dirent, filldir,
+						     name, len, instantiate, p,
+						     &fd);
+				if (rv < 0)
+					goto out_fd_loop;
 				rcu_read_lock();
 			}
 			rcu_read_unlock();
+out_fd_loop:
 			put_files_struct(files);
 	}
 out:
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
proc-pass-fd-by-value-in-proc-fdfdinfo-code.patch
proc-smaps-carefully-handle-migration-entries.patch
proc-smaps-show-amount-of-nonlinear-ptes-in-vma.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch

