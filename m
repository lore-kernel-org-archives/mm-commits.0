Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89756C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 11 Dec 2020 19:51:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47D9A23ED2
	for <mm-commits@archiver.kernel.org>; Fri, 11 Dec 2020 19:51:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732496AbgLKSPG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Dec 2020 13:15:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:45966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729580AbgLKSOs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 11 Dec 2020 13:14:48 -0500
Date:   Fri, 11 Dec 2020 10:14:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607710447;
        bh=DAsMOMfQ+GOxHhvn8fptXiy7tH7JtFM0Zpi6no7RuOs=;
        h=From:To:Subject:From;
        b=fv4dzcTHzqJXcnNhL/o4CDIzGI5LUU15vQhBJy45pFIZm/kloe91yz2Zt1PHwjCIn
         X0gOTZs/ImUsNL1hS26Sr0TuQH/m4YGyvf6URHU3zXzfp8Im9M+CEhAglFl0TtDQQu
         DrzGQfxdMhbLB6uRPqZ7jGvH9IU+gbBWMbmxhNUs=
From:   akpm@linux-foundation.org
To:     joe@perches.com, mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?checkpatch-add-printk=5Fonce-and-printk=5Fratelimit-to-prefe?=
 =?US-ASCII?Q?r-pr=5Flevel-warning-fix.patch?= added to -mm tree
Message-ID: <20201211181407.RrZGqJB5d%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch-add-printk_once-and-printk_ratelimit-to-prefer-pr_level-warning-fix
has been added to the -mm tree.  Its filename is
     checkpatch-add-printk_once-and-printk_ratelimit-to-prefer-pr_level-warning-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-printk_once-and-printk_ratelimit-to-prefer-pr_level-warning-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-printk_once-and-printk_ratelimit-to-prefer-pr_level-warning-fix.patch

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
Subject: checkpatch-add-printk_once-and-printk_ratelimit-to-prefer-pr_level-warning-fix

It also needs:

Link: https://lkml.kernel.org/r/32260871d4718ba7f48a8e9e07452bb76de300db.camel@perches.com

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/checkpatch.pl~checkpatch-add-printk_once-and-printk_ratelimit-to-prefer-pr_level-warning-fix
+++ a/scripts/checkpatch.pl
@@ -4548,6 +4548,7 @@ sub process {
 			my $printk = $1;
 			my $modifier = $2;
 			my $orig = $3;
+			$modifier = "" if (!defined($modifier));
 			my $level = lc($orig);
 			$level = "warn" if ($level eq "warning");
 			my $level2 = $level;
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
checkpatch-add-printk_once-and-printk_ratelimit-to-prefer-pr_level-warning-fix.patch
treewide-remove-stringification-from-__alias-macro-definition.patch

