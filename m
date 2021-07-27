Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 037A9C4320E
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 21:10:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEB3060FC0
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 21:10:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232456AbhG0VKC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 27 Jul 2021 17:10:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235897AbhG0VJ7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 27 Jul 2021 17:09:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8002760F94;
        Tue, 27 Jul 2021 21:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627420198;
        bh=adciA0T+3Gq1BYsrppbuMaNotf+JdbLXjuE3JM7GPdI=;
        h=Date:From:To:Subject:From;
        b=pHbyEQdKSPNB2jnALlbvydqMSeTLYrljIPimVNe5/xo21Xg3mtazLYFSwnWbq5HSK
         lrzEFTmuu7HsUh/FyBtl0XB20JP6qxtdTkNEpRZmKpQt813fVUG652coO/RVvger0S
         wPYZDa0d0F4Ov3Tt1RKhDDjzGV07wUGZkAHeISho=
Date:   Tue, 27 Jul 2021 14:09:58 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, masahiroy@kernel.org,
        rdunlap@infradead.org
Subject:  +
 scripts-checkversion-modernize-linux-versionh-search-strings.patch added to
 -mm tree
Message-ID: <20210727210958.ZRVOi%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts: checkversion: modernize linux/version.h search strings
has been added to the -mm tree.  Its filename is
     scripts-checkversion-modernize-linux-versionh-search-strings.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scripts-checkversion-modernize-linux-versionh-search-strings.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scripts-checkversion-modernize-linux-versionh-search-strings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: scripts: checkversion: modernize linux/version.h search strings

Update scripts/checkversion.pl to recognize the current contents
of <linux/version.h> and both of its current locations.

Also update my email address.

Link: https://lkml.kernel.org/r/20210727025737.30553-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkversion.pl |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/scripts/checkversion.pl~scripts-checkversion-modernize-linux-versionh-search-strings
+++ a/scripts/checkversion.pl
@@ -1,10 +1,10 @@
 #! /usr/bin/env perl
 # SPDX-License-Identifier: GPL-2.0
 #
-# checkversion find uses of LINUX_VERSION_CODE or KERNEL_VERSION
-# without including <linux/version.h>, or cases of
-# including <linux/version.h> that don't need it.
-# Copyright (C) 2003, Randy Dunlap <rdunlap@xenotime.net>
+# checkversion finds uses of all macros in <linux/version.h>
+# where the source files do not #include <linux/version.h>; or cases
+# of including <linux/version.h> where it is not needed.
+# Copyright (C) 2003, Randy Dunlap <rdunlap@infradead.org>
 
 use strict;
 
@@ -13,7 +13,8 @@ $| = 1;
 my $debugging;
 
 foreach my $file (@ARGV) {
-    next if $file =~ "include/linux/version\.h";
+    next if $file =~ "include/generated/uapi/linux/version\.h";
+    next if $file =~ "usr/include/linux/version\.h";
     # Open this file.
     open( my $f, '<', $file )
       or die "Can't open $file: $!\n";
@@ -41,8 +42,11 @@ foreach my $file (@ARGV) {
 	    $iLinuxVersion      = $. if m/^\s*#\s*include\s*<linux\/version\.h>/o;
 	}
 
-	# Look for uses: LINUX_VERSION_CODE, KERNEL_VERSION, UTS_RELEASE
-	if (($_ =~ /LINUX_VERSION_CODE/) || ($_ =~ /\WKERNEL_VERSION/)) {
+	# Look for uses: LINUX_VERSION_CODE, KERNEL_VERSION,
+	# LINUX_VERSION_MAJOR, LINUX_VERSION_PATCHLEVEL, LINUX_VERSION_SUBLEVEL
+	if (($_ =~ /LINUX_VERSION_CODE/) || ($_ =~ /\WKERNEL_VERSION/) ||
+	    ($_ =~ /LINUX_VERSION_MAJOR/) || ($_ =~ /LINUX_VERSION_PATCHLEVEL/) ||
+	    ($_ =~ /LINUX_VERSION_SUBLEVEL/)) {
 	    $fUseVersion = 1;
             last if $iLinuxVersion;
         }
_

Patches currently in -mm which might be from rdunlap@infradead.org are

scripts-check_extable-fix-typo-in-user-error-message.patch
scripts-checkversion-modernize-linux-versionh-search-strings.patch

