From: akpm@osdl.org
Subject: - do_coredump-and-not-stopping-rewrite-attacks.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:17:01 -0800
Message-ID: <200612072317.kB7NH1Z0030896@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53710 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163816AbWLGXRL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:17:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, ak@suse.de, alan@lxorguk.ukuu.org.uk, stable@kerenl.org, mm-commits@vger.kernel.org


The patch titled
     do_coredump() and not stopping rewrite attacks?
has been removed from the -mm tree.  Its filename was
     do_coredump-and-not-stopping-rewrite-attacks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: do_coredump() and not stopping rewrite attacks?
From: Alexey Dobriyan <adobriyan@gmail.com>

On Sat, Dec 02, 2006 at 11:47:44PM +0300, Alexey Dobriyan wrote:
> David Binderman compiled 2.6.19 with icc and grepped for "was set but never
> used". Many warnings are on
> 	http://coderock.org/kj/unused-2.6.19-fs

Heh, the very first line:
fs/exec.c(1465): remark #593: variable "flag" was set but never used

fs/exec.c:
  1477		/*
  1478		 *	We cannot trust fsuid as being the "true" uid of the
  1479		 *	process nor do we know its entire history. We only know it
  1480		 *	was tainted so we dump it as root in mode 2.
  1481		 */
  1482		if (mm->dumpable == 2) {	/* Setuid core dump mode */
  1483			flag = O_EXCL;		/* Stop rewrite attacks */
  1484			current->fsuid = 0;	/* Dump root private */
  1485		}

And then filp_open follows with "flag" totally ignored.

(akpm: this restores the code to Alan's original version.  Andi's "Support
piping into commands in /proc/sys/kernel/core_pattern" (cset d025c9db) broke
it).

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: <stable@kerenl.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/exec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/exec.c~do_coredump-and-not-stopping-rewrite-attacks fs/exec.c
--- a/fs/exec.c~do_coredump-and-not-stopping-rewrite-attacks
+++ a/fs/exec.c
@@ -1515,7 +1515,8 @@ int do_coredump(long signr, int exit_cod
 		ispipe = 1;
  	} else
  		file = filp_open(corename,
-				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE, 0600);
+				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
+				 0600);
 	if (IS_ERR(file))
 		goto fail_unlock;
 	inode = file->f_dentry->d_inode;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
git-cpufreq.patch
git-ieee1394.patch
git-mtd.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-isdn-trivial-vsnprintf-conversion.patch
drivers-video-use-kmemdup.patch

