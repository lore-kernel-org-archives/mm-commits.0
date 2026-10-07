Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC7D351C22
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338699; cv=none; b=dzPbNT42ae7gVMsHjtpl1lhfRT+BJirUQCQKwYtynFzyeb8Z3zVpHYjswEMkmAPclBu+Hu1gOeVsjDuZuaaHq3ysN9dDJ6OCbDSsePv1Lb9C54/EJyVmOeiowiL1l/ncmIsNulT7xuGxQnxwheYfx+WKDEFERV4PxtBlF/FcZWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338699; c=relaxed/simple;
	bh=YYCHg7FWD6FPRafKca1oPz4udd3oSLyB/+ojx0ciBw0=;
	h=Date:To:From:Subject:Message-Id; b=Q22HTwQbwlt2lQ91RYhE6OySBZR51N4EUzpVTl876CO1YQ24Rj8hFpl9ZUuKaNBMvqtWqx61j6fyjolZxSWN/Jf4r0GlhHCHS/89TRHULgG1ImgfH/6f6yljwhIa8lIrb+4xImS/dI9+ty+WSVNjXZpuLqYlrSIDNx4nTG5BV9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rfi8ow1x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rfi8ow1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE241F0089B;
	Wed,  7 Oct 2026 02:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338698;
	bh=Y2OSW1iKO84TArj8PXkzJsdmk7YJ1QK3J6I5QmJ0x1E=;
	h=Date:To:From:Subject;
	b=rfi8ow1x/fwD6FHac+d8nwweuir9iXKypp8cYInqqPtUb6FkP4Mczo1L9KXwTKlRl
	 5gJwurDsX7p2EIwpg0v5DlikxEsh/paIWdk0e6sGCJSWygN+xecSJswHQRmfT0UOGF
	 4RvZroJS5K9xYGp1bUgfwrODNpQDju61NS6G1ceY=
Date: Tue, 06 Oct 2026 19:04:58 -0700
To: mm-commits@vger.kernel.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,pvorel@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-skip-kernel-specific-checks-for-userspace.patch removed from -mm tree
Message-Id: <20261007020458.7DE241F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: skip kernel specific checks for userspace
has been removed from the -mm tree.  Its filename was
     checkpatch-skip-kernel-specific-checks-for-userspace.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
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


