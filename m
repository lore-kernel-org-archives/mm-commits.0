From: akpm@linux-foundation.org
Subject: - mismatching-declarations-of-revision-strings-in-hisax.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:03:33 -0700
Message-ID: <200707172303.l6HN3XRc011698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59206 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765325AbXGQXPq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Mismatching declarations of revision strings in HiSax
has been removed from the -mm tree.  Its filename was
     mismatching-declarations-of-revision-strings-in-hisax.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Mismatching declarations of revision strings in HiSax
From: David Woodhouse <dwmw2@infradead.org>

The {l1,l2,l3,lli,tei}_revision strings in the HiSax driver are 'const',
but have a mismatching declaration as 'extern char *' in config.c.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hisax/config.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/isdn/hisax/config.c~mismatching-declarations-of-revision-strings-in-hisax drivers/isdn/hisax/config.c
--- a/drivers/isdn/hisax/config.c~mismatching-declarations-of-revision-strings-in-hisax
+++ a/drivers/isdn/hisax/config.c
@@ -361,11 +361,11 @@ module_param_array(io1, int, NULL, 0);
 
 int nrcards;
 
-extern char *l1_revision;
-extern char *l2_revision;
-extern char *l3_revision;
-extern char *lli_revision;
-extern char *tei_revision;
+extern const char *l1_revision;
+extern const char *l2_revision;
+extern const char *l3_revision;
+extern const char *lli_revision;
+extern const char *tei_revision;
 
 char *HiSax_getrev(const char *revision)
 {
_

Patches currently in -mm which might be from dwmw2@infradead.org are

origin.patch
git-mtd.patch
mtd-add-module-license-to-mtdbdi.patch
git-ubi.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
jffs2-convert-to-new-aops.patch
