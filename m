Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E06E371867
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028734; cv=none; b=axNCZ1rO/cBKmINeLOsxeJlQ/T6Koalzy3dTIVgzz1qB78sNs6mBmR3SzVY4C732JP2hYy8ufFvmHBeuglyWb56bwaL1KSkgGp2El8ZgvAXSJORrb3v7ySGRq8MfIBkSxov9aZn5k/G4YhB80i43GZKL1Cc2axXNRKGEPBfVZ3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028734; c=relaxed/simple;
	bh=tUWuKx8TUYvavMWSrpG+VdX96aE3VDRjRCKkjhasjfY=;
	h=Date:To:From:Subject:Message-Id; b=f5Ifw024tc2evQGxUzDAhtLTv07AmXYMv6JWL3Mlsi+/jtuesVXWtR4rQfFXmIdub1yE3+bXO79URHeEtIxJwEi9ixMtzltx2elfHRDQEh5ANwMPsVdCSkj6GnW5F6VdWuj1dMboqu/1r92zCCcm78NT6YfVLVIhO6zB0KuhPPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wyI5ldhh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wyI5ldhh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3131F00893;
	Fri, 29 May 2026 04:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028732;
	bh=I57o5BH7y931vOxEimx7ldT4liYK790tVS8R9zjY4GU=;
	h=Date:To:From:Subject;
	b=wyI5ldhhToDvHBJ75XKlT+uJc45BWr/QtoDtO7eGYLFfq7WvFTT9WwCdWEoSLp1Ca
	 sf1oc6RwoHb3Kk57ZOWoLlCbk27nSPspFbQ5n72jWPCoCdDRZ8Ld5t97P5rKGgEvRD
	 8n4XOKyKiws1hxxF0e8oYa6KtW9AkH4xrQcQ10CY=
Date: Thu, 28 May 2026 21:25:31 -0700
To: mm-commits@vger.kernel.org,sjg@chromium.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,pvorel@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-allow-passing-config-directory.patch removed from -mm tree
Message-Id: <20260529042532.2D3131F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: allow passing config directory
has been removed from the -mm tree.  Its filename was
     checkpatch-allow-passing-config-directory.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


