Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9D078F52
	for <mm-commits@vger.kernel.org>; Tue, 17 Jun 2025 00:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750120229; cv=none; b=Bk0s0v6Ri+CkFrmPnP6y/qEHn6h+f7glw3dJouoYv1Fwf5dtawZVaFPPmQhh5d9qWlhabRk+uBnqP/mS+XEEiYQDn9vWFPU+Yai+V/QGWsmIr8ZYC2pspq8iPz6rScghf3+EI1G+UtLdKEfGY9+fhUKuACPSXdaGdkr2+FCmQFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750120229; c=relaxed/simple;
	bh=D0qv1rOR4weIbdlic1ciYuRfeiHlajHeIVGX2ZD6B1o=;
	h=Date:To:From:Subject:Message-Id; b=fGCdbhYLvHCfWnvp//WbQoDWLr9T9662SjRRo0PcN/cjG+8HrZy4M315+KxeW9aU79UL3tiUhN5nqUZlMuT8uj9RUnOIRS4MwTElR68zjwo9mhNi5O6mpkoymdnJ2KHEwUPFHwrikUZiEZG1r9I1Md3o1X1KMpGC4lK/8Mj3hHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eWI+GlEx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eWI+GlEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45DDC4CEEA;
	Tue, 17 Jun 2025 00:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750120228;
	bh=D0qv1rOR4weIbdlic1ciYuRfeiHlajHeIVGX2ZD6B1o=;
	h=Date:To:From:Subject:From;
	b=eWI+GlEx9DNRAMDexfclUhZEwk/3EZlIdoJiLnXieuSJXbSI/HeYVD+CCLz4HHmKL
	 VR8OA3xfjW4A6ZQvN5Cgf/yZ2qx4ql2+ejNy/eMqe2CE99qBZ3dwvixuliY69fRDM/
	 xn//a75FDnDcVSyRlhNIjDM5o+DBM5tE/ctiMKyM=
Date: Mon, 16 Jun 2025 17:30:28 -0700
To: mm-commits@vger.kernel.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,clement.legoffic@foss.st.com,apw@canonical.com,antonio.borneo@foss.st.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-use-utf-8-match-for-spell-checking.patch added to mm-nonmm-unstable branch
Message-Id: <20250617003028.B45DDC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: checkpatch: use utf-8 match for spell checking
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-use-utf-8-match-for-spell-checking.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-use-utf-8-match-for-spell-checking.patch

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
From: Antonio Borneo <antonio.borneo@foss.st.com>
Subject: checkpatch: use utf-8 match for spell checking
Date: Mon, 16 Jun 2025 09:59:13 +0200

The current code that checks for misspelling verifies, in a more
complex regex, if $rawline matches [^\w]($misspellings)[^\w]

Being $rawline a byte-string, a utf-8 character in $rawline can
match the non-word-char [^\w].
E.g.:
	./scripts/checkpatch.pl --git 81c2f059ab9
	WARNING: 'ment' may be misspelled - perhaps 'meant'?
	#36: FILE: MAINTAINERS:14360:
	+M:     Clément Léger <clement.leger@bootlin.com>
	            ^^^^

Use a utf-8 version of $rawline for spell checking.

Link: https://lkml.kernel.org/r/20250616-b4-checkpatch-upstream-v2-1-5600ce4a3b43@foss.st.com
Signed-off-by: Antonio Borneo <antonio.borneo@foss.st.com>
Signed-off-by: Clément Le Goffic <clement.legoffic@foss.st.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-use-utf-8-match-for-spell-checking
+++ a/scripts/checkpatch.pl
@@ -3502,9 +3502,10 @@ sub process {
 # Check for various typo / spelling mistakes
 		if (defined($misspellings) &&
 		    ($in_commit_log || $line =~ /^(?:\+|Subject:)/i)) {
-			while ($rawline =~ /(?:^|[^\w\-'`])($misspellings)(?:[^\w\-'`]|$)/gi) {
+			my $rawline_utf8 = decode("utf8", $rawline);
+			while ($rawline_utf8 =~ /(?:^|[^\w\-'`])($misspellings)(?:[^\w\-'`]|$)/gi) {
 				my $typo = $1;
-				my $blank = copy_spacing($rawline);
+				my $blank = copy_spacing($rawline_utf8);
 				my $ptr = substr($blank, 0, $-[1]) . "^" x length($typo);
 				my $hereptr = "$hereline$ptr\n";
 				my $typo_fix = $spelling_fix{lc($typo)};
_

Patches currently in -mm which might be from antonio.borneo@foss.st.com are

checkpatch-use-utf-8-match-for-spell-checking.patch

