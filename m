From: akpm@linux-foundation.org
Subject: [merged] checkpatchpl-warn-if-an-adding-line-introduce-spaces-before-tabs.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:09:17 -0800
Message-ID: <201003091909.o29J9Hru031509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755749Ab0CITWJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maramaopercheseimorto@gmail.com, apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch.pl: warn if an adding line introduce spaces before tabs.
has been removed from the -mm tree.  Its filename was
     checkpatchpl-warn-if-an-adding-line-introduce-spaces-before-tabs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch.pl: warn if an adding line introduce spaces before tabs.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>

Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatchpl-warn-if-an-adding-line-introduce-spaces-before-tabs scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatchpl-warn-if-an-adding-line-introduce-spaces-before-tabs
+++ a/scripts/checkpatch.pl
@@ -1422,6 +1422,12 @@ sub process {
 			ERROR("code indent should use tabs where possible\n" . $herevet);
 		}
 
+# check for space before tabs.
+		if ($rawline =~ /^\+/ && $rawline =~ / \t/) {
+			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
+			WARN("please, no space before tabs\n" . $herevet);
+		}
+
 # check we are in a valid C source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c)$/);
 
_

Patches currently in -mm which might be from maramaopercheseimorto@gmail.com are

linux-next.patch
w1-mxc_w1-move-probe-and-remove-to-the-dev-text-area.patch

