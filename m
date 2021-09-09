Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AA14C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E45B1611C3
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348314AbhIIVGZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:06:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:55896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345284AbhIIVF7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:05:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0DF4611CB;
        Thu,  9 Sep 2021 21:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221489;
        bh=iyL2A8ct2KdWacRAVr7bP8M138tWJuzK3Q7YJK/W4CY=;
        h=Date:From:To:Subject:From;
        b=knbANoHG3/zLixH+AkkfdS9XagvrMsZ5QcL4Jq9a/+Zt29/J21WlRgkhxSKRR3lqZ
         JzJol8/5ZmO7rDo8Peb5zB0qLBU04R6AHCjBjB44TCtMsfJ449F2b3HU9iCDPvBB/8
         soDis12S3Rqwx8c+tWDfxKkKanPJl8noG7IrvPm0=
Date:   Thu, 09 Sep 2021 14:04:49 -0700
From:   akpm@linux-foundation.org
To:     joe@perches.com, mm-commits@vger.kernel.org, zohar@linux.ibm.com
Subject:  [merged]
 checkpatch-make-email-address-check-case-insensitive.patch removed from -mm
 tree
Message-ID: <20210909210449.k1JWbzlMj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: make email address check case insensitive
has been removed from the -mm tree.  Its filename was
     checkpatch-make-email-address-check-case-insensitive.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


