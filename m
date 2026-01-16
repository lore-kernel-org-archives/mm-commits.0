Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56538145348
	for <mm-commits@vger.kernel.org>; Fri, 16 Jan 2026 20:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768596507; cv=none; b=V8LEoljlQNgS3BHQa+lpVVA4kvSHFVKfTWCFuI61Y/tJcrppEAHLrutSjfxp0EuzyDnlEVT5+ZZdXA75lFAVq0u0kNF4kjAkeX6+gc4fAQyzzKEaMVe7lQlG9uYklo24kkjEN2oXut1b96g7QHT8aR9ucEjakkwzfjvufDCqv8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768596507; c=relaxed/simple;
	bh=5FkwOhh6ZMwsYTV8yN20rOr5+p4Trp+If4nmNKFQXC4=;
	h=Date:To:From:Subject:Message-Id; b=PG2wEGYBR9a49SQ5pgqLPHHbfXY3nVUjzyqIZvGVbVxL/rdrQYbVOnoEAOdR51nJgyGaAlfvhnPZFpfsete3AC6lpTkxxDcT8Ql/3vij4lJgnMSUGwCPulwq3gTWMgCsWKJsjkQEm4dcyyDtETRrtdnzsKZA4i4Pr/Ef5MHlOd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0OtkSsvG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0OtkSsvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6895C116C6;
	Fri, 16 Jan 2026 20:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768596506;
	bh=5FkwOhh6ZMwsYTV8yN20rOr5+p4Trp+If4nmNKFQXC4=;
	h=Date:To:From:Subject:From;
	b=0OtkSsvGallYHY44olHmW5YJXd1BBJwYrUhunIKtvIuBaiv4iLIDWzUPI3LYFE2W4
	 il9pVKEnNryyUzhlKQlP3QSDuZ6vcuc4iPeHlzQU6J9gnNehsKxIVOzGPLyLQGRXkQ
	 EU/wf3FWrrPfFWnBwg3XNJq6c4NA5M1AZfpvpED4=
Date: Fri, 16 Jan 2026 12:48:26 -0800
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,sfr@canb.auug.org.au,namhyung@kernel.org,lukas.bulwahn@gmail.com,irogers@google.com,dwaipayanray1@gmail.com,apw@canonical.com,joe@perches.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-add-an-invalid-patch-separator-test.patch added to mm-nonmm-unstable branch
Message-Id: <20260116204826.C6895C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: checkpatch: add an invalid patch separator test
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-add-an-invalid-patch-separator-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-add-an-invalid-patch-separator-test.patch

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
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add an invalid patch separator test
Date: Fri, 16 Jan 2026 09:42:52 -0800

Some versions of tools that apply patches incorrectly allow lines that
start with 3 dashes and have additional content on the same line.

Checkpatch will now emit an ERROR on these lines and optionally convert
those lines from dashes to equals with --fix.

Link: https://lkml.kernel.org/r/6ec1ed08328340db42655287afd5fa4067316b11.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Suggested-by: Ian Rogers <irogers@google.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Namhyung kim <namhyung@kernel.org>
Cc: Stehen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/checkpatch.rst |    5 +++++
 scripts/checkpatch.pl                  |   10 ++++++++++
 2 files changed, 15 insertions(+)

--- a/Documentation/dev-tools/checkpatch.rst~checkpatch-add-an-invalid-patch-separator-test
+++ a/Documentation/dev-tools/checkpatch.rst
@@ -601,6 +601,11 @@ Commit message
 
     See: https://www.kernel.org/doc/html/latest/process/submitting-patches.html#describe-your-changes
 
+  **BAD_COMMIT_SEPARATOR**
+    The commit separator is a single line with 3 dashes.
+    The regex match is '^---$'
+    Lines that start with 3 dashes and have more content on the same line
+    may confuse tools that apply patches.
 
 Comparison style
 ----------------
--- a/scripts/checkpatch.pl~checkpatch-add-an-invalid-patch-separator-test
+++ a/scripts/checkpatch.pl
@@ -3031,6 +3031,16 @@ sub process {
 			}
 		}
 
+# Check for invalid patch separator
+		if ($in_commit_log &&
+		    $line =~ /^---.+/) {
+			if (ERROR("BAD_COMMIT_SEPARATOR",
+				  "Invalid commit separator - some tools may have problems applying this\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$fixlinenr] =~ s/-/=/g;
+			}
+		}
+
 # Check for patch separator
 		if ($line =~ /^---$/) {
 			$has_patch_separator = 1;
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-add-an-invalid-patch-separator-test.patch

