Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6D8371D01
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028739; cv=none; b=pL5DM8Rc5TRaZvsVGF8Zv7fCump64zve0dW1usV7nHqvZQg6ocu87q+HNUMr382zG4itZ8YCNAticoPbzOEpZ+JTWspRvrgzd8q6xRXS4/CjzbQFZlS0d1q5m5f9H3BInAggsooUAvCUVmdEJnj8D4c/8RuPLiFvTy4cRV+c84U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028739; c=relaxed/simple;
	bh=+bZHuavL94mOF4dQV22rdLz0GJjaHCepzpf/PPSu9Jg=;
	h=Date:To:From:Subject:Message-Id; b=ArjU2aQ9xek0Lqux/52EOIQxwkYh+mX7dxwvXFChOdAiJsafMFvzSE7VZdYagy6I/D1pz+U12vs82wb7PZJdSFrDkqrcC1djKin5rohZ02oRGZdfDGQcxKCMeX3hfGcA97rOomr8dD/ykkMWQky9cDcksZPDgXZaU2+DhJ7W73M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d4y52BNI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d4y52BNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012C01F00898;
	Fri, 29 May 2026 04:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028738;
	bh=CS7xdpHgled+Z3PlgUqKvAPKz4cgmEov3ITd8uePDOg=;
	h=Date:To:From:Subject;
	b=d4y52BNIgDjRQ0s7MpnErrseiwMGrEszWR4ZRy7Bq/E3NmHUdhTBXkj81Fk+7QX5E
	 jhi3IIaqgm5RdnqZBYbRaMEPZQFg027mPB2RsRKHkB9U0B57VHGU/7OrXBHEcAtQyM
	 scndomWMurlmPVcKMF9XcBkJrXRGNl7W5BjkE9iA=
Date: Thu, 28 May 2026 21:25:37 -0700
To: mm-commits@vger.kernel.org,lukas.bulwahn@gmail.com,dwaipayanray1@gmail.com,dan.carpenter@linaro.org,apw@canonical.com,joe@perches.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-add-check-for-function-pointer-arrays-in-declarations.patch removed from -mm tree
Message-Id: <20260529042538.012C01F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: add check for function pointer arrays in declarations
has been removed from the -mm tree.  Its filename was
     checkpatch-add-check-for-function-pointer-arrays-in-declarations.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add check for function pointer arrays in declarations
Date: Sat, 18 Apr 2026 10:34:59 -0700

checkpatch did not allow function pointer arrays when testing
declaration blocks.

Add it.

Link: https://lore.kernel.org/eb62763085eb42193a611bca00a62d6f0ae72e1e.1776530118.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-add-check-for-function-pointer-arrays-in-declarations
+++ a/scripts/checkpatch.pl
@@ -4183,7 +4183,7 @@ sub process {
 			$pl =~ s/\b(?:$Attribute|$Sparse)\b//g;
 			if (($pl =~ /^\+\s+$Declare\s*$Ident\s*[=,;:\[]/ ||
 			# function pointer declarations
-			     $pl =~ /^\+\s+$Declare\s*\(\s*\*\s*$Ident\s*\)\s*[=,;:\[\(]/ ||
+			     $pl =~ /^\+\s+$Declare\s*\(\s*\*\s*$Ident(?:\s*\[\s*(?:$Ident|$Constant)?\s*\])?\s*\)\s*[=,;:\[\(]/ ||
 			# foo bar; where foo is some local typedef or #define
 			     $pl =~ /^\+\s+$Ident(?:\s+|\s*\*\s*)$Ident\s*[=,;\[]/ ||
 			# known declaration macros
@@ -4197,7 +4197,7 @@ sub process {
 			# looks like a declaration
 			    !($sl =~ /^\+\s+$Declare\s*$Ident\s*[=,;:\[]/ ||
 			# function pointer declarations
-			      $sl =~ /^\+\s+$Declare\s*\(\s*\*\s*$Ident\s*\)\s*[=,;:\[\(]/ ||
+			      $sl =~ /^\+\s+$Declare\s*\(\s*\*\s*$Ident(?:\s*\[\s*(?:$Ident|$Constant)?\s*\])?\s*\)\s*[=,;:\[\(]/ ||
 			# foo bar; where foo is some local typedef or #define
 			      $sl =~ /^\+\s+$Ident(?:\s+|\s*\*\s*)$Ident\s*[=,;\[]/ ||
 			# known declaration macros
_

Patches currently in -mm which might be from joe@perches.com are


