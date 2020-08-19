Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85A71C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 01:31:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DD3520657
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 01:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597800709;
	bh=EfhyArrBu7Q8UxjcwrjcdD94K8HQoK8aMsfFukDTW9E=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ijQXbUKbomOJsxZgvmCWYfLbYIIU0mNGlG7DJbHVinKS3qMZOztV3BxaxYztWmSkK
	 +BtX3xnM33NonBAdltAi6q4y8DghjY6rAsCL3PhlV7Qb7c4OsW0H5ysm0es8mMKmsY
	 a6oAKkWegPrHvaUHuPYxYfhHCJZo+G5jgwtcoB1Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgHSBbs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 21:31:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:40624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726367AbgHSBbr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 21:31:47 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90CF020657;
        Wed, 19 Aug 2020 01:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597800706;
        bh=EfhyArrBu7Q8UxjcwrjcdD94K8HQoK8aMsfFukDTW9E=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gjcxnZ09gbuxDlojK1suoNaYm2x1+D7sSME4oLZ8EltZ+uUPESn0P4TS2BifwkQ2U
         /21kP59nP4jkxLk3Q+ReUufXP2C5OwE5MYkjoHT9OoU48DTvYq7wg3kJwT6o1PllIv
         1QhwS/ClNXrtNKlyN+/clkRD8ajkTvrj6NzpeczI=
Date:   Tue, 18 Aug 2020 18:31:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     jerome@forissier.org, joe@perches.com, mm-commits@vger.kernel.org
Subject:  + checkpatch-add-kconfig-prefix.patch added to -mm tree
Message-ID: <20200819013146.MXnzC_D0E%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add --kconfig-prefix
has been added to the -mm tree.  Its filename is
     checkpatch-add-kconfig-prefix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-kconfig-prefix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-kconfig-prefix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jerome Forissier <jerome@forissier.org>
Subject: checkpatch: add --kconfig-prefix

Kconfig allows to customize the CONFIG_ prefix via the $CONFIG_
environment variable.  Out-of-tree projects may therefore use Kconfig with
a different prefix, or they may use a custom configuration tool which does
not use the CONFIG_ prefix at all.  Such projects may still want to adhere
to the Linux kernel coding style and run checkpatch.pl.

One example is OP-TEE [1] which does not use Kconfig but does have
configuration options prefixed with CFG_.  It also mostly follows the
kernel coding style and therefore being able to use checkpatch is quite
valuable.

To make this possible, add the --kconfig-prefix command line option.

[1] https://github.com/OP-TEE/optee_os

Link: http://lkml.kernel.org/r/20200818081732.800449-1-jerome@forissier.org
Signed-off-by: Jerome Forissier <jerome@forissier.org>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-add-kconfig-prefix
+++ a/scripts/checkpatch.pl
@@ -67,6 +67,7 @@ my $allow_c99_comments = 1; # Can be ove
 # git output parsing needs US English output, so first set backtick child process LANGUAGE
 my $git_command ='export LANGUAGE=en_US.UTF-8; git';
 my $tabsize = 8;
+my ${CONFIG_} = "CONFIG_";
 
 sub help {
 	my ($exitcode) = @_;
@@ -129,6 +130,8 @@ Options:
   --typedefsfile             Read additional types from this file
   --color[=WHEN]             Use colors 'always', 'never', or only when output
                              is a terminal ('auto'). Default is 'auto'.
+  --kconfig-prefix=WORD      use WORD as a prefix for Kconfig symbols (default
+                             ${CONFIG_})
   -h, --help, --version      display this help and exit
 
 When FILE is - read standard input.
@@ -237,6 +240,7 @@ GetOptions(
 	'color=s'	=> \$color,
 	'no-color'	=> \$color,	#keep old behaviors of -nocolor
 	'nocolor'	=> \$color,	#keep old behaviors of -nocolor
+	'kconfig-prefix=s'	=> \${CONFIG_},
 	'h|help'	=> \$help,
 	'version'	=> \$help
 ) or help(1);
@@ -6526,16 +6530,16 @@ sub process {
 		}
 
 # check for IS_ENABLED() without CONFIG_<FOO> ($rawline for comments too)
-		if ($rawline =~ /\bIS_ENABLED\s*\(\s*(\w+)\s*\)/ && $1 !~ /^CONFIG_/) {
+		if ($rawline =~ /\bIS_ENABLED\s*\(\s*(\w+)\s*\)/ && $1 !~ /^${CONFIG_}/) {
 			WARN("IS_ENABLED_CONFIG",
-			     "IS_ENABLED($1) is normally used as IS_ENABLED(CONFIG_$1)\n" . $herecurr);
+			     "IS_ENABLED($1) is normally used as IS_ENABLED(${CONFIG_}$1)\n" . $herecurr);
 		}
 
 # check for #if defined CONFIG_<FOO> || defined CONFIG_<FOO>_MODULE
-		if ($line =~ /^\+\s*#\s*if\s+defined(?:\s*\(?\s*|\s+)(CONFIG_[A-Z_]+)\s*\)?\s*\|\|\s*defined(?:\s*\(?\s*|\s+)\1_MODULE\s*\)?\s*$/) {
+		if ($line =~ /^\+\s*#\s*if\s+defined(?:\s*\(?\s*|\s+)(${CONFIG_}[A-Z_]+)\s*\)?\s*\|\|\s*defined(?:\s*\(?\s*|\s+)\1_MODULE\s*\)?\s*$/) {
 			my $config = $1;
 			if (WARN("PREFER_IS_ENABLED",
-				 "Prefer IS_ENABLED(<FOO>) to CONFIG_<FOO> || CONFIG_<FOO>_MODULE\n" . $herecurr) &&
+				 "Prefer IS_ENABLED(<FOO>) to ${CONFIG_}<FOO> || ${CONFIG_}<FOO>_MODULE\n" . $herecurr) &&
 			    $fix) {
 				$fixed[$fixlinenr] = "\+#if IS_ENABLED($config)";
 			}
_

Patches currently in -mm which might be from jerome@forissier.org are

checkpatch-add-kconfig-prefix.patch

