From: akpm@linux-foundation.org
Subject: - reiser4-kgdb-fix.patch removed from -mm tree
Date: Thu, 01 May 2008 02:16:51 -0700
Message-ID: <200805010916.m419Gp8s029784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754820AbYEAJQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:16:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamalesh@linux.vnet.ibm.com, edward.shishkin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     reiser4 kgdb fix
has been removed from the -mm tree.  Its filename was
     reiser4-kgdb-fix.patch

This patch was dropped because it was folded into reiser4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4 kgdb fix
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

fs/built-in.o: In function `reiser4_debugtrap':
/root/kernels/linux-2.6.25-rc5/fs/reiser4/debug.c:295: undefined reference to `breakpoint'
make: *** [.tmp_vmlinux1] Error 1

This build failure has been introduced by reiser4.patch, i think the
breakpoint() have been used instead of kgdb_breakpoint().

Cc: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/debug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/reiser4/debug.c~reiser4-kgdb-fix fs/reiser4/debug.c
--- a/fs/reiser4/debug.c~reiser4-kgdb-fix
+++ a/fs/reiser4/debug.c
@@ -291,8 +291,8 @@ void reiser4_debugtrap(void)
 {
 	/* do nothing. Put break point here. */
 #if defined(CONFIG_KGDB) && !defined(CONFIG_REISER4_FS_MODULE)
-	extern void breakpoint(void);
-	breakpoint();
+	extern void kgdb_breakpoint(void);
+	kgdb_breakpoint();
 #endif
 }
 #endif
_

Patches currently in -mm which might be from kamalesh@linux.vnet.ibm.com are

origin.patch
smsc-ircc2-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
nsc-ircc-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
reiser4.patch
reiser4-kgdb-fix.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

