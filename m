From: akpm@linux-foundation.org
Subject: [merged] fs-coda-fix-compile-warning-when-config_sysctl=n.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:40:56 -0700
Message-ID: <201103232044.p2NKiWkG029082@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933468Ab1CWUoj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:44:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rakib.mullick@gmail.com, jaharkes@cs.cmu.edu, mm-commits@vger.kernel.org


The patch titled
     codafs: fix compile warning when CONFIG_SYSCTL=n
has been removed from the -mm tree.  Its filename was
     fs-coda-fix-compile-warning-when-config_sysctl=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: codafs: fix compile warning when CONFIG_SYSCTL=n
From: Rakib Mullick <rakib.mullick@gmail.com>

When CONFIG_SYSCTL=n, we get the following warning:

fs/coda/sysctl.c:18: warning: `coda_tabl' defined but not used

Fix the warning by making sure coda_table and it's callee function are in
the same context.  Also clean up the code by removing extra #ifdef.

[akpm@linux-foundation.org: remove unneeded stub macros]
Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/sysctl.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

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
@@ -49,22 +47,18 @@ static ctl_table fs_table[] = {
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
+#endif
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

origin.patch
linux-next.patch

