Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B96C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:53:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CE15613F8
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:53:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbhD3Fyp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:54:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230291AbhD3Fyp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:54:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A3346144F;
        Fri, 30 Apr 2021 05:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762037;
        bh=7ipukFohT+ra6QA/EaiiYzPdV5X9teQHURTzpStAEi4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yEN0Z1PY1Kqm/rFYaZiNF4oH0kH/J7kg+Dov6f1Gy5awK+wCuwG55iLOqtgyzXhHK
         u9+krRP3yEuPGeKhXN6bJAjNfMvIsxV3mXdE/+wvjgDOEXDiZbYrJQ5a+E1FbklJIY
         qW/XgxjDnpXTlqbPXeFryt1e4VLm1MAFAGmOOCqg=
Date:   Thu, 29 Apr 2021 22:53:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com, linux-mm@kvack.org,
        masahiroy@kernel.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, wanjiabing@vivo.com
Subject:  [patch 014/178] scripts: a new script for checking
 duplicate struct declaration
Message-ID: <20210430055356.ue1uHp3v6%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Wan Jiabing <wanjiabing@vivo.com>
Subject: scripts: a new script for checking duplicate struct declaration

checkdeclares: find struct declared more than once.  Inspired by
checkincludes.pl.

This script checks for duplicate struct declares.  Note that this will not
take into consideration macros, so you should run this only if you know
you do have real dups and do not have them under #ifdef's.  You could also
just review the results.

[akpm@linux-foundation.org: fix usage message, grammar]
Link: https://lkml.kernel.org/r/20210401110943.1010796-1-wanjiabing@vivo.com
Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkdeclares.pl |   53 +++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

--- /dev/null
+++ a/scripts/checkdeclares.pl
@@ -0,0 +1,53 @@
+#!/usr/bin/env perl
+# SPDX-License-Identifier: GPL-2.0
+#
+# checkdeclares: find struct declared more than once
+#
+# Copyright 2021 Wan Jiabing<wanjiabing@vivo.com>
+# Inspired by checkincludes.pl
+#
+# This script checks for duplicate struct declares.
+# Note that this will not take into consideration macros so
+# you should run this only if you know you do have real dups
+# and do not have them under #ifdef's.
+# You could also just review the results.
+
+use strict;
+
+sub usage {
+	print "Usage: checkdeclares.pl file1.h ...\n";
+	print "Warns of struct declaration duplicates\n";
+	exit 1;
+}
+
+if ($#ARGV < 0) {
+	usage();
+}
+
+my $dup_counter = 0;
+
+foreach my $file (@ARGV) {
+	open(my $f, '<', $file)
+	    or die "Cannot open $file: $!.\n";
+
+	my %declaredstructs = ();
+
+	while (<$f>) {
+		if (m/^\s*struct\s*(\w*);$/o) {
+			++$declaredstructs{$1};
+		}
+	}
+
+	close($f);
+
+	foreach my $structname (keys %declaredstructs) {
+		if ($declaredstructs{$structname} > 1) {
+			print "$file: struct $structname is declared more than once.\n";
+			++$dup_counter;
+		}
+	}
+}
+
+if ($dup_counter == 0) {
+	print "No duplicate struct declares found.\n";
+}
_
