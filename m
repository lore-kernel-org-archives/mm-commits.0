Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1B93EBF1D
	for <mm-commits@vger.kernel.org>; Sun,  1 Feb 2026 00:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769905002; cv=none; b=Y6ANpx115/KIc8vDoRKn9toaCCeYLZwB+E/Zwm7/Wn1b33/i8tG76pYv9W5R6cV/u72gKecfmuD6qbo0N36p82SyIvaGEy1N56w3jpyG3qzyeG7cEThij1nVfMdP85SC+LHH0/M1rIuVZ3YQFbv2XgyWVU7Ssd92oqoJRZ+7H/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769905002; c=relaxed/simple;
	bh=J8xo8HkZWRgKsdzQs9PluAbsI2g5rdwzibmb1mNi/IQ=;
	h=Date:To:From:Subject:Message-Id; b=QypayBLsKpAaafrAhzIiNjAmUpLeWz+VsugQ8Fy0Tr5SL98+XCxDBulNhOLX4Qi959xL5/yoahEt/l9BIsbF/vu7tqOUYVQMNuFHckDRTcZiLaTbEzjKWk/fBSpCmYTfsqmQxQ7hD/0FJAeflB6uU9Gid5gi/xyOg6aA9AGQtQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tfTKasit; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tfTKasit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61ADAC4CEF1;
	Sun,  1 Feb 2026 00:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769905001;
	bh=J8xo8HkZWRgKsdzQs9PluAbsI2g5rdwzibmb1mNi/IQ=;
	h=Date:To:From:Subject:From;
	b=tfTKasitHev4vTbzaRaaq9O6Q/1ulFXYGFWEL9WidJUFZtK9tAojJswkrRcwftRnC
	 cW7JGy/xzBqCzcjzw1onXhatFFfZ3cKYm23MEPl0wAk1ECG/3YkP7X6FKmJ2FSyF+r
	 mMai1+91akh9OCyL35j2nMgus6JF25KcWtmP0eTU=
Date: Sat, 31 Jan 2026 16:16:40 -0800
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,sfr@canb.auug.org.au,namhyung@kernel.org,lukas.bulwahn@gmail.com,irogers@google.com,dwaipayanray1@gmail.com,apw@canonical.com,joe@perches.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-add-an-invalid-patch-separator-test.patch removed from -mm tree
Message-Id: <20260201001641.61ADAC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: add an invalid patch separator test
has been removed from the -mm tree.  Its filename was
     checkpatch-add-an-invalid-patch-separator-test.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


