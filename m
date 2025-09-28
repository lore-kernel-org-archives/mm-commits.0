Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD92F244698
	for <mm-commits@vger.kernel.org>; Sun, 28 Sep 2025 18:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759084635; cv=none; b=Y8852FwU8FUEoq+SVCAc7cf1pHMF8v4V66H5SvPO4+KVDZ89dT+jTuWpqb0us9orKDzM/fu456tBHQONQl+KedbLIP97tUY/5ESQUk+Cjh4WOh16pda5jSSxn1UnPMRDQJgKtYQwLdnYpM23BUsop3WZVSEQDnlEfN+21Lxg7DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759084635; c=relaxed/simple;
	bh=jKfFXtFLU0n6miP5EGK6za4kMIyT13kiW58YagN4GGo=;
	h=Date:To:From:Subject:Message-Id; b=qe8GiuTRGLfJVNl5CYQ3PBPd8D3kNkLgh5yfWofmZZsXN8VFcMpTpT8Huom50Y7jTfKW+pFig/lnYIR0c5lhsPVgaETFXWnUdsg3b1pYHSnnbRKUv29/vQsPZ4gOj4eJV9hnB1yUsen0OoToMIGIc5qE5AxGjnUGakWxDldtS3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yh4uEwlA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yh4uEwlA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DBC7C4CEF7;
	Sun, 28 Sep 2025 18:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759084634;
	bh=jKfFXtFLU0n6miP5EGK6za4kMIyT13kiW58YagN4GGo=;
	h=Date:To:From:Subject:From;
	b=Yh4uEwlArv7baGDvqGs9BYkfrfSox2Vkoi0vxkaRH8Ct9BA1LiNMBzhWq8loEUDuP
	 PPGJrVyRu0wHamIoVxpHv9SEPct0CrWeX0VaY/ROvxiEyYI5cDJQSdy3725jVnmeqY
	 +vcS9TtrPn9kh51lbMyi2XPgJsh5Nd5s8zmnRN7U=
Date: Sun, 28 Sep 2025 11:37:13 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,suchitkarunakaran@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-suppress-strscpy-warnings-for-userspace-tools.patch removed from -mm tree
Message-Id: <20250928183714.5DBC7C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: suppress strscpy warnings for userspace tools
has been removed from the -mm tree.  Its filename was
     checkpatch-suppress-strscpy-warnings-for-userspace-tools.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suchit Karunakaran <suchitkarunakaran@gmail.com>
Subject: checkpatch: suppress strscpy warnings for userspace tools
Date: Tue, 23 Sep 2025 22:47:21 +0530

The checkpatch.pl script currently warns against the use of strcpy,
strlcpy, and strncpy, recommending strscpy as a safer alternative. 
However, these warnings are also triggered for code under tools/ and
scripts/, which are userspace utilities where strscpy is not available. 
This patch suppresses these warnings for files in tools/ and scripts/.

Link: https://lkml.kernel.org/r/20250923171722.7798-1-suchitkarunakaran@gmail.com
Signed-off-by: Suchit Karunakaran <suchitkarunakaran@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-suppress-strscpy-warnings-for-userspace-tools
+++ a/scripts/checkpatch.pl
@@ -2636,6 +2636,11 @@ sub exclude_global_initialisers {
 		$realfile =~ m@/bpf/.*\.bpf\.c$@;
 }
 
+sub is_userspace {
+    my ($realfile) = @_;
+    return ($realfile =~ m@^tools/@ || $realfile =~ m@^scripts/@);
+}
+
 sub process {
 	my $filename = shift;
 
@@ -7018,21 +7023,20 @@ sub process {
 #				}
 #			}
 #		}
-
 # strcpy uses that should likely be strscpy
-		if ($line =~ /\bstrcpy\s*\(/) {
+		if ($line =~ /\bstrcpy\s*\(/ && !is_userspace($realfile)) {
 			WARN("STRCPY",
 			     "Prefer strscpy over strcpy - see: https://github.com/KSPP/linux/issues/88\n" . $herecurr);
 		}
 
 # strlcpy uses that should likely be strscpy
-		if ($line =~ /\bstrlcpy\s*\(/) {
+		if ($line =~ /\bstrlcpy\s*\(/ && !is_userspace($realfile)) {
 			WARN("STRLCPY",
 			     "Prefer strscpy over strlcpy - see: https://github.com/KSPP/linux/issues/89\n" . $herecurr);
 		}
 
 # strncpy uses that should likely be strscpy or strscpy_pad
-		if ($line =~ /\bstrncpy\s*\(/) {
+		if ($line =~ /\bstrncpy\s*\(/ && !is_userspace($realfile)) {
 			WARN("STRNCPY",
 			     "Prefer strscpy, strscpy_pad, or __nonstring over strncpy - see: https://github.com/KSPP/linux/issues/90\n" . $herecurr);
 		}
_

Patches currently in -mm which might be from suchitkarunakaran@gmail.com are


