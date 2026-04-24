Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F44E335575
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 18:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777054471; cv=none; b=TbsVzzCMaZ8ohsobA4eIJMmrA6oQhYizLS1gSuCk6rEzr3R7YUKQLbH6OE8GpKY8x2uRy5eARDAz6ig7Up3YqWgU9+42X18nWPZpMdEa8M4SrNTVhwPjaembRar4MiFtOTyYFJUXI5VGe/CW+5PBoyZwL1aP9KyxmITRQZWUmtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777054471; c=relaxed/simple;
	bh=H2f6rdIZNF4Arr4BzdQjqMiHFxqY1G+5Za0uoKoIOZw=;
	h=Date:To:From:Subject:Message-Id; b=bR5BSscV75btPAub01P7s5gVYeumRj9hYamO8Oz6OdRuO7P4vVJZQUlUkgETJl8mKhU+aMoChXi0qWuAnTebY2hNw6CCpP+z2UpfjhGLLuhikZ6xr3RuJlC18+m9K4YuyUOPwdM4CZVdDHFut7cRtZFYlPY1Z7VfBvKMxwgOEsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rgsjjB2Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rgsjjB2Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FC3C2BCB0;
	Fri, 24 Apr 2026 18:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777054471;
	bh=H2f6rdIZNF4Arr4BzdQjqMiHFxqY1G+5Za0uoKoIOZw=;
	h=Date:To:From:Subject:From;
	b=rgsjjB2ZBMiy8ZbSyi5+slt5wE08eKOpNpHBcyLU15eytHUlOXw3mQ+pRcF1Yl5Ct
	 ODAS3nDbY5DmdGURuFT7wdFPCS3nz1nEHZVyr8W0FqPf3qDySjlGc1cM8WaTALo9JP
	 SFeDAlNltTpw4LCOacPURV/fE/xafPLKHZyR6gvA=
Date: Fri, 24 Apr 2026 11:14:30 -0700
To: mm-commits@vger.kernel.org,joe@perches.com,sashal@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + get_maintainer-add-json-output-mode.patch added to mm-nonmm-unstable branch
Message-Id: <20260424181430.E5FC3C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: get_maintainer: add --json output mode
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     get_maintainer-add-json-output-mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/get_maintainer-add-json-output-mode.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Sasha Levin <sashal@kernel.org>
Subject: get_maintainer: add --json output mode
Date: Wed, 8 Apr 2026 15:45:42 -0400

Add a --json flag to get_maintainer.pl that emits structured JSON output,
making results machine-parseable for CI systems, IDE integrations, and
AI-assisted development tools.

The JSON output includes a maintainers array with structured name, email,
and role fields, plus optional arrays for scm, status, subsystem, web, and
bug information when those flags are enabled.

Normal text output behavior is completely unchanged when --json is not
specified.

Assisted-by: Claude:claude-opus-4-6
Link: https://lore.kernel.org/20260408194542.1354549-1-sashal@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   75 +++++++++++++++++++++---------------
 1 file changed, 44 insertions(+), 31 deletions(-)

--- a/scripts/get_maintainer.pl~get_maintainer-add-json-output-mode
+++ a/scripts/get_maintainer.pl
@@ -21,6 +21,7 @@ use Cwd;
 use File::Find;
 use File::Spec::Functions;
 use open qw(:std :encoding(UTF-8));
+use JSON::PP;
 
 my $cur_path = fastgetcwd() . '/';
 my $lk_path = "./";
@@ -68,6 +69,7 @@ my $pattern_depth = 0;
 my $self_test = undef;
 my $version = 0;
 my $help = 0;
+my $json = 0;
 my $find_maintainer_files = 0;
 my $maintainer_path;
 my $vcs_used = 0;
@@ -285,6 +287,7 @@ if (!GetOptions(
 		'find-maintainer-files' => \$find_maintainer_files,
 		'mpath|maintainer-path=s' => \$maintainer_path,
 		'self-test:s' => \$self_test,
+		'json!' => \$json,
 		'v|version' => \$version,
 		'h|help|usage' => \$help,
 		)) {
@@ -650,39 +653,48 @@ my %deduplicate_name_hash = ();
 my %deduplicate_address_hash = ();
 
 my @maintainers = get_maintainers();
-if (@maintainers) {
-    @maintainers = merge_email(@maintainers);
-    output(@maintainers);
-}
-
-if ($scm) {
-    @scm = uniq(@scm);
-    output(@scm);
-}
-
-if ($output_substatus) {
-    @substatus = uniq(@substatus);
-    output(@substatus);
-}
-
-if ($status) {
-    @status = uniq(@status);
-    output(@status);
-}
 
-if ($subsystem) {
-    @subsystem = uniq(@subsystem);
-    output(@subsystem);
-}
-
-if ($web) {
-    @web = uniq(@web);
-    output(@web);
-}
+@maintainers = merge_email(@maintainers) if (@maintainers);
+@scm = uniq(@scm) if ($scm);
+@substatus = uniq(@substatus) if ($output_substatus);
+@status = uniq(@status) if ($status);
+@subsystem = uniq(@subsystem) if ($subsystem);
+@web = uniq(@web) if ($web);
+@bug = uniq(@bug) if ($bug);
+
+if ($json) {
+    my @json_maintainers;
+    for my $m (@maintainers) {
+	my ($addr, $role);
+	if ($output_roles && $m =~ /^(.*?)\s+\((.+)\)\s*$/) {
+	    $addr = $1;
+	    $role = $2;
+	} else {
+	    $addr = $m;
+	}
+	my ($name, $email_addr) = parse_email($addr);
+	my %entry = (name => $name, email => $email_addr);
+	$entry{role} = $role if (defined $role && $role ne '');
+	push(@json_maintainers, \%entry);
+    }
+
+    my %result = (maintainers => \@json_maintainers);
+    $result{scm} = \@scm if ($scm);
+    $result{status} = \@status if ($status);
+    $result{subsystem} = \@subsystem if ($subsystem);
+    $result{web} = \@web if ($web);
+    $result{bug} = \@bug if ($bug);
 
-if ($bug) {
-    @bug = uniq(@bug);
-    output(@bug);
+    my $json_encoder = JSON::PP->new->canonical->utf8;
+    print($json_encoder->encode(\%result) . "\n");
+} else {
+    output(@maintainers) if (@maintainers);
+    output(@scm) if ($scm);
+    output(@substatus) if ($output_substatus);
+    output(@status) if ($status);
+    output(@subsystem) if ($subsystem);
+    output(@web) if ($web);
+    output(@bug) if ($bug);
 }
 
 exit($exit);
@@ -1104,6 +1116,7 @@ Output type options:
   --separator [, ] => separator for multiple entries on 1 line
     using --separator also sets --nomultiline if --separator is not [, ]
   --multiline => print 1 entry per line
+  --json => output results as JSON
 
 Other options:
   --pattern-depth => Number of pattern directory traversals (default: 0 (all))
_

Patches currently in -mm which might be from sashal@kernel.org are

get_maintainer-add-json-output-mode.patch
kallsyms-embed-source-file-line-info-in-kernel-stack-traces.patch
kallsyms-extend-lineinfo-to-loadable-modules.patch
kallsyms-delta-compress-lineinfo-tables-for-27x-size-reduction.patch
kallsyms-add-kunit-tests-for-lineinfo-feature.patch

