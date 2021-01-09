Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2EC9C433E0
	for <mm-commits@archiver.kernel.org>; Sat,  9 Jan 2021 00:26:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A15342399A
	for <mm-commits@archiver.kernel.org>; Sat,  9 Jan 2021 00:26:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725817AbhAIA0V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jan 2021 19:26:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:56528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbhAIA0V (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 8 Jan 2021 19:26:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7507208E4;
        Sat,  9 Jan 2021 00:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610151940;
        bh=eL6+8W8t6wy1wDQdeBWTqpBsOq2lllkZcma0gWlaCAo=;
        h=Date:From:To:Subject:From;
        b=mfzI4y+W/blgE0jKqXkwmo2zMLuQTj49898jBZ+2t8rgDA47/0jWfEoP5XRo8AmAP
         uZ9eoMETcC2HA1THPM6CgiEgu0uT/GaqeMgTea8EkjEImhZlnOG/AiRY18QSuYNp8T
         zHljarbmyQ1zCWDtg9Ffq71eI1WvFbx88GYiRZ4U=
Date:   Fri, 08 Jan 2021 16:25:39 -0800
From:   akpm@linux-foundation.org
To:     dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        joe@perches.com, mm-commits@vger.kernel.org
Subject:  +
 checkpatch-prefer-ftrace-over-function-entry-exit-printks.patch added to
 -mm tree
Message-ID: <20210109002539.ZPYcSP5ag%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: prefer ftrace over function entry/exit printks
has been added to the -mm tree.  Its filename is
     checkpatch-prefer-ftrace-over-function-entry-exit-printks.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-prefer-ftrace-over-function-entry-exit-printks.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-prefer-ftrace-over-function-entry-exit-printks.patch

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
Subject: checkpatch: prefer ftrace over function entry/exit printks

Prefer using ftrace over function entry/exit logging messages.

Warn with various function entry/exit only logging that only
use __func__ with or without descriptive decoration.

Link: https://lkml.kernel.org/r/47c01081533a417c99c9a80a4cd537f8c308503f.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-prefer-ftrace-over-function-entry-exit-printks
+++ a/scripts/checkpatch.pl
@@ -507,6 +507,30 @@ our $signature_tags = qr{(?xi:
 	Cc:
 )};
 
+our $tracing_logging_tags = qr{(?xi:
+	[=-]*> |
+	<[=-]* |
+	\[ |
+	\] |
+	start |
+	called |
+	entered |
+	entry |
+	enter |
+	in |
+	inside |
+	here |
+	begin |
+	exit |
+	end |
+	done |
+	leave |
+	completed |
+	out |
+	return |
+	[\.\!:\s]*
+)};
+
 sub edit_distance_min {
 	my (@arr) = @_;
 	my $len = scalar @arr;
@@ -5981,6 +6005,17 @@ sub process {
 			     "Prefer using '\"%s...\", __func__' to using '$context_function', this function's name, in a string\n" . $herecurr);
 		}
 
+# check for unnecessary function tracing like uses
+# This does not use $logFunctions because there are many instances like
+# 'dprintk(FOO, "%s()\n", __func__);' which do not match $logFunctions
+		if ($rawline =~ /^\+.*\([^"]*"$tracing_logging_tags{0,3}%s(?:\s*\(\s*\)\s*)?$tracing_logging_tags{0,3}(?:\\n)?"\s*,\s*__func__\s*\)\s*;/) {
+			if (WARN("TRACING_LOGGING",
+				 "Unnecessary ftrace-like logging - prefer using ftrace\n" . $herecurr) &&
+			    $fix) {
+                                fix_delete_line($fixlinenr, $rawline);
+			}
+		}
+
 # check for spaces before a quoted newline
 		if ($rawline =~ /^.*\".*\s\\n/) {
 			if (WARN("QUOTED_WHITESPACE_BEFORE_NEWLINE",
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-improve-blank-line-after-declaration-test.patch
checkpatch-prefer-ftrace-over-function-entry-exit-printks.patch

