Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E87FC433ED
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53FE2613C8
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:03:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234061AbhEGBEz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:04:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:45140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230499AbhEGBEz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:04:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F30E561289;
        Fri,  7 May 2021 01:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349436;
        bh=yNccgy6pq9qZzno8uinz34DjqBjAwW+ELqL//f2yANc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=TIUxSFg8ME/hyCtp6c8AUFxwYdL5zbqHPu8+lbaFRGuFr4HqPBfZdNKYMeTRAD1qS
         1ltdINq/RE/m4BAXqhex//QhR46QqDLC8xQJ6ylNwGEoC/7wRrPbpdfBfXF09qK7pJ
         Ep5oFLG2FTHPQ0p9MnjCbKS+XJ3s/ZmW+xlM686M=
Date:   Thu, 06 May 2021 18:03:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 36/91] checkpatch: warn when missing newline in
 return sysfs_emit() formats
Message-ID: <20210507010355.UoGRYeyIJ%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joe Perches <joe@perches.com>
Subject: checkpatch: warn when missing newline in return sysfs_emit() formats

return sysfs_emit() uses should include a newline.

Suggest adding a newline when one is missing.
Add one using --fix too.

Link: https://lkml.kernel.org/r/aa1819fa5faf786573df298e5e2e7d357ba7d4ad.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-warn-when-missing-newline-in-return-sysfs_emit-formats
+++ a/scripts/checkpatch.pl
@@ -7198,6 +7198,17 @@ sub process {
 			     "Using $1 should generally have parentheses around the comparison\n" . $herecurr);
 		}
 
+# return sysfs_emit(foo, fmt, ...) fmt without newline
+		if ($line =~ /\breturn\s+sysfs_emit\s*\(\s*$FuncArg\s*,\s*($String)/ &&
+		    substr($rawline, $-[6], $+[6] - $-[6]) !~ /\\n"$/) {
+			my $offset = $+[6] - 1;
+			if (WARN("SYSFS_EMIT",
+				 "return sysfs_emit(...) formats should include a terminating newline\n" . $herecurr) &&
+			    $fix) {
+				substr($fixed[$fixlinenr], $offset, 0) = '\\n';
+			}
+		}
+
 # nested likely/unlikely calls
 		if ($line =~ /\b(?:(?:un)?likely)\s*\(\s*!?\s*(IS_ERR(?:_OR_NULL|_VALUE)?|WARN)/) {
 			WARN("LIKELY_MISUSE",
_
