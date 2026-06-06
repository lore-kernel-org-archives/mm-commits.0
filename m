Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0290122DFA4
	for <mm-commits@vger.kernel.org>; Sat,  6 Jun 2026 01:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780709124; cv=none; b=DLrD1XSFdBYAixYPYuWR/+XU2Ky0+k1mWjyCDDvhKXOJ3etH+Kr8MH1wJdE5QIYDRVuvrgcA4BdZoC/PHKR533JNUYdgmAEPNCYziv216Ae3RGJmW91yUF5vGQvO2OGX8C0H4qEBSElf8GB72MmlSUWipAt7OnfoNPF0/1lm92U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780709124; c=relaxed/simple;
	bh=aaQvnHkQ9wSfpS8JHeCNzZi3QWHokwLwPX6HEEl5FgI=;
	h=Date:To:From:Subject:Message-Id; b=Rxuzi3Td1ATkxXRid8BAiNXxodhj3FuLzQuC/2SevTT2nUcT0+pEOZBXoegJTDcU/THwiAYxxlWjpf03GIFGdRdyXgKuoxBDnOreSclU6xP1X7gssBJvHA5DPq+hWaof+ndxbWJVsFVmyi5yOmllU7X9JZSTR4S6mXuyW5xjgSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cmK6g7CG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cmK6g7CG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939471F00893;
	Sat,  6 Jun 2026 01:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780709122;
	bh=fsCOzE7gWFerrswhEUaxdbCbonspE7orjUgIlPUiopw=;
	h=Date:To:From:Subject;
	b=cmK6g7CGUkkFAhM0rv35/QXRibY1laHEyouaM0OIQAeM6Fv8+YKED9Gu6PBY96/A6
	 +pRWjhaqbp6C+groW3jvBZTaEoKtVstEZXQiIH20+XrNdAEwu0cdzA/6Joc6XC/2rK
	 /9rrrCQk68miO77rNY9+bJS2Zk9TBhQ2tTx0T63s=
Date: Fri, 05 Jun 2026 18:25:22 -0700
To: mm-commits@vger.kernel.org,pvorel@suse.cz,niecheng1@uniontech.com,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,cryolitia@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-suppress-warnings-when-reported-by-is-followed-by-link.patch added to mm-nonmm-unstable branch
Message-Id: <20260606012522.939471F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: checkpatch: cuppress warnings when Reported-by: is followed by Link:
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-suppress-warnings-when-reported-by-is-followed-by-link.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-suppress-warnings-when-reported-by-is-followed-by-link.patch

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
From: Cryolitia PukNgae <cryolitia@uniontech.com>
Subject: checkpatch: cuppress warnings when Reported-by: is followed by Link:
Date: Fri, 05 Jun 2026 14:57:04 +0800

> The tag should be followed by a Closes: tag pointing to the report,
> unless the report is not available on the web. The Link: tag can be
> used instead of Closes: if the patch fixes a part of the issue(s)
> being reported.

According to Documentation/process/submitting-patches.rst, Link: is also
acceptable to follow a Reported-by:, if the patch fixes a part of the
issue(s) being reported.

Link: https://lore.kernel.org/20260605-checkpatch-v1-1-8c68ae618513@linux.dev
Signed-off-by: Cryolitia PukNgae <cryolitia@uniontech.com>
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Cheng Nie <niecheng1@uniontech.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-suppress-warnings-when-reported-by-is-followed-by-link
+++ a/scripts/checkpatch.pl
@@ -3253,10 +3253,10 @@ sub process {
 			if ($sign_off =~ /^reported(?:|-and-tested)-by:$/i) {
 				if (!defined $lines[$linenr]) {
 					WARN("BAD_REPORTED_BY_LINK",
-					     "Reported-by: should be immediately followed by Closes: with a URL to the report\n" . $herecurr . "\n");
-				} elsif ($rawlines[$linenr] !~ /^closes:\s*/i) {
+					     "Reported-by: should be immediately followed by Closes: or Link: with a URL to the report\n" . $herecurr . "\n");
+				} elsif ($rawlines[$linenr] !~ /^(closes|link):\s*/i) {
 					WARN("BAD_REPORTED_BY_LINK",
-					     "Reported-by: should be immediately followed by Closes: with a URL to the report\n" . $herecurr . $rawlines[$linenr] . "\n");
+					     "Reported-by: should be immediately followed by Closes: or Link: with a URL to the report\n" . $herecurr . $rawlines[$linenr] . "\n");
 				}
 			}
 		}
_

Patches currently in -mm which might be from cryolitia@uniontech.com are

checkpatch-suppress-warnings-when-reported-by-is-followed-by-link.patch

