Return-Path: <SRS0=lzHQ=BG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE3F8C43461
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 20:53:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB79722CB3
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 20:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595883181;
	bh=syfdimmeMgmZ9oIVe7F0MhaSsLZ75vxi9RGAsfALHeE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=zQYS9QKtK/MQshSINPa3GlGPgQTibFrQcMXKRM7PKFDKHg+wx68wj3ofIiSCsRXsI
	 flhAO4aUtvtPXXQ+9HE4lCovpqjVpMdfiRyF6kz9gRJ9nD8DitMPOdAMpEwzowWeAN
	 Ta+YpGJmCH/gpOKM5Y5lUZa579DrpSvpRYaDEmYg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgG0Uw4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Jul 2020 16:52:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726676AbgG0Uwz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Jul 2020 16:52:55 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA4CB22CA0;
        Mon, 27 Jul 2020 20:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595883174;
        bh=syfdimmeMgmZ9oIVe7F0MhaSsLZ75vxi9RGAsfALHeE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=NK/JmHFyPXrYB+XlPhroTivfI2uMjiZUVxRLHC8vewFPWkwvHdW/C/8tD7x2sM6qC
         pUCZzE/GlwEZbNV2mojNldfHoZRNrh3dlsb6gqX3rOG3aDJt40PV+hskqnGr+umdIL
         PPXbFLEYpc4EJEmH3xAIsKwcxTMbK6QplpiXcOqw=
Date:   Mon, 27 Jul 2020 13:52:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     colin.king@canonical.com, jslaby@suse.cz,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        sj38.park@gmail.com, sjpark@amazon.de
Subject:  [withdrawn]
 checkpatch-support-deprecated-terms-checking.patch removed from -mm tree
Message-ID: <20200727205253.YoNX2lRBF%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: support deprecated terms checking
has been removed from the -mm tree.  Its filename was
     checkpatch-support-deprecated-terms-checking.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: SeongJae Park <sjpark@amazon.de>
Subject: checkpatch: support deprecated terms checking

Patch series "Recommend denylist/allowlist instead of blacklist/whitelist:, v4.

This patchset 1) adds support of deprecated terms in the 'checkpatch.pl'
and 2) set the 'blacklist' and 'whitelist' as deprecated with replacement
suggestion of 'denylist' and 'allowlist', because the suggestions are
incontrovertible, doesn't make people hurt, and more self-explanatory.


This patch (of 2):

Some terms could be deprecated for various reasons, but it is hard to
update the entire old usages.  That said, we could at least encourage new
patches to use the suggested replacements.  This commit adds check of
deprecated terms in the 'checkpatch.pl' for that.  The script will get
deprecated terms and suggested replacements of those from
'scripts/deprecated_terms.txt' file and warn if the deprecated terms are
used.  The mechanism and the format of the file are almost the same as
that of 'spelling.txt'.  For the reason, this commit modularizes the read
of the 'spelling.txt' and reuses.

Link: http://lkml.kernel.org/r/20200611062550.20113-1-sjpark@amazon.com
Link: http://lkml.kernel.org/r/20200611062550.20113-2-sjpark@amazon.com
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: SeongJae Park <sj38.park@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl        |   60 ++++++++++++++++++++++++---------
 scripts/deprecated_terms.txt |    5 ++
 2 files changed, 50 insertions(+), 15 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-support-deprecated-terms-checking
+++ a/scripts/checkpatch.pl
@@ -57,6 +57,7 @@ my $max_line_length = 100;
 my $ignore_perl_version = 0;
 my $minimum_perl_version = 5.10.0;
 my $min_conf_desc_length = 4;
+my $deprecated_terms_file = "$D/deprecated_terms.txt";
 my $spelling_file = "$D/spelling.txt";
 my $codespell = 0;
 my $codespellfile = "/usr/share/codespell/dictionary.txt";
@@ -692,29 +693,40 @@ our $allowed_asm_includes = qr{(?x:
 )};
 # memory.h: ARM has a custom one
 
-# Load common spelling mistakes and build regular expression list.
-my $misspellings;
-my %spelling_fix;
+sub read_word_corrections {
+	my ($file, $fixesRef) = @_;
+	my $suspects;
 
-if (open(my $spelling, '<', $spelling_file)) {
-	while (<$spelling>) {
-		my $line = $_;
+	if (open(my $corrections, '<', $file)) {
+		while (<$corrections>) {
+			my $line = $_;
 
-		$line =~ s/\s*\n?$//g;
-		$line =~ s/^\s*//g;
+			$line =~ s/\s*\n?$//g;
+			$line =~ s/^\s*//g;
 
-		next if ($line =~ m/^\s*#/);
-		next if ($line =~ m/^\s*$/);
+			next if ($line =~ m/^\s*#/);
+			next if ($line =~ m/^\s*$/);
 
-		my ($suspect, $fix) = split(/\|\|/, $line);
+			my ($suspect, $fix) = split(/\|\|/, $line);
 
-		$spelling_fix{$suspect} = $fix;
+			$fixesRef->{$suspect} = $fix;
+		}
+		close($corrections);
+	} else {
+		warn "No correction will be found - file '$file': $!\n";
 	}
-	close($spelling);
-} else {
-	warn "No typos will be found - file '$spelling_file': $!\n";
 }
 
+# Load deprecated terms and build regular expression list.
+my %deprecated_terms_fix;
+read_word_corrections($deprecated_terms_file, \%deprecated_terms_fix);
+my $deprecated_terms = join("|", sort keys %deprecated_terms_fix) if keys %deprecated_terms_fix;
+
+# Load common spelling mistakes and build regular expression list.
+my $misspellings;
+my %spelling_fix;
+read_word_corrections($spelling_file, \%spelling_fix);
+
 if ($codespell) {
 	if (open(my $spelling, '<', $codespellfile)) {
 		while (<$spelling>) {
@@ -2956,6 +2968,24 @@ sub process {
 				}
 			}
 		}
+
+# Check for deprecated terms
+		if (defined($deprecated_terms) &&
+		    ($in_commit_log || $line =~ /^(?:\+|Subject:)/i)) {
+			while ($rawline =~ /(?:^|[^a-z@])($deprecated_terms)(?:\b|$|[^a-z@])/gi) {
+				my $deprecated_term = $1;
+				my $suggested = $deprecated_terms_fix{lc($deprecated_term)};
+				$suggested = ucfirst($suggested) if ($deprecated_term=~ /^[A-Z]/);
+				$suggested = uc($suggested) if ($deprecated_term =~ /^[A-Z]+$/);
+				my $msg_level = \&WARN;
+				$msg_level = \&CHK if ($file);
+				if (&{$msg_level}("DEPRECATED_TERM",
+						  "Use of '$deprecated_term' is deprecated, please '$suggested', instead.\n" . $herecurr) &&
+				    $fix) {
+					$fixed[$fixlinenr] =~ s/(^|[^A-Za-z@])($deprecated_term)($|[^A-Za-z@])/$1$suggested$3/;
+				}
+			}
+		}
 
 # Check for various typo / spelling mistakes
 		if (defined($misspellings) &&
--- /dev/null
+++ a/scripts/deprecated_terms.txt
@@ -0,0 +1,5 @@
+# License: GPLv2
+#
+# The format of each line is:
+# deprecated||suggested
+#
_

Patches currently in -mm which might be from sjpark@amazon.de are

scripts-deprecated_terms-recommend-denylist-allowlist-instead-of-blacklist-whitelist.patch
scripts-deprecated_terms-sync-with-inclusive-terms.patch

