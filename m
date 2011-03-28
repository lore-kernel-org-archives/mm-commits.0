From: akpm@linux-foundation.org
Subject: [merged] codafs-fix-build-break-when-config_proc_sysctl=n.patch removed from -mm tree
Date: Mon, 28 Mar 2011 13:40:11 -0700
Message-ID: <201103282039.p2SKdX9b027608@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751536Ab1C1UkK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Mar 2011 16:40:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rakib.mullick@gmail.com, mingo@elte.hu, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     codafs: fix build break when CONFIG_PROC_SYSCTL=n
has been removed from the -mm tree.  Its filename was
     codafs-fix-build-break-when-config_proc_sysctl=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: codafs: fix build break when CONFIG_PROC_SYSCTL=n
From: Rakib Mullick <rakib.mullick@gmail.com>

Commit 0bc825d240ab (codafs: fix compile warning when CONFIG_SYSCTL=n),
introduces build breakage, when CONFIG_PROC_SYSCTL=n and CONFIG_CODA_FS=y.
 This patch fixes it.

fs/built-in.o: In function `init_coda':
psdev.c:(.init.text+0xc02): undefined reference to `coda_sysctl_init'
psdev.c:(.init.text+0xc7c): undefined reference to `coda_sysctl_clean'
fs/built-in.o: In function `exit_coda':
psdev.c:(.exit.text+0xa9): undefined reference to `coda_sysctl_clean'
make: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Reported-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/sysctl.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN fs/coda/sysctl.c~codafs-fix-build-break-when-config_proc_sysctl=n fs/coda/sysctl.c
--- a/fs/coda/sysctl.c~codafs-fix-build-break-when-config_proc_sysctl=n
+++ a/fs/coda/sysctl.c
@@ -61,4 +61,13 @@ void coda_sysctl_clean(void)
 		fs_table_header = NULL;
 	}
 }
+
+#else
+void coda_sysctl_init(void)
+{
+}
+
+void coda_sysctl_clean(void)
+{
+}
 #endif
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

origin.patch
linux-next.patch

