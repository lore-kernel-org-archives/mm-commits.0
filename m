Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D499CC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78248216C4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881633;
	bh=VsOqVrQcDRgFeVMmYWbMumOErir/v/hWixYbowKEHTY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=meHkRCRIscr3eVNH94YcKRmAU9pbl0T4aeFf4GBuJt31u83YKrmJ1wLLBPYwdeSDv
	 hNaK6EHoGP7ZG/wQAbIbvw2Njs9Ck+36WzNaEpljK6R2OnLXp63meusfyiemjjwadQ
	 k0ZZByYH8UAVh8sL6imSxiLooYCrnhaOtJqXog3M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409216AbgJPUxx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:53:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409148AbgJPUxp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:53:45 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADE412076C;
        Fri, 16 Oct 2020 20:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881624;
        bh=VsOqVrQcDRgFeVMmYWbMumOErir/v/hWixYbowKEHTY=;
        h=Date:From:To:Subject:From;
        b=VMSYyCcjhEiMRAYJoyTT7uIsCA32kB3g7yEi6b7wP3K+EHDHJRix7HW3oUI41QcQD
         VyucPWZ6VrRCHo12tt7yNSMbQ1r0tBnt9hlTJrUD5dnBTJXVBT+ACgAQRup9SnHSj5
         T2crViIJB+DJgRs/Oo6YsyjsAz6c78tQ2/PFGfvY=
Date:   Fri, 16 Oct 2020 13:53:44 -0700
From:   akpm@linux-foundation.org
To:     jerome@forissier.org, joe@perches.com, mm-commits@vger.kernel.org
Subject:  [merged] checkpatch-add-kconfig-prefix.patch removed from
 -mm tree
Message-ID: <20201016205344.HPxnsdG56%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add --kconfig-prefix
has been removed from the -mm tree.  Its filename was
     checkpatch-add-kconfig-prefix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -65,6 +65,7 @@ my $allow_c99_comments = 1; # Can be ove
 # git output parsing needs US English output, so first set backtick child process LANGUAGE
 my $git_command ='export LANGUAGE=en_US.UTF-8; git';
 my $tabsize = 8;
+my ${CONFIG_} = "CONFIG_";
 
 sub help {
 	my ($exitcode) = @_;
@@ -127,6 +128,8 @@ Options:
   --typedefsfile             Read additional types from this file
   --color[=WHEN]             Use colors 'always', 'never', or only when output
                              is a terminal ('auto'). Default is 'auto'.
+  --kconfig-prefix=WORD      use WORD as a prefix for Kconfig symbols (default
+                             ${CONFIG_})
   -h, --help, --version      display this help and exit
 
 When FILE is - read standard input.
@@ -235,6 +238,7 @@ GetOptions(
 	'color=s'	=> \$color,
 	'no-color'	=> \$color,	#keep old behaviors of -nocolor
 	'nocolor'	=> \$color,	#keep old behaviors of -nocolor
+	'kconfig-prefix=s'	=> \${CONFIG_},
 	'h|help'	=> \$help,
 	'version'	=> \$help
 ) or help(1);
@@ -6524,16 +6528,16 @@ sub process {
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


