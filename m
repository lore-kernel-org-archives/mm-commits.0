Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D153C433ED
	for <mm-commits@archiver.kernel.org>; Fri,  2 Apr 2021 00:27:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6B20610E9
	for <mm-commits@archiver.kernel.org>; Fri,  2 Apr 2021 00:27:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236345AbhDBA11 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Apr 2021 20:27:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233677AbhDBA10 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 1 Apr 2021 20:27:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01AB461132;
        Fri,  2 Apr 2021 00:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617323245;
        bh=JaHlRgyfCzdGGy+4Hv0e7EY6+AkXhPH12pRNPQCfNpk=;
        h=Date:From:To:Subject:From;
        b=acnMmm9u0sOjdQDEjZqUu5xd23tlNp98rxgQLEqbLeLl7dvmKWxgUCvrVcYu7n9+e
         KwcD2nuiRXuBrLoeblWNdsKv43g67Jfiu9rfVxF6rOqE4zTXxOZnwbNeoDMSlLHEkz
         DnP1Oj1n6edapUEayyNy57il2DXL0UHMgDKuo8so=
Date:   Thu, 01 Apr 2021 17:27:24 -0700
From:   akpm@linux-foundation.org
To:     joe@perches.com, masahiroy@kernel.org, mm-commits@vger.kernel.org,
        wanjiabing@vivo.com
Subject:  +
 scripts-a-new-script-for-checking-duplicate-struct-declaration.patch added
 to -mm tree
Message-ID: <20210402002724.2GVV7u4ea%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts: a new script for checking duplicate struct declaration
has been added to the -mm tree.  Its filename is
     scripts-a-new-script-for-checking-duplicate-struct-declaration.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scripts-a-new-script-for-checking-duplicate-struct-declaration.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scripts-a-new-script-for-checking-duplicate-struct-declaration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wan Jiabing <wanjiabing@vivo.com>
Subject: scripts: a new script for checking duplicate struct declaration

checkdeclares: find struct declared more than once.  Inspired by
checkincludes.pl.

This script checks for duplicate struct declares.  Note that this will not
take into consideration macros, so you should run this only if you know
you do have real dups and do not have them under #ifdef's.  You could also
just review the results.

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
+	print "Usage: checkdeclares.pl \n";
+	print "We just warn of struct declaration duplicates\n";
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

scripts-a-new-script-for-checking-duplicate-struct-declaration.patch
linux-memcontrolh-remove-duplicate-struct-declaration.patch

