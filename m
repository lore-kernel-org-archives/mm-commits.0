From: akpm@linux-foundation.org
Subject: + fs-coda-fix-compile-warning-when-config_sysctl=n.patch added to -mm tree
Date: Mon, 14 Mar 2011 15:34:24 -0700
Message-ID: <201103142234.p2EMYOnT015026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757404Ab1CNWfB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Mar 2011 18:35:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rakib.mullick@gmail.com, jaharkes@cs.cmu.edu


The patch titled
     codafs: fix compile warning when CONFIG_SYSCTL=n
has been added to the -mm tree.  Its filename is
     fs-coda-fix-compile-warning-when-config_sysctl=n.patch

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
Subject: codafs: fix compile warning when CONFIG_SYSCTL=n
From: Rakib Mullick <rakib.mullick@gmail.com>

When CONFIG_SYSCTL=n, we get the following warning:

fs/coda/sysctl.c:18: warning: `coda_tabl' defined but not used

Fix the warning by making sure coda_table and it's callee function are in
the same context.  Also clean up the code by removing extra #ifdef.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/sysctl.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN fs/coda/sysctl.c~fs-coda-fix-compile-warning-when-config_sysctl=n fs/coda/sysctl.c
--- a/fs/coda/sysctl.c~fs-coda-fix-compile-warning-when-config_sysctl=n
+++ a/fs/coda/sysctl.c
@@ -13,7 +13,6 @@
 
 #ifdef CONFIG_SYSCTL
 static struct ctl_table_header *fs_table_header;
-#endif
 
 static ctl_table coda_table[] = {
 	{
@@ -40,7 +39,6 @@ static ctl_table coda_table[] = {
 	{}
 };
 
-#ifdef CONFIG_SYSCTL
 static ctl_table fs_table[] = {
 	{
 		.procname	= "coda",
@@ -49,22 +47,23 @@ static ctl_table fs_table[] = {
 	},
 	{}
 };
-#endif
 
 void coda_sysctl_init(void)
 {
-#ifdef CONFIG_SYSCTL
 	if ( !fs_table_header )
 		fs_table_header = register_sysctl_table(fs_table);
-#endif
 }
 
 void coda_sysctl_clean(void)
 {
-#ifdef CONFIG_SYSCTL
 	if ( fs_table_header ) {
 		unregister_sysctl_table(fs_table_header);
 		fs_table_header = NULL;
 	}
-#endif
 }
+#else
+
+#define	coda_sysctl_init()		do { }  while (0);
+#define	coda_sysctl_clean()		do { }	while (0);
+
+#endif
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

linux-next.patch
smp-move-smp-setup-functions-to-kernel-smpc.patch
fs-coda-fix-compile-warning-when-config_sysctl=n.patch
fs-coda-fix-compile-warning-when-config_sysctl=n-fix.patch

