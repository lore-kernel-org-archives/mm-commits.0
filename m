Return-Path: <SRS0=BOB0=CX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A38EAC433E2
	for <mm-commits@archiver.kernel.org>; Mon, 14 Sep 2020 01:23:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 659EE217BA
	for <mm-commits@archiver.kernel.org>; Mon, 14 Sep 2020 01:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600046614;
	bh=vS0OdgeSXevNnbxRDTmNIQglfEDwFyAQ1YLsvr/qJ8o=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=YUSSZMBgQMGoE2xjpm3l/XP6LhjxXlBR5pO8eUh948Stekr3YyxvFTLsD6B//boFR
	 c2yJRMc4mjvgqdRCki7wEmRF6aGSIo4gVYorN4Eon7mvi4VTxL9LbaQZH0NXyPm1sF
	 MLRujRAsS2NDGTJN/gdew2Rh+qtOcIBoLHVN8Ylc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgINBXd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 13 Sep 2020 21:23:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgINBXc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 13 Sep 2020 21:23:32 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 914D6217BA;
        Mon, 14 Sep 2020 01:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600046609;
        bh=vS0OdgeSXevNnbxRDTmNIQglfEDwFyAQ1YLsvr/qJ8o=;
        h=Date:From:To:Subject:From;
        b=dSPF1vKvPrE/3i/zRA3UOKHvud6V9SsT0jnO2zauNUiZ92rw2ZGZPNHKffd8EklqR
         w7XwCmYiU4flMNy64xEwrJhWygzFhTy9GvgC/tKtruTaTuWMXmSOsv/7ksnrzivzTA
         2ya8vmDdh7NHggD+Gtkrbe9BWkIwEyHwL85ygoCU=
Date:   Sun, 13 Sep 2020 18:23:29 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, linux@rasmusvillemoes.dk,
        joe@perches.com
Subject:  +
 checkpatch-allow-not-using-f-with-files-that-are-in-git.patch added to -mm
 tree
Message-ID: <20200914012329.HrAUa%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: allow not using -f with files that are in git
has been added to the -mm tree.  Its filename is
     checkpatch-allow-not-using-f-with-files-that-are-in-git.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-allow-not-using-f-with-files-that-are-in-git.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-allow-not-using-f-with-files-that-are-in-git.patch

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
Subject: checkpatch: allow not using -f with files that are in git

If a file exists in git and checkpatch is used without the -f flag for
scanning a file, then checkpatch will scan the file assuming it's a patch
and emit:

ERROR: Does not appear to be a unified-diff format patch

Change the behavior to assume the -f flag if the file exists in git.

Link: https://lkml.kernel.org/r/45b81a48e1568bd0126a96f5046eb7aaae9b83c9.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-allow-not-using-f-with-files-that-are-in-git
+++ a/scripts/checkpatch.pl
@@ -976,6 +976,16 @@ sub seed_camelcase_includes {
 	}
 }
 
+sub git_is_single_file {
+	my ($filename) = @_;
+
+	return 0 if ((which("git") eq "") || !(-e "$gitroot"));
+
+	my $output = `${git_command} ls-files -- $filename`;
+	my $count = $output =~ tr/\n//;
+	return $count eq 1 && $output =~ m{^${filename}$};
+}
+
 sub git_commit_info {
 	my ($commit, $id, $desc) = @_;
 
@@ -1049,6 +1059,9 @@ my $vname;
 $allow_c99_comments = !defined $ignore_type{"C99_COMMENT_TOLERANCE"};
 for my $filename (@ARGV) {
 	my $FILE;
+	my $is_git_file = git_is_single_file($filename);
+	my $oldfile = $file;
+	$file = 1 if ($is_git_file);
 	if ($git) {
 		open($FILE, '-|', "git format-patch -M --stdout -1 $filename") ||
 			die "$P: $filename: git format-patch failed - $!\n";
@@ -1093,6 +1106,7 @@ for my $filename (@ARGV) {
 	@modifierListFile = ();
 	@typeListFile = ();
 	build_types();
+	$file = $oldfile if ($is_git_file);
 }
 
 if (!$quiet) {
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-test-git_dir-changes.patch
get_maintainer-add-test-for-file-in-vcs.patch
get_maintainer-exclude-maintainers-files-from-git-fallback.patch
checkpatch-move-repeated-word-test.patch
checkpatch-add-test-for-comma-use-that-should-be-semicolon.patch
checkpatch-warn-on-self-assignments.patch
checkpatch-allow-not-using-f-with-files-that-are-in-git.patch

