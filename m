Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8051459E2
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293220; cv=none; b=HAxOH9R1wpD1vgkyhmq5YcMRRnQ9z9LqboprBIFcoRtFM5Lns0bBE7gDIAeVc1My1L0vWh+IkVh//RHHrxfWA9+EZN9P9uVibxRpqmTsYeAwmVH8w5oeqKRUQdO95rMABjAkxE7udExskaIdd/9ADXsphn047du2FyTMy5wYx/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293220; c=relaxed/simple;
	bh=MoUd5osFE72honIdDoRbv05ZDXFVAU6jidz6Ge7PcJY=;
	h=Date:To:From:Subject:Message-Id; b=HjQCFUWexui0r8t3TfSryoi5CAs7DuiR82fZEg1VpxVVCYkXgzkq9ZoNAeVdMGnSOHzUTKA/eKaDlI6bAU/aSlf5caQWhXFp9mTeWgpajiU0LL1+/cAn4Hmn8mWcTorN/kZKmkCr+aHgp1xiI2kM3s+RXLuQZitkkadL3sLjOpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PuTiN9Sj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PuTiN9Sj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5638C32782;
	Tue, 25 Jun 2024 05:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293219;
	bh=MoUd5osFE72honIdDoRbv05ZDXFVAU6jidz6Ge7PcJY=;
	h=Date:To:From:Subject:From;
	b=PuTiN9Sj+Pitng8rYMG8tH4ehJPeOBehGHh6vQYvon93MrdJVg8xuGWMJPH+Ut/l9
	 153TnGvZYy9rRh0yinpzt0PXZY8u7CbVNr1ViFv4lPm74z2+PvFqYrKIZvXNcOblzO
	 ujpPeEBT60Kq3swM33KmMGWniZgKYn6GgajMgvcU=
Date: Mon, 24 Jun 2024 22:26:59 -0700
To: mm-commits@vger.kernel.org,sashal@kernel.org,lukas.bulwahn@gmail.com,linux@leemhuis.info,keescook@chromium.org,joe@perches.com,gregkh@linuxfoundation.org,dwaipayanray1@gmail.com,arnd@arndb.de,apw@canonical.com,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-check-for-missing-fixes-tags.patch removed from -mm tree
Message-Id: <20240625052659.D5638C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: check for missing Fixes tags
has been removed from the -mm tree.  Its filename was
     checkpatch-check-for-missing-fixes-tags.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: checkpatch: check for missing Fixes tags
Date: Tue, 11 Jun 2024 16:43:29 +0300

This check looks for common words that probably indicate a patch
is a fix.  For now the regex is:

	(?:(?:BUG: K.|UB)SAN: |Call Trace:|stable\@|syzkaller)/)

Why are stable patches encouraged to have a fixes tag?  Some people mark
their stable patches as "# 5.10" etc.  This is useful but a Fixes tag is
still a good idea.  For example, the Fixes tag helps in review.  It
helps people to not cherry-pick buggy patches without also
cherry-picking the fix.

Also if a bug affects the 5.7 kernel some people will round it up to
5.10+ because 5.7 is not supported on kernel.org.  It's possible the Bad
Binder bug was caused by this sort of gap where companies outside of
kernel.org are supporting different kernels from kernel.org.

Should it be counted as a Fix when a patch just silences harmless
WARN_ON() stack trace.  Yes.  Definitely.

Is silencing compiler warnings a fix?  It seems unfair to the original
authors, but we use -Werror now, and warnings break the build so let's
just add Fixes tags.  I tell people that silencing static checker
warnings is not a fix but the rules on this vary by subsystem.

Is fixing a minor LTP issue (Linux Test Project) a fix?  Probably?  It's
hard to know what to do if the LTP test has technically always been
broken.

One clear false positive from this check is when someone updated their
debug output and included before and after Call Traces.  Or when crashes
are introduced deliberately for testing.  In those cases, you should
just ignore checkpatch.

Link: https://lkml.kernel.org/r/ZmhUgZBKeF_8ixA6@moroto
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Thorsten Leemhuis <linux@leemhuis.info>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-check-for-missing-fixes-tags
+++ a/scripts/checkpatch.pl
@@ -28,6 +28,7 @@ my %verbose_messages = ();
 my %verbose_emitted = ();
 my $tree = 1;
 my $chk_signoff = 1;
+my $chk_fixes_tag = 1;
 my $chk_patch = 1;
 my $tst_only;
 my $emacs = 0;
@@ -88,6 +89,7 @@ Options:
   -v, --verbose              verbose mode
   --no-tree                  run without a kernel tree
   --no-signoff               do not check for 'Signed-off-by' line
+  --no-fixes-tag             do not check for 'Fixes:' tag
   --patch                    treat FILE as patchfile (default)
   --emacs                    emacs compile window format
   --terse                    one line per report
@@ -295,6 +297,7 @@ GetOptions(
 	'v|verbose!'	=> \$verbose,
 	'tree!'		=> \$tree,
 	'signoff!'	=> \$chk_signoff,
+	'fixes-tag!'	=> \$chk_fixes_tag,
 	'patch!'	=> \$chk_patch,
 	'emacs!'	=> \$emacs,
 	'terse!'	=> \$terse,
@@ -1257,6 +1260,7 @@ sub git_commit_info {
 }
 
 $chk_signoff = 0 if ($file);
+$chk_fixes_tag = 0 if ($file);
 
 my @rawlines = ();
 my @lines = ();
@@ -2636,6 +2640,9 @@ sub process {
 
 	our $clean = 1;
 	my $signoff = 0;
+	my $fixes_tag = 0;
+	my $is_revert = 0;
+	my $needs_fixes_tag = "";
 	my $author = '';
 	my $authorsignoff = 0;
 	my $author_sob = '';
@@ -3189,6 +3196,16 @@ sub process {
 			}
 		}
 
+# These indicate a bug fix
+		if (!$in_header_lines && !$is_patch &&
+			$line =~ /^This reverts commit/) {
+			$is_revert = 1;
+		}
+
+		if (!$in_header_lines && !$is_patch &&
+		    $line =~ /((?:(?:BUG: K.|UB)SAN: |Call Trace:|stable\@|syzkaller))/) {
+			$needs_fixes_tag = $1;
+		}
 
 # Check Fixes: styles is correct
 		if (!$in_header_lines &&
@@ -3201,6 +3218,7 @@ sub process {
 			my $id_length = 1;
 			my $id_case = 1;
 			my $title_has_quotes = 0;
+			$fixes_tag = 1;
 
 			if ($line =~ /(\s*fixes:?)\s+([0-9a-f]{5,})\s+($balanced_parens)/i) {
 				my $tag = $1;
@@ -7697,6 +7715,12 @@ sub process {
 		ERROR("NOT_UNIFIED_DIFF",
 		      "Does not appear to be a unified-diff format patch\n");
 	}
+	if ($is_patch && $has_commit_log && $chk_fixes_tag) {
+		if ($needs_fixes_tag ne "" && !$is_revert && !$fixes_tag) {
+			WARN("MISSING_FIXES_TAG",
+				 "The commit message has '$needs_fixes_tag', perhaps it also needs a 'Fixes:' tag?\n");
+		}
+	}
 	if ($is_patch && $has_commit_log && $chk_signoff) {
 		if ($signoff == 0) {
 			ERROR("MISSING_SIGN_OFF",
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are


