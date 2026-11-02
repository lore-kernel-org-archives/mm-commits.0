Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793594263;
	b=uaqmLarwh9f7iEU0MUFBxLm/o7wnaNDPpa/K5NTG+5mdwKfQsouq+QQjwG6RZTWhNhgF
	 4oZv2bG5q0tjUSTkGEofMROIV4QcamfLd3VoWX5wxx0VZjve/nPvs1MBoPIJKDx+hrWJS
	 KlhVkygGF4eDIxnbYhyv8zB/pv36Ih34AIrBbFG40c2kjWQXx0/SymfcceQT2gGOKDiWe
	 x1YtLpqhZ/LDNBCQmlF+2JYGv0gyX7DjXSYEmkxe+dKL4SGqqD/xa5Nccz+HCH1+cR8bO
	 uUJFkKc62GLMIYFMEbiyK0vw9xhSkEJjiCfBaLe2dr5wA3VsBLoMOfnkmCepRF/4UKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793594263;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=5LLzBCqOKqyu1CqVOndQEvKDfZU4Yrz/WkVE7eb30M4=;
	b=Jayr334X3cnp8Szj1RW42LS+xvS465WceJ+PvDTXxK1tMY+UHZiyszjS9SYZD6wDrl4i
	 xCgCvjXehfGN5/eB9HkI2GG9+ognnzdl+0a61kuWcTh588/WXdvn9ZTxQYQkspa7thAwO
	 EItpCbCSe3sjNd+O8DhS8OGDtOUh4J6YVyf2HJxr/l3jeDeFfs1a+BIDWVK7ARcEMYRdE
	 9GOH0xqeYVCQETkkY8j6xoTQ7jUZBWvGWbMkXT0bjJQpUcWS7Ae4O5kus1lW9SNEZ48cZ
	 3JntpwG7cDIPzhxdUGf/VFtCgX5Xr7+qmy12AWwErX21uHd3CiFN8/j50gCtcWoeGlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=VtmkEDcY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08069606A324
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 04:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=VtmkEDcY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711CC1F000C1;
	Mon,  2 Nov 2026 04:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793594262;
	bh=5LLzBCqOKqyu1CqVOndQEvKDfZU4Yrz/WkVE7eb30M4=;
	h=Date:To:From:Subject;
	b=VtmkEDcYXrSPcp1yLTbPXbaAYv9g0EKUeL5og6rdqLdTN5rCn8nAPRA0z8vrvowJr
	 Gs4kUjFpZnq7ey7F9q7pCjPXrg8v7ySY4PWI/rrfBa6UABZoawbqS+zB904gQJ+UL4
	 fItkepHkte8iT/FqSbQc3KjS3cr91ovhHRjjKhhU=
Date: Sun, 01 Nov 2026 20:37:42 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,lukas.bulwahn@gmail.com,
	joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,
	kolyshkin@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-dont-warn-about-bug-in-userspace-code.patch added to mm-nonmm-unstable branch
Message-Id: <20261102043742.711CC1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: checkpatch: don't warn about BUG() in userspace code
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-dont-warn-about-bug-in-userspace-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-dont-warn-about-bug-in-userspace-code.patch

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
From: Kir Kolyshkin <kolyshkin@gmail.com>
Subject: checkpatch: don't warn about BUG() in userspace code
Date: Thu, 22 Oct 2026 15:44:22 -0700

The AVOID_BUG check says "Do not crash the kernel unless it is absolutely
unavoidable". This makes no sense for userspace code under tools/, where
BUG() and BUG_ON() are assert-like helpers provided by the kernel API
shims (e.g. in tools/testing/radix-tree), and crashing a test program on
an unexpected condition is fine.

Use is_userspace() to skip the check for such files.

Link: https://lore.kernel.org/20261022224426.2756960-4-kolyshkin@gmail.com
Signed-off-by: Kir Kolyshkin <kolyshkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
---

 scripts/checkpatch.pl |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-dont-warn-about-bug-in-userspace-code
+++ a/scripts/checkpatch.pl
@@ -4922,8 +4922,9 @@ sub process {
 			}
 		}
 
-# do not use BUG() or variants
-		if ($line =~ /\b(?!AA_|BUILD_|IDA_|KVM_|RWLOCK_|snd_|SPIN_)(?:[a-zA-Z_]*_)?BUG(?:_ON)?(?:_[A-Z_]+)?\s*\(/) {
+# do not use BUG() or variants (does not apply to userspace)
+		if (!is_userspace($realfile) &&
+		    $line =~ /\b(?!AA_|BUILD_|IDA_|KVM_|RWLOCK_|snd_|SPIN_)(?:[a-zA-Z_]*_)?BUG(?:_ON)?(?:_[A-Z_]+)?\s*\(/) {
 			my $msg_level = \&WARN;
 			$msg_level = \&CHK if ($file);
 			&{$msg_level}("AVOID_BUG",
_

Patches currently in -mm which might be from kolyshkin@gmail.com are

checkpatch-is_userspace-exclude-kernel-code-under-tools.patch
checkpatch-dont-warn-about-enosys-in-userspace-code.patch
checkpatch-dont-warn-about-bug-in-userspace-code.patch
checkpatch-dont-suggest-kstrtotype-in-userspace-code.patch

