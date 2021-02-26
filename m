Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10530C433DB
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9AE564F17
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhBZBXS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:23:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:53634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230081AbhBZBWi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:22:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6971464F41;
        Fri, 26 Feb 2021 01:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302511;
        bh=FfuTJGlO127o8DalZNUFdfrDB3uGY44TJCV+vmc/VNM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=plkV+/LrTNQf4zy5NPxay8oX6WLuq1XRq/DiOMIGHnwXTR5KUONeOTcSK3IrR4DE1
         tVYfeMPbTnzoj7DpArD16jNMUVCbuPBoyartrZp0YH0t5jbQMm613ledRlBUUhfHUN
         KbbLooxZt1HitYD1Ip/Ynq2nONZBslUoXHWXAN/U=
Date:   Thu, 25 Feb 2021 17:21:50 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.carpenter@oracle.com,
        gregkh@linuxfoundation.org, joe@perches.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 102/118] checkpatch: prefer ftrace over function
 entry/exit printks
Message-ID: <20210226012150.BM2udiq4_%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -5972,6 +5996,17 @@ sub process {
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
