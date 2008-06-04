From: akpm@linux-foundation.org
Subject: + net-make-proc-net-a-symlink-on-proc-self-net.patch added to -mm tree
Date: Wed, 04 Jun 2008 01:02:10 -0700
Message-ID: <200806040802.m5482AEF011323@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752776AbYFDICn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 04:02:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vegard.nossum@gmail.com, davem@davemloft.net, ebiederm@xmission.com, xemul@openvz.org


The patch titled
     net: make /proc/net a symlink on /proc/self/net
has been added to the -mm tree.  Its filename is
     net-make-proc-net-a-symlink-on-proc-self-net.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net: make /proc/net a symlink on /proc/self/net
From: Vegard Nossum <vegard.nossum@gmail.com>

This patch:

  commit e9720acd728a46cb40daa52c99a979f7c4ff195c
  Author: Pavel Emelyanov <xemul@openvz.org>
  Date:   Fri Mar 7 11:08:40 2008 -0800

    [NET]: Make /proc/net a symlink on /proc/self/net (v3)

Introduced /proc/net without bumping the link count on /proc/self.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/proc/base.c~net-make-proc-net-a-symlink-on-proc-self-net fs/proc/base.c
--- a/fs/proc/base.c~net-make-proc-net-a-symlink-on-proc-self-net
+++ a/fs/proc/base.c
@@ -2590,6 +2590,9 @@ static struct dentry *proc_pid_instantia
 #ifdef CONFIG_SECURITY
 	inode->i_nlink += 1;
 #endif
+#ifdef CONFIG_NET
+	inode->i_nlink += 1;
+#endif
 
 	dentry->d_op = &pid_dentry_operations;
 
_

Patches currently in -mm which might be from vegard.nossum@gmail.com are

origin.patch
linux-next.patch
arm-fix-header-guards.patch
parisc-fix-incomplete-header-guard.patch
h8300-fix-typo-in-header-guard.patch
v850-fix-typo-in-header-guard.patch
net-make-proc-net-a-symlink-on-proc-self-net.patch
kallsyms-fix-potential-overflow-in-binary-search.patch
quota-cleanup-loop-in-sync_dquots.patch

