Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B42282F36
	for <mm-commits@vger.kernel.org>; Sun,  6 Sep 2026 01:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788657733; cv=none; b=k46KtQwLByvj1xn8kz+5194Md0xKwIpZxpNCQHkYF0+cB+ZLNWfFIoR5YmvSVvpHB4WBNJ1jmkgWcj/gnENR5A2PSEwo1okwy/pyzewiscL6mngNFt+L5WA8fKECqQkzHPgU9CNanC9ok5qXMd5/oI4/cHsg+g1IN0ZLxEmfOzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788657733; c=relaxed/simple;
	bh=wDR8OQ2Wvn8FdtVOsBcaILQuAjmymU4R4vm1iM3hd0I=;
	h=Date:To:From:Subject:Message-Id; b=ts/6xVSYAPCHQ2XRz0FjgMETeu19Hma0utkV4EXLunYdrosVAOV/ImLjGCLzZU0yxSuZqvR1CLZeCjCNtGocnE2BTQ9Xo/5+6bLeRkPJzXnIb41j8Y7hKQyN74gZ/D+vWL0xg8CW2YL5WhSrnv4LmNFOpGGt8BmOncpuJpAeX/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yZwfZCkQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yZwfZCkQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9428A1F00A3A;
	Sun,  6 Sep 2026 01:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788657730;
	bh=aPBL2b8TsRTwAc3y6XDUICFLvzEQvDbZXwdZvEtrHz8=;
	h=Date:To:From:Subject;
	b=yZwfZCkQPQYGdEJzOQoqcvxIQxNLE3mi2jaQqxuHg1LB0DYxSiB+VKROD5MyvbJN0
	 rAhqTu4X7sEK59GXflzpSNwxvEJHTly8d0dcj0hSsUS4mhp2M0zATgE89Pn0Afzyuo
	 E1qeN6MCon1yC1AuixAUP/Oc59+Kc8lMOn6Sj26I=
Date: Sat, 05 Sep 2026 18:22:10 -0700
To: mm-commits@vger.kernel.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,pvorel@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-add-more-userspace-directories-to-is_userspace.patch added to mm-nonmm-unstable branch
Message-Id: <20260906012210.9428A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: checkpatch: add more userspace directories to is_userspace()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-add-more-userspace-directories-to-is_userspace.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-add-more-userspace-directories-to-is_userspace.patch

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
Subject: checkpatch: add more userspace directories to is_userspace()
Date: Fri, 4 Sep 2026 13:02:27 +0200

Patch series "checkpatch: userspace improvements", v6.

Few improvements for user space code + --userspace option for projects
which vendored checkpatch.pl.

There could be probably more checks which are kernel space only.


This patch (of 4):

arch/ directory contains subdirectories with userspace tools (at least
arch/*/tools/ and arch/*/boot/tools/).  Add check to consider any
arch/.*/tools/ subdirectory as userspace tools directory.

This helps not only to strscpy() checks but also to CamelCase checks in
the next commit to be more precise.

This is a follow-up to 99b70ece33d8 ("checkpatch: suppress strscpy
warnings for userspace tools").

Link: https://lore.kernel.org/20260904110230.1219037-1-pvorel@suse.cz
Link: https://lore.kernel.org/20260904110230.1219037-2-pvorel@suse.cz
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-add-more-userspace-directories-to-is_userspace
+++ a/scripts/checkpatch.pl
@@ -2667,7 +2667,9 @@ sub exclude_global_initialisers {
 
 sub is_userspace {
     my ($realfile) = @_;
-    return ($realfile =~ m@^tools/@ || $realfile =~ m@^scripts/@);
+    return ($realfile =~ m@^tools/@ ||
+		$realfile =~ m@^scripts/@ ||
+		$realfile =~ m@^arch/.*/tools/@);
 }
 
 sub process {
_

Patches currently in -mm which might be from pvorel@suse.cz are

checkpatch-skip-camelcase-cache-for-no-tree-without-root.patch
checkpatch-add-more-userspace-directories-to-is_userspace.patch
checkpatch-ignore-inttypesh-format-macros-for-userspace-tools.patch
checkpatch-add-userspace-to-force-userspace-rules.patch
checkpatch-skip-kernel-specific-checks-for-userspace.patch

