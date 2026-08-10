Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2472F385D72
	for <mm-commits@vger.kernel.org>; Mon, 10 Aug 2026 17:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786381924; cv=none; b=kZhxXn0Hzk3/G2GebHBF9vjU7OFbGQ+AGboBIPfKd+OT+VMvl2rNlGR0rEQ3EOjQOCiGmDVx49XKQWXxMIMUG2oa0x3dV6iUKSeul4cu8EsTN2mR6K+QF1/fYyfsW2RwdM3VPHpyxSQSsd69ZRL+hfLOMJJJt57B13QR28Gku7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786381924; c=relaxed/simple;
	bh=INfDVmdlmc+o+AzuaPxQzrEodWHtupQaR7zq5WL1m74=;
	h=Date:To:From:Subject:Message-Id; b=tkwCFGuQm33Capnb3M8PqFBvnlecbaXxFfhkVgsMKB6brezavWZe5VGfny0hWdJNDLOjcNVVaVFwTLeXQezS6ac7haMW3AhzM/Dx1OtQUOOb0nn6CycP6Gx7x1x0LeX28vVfCiLP+2gLOcmsg9Y6NgPNLzq5MCSCiVI7lCGmAVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h9TRdjUe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h9TRdjUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856701F000E9;
	Mon, 10 Aug 2026 17:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786381922;
	bh=l28BQo0W0qdsvIKUFZI+Fkoyxct/5H59uxFs/K7yqf8=;
	h=Date:To:From:Subject;
	b=h9TRdjUe4nYAytj2Rip9r9bn/P/6tfJZ6IFESj6bbp0HvMMqcYJ8hrPYb72QH7FbL
	 kkSImK2Pqwvo5ozUmy2eDMpvV41BCko+mzOSF8RjEeh9BZ5hLyv1HFumYiqonjN970
	 MFcna8Dd8S1dXTzVaVJRqWFSmnjvwmX2yaDq1Bgg=
Date: Mon, 10 Aug 2026 10:12:02 -0700
To: mm-commits@vger.kernel.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,pvorel@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-skip-camelcase-cache-for-no-tree-without-root.patch added to mm-nonmm-unstable branch
Message-Id: <20260810171202.856701F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: checkpatch: skip CamelCase cache for --no-tree without root
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-skip-camelcase-cache-for-no-tree-without-root.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-skip-camelcase-cache-for-no-tree-without-root.patch

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
Subject: checkpatch: skip CamelCase cache for --no-tree without root
Date: Mon, 10 Aug 2026 18:11:59 +0200

Running outside tree (--no-tree) without git root (--root DIR) is not
doable because we have no include/ directory which could be cached.  But
3445686af721 expected that we are always in Linux tree (w/a git).  But
--no-tree does not require --root.  Therefore skip whole caching in that
case.

This fixes perl and find errors when running checkpatch.pl *with*
--no-tree --strict and *without* --root:

    No structs that should be const will be found - file 'scripts/const_structs.checkpatch': No such file or directory
    Use of uninitialized value $root in concatenation (.) or string at scripts/checkpatch.pl line 1213.
    find: `/include': No such file or directory

Link: https://lore.kernel.org/20260810161159.1044160-1-pvorel@suse.cz
Fixes: 3445686af721 ("checkpatch: ignore existing CamelCase uses from include/...")
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 ++
 1 file changed, 2 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-skip-camelcase-cache-for-no-tree-without-root
+++ a/scripts/checkpatch.pl
@@ -1206,6 +1206,8 @@ sub seed_camelcase_includes {
 		my $git_last_include_commit = `${git_command} log --no-merges --pretty=format:"%h%n" -1 -- include`;
 		chomp $git_last_include_commit;
 		$camelcase_cache = ".checkpatch-camelcase.git.$git_last_include_commit";
+	} elsif (not defined $root) {
+		return;
 	} else {
 		my $last_mod_date = 0;
 		$files = `find $root/include -name "*.h"`;
_

Patches currently in -mm which might be from pvorel@suse.cz are

maintainers-add-irc-and-patchwork-for-ltp.patch
checkpatch-skip-camelcase-cache-for-no-tree-without-root.patch

