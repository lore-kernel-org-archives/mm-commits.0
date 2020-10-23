Return-Path: <SRS0=9dK4=D6=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07732C388F9
	for <mm-commits@archiver.kernel.org>; Fri, 23 Oct 2020 01:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0967223BF
	for <mm-commits@archiver.kernel.org>; Fri, 23 Oct 2020 01:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603415246;
	bh=vcct/9C4pn4LNQGFBVpexmEhIK2XQwS49Tm2UVF2314=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=nAox/FzpZxdlwHB+lD+q4pY45u3MilhfQCqX/8kw+4zT4ZskD+KsDZoBbN30t0ix9
	 C6WbyNIa4WMdNC7s19GbNnqrzOHyJBLw+v3uHP/D0XOLPea4nG3atggDjwrjm8RMkP
	 EJ7ZSv9D+DU5OMOvsxJaX3W3D/vvuxTwQZUT5JC4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369051AbgJWBH0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Oct 2020 21:07:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S368914AbgJWBH0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Oct 2020 21:07:26 -0400
Received: from X1 (216-169-68-50.scinternet.net [216.169.68.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFA5220760;
        Fri, 23 Oct 2020 01:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603415245;
        bh=vcct/9C4pn4LNQGFBVpexmEhIK2XQwS49Tm2UVF2314=;
        h=Date:From:To:Subject:From;
        b=UMU6C82c+5gYGVdS3aOAg8TCCOxpXt6YpkSydIJoT9YiEF68JWgtHr3dzQOD9mxsQ
         mXgdDyWYB9VgJiYPw2pVGBb8y15+236X4mNB/8RKjcBil3sxThehCmcPCpYnq588nT
         Mwc86okUivN+bUDLwelpq8prtJwYC/OJO522t5k0=
Date:   Thu, 22 Oct 2020 18:07:15 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, joe@perches.com
Subject:  +
 checkpatch-enable-git_dir-environment-use-to-set-git-repository-location.patch
 added to -mm tree
Message-ID: <20201023010715.XQIT1%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: enable GIT_DIR environment use to set git repository location
has been added to the -mm tree.  Its filename is
     checkpatch-enable-git_dir-environment-use-to-set-git-repository-location.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-enable-git_dir-environment-use-to-set-git-repository-location.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-enable-git_dir-environment-use-to-set-git-repository-location.patch

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
Subject: checkpatch: enable GIT_DIR environment use to set git repository location

If set, use the environment variable GIT_DIR to change the default .git
location of the kernel git tree.

If GIT_DIR is unset, keep using the current ".git" default.

Link: https://lkml.kernel.org/r/95f9ca20c9c7efe5d40d38e2dd60487e66df43f2.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.co>
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

Patches currently in -mm which might be from joe@perches.com are

checkpatch-enable-git_dir-environment-use-to-set-git-repository-location.patch
checkpatch-test-git_dir-changes.patch

