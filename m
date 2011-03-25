From: akpm@linux-foundation.org
Subject: + codafs-fix-build-break-when-config_proc_sysctl=n.patch added to -mm tree
Date: Thu, 24 Mar 2011 17:06:59 -0700
Message-ID: <201103250006.p2P06uXo007964@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752132Ab1CYAHl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Mar 2011 20:07:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rakib.mullick@gmail.com, mingo@elte.hu, randy.dunlap@oracle.com


The patch titled
     codafs: fix build break when CONFIG_PROC_SYSCTL=n
has been added to the -mm tree.  Its filename is
     codafs-fix-build-break-when-config_proc_sysctl=n.patch

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
codafs-fix-build-break-when-config_proc_sysctl=n.patch

