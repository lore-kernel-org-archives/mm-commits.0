From: akpm@linux-foundation.org
Subject: - fix-permissions-of-proc-net.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:31:35 -0700
Message-ID: <200803212031.m2LKVZe2009082@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760910AbYCUUcK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:32:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maan@systemlinux.org, davem@davemloft.net, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Fix permissions of /proc/net
has been removed from the -mm tree.  Its filename was
     fix-permissions-of-proc-net.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix permissions of /proc/net
From: Andre Noll <maan@systemlinux.org>

commit e9720ac ([NET]: Make /proc/net a symlink on /proc/self/net (v3))
broke ganglia and probably other applications that read /proc/net/dev.

This is due to the change of permissions of /proc/net that was
introduced in that commit.

Before: dr-xr-xr-x 5 root root 0 Mar 19 11:30 /proc/net
After: dr-xr--r-- 5 root root 0 Mar 19 11:29 /proc/self/net

This patch restores the permissions to the old value which makes ganglia
happy again.

Signed-off-by: Andre Noll <maan@systemlinux.org>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/base.c~fix-permissions-of-proc-net fs/proc/base.c
--- a/fs/proc/base.c~fix-permissions-of-proc-net
+++ a/fs/proc/base.c
@@ -2290,7 +2290,7 @@ static const struct pid_entry tgid_base_
 	DIR("fd",         S_IRUSR|S_IXUSR, fd),
 	DIR("fdinfo",     S_IRUSR|S_IXUSR, fdinfo),
 #ifdef CONFIG_NET
-	DIR("net",        S_IRUGO|S_IXUSR, net),
+	DIR("net",        S_IRUGO|S_IXUGO, net),
 #endif
 	REG("environ",    S_IRUSR, environ),
 	INF("auxv",       S_IRUSR, pid_auxv),
_

Patches currently in -mm which might be from maan@systemlinux.org are

origin.patch

