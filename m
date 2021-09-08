Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 961E3C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 03:00:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B70261153
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 03:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347363AbhIHDBF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 23:01:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345390AbhIHDBB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 23:01:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6BCB61131;
        Wed,  8 Sep 2021 02:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069994;
        bh=KOyA7raIJrUn6+H9zJMTvf8WsDJPNZSLVvEnKmmuRkY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=faMox7oXXrzjV3GlvJZNOwP2cCJxwrXtf4BC7HUgcvshw1CCQ4fk8DFynub51+Xa4
         3XFiGuhAFlu1yEKdSQP/VxHU/mn7mGJE9XJPyolKPHGpui6v5rnJEQ87y1B3sChS6h
         C4jI3zHpGB/eQzSSIRLeqRWLjP6p5dbcERgT+UvI=
Date:   Tue, 07 Sep 2021 19:59:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        zohar@linux.ibm.com
Subject:  [patch 125/147] checkpatch: make email address check case
 insensitive
Message-ID: <20210908025954.fiU3QKGNM%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
