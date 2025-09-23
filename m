Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC0326CE17
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 20:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758660962; cv=none; b=gMKYA8+Raw/5Lan7Me0PqDAodKImyE7TH11Dbximdu5wy0lCbqJuouIiXC1q7wBb2+2cWOt9XJ8e+3y323IItV24LDU1f+Y8Rr/sFdPm+68Nn4ohlz5xcn8LUoY6vmli2mts8+iLSVFFruVC1UKriWy1P9DW+ODK4XZqK/MQgug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758660962; c=relaxed/simple;
	bh=Z3+8VI5F3nMpedeGVY4hwYKGg9j02CQpBRxW0H8nAE0=;
	h=Date:To:From:Subject:Message-Id; b=UNXZX5aMVZgqumiZn1CeWFyix3eHZj8WYlzuIx47fedcUlMRtkTeewroD29Z9bbs8yCHUOZq1wdCyaCvP+5+8ylC9XpmEbS84QVDEuwMBR+E3DK7hVE501kZz/dP4bjUvZBL3x4IH5rvkZDebMsXTPIiRabPJq69MJK6dTZTCRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1fTYExz3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1fTYExz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C94AC4CEF5;
	Tue, 23 Sep 2025 20:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758660961;
	bh=Z3+8VI5F3nMpedeGVY4hwYKGg9j02CQpBRxW0H8nAE0=;
	h=Date:To:From:Subject:From;
	b=1fTYExz3RJuIzcA7m/SzwlfkCLTj9T3SxjUo9bgPOTRj/b1ylDI1/eyXWWEwzyf84
	 5QHAJxF3CX9Qc0JSqVrCOYb9ETa8S6/E5VJsb2NHl/zSVS/Hqf8r6H1FZ7EarJFJ0s
	 UoGfFPhdDMve+Zm8MCFMTB7OpDGEJs3xHVY0ASVE=
Date: Tue, 23 Sep 2025 13:56:00 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,suchitkarunakaran@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-suppress-strscpy-warnings-for-userspace-tools.patch added to mm-nonmm-unstable branch
Message-Id: <20250923205601.5C94AC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: checkpatch: suppress strscpy warnings for userspace tools
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-suppress-strscpy-warnings-for-userspace-tools.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-suppress-strscpy-warnings-for-userspace-tools.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

checkpatch-suppress-strscpy-warnings-for-userspace-tools.patch

