From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-check-spdx-tags-in-yaml-files.patch added to
 -mm tree
Date: Wed, 12 Feb 2020 15:10:43 -0800
Message-ID: <20200212231043.6qDS49XOG%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728603AbgBLXKo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Feb 2020 18:10:44 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, lkundrak@v3.sk, mm-commits@vger.kernel.org, robh@kernel.org


The patch titled
     Subject: checkpatch: check SPDX tags in YAML files
has been added to the -mm tree.  Its filename is
     checkpatch-check-spdx-tags-in-yaml-files.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-check-spdx-tags-in-yaml-files.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-check-spdx-tags-in-yaml-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3120,7 +3120,7 @@ sub process {
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

checkpatch-check-spdx-tags-in-yaml-files.patch
