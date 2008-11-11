From: akpm@linux-foundation.org
Subject: + coda-fix-fs-coda-sysctlc-build-warnings-when-config_sysctl.patch added to -mm tree
Date: Tue, 11 Nov 2008 14:31:15 -0800
Message-ID: <200811112231.mABMVFoO018486@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751647AbYKKWbw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Nov 2008 17:31:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aciddeath@gmail.com, jaharkes@cs.cmu.edu


The patch titled
     coda: fix fs/coda/sysctl.c build warnings when !CONFIG_SYSCTL
has been added to the -mm tree.  Its filename is
     coda-fix-fs-coda-sysctlc-build-warnings-when-config_sysctl.patch

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
