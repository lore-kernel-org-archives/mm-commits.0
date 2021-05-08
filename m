Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DD8CC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3142D6140E
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhEHWkZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:40:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229549AbhEHWkY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:40:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 947A761402;
        Sat,  8 May 2021 22:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513561;
        bh=b9jePucc+Vgxo3k6APG+zRZ4ns7IljP74Xu25hwnWoo=;
        h=Date:From:To:Subject:From;
        b=TomcFbV6ZT6HuORzNSfGSwhey98tjHKlltBxP1/Zvl8TYFMFott4zAg8MsMrQKlwL
         dn1F0dCSG2sxzESpcBXYsE4CQUeHGmkxUTtiUN43xtbYo+NqUODDLZmxBY6s3xaTlh
         9a5WYqHYQeoDTEfPvAPCSbhwmNbhoml9tjwQiY8w=
Date:   Sat, 08 May 2021 15:39:21 -0700
From:   akpm@linux-foundation.org
To:     joe@perches.com, masahiroy@kernel.org, mm-commits@vger.kernel.org,
        wanjiabing@vivo.com
Subject:  [merged]
 scripts-a-new-script-for-checking-duplicate-struct-declaration.patch
 removed from -mm tree
Message-ID: <20210508223921.O4J7vU2fW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts: a new script for checking duplicate struct declaration
has been removed from the -mm tree.  Its filename was
     scripts-a-new-script-for-checking-duplicate-struct-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from wanjiabing@vivo.com are


