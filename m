Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E1B30F7EA
	for <mm-commits@vger.kernel.org>; Sun,  6 Sep 2026 01:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788657735; cv=none; b=HB0idos4twDnQczcr0ipaRiOuuELn/EIcxN4D6Py5It+Sbao3XZEo8jjtQ9i1AQfF8skM0WAJNP/7Vle+gYG1byemZO5riHqD2k8lmfAnowMmk1uwQ+1pdzpbbvLBtpR49Hj5LVzfoSHX4j5fGurubUOAvsqJvunWWWbxpojkD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788657735; c=relaxed/simple;
	bh=M32kJA/+erPF++dxRSkxQo5uC+6lm7rQupPjgzA0vWg=;
	h=Date:To:From:Subject:Message-Id; b=Mg1ErulfK1mvantA/3z3k507J79wqA3AsNo6Gv8kwe2NLKOTw0HwfQ6eFVPhfrG0MyjN5H/O3DNWMdWo/e6fMCLY2jZZDP2p8bcA4J8Xirro176lFDSf2/1R6BVhOqVDYea+Et/JaeyW0/gwMxKUf9J3HT8ceTcaTMOQLOy1j/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ewJYYTWt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ewJYYTWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C141F00A3A;
	Sun,  6 Sep 2026 01:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788657734;
	bh=Hi5RGyt1z144WJIiNrppGIZ2Fr1ASXvM8f6SNQl1OF8=;
	h=Date:To:From:Subject;
	b=ewJYYTWtGgAKxBbnsAo/l4RnD5Y/rTGyj8sYiPYoINGkR2mBDGKfzbdhgvs6DpT4Y
	 3XEdu5NKlglp4vZVvIAZtkI/azblCNjByE6hH8Ty+MKDG37PVU/+bT3jgdBlP3WdJ/
	 cuS1TtQGmHl7NLdMfKqZZ0dhWFZulxlS8vTjtHZk=
Date: Sat, 05 Sep 2026 18:22:13 -0700
To: mm-commits@vger.kernel.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,pvorel@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-add-userspace-to-force-userspace-rules.patch added to mm-nonmm-unstable branch
Message-Id: <20260906012214.51C141F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: checkpatch: add --userspace to force userspace rules
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-add-userspace-to-force-userspace-rules.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-add-userspace-to-force-userspace-rules.patch

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
Subject: checkpatch: add --userspace to force userspace rules
Date: Fri, 4 Sep 2026 13:02:29 +0200

Also allow to use --no-userspace for userspace projects which vendored
checkpatch.pl and use --userspace globally to be able switch it off for
files with kernel code.

Link: https://lore.kernel.org/20260904110230.1219037-4-pvorel@suse.cz
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-add-userspace-to-force-userspace-rules
+++ a/scripts/checkpatch.pl
@@ -63,6 +63,7 @@ my $env_config_dir = 'CHECKPATCH_CONFIG_
 my $max_line_length = 100;
 my $ignore_perl_version = 0;
 my $spdx_cxx_comments = 0;
+my $userspace;
 my $minimum_perl_version = 5.10.0;
 my $min_conf_desc_length = 4;
 my $spelling_file = "$D/spelling.txt";
@@ -143,6 +144,7 @@ Options:
                              (required by old toolchains), allow also C++
                              comments (//).
                              NOTE: it should *not* be used for Linux mainline.
+  --userspace                Force rules specific for userspace.
   --codespell                Use the codespell dictionary for spelling/typos
                              (default:$codespellfile)
   --codespellfile            Use this codespell dictionary
@@ -358,6 +360,7 @@ GetOptions(
 	'codespell!'	=> \$codespell,
 	'codespellfile=s'	=> \$user_codespellfile,
 	'typedefsfile=s'	=> \$typedefsfile,
+	'userspace!'	=> \$userspace,
 	'color=s'	=> \$color,
 	'no-color'	=> \$color,	#keep old behaviors of -nocolor
 	'nocolor'	=> \$color,	#keep old behaviors of -nocolor
@@ -2667,6 +2670,9 @@ sub exclude_global_initialisers {
 
 sub is_userspace {
     my ($realfile) = @_;
+
+    return $userspace if (defined $userspace);
+
     return ($realfile =~ m@^tools/@ ||
 		$realfile =~ m@^scripts/@ ||
 		$realfile =~ m@^arch/.*/tools/@);
_

Patches currently in -mm which might be from pvorel@suse.cz are

checkpatch-skip-camelcase-cache-for-no-tree-without-root.patch
checkpatch-add-more-userspace-directories-to-is_userspace.patch
checkpatch-ignore-inttypesh-format-macros-for-userspace-tools.patch
checkpatch-add-userspace-to-force-userspace-rules.patch
checkpatch-skip-kernel-specific-checks-for-userspace.patch

