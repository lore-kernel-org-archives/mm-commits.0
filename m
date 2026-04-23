Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA74F1C861D
	for <mm-commits@vger.kernel.org>; Thu, 23 Apr 2026 14:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776955192; cv=none; b=QkH4wH/MC0R8ohQjsuj5Pe7EhKGVO7xCA/v/QjAbuwBSXQbeSJrwKf3tDCePfFltMTvPA7F0GUX8YKOBxyq5OHoJgSqI1Ssh/uCYSA/gud+c9mO6qabVJw5Dimrmu0ssW21DOV/KBtFNkFiZomz3TDlM6hrZfEy7O9LK35torU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776955192; c=relaxed/simple;
	bh=pbak+E5bmRfPFa5m6Xn4N4h72mzx4qFOGP+nDt2E08I=;
	h=Date:To:From:Subject:Message-Id; b=Wv08bZpqz1o0TtwqilXnqbZRLbb5fIMaMoV3qU+oqUncBs267GzXzBQzM0bPb/AcdRvBYB8ixOMaNiMssy8ODzkNkOsHVaJcJkEtpuzMiy7T0GSNjzZTYGDLRU/OmOd4PkjFoZROGp1B3QdYvRw6KwnVb9gc2wVxyn9y0nUxuYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RP/IC5Xc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RP/IC5Xc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47BD9C2BCAF;
	Thu, 23 Apr 2026 14:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776955192;
	bh=pbak+E5bmRfPFa5m6Xn4N4h72mzx4qFOGP+nDt2E08I=;
	h=Date:To:From:Subject:From;
	b=RP/IC5Xc+tiEMqqloCoNAoQoAWd4tbhufl4gq5STzp8hWE6kK14yf+apcUnvt93/I
	 GALwq0blc1Lw0k19WHeL4R4888QFep2XojtwUwm+qZY6AvYseIVoCJ5ifYvpUKGBjw
	 8yqm8GS2HkunhiJpQMOWAOw9my7O7acUCf5FAcQ4=
Date: Thu, 23 Apr 2026 07:39:51 -0700
To: mm-commits@vger.kernel.org,sjg@chromium.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,pvorel@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-allow-passing-config-directory.patch added to mm-nonmm-unstable branch
Message-Id: <20260423143952.47BD9C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: checkpatch: allow passing config directory
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-allow-passing-config-directory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-allow-passing-config-directory.patch

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
From: Petr Vorel <pvorel@suse.cz>
Subject: checkpatch: allow passing config directory
Date: Tue, 21 Apr 2026 23:14:06 +0200

checkpatch.pl searches for .checkpatch.conf in $CWD, $HOME and
$CWD/.scripts.  Allow passing a single directory via CHECKPATCH_CONFIG_DIR
environment variable (empty value is ignored).  This allows to directly
use project configuration file for projects which vendored checkpatch.pl
(e.g.  LTP or u-boot).

Although it'd be more convenient for user to have --conf-dir option
(instead of using environment variable), code would get ugly because
options from the configuration file needs to be read before processing
command line options with Getopt::Long.

While at it, document directories and environment variable in -h help
and HTML doc.

Link: https://lore.kernel.org/20260421211408.383972-1-pvorel@suse.cz
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Reviewed-by: Simon Glass <sjg@chromium.org>
Acked-by: Joe Perches <joe@perches.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/checkpatch.rst |    7 +++++++
 scripts/checkpatch.pl                  |   20 +++++++++++++++++---
 2 files changed, 24 insertions(+), 3 deletions(-)

--- a/Documentation/dev-tools/checkpatch.rst~checkpatch-allow-passing-config-directory
+++ a/Documentation/dev-tools/checkpatch.rst
@@ -210,6 +210,13 @@ Available options:
 
    Display the help text.
 
+Configuration file
+==================
+
+Default configuration options can be stored in ``.checkpatch.conf``, search
+path: ``.:$HOME:.scripts`` or in a directory specified by ``$CHECKPATCH_CONFIG_DIR``
+environment variable (falling back to the default search path).
+
 Message Levels
 ==============
 
--- a/scripts/checkpatch.pl~checkpatch-allow-passing-config-directory
+++ a/scripts/checkpatch.pl
@@ -57,6 +57,9 @@ my %ignore_type = ();
 my @ignore = ();
 my $help = 0;
 my $configuration_file = ".checkpatch.conf";
+my $def_configuration_dirs_help = '.:$HOME:.scripts';
+(my $def_configuration_dirs = $def_configuration_dirs_help) =~ s/\$(\w+)/$ENV{$1}/g;
+my $env_config_dir = 'CHECKPATCH_CONFIG_DIR';
 my $max_line_length = 100;
 my $ignore_perl_version = 0;
 my $minimum_perl_version = 5.10.0;
@@ -146,6 +149,11 @@ Options:
   -h, --help, --version      display this help and exit
 
 When FILE is - read standard input.
+
+CONFIGURATION FILE
+Default configuration options can be stored in $configuration_file,
+search path: '$def_configuration_dirs_help' or in a directory specified by
+\$$env_config_dir environment variable (fallback to the default search path).
 EOM
 
 	exit($exitcode);
@@ -237,7 +245,7 @@ sub list_types {
 	exit($exitcode);
 }
 
-my $conf = which_conf($configuration_file);
+my $conf = which_conf($configuration_file, $env_config_dir, $def_configuration_dirs);
 if (-f $conf) {
 	my @conf_args;
 	open(my $conffile, '<', "$conf")
@@ -1531,9 +1539,15 @@ sub which {
 }
 
 sub which_conf {
-	my ($conf) = @_;
+	my ($conf, $env_key, $paths) = @_;
+	my $env_dir = $ENV{$env_key};
+
+	if (defined($env_dir) && $env_dir ne "") {
+		return "$env_dir/$conf" if (-e "$env_dir/$conf");
+		warn "$P: Can't find a readable $conf in '$env_dir', falling back to default search paths\n";
+	}
 
-	foreach my $path (split(/:/, ".:$ENV{HOME}:.scripts")) {
+	foreach my $path (split(/:/, $paths)) {
 		if (-e "$path/$conf") {
 			return "$path/$conf";
 		}
_

Patches currently in -mm which might be from pvorel@suse.cz are

checkpatch-allow-passing-config-directory.patch
checkpatch-add-option-to-not-force-for-spdx.patch

