Return-Path: <SRS0=6wtZ=ED=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73877C4363A
	for <mm-commits@archiver.kernel.org>; Wed, 28 Oct 2020 22:24:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2598420709
	for <mm-commits@archiver.kernel.org>; Wed, 28 Oct 2020 22:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603923888;
	bh=PUl+lufTOoioYvhUmq6kme5hSdclXirDmCHVajIO9/w=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ePJSVijgBT8LC9OUDxy11yb1ODhydcubmOB1LKDvF/O7p4ijmPCcerSTa7Qfuo0e5
	 xuDpVn41X5ZKYDP9IqAmkpD/A9NCad8cQuUXWBxVw3CepCkaTUE4o1ruvIliF708aI
	 GWgqfP7l2T97NTwvkOajAAnuJ7ECWKJ881xKzehI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732970AbgJ1WYq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Oct 2020 18:24:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733024AbgJ1WYp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 28 Oct 2020 18:24:45 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 232F820706;
        Wed, 28 Oct 2020 22:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603923884;
        bh=PUl+lufTOoioYvhUmq6kme5hSdclXirDmCHVajIO9/w=;
        h=Date:From:To:Subject:From;
        b=iHna46cn/Y/7fLurt3hcOauiR5+MWN6tPsEGhhldGQtF/Z4hEhaazFqlPZ8j6CtCB
         6Vj7CmYRxQGEo5h/cpqa4fH2vcpuuExZ1rQjR/KEFLxTZ0w7kl4mZqLN+dsog/rtBS
         ws8SSgRsFzvVDBqgyI39Nv8uxJNaN7BTp/5RRtWE=
Date:   Wed, 28 Oct 2020 15:24:43 -0700
From:   akpm@linux-foundation.org
To:     dwaipayanray1@gmail.com, joe@perches.com,
        mm-commits@vger.kernel.org
Subject:  +
 checkpatch-update-__attribute__sectionname-quote-removal-v2.patch added to
 -mm tree
Message-ID: <20201028222443.HMuI7J08p%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch-update-__attribute__sectionname-quote-removal-v2
has been added to the -mm tree.  Its filename is
     checkpatch-update-__attribute__sectionname-quote-removal-v2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-update-__attribute__sectionname-quote-removal-v2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-update-__attribute__sectionname-quote-removal-v2.patch

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
Subject: checkpatch-update-__attribute__sectionname-quote-removal-v2

This is a slightly shorter/better patch as it eliminates the separate
test below the possible conversions loop.

Link: https://lkml.kernel.org/r/58e9d55e933dc8fdc6af489f2ad797fa8eb13e44.camel@perches.com
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-update-__attribute__sectionname-quote-removal-v2
+++ a/scripts/checkpatch.pl
@@ -6241,14 +6241,11 @@ sub process {
 						$fixed[$fixlinenr] =~ s/$remove//;
 						$fixed[$fixlinenr] =~ s/\b__attribute__/$new __attribute__/;
 						$fixed[$fixlinenr] =~ s/\}\Q$new\E/} $new/;
+						$fixed[$fixlinenr] =~ s/ __attribute__\s*\(\s*\(\s*\)\s*\)//;
 					}
 				}
 			}
 
-			if (show_type("PREFER_DEFINED_ATTRIBUTE_MACRO") && $fix) {
-				$fixed[$fixlinenr] =~ s/ __attribute__\s*\(\s*\(\s*\)\s*\)//;
-			}
-
 			# Check for __attribute__ unused, prefer __always_unused or __maybe_unused
 			if ($attr =~ /^_*unused/) {
 				WARN("PREFER_DEFINED_ATTRIBUTE_MACRO",
_

Patches currently in -mm which might be from joe@perches.com are

mm-zswap-make-struct-kernel_param_ops-definitions-const.patch
checkpatch-prefer-static-const-declarations.patch
checkpatch-allow-fix-removal-of-unnecessary-break-statements.patch
checkpatch-update-__attribute__sectionname-quote-removal.patch
checkpatch-update-__attribute__sectionname-quote-removal-v2.patch

