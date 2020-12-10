Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 870F9C4361B
	for <mm-commits@archiver.kernel.org>; Thu, 10 Dec 2020 00:03:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31D7E22D06
	for <mm-commits@archiver.kernel.org>; Thu, 10 Dec 2020 00:03:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgLJADC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Dec 2020 19:03:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:39424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725914AbgLJADC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 9 Dec 2020 19:03:02 -0500
Date:   Wed, 09 Dec 2020 16:02:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607558541;
        bh=0LBlUW/NUjspfMkM3pKgfaWCTiPqCRux9dvHZXBHahE=;
        h=From:To:Subject:From;
        b=cNmG5kGCRrBX08JdxKpq6zZyc6aOL4zV4i6fcwlr54D2jqm0WXBBkLZGU1bdLwmaI
         60hey7n528ixpem6QzL77wHcXWyxR27gjimE27cGZ4of5VtQRjf+yG2V4J2jMQSZZ7
         hCYrlHbPsX/DxIeE48/DnBeYDBP4e+lnPi5PjvM4=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, joe@perches.com
Subject:  +
 =?us-ascii?Q?checkpatch-add-printk=5Fonce-and-printk=5Fratelimit-to-prefe?=
 =?us-ascii?Q?r-pr=5Flevel-warning.patch?= added to -mm tree
Message-ID: <20201210000220.qQxGM%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add printk_once and printk_ratelimit to prefer pr_<level> warning
has been added to the -mm tree.  Its filename is
     checkpatch-add-printk_once-and-printk_ratelimit-to-prefer-pr_level-warning.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-printk_once-and-printk_ratelimit-to-prefer-pr_level-warning.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-printk_once-and-printk_ratelimit-to-prefer-pr_level-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add printk_once and printk_ratelimit to prefer pr_<level> warning

Add the _once and _ratelimited variants to the test for
printk(KERN_<LEVEL> that should prefer pr_<level>.

Miscellanea:

o Add comment description for the conversions

Link: https://lkml.kernel.org/r/993b72b2ef91a57c5e725b52971ce3fd31375061.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-add-printk_once-and-printk_ratelimit-to-prefer-pr_level-warning
+++ a/scripts/checkpatch.pl
@@ -4543,16 +4543,22 @@ sub process {
 			     "printk() should include KERN_<LEVEL> facility level\n" . $herecurr);
 		}
 
-		if ($line =~ /\bprintk\s*\(\s*KERN_([A-Z]+)/) {
-			my $orig = $1;
+# prefer variants of (subsystem|netdev|dev|pr)_<level> to printk(KERN_<LEVEL>
+		if ($line =~ /\b(printk(_once|_ratelimited)?)\s*\(\s*KERN_([A-Z]+)/) {
+			my $printk = $1;
+			my $modifier = $2;
+			my $orig = $3;
 			my $level = lc($orig);
 			$level = "warn" if ($level eq "warning");
 			my $level2 = $level;
 			$level2 = "dbg" if ($level eq "debug");
+			$level .= $modifier;
+			$level2 .= $modifier;
 			WARN("PREFER_PR_LEVEL",
-			     "Prefer [subsystem eg: netdev]_$level2([subsystem]dev, ... then dev_$level2(dev, ... then pr_$level(...  to printk(KERN_$orig ...\n" . $herecurr);
+			     "Prefer [subsystem eg: netdev]_$level2([subsystem]dev, ... then dev_$level2(dev, ... then pr_$level(...  to $printk(KERN_$orig ...\n" . $herecurr);
 		}
 
+# prefer dev_<level> to dev_printk(KERN_<LEVEL>
 		if ($line =~ /\bdev_printk\s*\(\s*KERN_([A-Z]+)/) {
 			my $orig = $1;
 			my $level = lc($orig);
_

Patches currently in -mm which might be from joe@perches.com are

mm-zswap-make-struct-kernel_param_ops-definitions-const.patch
mm-use-sysfs_emit-for-struct-kobject-uses.patch
mm-huge_memory-convert-remaining-use-of-sprintf-to-sysfs_emit-and-neatening.patch
mm-backing-dev-use-sysfs_emit-in-macro-defining-functions.patch
mm-shmem-convert-shmem_enabled_show-to-use-sysfs_emit_at.patch
mm-slub-convert-sysfs-sprintf-family-to-sysfs_emit-sysfs_emit_at.patch
checkpatch-prefer-static-const-declarations.patch
checkpatch-allow-fix-removal-of-unnecessary-break-statements.patch
checkpatch-update-__attribute__sectionname-quote-removal.patch
checkpatch-update-__attribute__sectionname-quote-removal-v2.patch
checkpatch-add-__alias-and-__weak-to-suggested-__attribute__-conversions.patch
checkpatch-add-printk_once-and-printk_ratelimit-to-prefer-pr_level-warning.patch
treewide-remove-stringification-from-__alias-macro-definition.patch

