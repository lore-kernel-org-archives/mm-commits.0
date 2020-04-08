From: akpm@linux-foundation.org
Subject: [merged] checkpatch-check-spdx-tags-in-yaml-files.patch
 removed from -mm tree
Date: Tue, 07 Apr 2020 19:01:27 -0700
Message-ID: <20200408020127.UIIXBH2mj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbgDHCB2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:01:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, lkundrak@v3.sk, mm-commits@vger.kernel.org, robh@kernel.org


The patch titled
     Subject: checkpatch: check SPDX tags in YAML files
has been removed from the -mm tree.  Its filename was
     checkpatch-check-spdx-tags-in-yaml-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lubomir Rintel <lkundrak@v3.sk>
Subject: checkpatch: check SPDX tags in YAML files

This adds a warning when a YAML file is lacking a SPDX header on first
line, or it uses incorrect commenting style.

Currently the only YAML files in the tree are Devicetree binding
documents.

Link: http://lkml.kernel.org/r/20200129123356.388669-1-lkundrak@v3.sk
Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Acked-by: Joe Perches <joe@perches.com>
Cc: Rob Herring <robh@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-check-spdx-tags-in-yaml-files
+++ a/scripts/checkpatch.pl
@@ -3106,7 +3106,7 @@ sub process {
 					$comment = '/*';
 				} elsif ($realfile =~ /\.(c|dts|dtsi)$/) {
 					$comment = '//';
-				} elsif (($checklicenseline == 2) || $realfile =~ /\.(sh|pl|py|awk|tc)$/) {
+				} elsif (($checklicenseline == 2) || $realfile =~ /\.(sh|pl|py|awk|tc|yaml)$/) {
 					$comment = '#';
 				} elsif ($realfile =~ /\.rst$/) {
 					$comment = '..';
_

Patches currently in -mm which might be from lkundrak@v3.sk are
