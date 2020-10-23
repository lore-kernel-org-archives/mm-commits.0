Return-Path: <SRS0=9dK4=D6=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70307C388F7
	for <mm-commits@archiver.kernel.org>; Fri, 23 Oct 2020 01:27:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01E8421D43
	for <mm-commits@archiver.kernel.org>; Fri, 23 Oct 2020 01:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603416425;
	bh=vMOBIvjRPRfAiH3ZPQ+zvWr9vNAzLM2unM4/MQ3c86A=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=tkvlzxKuIntq6LKeqJOwzV40JIqufd/mpG//DDTmgVGsbcrGd5IrbU0yzEabIjF8w
	 0T7aDSWO+Drn6a7lKblUCO9TkvGQ9/yaFEHo72IezfbRhrzCFA36FxWxTSckfGDFsL
	 o3Qh/Gz98MgOqif5u0Q45LDwrBFeKX34YwOZ/HEE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374296AbgJWB1E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Oct 2020 21:27:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S374284AbgJWB1E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Oct 2020 21:27:04 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46F682177B;
        Fri, 23 Oct 2020 01:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603416423;
        bh=vMOBIvjRPRfAiH3ZPQ+zvWr9vNAzLM2unM4/MQ3c86A=;
        h=Date:From:To:Subject:From;
        b=kuIiPdj+WlG4VZ3YZoyUQ+qtQA+sLrjMUighZWa77+Mbm9d36d8iJyh/Q5UlpU7Lt
         WLEkK2cF1VLalmN3yeDYeidxX00fwcCokayeOneKZAGdV8C6Nyg0ouba5yyEV17Pwi
         k6MX/JsLdcwRsDSBmBSqQF0/1ia+r9sSH21BFCps=
Date:   Thu, 22 Oct 2020 18:27:02 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, geert@linux-m68k.org, joe@perches.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 1/1] checkpatch: enable GIT_DIR environment use to
 set git repository location
Message-ID: <20201023012702.VnYL5x_5l%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joe Perches <joe@perches.com>
Subject: checkpatch: enable GIT_DIR environment use to set git repository location

If set, use the environment variable GIT_DIR to change the default .git
location of the kernel git tree.

If GIT_DIR is unset, keep using the current ".git" default.

Link: https://lkml.kernel.org/r/c5e23b45562373d632fccb8bc04e563abba4dd1d.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-enable-git_dir-environment-use-to-set-git-repository-location
+++ a/scripts/checkpatch.pl
@@ -43,6 +43,8 @@ my $list_types = 0;
 my $fix = 0;
 my $fix_inplace = 0;
 my $root;
+my $gitroot = $ENV{'GIT_DIR'};
+$gitroot = ".git" if !defined($gitroot);
 my %debug;
 my %camelcase = ();
 my %use_type = ();
@@ -908,7 +910,7 @@ sub is_maintained_obsolete {
 sub is_SPDX_License_valid {
 	my ($license) = @_;
 
-	return 1 if (!$tree || which("python") eq "" || !(-e "$root/scripts/spdxcheck.py") || !(-e "$root/.git"));
+	return 1 if (!$tree || which("python") eq "" || !(-e "$root/scripts/spdxcheck.py") || !(-e "$gitroot"));
 
 	my $root_path = abs_path($root);
 	my $status = `cd "$root_path"; echo "$license" | python scripts/spdxcheck.py -`;
@@ -926,7 +928,7 @@ sub seed_camelcase_includes {
 
 	$camelcase_seeded = 1;
 
-	if (-e ".git") {
+	if (-e "$gitroot") {
 		my $git_last_include_commit = `${git_command} log --no-merges --pretty=format:"%h%n" -1 -- include`;
 		chomp $git_last_include_commit;
 		$camelcase_cache = ".checkpatch-camelcase.git.$git_last_include_commit";
@@ -954,7 +956,7 @@ sub seed_camelcase_includes {
 		return;
 	}
 
-	if (-e ".git") {
+	if (-e "$gitroot") {
 		$files = `${git_command} ls-files "include/*.h"`;
 		@include_files = split('\n', $files);
 	}
@@ -987,7 +989,7 @@ sub git_is_single_file {
 sub git_commit_info {
 	my ($commit, $id, $desc) = @_;
 
-	return ($id, $desc) if ((which("git") eq "") || !(-e ".git"));
+	return ($id, $desc) if ((which("git") eq "") || !(-e "$gitroot"));
 
 	my $output = `${git_command} log --no-color --format='%H %s' -1 $commit 2>&1`;
 	$output =~ s/^\s*//gm;
@@ -1026,7 +1028,7 @@ my $fixlinenr = -1;
 
 # If input is git commits, extract all commits from the commit expressions.
 # For example, HEAD-3 means we need check 'HEAD, HEAD~1, HEAD~2'.
-die "$P: No git repository found\n" if ($git && !-e ".git");
+die "$P: No git repository found\n" if ($git && !-e "$gitroot");
 
 if ($git) {
 	my @commits = ();
_
