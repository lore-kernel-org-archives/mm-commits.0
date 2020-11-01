Return-Path: <SRS0=QWLf=EH=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02DE4C2D0A3
	for <mm-commits@archiver.kernel.org>; Sun,  1 Nov 2020 23:52:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5BBB2080A
	for <mm-commits@archiver.kernel.org>; Sun,  1 Nov 2020 23:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604274743;
	bh=WMV+6VP54o/oNi/wx56dIbgqsKcjtjihE/xfFVoGRQs=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=FjjYEYx89i97E/HCoZ1cfApThJW5ZqrCy3AoVJ/rkjHLRMCGRKBMFYdHtc09MTi0b
	 0bRIuqfpexJqZ6FEEws6AG5uSBZIk1423RvfMffskjvApW7m4u5OD4eTT2nJPlUiMj
	 csNI8g4Ask1nv810jFf78mQHnqIVdhBwlSnNrrJ4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbgKAXwX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Nov 2020 18:52:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:46216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727062AbgKAXwX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 1 Nov 2020 18:52:23 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BE2B2076E;
        Sun,  1 Nov 2020 23:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604274742;
        bh=WMV+6VP54o/oNi/wx56dIbgqsKcjtjihE/xfFVoGRQs=;
        h=Date:From:To:Subject:From;
        b=Q9PtbslZlCJ4vwn+X2puSUKhBlH7izwML3tMN+SUvfGoTlD9nfY+WHyyCK1WstBPL
         ZdAyT1h6jBJ0kqmnlQ/7MU631dX78kgYlfYwv+djRxn9goop/1mcAQdnhUhDqdnwnO
         b5PWb+RLj5apVOBAy4QDzuSRgV9XNFYwSak1E4C0=
Date:   Sun, 01 Nov 2020 15:52:22 -0800
From:   akpm@linux-foundation.org
To:     dwaipayanray1@gmail.com, joe@perches.com,
        mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?checkpatch-add-=5F=5Falias-and-=5F=5Fweak-to-suggested?=
 =?US-ASCII?Q?-=5F=5Fattribute=5F=5F-conversions.patch?= added to -mm tree
Message-ID: <20201101235222.55E8f8d02%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add __alias and __weak to suggested __attribute__ conversions
has been added to the -mm tree.  Its filename is
     checkpatch-add-__alias-and-__weak-to-suggested-__attribute__-conversions.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-__alias-and-__weak-to-suggested-__attribute__-conversions.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-__alias-and-__weak-to-suggested-__attribute__-conversions.patch

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
Subject: checkpatch: add __alias and __weak to suggested __attribute__ conversions

Add __alias and __weak to the suggested __attribute__((<foo>))
conversions.

Link: https://lkml.kernel.org/r/7b74137743c58ce0633ec4d575b94e2210e4dbe7.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-add-__alias-and-__weak-to-suggested-__attribute__-conversions
+++ a/scripts/checkpatch.pl
@@ -6200,6 +6200,7 @@ sub process {
 			$attr =~ s/\s*\(\s*(.*)\)\s*/$1/;
 
 			my %attr_list = (
+				"alias"				=> "__alias",
 				"aligned"			=> "__aligned",
 				"always_inline"			=> "__always_inline",
 				"assume_aligned"		=> "__assume_aligned",
@@ -6220,7 +6221,8 @@ sub process {
 				"packed"			=> "__packed",
 				"pure"				=> "__pure",
 				"section"			=> "__section",
-				"used"				=> "__used"
+				"used"				=> "__used",
+				"weak"				=> "__weak"
 			);
 
 			while ($attr =~ /\s*(\w+)\s*(${balanced_parens})?/g) {
_

Patches currently in -mm which might be from joe@perches.com are

mm-zswap-make-struct-kernel_param_ops-definitions-const.patch
treewide-remove-stringification-from-__alias-macro-definition.patch
checkpatch-prefer-static-const-declarations.patch
checkpatch-allow-fix-removal-of-unnecessary-break-statements.patch
checkpatch-update-__attribute__sectionname-quote-removal.patch
checkpatch-update-__attribute__sectionname-quote-removal-v2.patch
checkpatch-add-__alias-and-__weak-to-suggested-__attribute__-conversions.patch

