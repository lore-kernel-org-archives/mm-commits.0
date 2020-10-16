Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B3B5C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:54:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1854421D41
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881647;
	bh=m9NeUaHTblYmRMcFbGMCToWgIzsjTTe8nV9/GYjbBBM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=tgBgeBnj4XiH3ixHjZul/kIDElJtURNW/vzN5POZeiDGp4mnjrBm2DOPQ1MI6Kr+/
	 kCyDVOxSMoXjaPJsMsyvhfyq0rFQJTk3J8gFOraAaJf7hGzK7miAEi4MkiMBb64f7W
	 7FuZ/G5Twq/AkwoAuTSqqiVcpLhU/ri1KItWVIgc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409219AbgJPUyG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:54:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:42024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409202AbgJPUyG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:54:06 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96337218AC;
        Fri, 16 Oct 2020 20:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881645;
        bh=m9NeUaHTblYmRMcFbGMCToWgIzsjTTe8nV9/GYjbBBM=;
        h=Date:From:To:Subject:From;
        b=W7wsYj3rGIPO5/tSyUHPUJWEpUVRK1RtxslawBIr6Oprox7IquYiE0SSYrafXi+l8
         91KSeLjN4wxpGjCFDXfQ3AMsanD15IyW575/KdYmW3YsXfTQ7f33rHmlrsOOrLfKIR
         D0pRwI5f/bRJ69Cnjy1s3e7A9N06Ifho46pIiqCE=
Date:   Fri, 16 Oct 2020 13:54:05 -0700
From:   akpm@linux-foundation.org
To:     joe@perches.com, julia.lawall@inria.fr, linux@rasmusvillemoes.dk,
        mm-commits@vger.kernel.org
Subject:  [merged]
 checkpatch-allow-not-using-f-with-files-that-are-in-git.patch removed from
 -mm tree
Message-ID: <20201016205405.m0NUOJYKD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: allow not using -f with files that are in git
has been removed from the -mm tree.  Its filename was
     checkpatch-allow-not-using-f-with-files-that-are-in-git.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: allow not using -f with files that are in git

If a file exists in git and checkpatch is used without the -f flag for
scanning a file, then checkpatch will scan the file assuming it's a patch
and emit:

ERROR: Does not appear to be a unified-diff format patch

Change the behavior to assume the -f flag if the file exists in git.

[joe@perches.com: fix git "fatal" warning if file argument outside kernel tree]
  Link: https://lkml.kernel.org/r/b6afa04112d450c2fc120a308d706acd60cee294.camel@perches.com
Link: https://lkml.kernel.org/r/45b81a48e1568bd0126a96f5046eb7aaae9b83c9.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Julia Lawall <julia.lawall@inria.fr>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-allow-not-using-f-with-files-that-are-in-git
+++ a/scripts/checkpatch.pl
@@ -974,6 +974,16 @@ sub seed_camelcase_includes {
 	}
 }
 
+sub git_is_single_file {
+	my ($filename) = @_;
+
+	return 0 if ((which("git") eq "") || !(-e "$gitroot"));
+
+	my $output = `${git_command} ls-files -- $filename 2>/dev/null`;
+	my $count = $output =~ tr/\n//;
+	return $count eq 1 && $output =~ m{^${filename}$};
+}
+
 sub git_commit_info {
 	my ($commit, $id, $desc) = @_;
 
@@ -1047,6 +1057,9 @@ my $vname;
 $allow_c99_comments = !defined $ignore_type{"C99_COMMENT_TOLERANCE"};
 for my $filename (@ARGV) {
 	my $FILE;
+	my $is_git_file = git_is_single_file($filename);
+	my $oldfile = $file;
+	$file = 1 if ($is_git_file);
 	if ($git) {
 		open($FILE, '-|', "git format-patch -M --stdout -1 $filename") ||
 			die "$P: $filename: git format-patch failed - $!\n";
@@ -1091,6 +1104,7 @@ for my $filename (@ARGV) {
 	@modifierListFile = ();
 	@typeListFile = ();
 	build_types();
+	$file = $oldfile if ($is_git_file);
 }
 
 if (!$quiet) {
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-test-git_dir-changes.patch

