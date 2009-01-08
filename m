From: akpm@linux-foundation.org
Subject: - coda-fix-fs-coda-sysctlc-build-warnings-when-config_sysctl.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:47:11 -0800
Message-ID: <200901082247.n08MlBS6026655@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763432AbZAHWvH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:51:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aciddeath@gmail.com, jaharkes@cs.cmu.edu, mm-commits@vger.kernel.org


The patch titled
     coda: fix fs/coda/sysctl.c build warnings when !CONFIG_SYSCTL
has been removed from the -mm tree.  Its filename was
     coda-fix-fs-coda-sysctlc-build-warnings-when-config_sysctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: coda: fix fs/coda/sysctl.c build warnings when !CONFIG_SYSCTL
From: "Richard A. Holden III" <aciddeath@gmail.com>

Fix
fs/coda/sysctl.c:14: warning: 'fs_table_header' defined but not used
fs/coda/sysctl.c:44: warning: 'fs_table' defined but not used

these are only used when CONFIG_SYSCTL is defined.

Signed-off-by: Richard A. Holden III <aciddeath@gmail.com>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/sysctl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/coda/sysctl.c~coda-fix-fs-coda-sysctlc-build-warnings-when-config_sysctl fs/coda/sysctl.c
--- a/fs/coda/sysctl.c~coda-fix-fs-coda-sysctlc-build-warnings-when-config_sysctl
+++ a/fs/coda/sysctl.c
@@ -11,7 +11,9 @@
 
 #include "coda_int.h"
 
+#ifdef CONFIG_SYSCTL
 static struct ctl_table_header *fs_table_header;
+#endif
 
 static ctl_table coda_table[] = {
 	{
@@ -41,6 +43,7 @@ static ctl_table coda_table[] = {
 	{}
 };
 
+#ifdef CONFIG_SYSCTL
 static ctl_table fs_table[] = {
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -50,7 +53,7 @@ static ctl_table fs_table[] = {
 	},
 	{}
 };
