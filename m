Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CD6330B04
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967326; cv=none; b=GgCn+FMWAVfjOkuIcb/z55B3BYfS90+/dBtNR+ASQgiuVLVPODqA+TZwg6KQn1eziLITY5A5d61/pysMCWHIhS+IFJHh+OvFG/Py0sv/8y9l5TJGaIZ7HNFkQd/jQbzq5IFYcKVwzymgljGKbQUdBVj7JQmbes38xXZ/T2cMMDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967326; c=relaxed/simple;
	bh=VrAVOv7m1/rA3SaR3WIn3x3xC8vMXbaHcDznRyRhh1M=;
	h=Date:To:From:Subject:Message-Id; b=u+RMz8yVgb81oceZ59Qv3IAJonS1wWOjSf7H8KKTju1yVoNguYSrhkrY8aFSXYcDh9VjFAq5bL+rtmZHIl6BGDi6RWzGKlDoJfmD1n4PMfQu4KidZSohqoWJc9d/Fekxu0PeYXqNk64CwoiNAWyHo/+E+gNtLw7vIpIfgmxQO64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rotzsyce; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rotzsyce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8225FC16AAE;
	Wed, 21 Jan 2026 03:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967325;
	bh=VrAVOv7m1/rA3SaR3WIn3x3xC8vMXbaHcDznRyRhh1M=;
	h=Date:To:From:Subject:From;
	b=RotzsycesWO1qQdRrrX2nc+MGTbZ1UANmeoqYnbwEatvf59u+W48OoGwYrcfYRBE1
	 OLdlwS3p+4buSN6KNzLpxb+uP9Frk+IeEDIyBmltrRgDbKfTyazUW/cYSbi8/XLiY5
	 fPGx5tEwvg7Q8MGlaJ2JcdV8Ky5d56djEIe2ABS8=
Date: Tue, 20 Jan 2026 19:48:44 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,torvalds@linux-foundation.org,mhocko@suse.com,macro@orcam.me.uk,linux@rasmusvillemoes.dk,kees@kernel.org,jannh@google.com,glider@google.com,elver@google.com,dvyukov@google.com,chris.bazley.wg14@gmail.com,alx@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-fix-off-by-one-benign-bugs.patch removed from -mm tree
Message-Id: <20260121034845.8225FC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel: fix off-by-one benign bugs
has been removed from the -mm tree.  Its filename was
     kernel-fix-off-by-one-benign-bugs.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alejandro Colomar <alx@kernel.org>
Subject: kernel: fix off-by-one benign bugs
Date: Thu, 11 Dec 2025 11:44:00 +0100

We were wasting a byte due to an off-by-one bug.  s[c]nprintf() doesn't
write more than $2 bytes including the null byte, so trying to pass
'size-1' there is wasting one byte.

This is essentially the same as the previous commit, in a different
file.

Link: https://lkml.kernel.org/r/b4a945a4d40b7104364244f616eb9fb9f1fa691f.1765449750.git.alx@kernel.org
Signed-off-by: Alejandro Colomar <alx@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Christopher Bazley <chris.bazley.wg14@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcsan/kcsan_test.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/kcsan/kcsan_test.c~kernel-fix-off-by-one-benign-bugs
+++ a/kernel/kcsan/kcsan_test.c
@@ -176,7 +176,7 @@ static bool __report_matches(const struc
 
 	/* Title */
 	cur = expect[0];
-	end = &expect[0][sizeof(expect[0]) - 1];
+	end = ARRAY_END(expect[0]);
 	cur += scnprintf(cur, end - cur, "BUG: KCSAN: %s in ",
 			 is_assert ? "assert: race" : "data-race");
 	if (r->access[1].fn) {
@@ -200,7 +200,7 @@ static bool __report_matches(const struc
 
 	/* Access 1 */
 	cur = expect[1];
-	end = &expect[1][sizeof(expect[1]) - 1];
+	end = ARRAY_END(expect[1]);
 	if (!r->access[1].fn)
 		cur += scnprintf(cur, end - cur, "race at unknown origin, with ");
 
_

Patches currently in -mm which might be from alx@kernel.org are


