Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33D73126B0
	for <mm-commits@vger.kernel.org>; Sun,  6 Sep 2026 01:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788657738; cv=none; b=kAB18sF1jnWs7m+oyC48ZgEme1tSi2RA8tY0UHS4pxY29u/bHyskDh6VjXAcX2KkJDvuy4668lqzG7etOEzrNk+5TrUJX6chu/yNqQMU3krWSA7m51M/Q1VvmfXpO+F9qJFQaOVE/e8o0u+Yae7OADr4aMT1XZxbpxYAE+txz/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788657738; c=relaxed/simple;
	bh=3y0taDbZEOwcW4CdeKaWMqJKkFHKlaEgMbOg7GJgj08=;
	h=Date:To:From:Subject:Message-Id; b=IYVmTteVx5WsqUIPgnEbsAPX5E5kbzJUtYeKo7a5dvrj3EAjhSnErMBiz3PjbD7NSCRgN48oaisUX8ofpsv13+ddXcYesPqxUE7rhCjz60LogiF2a5yYQn9ToVKjcdaDl0QfiqAGPlDCeq0R0T74WfqZYem+wUCHxr/nRFHzMv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g1i2sdVw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g1i2sdVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A97F1F00A3A;
	Sun,  6 Sep 2026 01:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788657736;
	bh=zzEbuneJABHIedkpd+6ANDDy13kmQFbRHp5Z3jTDbXk=;
	h=Date:To:From:Subject;
	b=g1i2sdVwMaBVAIi1ioCoyeOd8+nTI98IKqdLkH4VrPVZcQNy/4o/P5dTgtyr8aYst
	 94R8VxMZS4ovmhxQQqH+/DIBPN27nFiSfVf8yWBpCc80uK58Zg6NAJ4mC/d0htJkFT
	 Xyf4bEhPRL3JtQb1C7uWxd72MZxxe7jzsfHPfSW0=
Date: Sat, 05 Sep 2026 18:22:15 -0700
To: mm-commits@vger.kernel.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,pvorel@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-skip-kernel-specific-checks-for-userspace.patch added to mm-nonmm-unstable branch
Message-Id: <20260906012216.3A97F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: checkpatch: skip kernel specific checks for userspace
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-skip-kernel-specific-checks-for-userspace.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-skip-kernel-specific-checks-for-userspace.patch

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
Subject: checkpatch: skip kernel specific checks for userspace
Date: Fri, 4 Sep 2026 13:02:30 +0200

These check are kernel specific, do not warn about it when testing
userspace code:

* BIT_MACRO
* LONG_UDELAY
* MSLEEP
* PREFER_KERNEL_TYPES
* USLEEP_RANGE

This is a follow-up to 99b70ece33d8 ("checkpatch: suppress strscpy
warnings for userspace tools").

Link: https://lore.kernel.org/20260904110230.1219037-5-pvorel@suse.cz
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-skip-kernel-specific-checks-for-userspace
+++ a/scripts/checkpatch.pl
@@ -6696,7 +6696,8 @@ sub process {
 		}
 
 # prefer usleep_range over udelay
-		if ($line =~ /\budelay\s*\(\s*(\d+)\s*\)/) {
+		if (!is_userspace($realfile) &&
+			$line =~ /\budelay\s*\(\s*(\d+)\s*\)/) {
 			my $delay = $1;
 			# ignore udelay's < 10, however
 			if (! ($delay < 10) ) {
@@ -6710,7 +6711,8 @@ sub process {
 		}
 
 # warn about unexpectedly long msleep's
-		if ($line =~ /\bmsleep\s*\((\d+)\);/) {
+		if (!is_userspace($realfile) &&
+			$line =~ /\bmsleep\s*\((\d+)\);/) {
 			if ($1 < 20) {
 				WARN("MSLEEP",
 				     "msleep < 20ms can sleep for up to 20ms; see function description of msleep().\n" . $herecurr);
@@ -6932,7 +6934,7 @@ sub process {
 
 # check for c99 types like uint8_t used outside of uapi/ and tools/
 		if ($realfile !~ m@\binclude/uapi/@ &&
-		    $realfile !~ m@\btools/@ &&
+		    !is_userspace($realfile) &&
 		    $line =~ /\b($Declare)\s*$Ident\s*[=;,\[]/) {
 			my $type = $1;
 			if ($type =~ /\b($typeC99Typedefs)\b/) {
@@ -7182,6 +7184,7 @@ sub process {
 # check usleep_range arguments
 		if ($perl_version_ok &&
 		    defined $stat &&
+		    !is_userspace($realfile) &&
 		    $stat =~ /^\+(?:.*?)\busleep_range\s*\(\s*($FuncArg)\s*,\s*($FuncArg)\s*\)/) {
 			my $min = $1;
 			my $max = $7;
@@ -7425,6 +7428,7 @@ sub process {
 
 # check for #defines like: 1 << <digit> that could be BIT(digit), it is not exported to uapi
 		if ($realfile !~ m@^include/uapi/@ &&
+		    !is_userspace($realfile) &&
 		    $line =~ /#\s*define\s+\w+\s+\(?\s*1\s*([ulUL]*)\s*\<\<\s*(?:\d+|$Ident)\s*\)?/) {
 			my $ull = "";
 			$ull = "_ULL" if (defined($1) && $1 =~ /ll/i);
_

Patches currently in -mm which might be from pvorel@suse.cz are

checkpatch-skip-camelcase-cache-for-no-tree-without-root.patch
checkpatch-add-more-userspace-directories-to-is_userspace.patch
checkpatch-ignore-inttypesh-format-macros-for-userspace-tools.patch
checkpatch-add-userspace-to-force-userspace-rules.patch
checkpatch-skip-kernel-specific-checks-for-userspace.patch

