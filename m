Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BC4274B53
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338698; cv=none; b=jlAkZazQe5h4HAp66PFzUR17sS02Q09vkWoyYOxaidYCiY6RV7Yut2V3iqcs95vcafvsvNdbhxBtEi02k1lNaKyAF5d5E9VTlZMbMBDS3tA8uR78ImlAZmxv5Dru0s1Lbem8BBpPDfC8ZHKGurA2CTFhASxiXUDHORxLOuA+hqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338698; c=relaxed/simple;
	bh=m21Cq7ApqQqiLvdH5Oe/Rdb2TTu6ELn4iaCe1yQlHVo=;
	h=Date:To:From:Subject:Message-Id; b=H8ZpEZmX8486a3TJaQ7QLe8YFDNk6w3jtt8bjaVqA/ib0Bb4ByfykonT4z3iW2bBwpgJ0wEy+mRt0Qek9zds4AZLrKS5ffJphs89lO0lvBM0BEMdwdkb2woKHFg/OG6+/ZvOLZdENhxEN4OlU1RhodOLCmPZ0i3IVjjZAdJt7cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DDH/Y8rX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DDH/Y8rX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589E81F0089C;
	Wed,  7 Oct 2026 02:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338697;
	bh=x5MwcsffF8boMHuwO4DIdTyYvIZcwUkGV5hMezizG5I=;
	h=Date:To:From:Subject;
	b=DDH/Y8rXNh4KLzGDwxeQuQm161lvUTBprFCbSiAQPSnK2RTqBj41GVtqu+q3Dfqd2
	 8oqM8I+k6Grmgx5epDVYvhzxi7aBh0dGp3H17KTOH0qAxwv16Fm9/vP7uc7miYrJNm
	 niYF9zhPKNyJJvwL239iikqVtYnHdI0f36W4z5+Q=
Date: Tue, 06 Oct 2026 19:04:56 -0700
To: mm-commits@vger.kernel.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,pvorel@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-add-userspace-to-force-userspace-rules.patch removed from -mm tree
Message-Id: <20261007020457.589E81F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: add --userspace to force userspace rules
has been removed from the -mm tree.  Its filename was
     checkpatch-add-userspace-to-force-userspace-rules.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Petr Vorel <pvorel@suse.cz>
Subject: checkpatch: add --userspace to force userspace rules
Date: Fri, 4 Sep 2026 13:02:29 +0200

Also allow to use --no-userspace for userspace projects which vendored
checkpatch.pl and use --userspace globally to be able switch it off for
files with kernel code.

Link: https://lore.kernel.org/20260904110230.1219037-4-pvorel@suse.cz
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
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


