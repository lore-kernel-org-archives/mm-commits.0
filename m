Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE8E5C4338F
	for <mm-commits@archiver.kernel.org>; Tue, 17 Aug 2021 00:33:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A208660FD7
	for <mm-commits@archiver.kernel.org>; Tue, 17 Aug 2021 00:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235235AbhHQAeW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Aug 2021 20:34:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235271AbhHQAeW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Aug 2021 20:34:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91A0760F39;
        Tue, 17 Aug 2021 00:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629160429;
        bh=NqDu5+r7Nkpk5t6FSo7kklFvpP0zpiLGffbp58VoxTQ=;
        h=Date:From:To:Subject:From;
        b=ysjM+5tlcQIFAt4BKoi7xw5d/sw4KsTwwx4XAhLPL1DqjFoTTioC8QwIpHPN/Ujkd
         NLIpj5QMl2/oxyx9UkNDXfhB9F9/d6cfCDJdexhkZ0XcQpayWWkR/jAtUeqMwDqhKW
         G1I5Hg1hmSb5VR0St2i+wZ4fmgvlDml+jYfD4Nno=
Date:   Mon, 16 Aug 2021 17:33:49 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, joe@perches.com, zohar@linux.ibm.com
Subject:  +
 checkpatch-make-email-address-check-case-insensitive.patch added to -mm tree
Message-ID: <20210817003349.cQ9QJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: make email address check case insensitive
has been added to the -mm tree.  Its filename is
     checkpatch-make-email-address-check-case-insensitive.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-make-email-address-check-case-insensitive.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-make-email-address-check-case-insensitive.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mimi Zohar <zohar@linux.ibm.com>
Subject: checkpatch: make email address check case insensitive

Instead of checkpatch requiring the patch author to exactly match the
signed-off-by tag, commit 48ca2d8ac8a1 ("checkpatch: add new warnings to
author signoff checks.") safely relaxed this requirement.

Although the local-part of an email address (local-part@domain), may be
case sensitive, exploiting the case sensitivity of mailbox local-parts
impedes interoperability and is discouraged.  Mailbox domains follow
normal DNS rules and are hence not case sensitive.  (Refer to
https://datatracker.ietf.org/doc/html/rfc5321#section-2.4.)

Further relax the patch author and signed-off-by tag comparison by making
the email address check case insensitive.

Link: https://lkml.kernel.org/r/20210816112725.173206-1-zohar@linux.ibm.com
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-make-email-address-check-case-insensitive
+++ a/scripts/checkpatch.pl
@@ -2909,10 +2909,10 @@ sub process {
 					my ($email_name, $email_comment, $email_address, $comment1) = parse_email($ctx);
 					my ($author_name, $author_comment, $author_address, $comment2) = parse_email($author);
 
-					if ($email_address eq $author_address && $email_name eq $author_name) {
+					if (lc $email_address eq lc $author_address && $email_name eq $author_name) {
 						$author_sob = $ctx;
 						$authorsignoff = 2;
-					} elsif ($email_address eq $author_address) {
+					} elsif (lc $email_address eq lc $author_address) {
 						$author_sob = $ctx;
 						$authorsignoff = 3;
 					} elsif ($email_name eq $author_name) {
_

Patches currently in -mm which might be from zohar@linux.ibm.com are

checkpatch-make-email-address-check-case-insensitive.patch

