Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78392846F
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 11:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777031154; cv=none; b=SMOA5xsnVuw5+ZtbYGR1H7fDBWEk/x4fgmKZjLF7jklJuB7rXeMkxrLBxbYoix6dpuywB1cio4tkCMSdK1/Or91+9hae7XmGWCghAGL7IXy7kanFIu15dmoGx5qSTL6Mm2FVb2/bJS23fAuMDvQjt0iEVxGC+F7tr2hsO0+8A2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777031154; c=relaxed/simple;
	bh=ZRF8KOMAcjS+00ie57+cGEuqgLothAlA9B63E8kXI+s=;
	h=Date:To:From:Subject:Message-Id; b=MnMbxpdYTotAurhNISbLiczxwojc+ACrudRnPHivzSPc300B6gTz+gEUtNnBm+lcRRylrjm3n3iAqbCjI/NUcYEFprzSBidnpjADuZxrtgWxFfeejU9nrr8tZyHWajOJln08B3pEQnwitcllXKisN9qP/GIA4Z8ap4CkzQqLz5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JPss16w7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JPss16w7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA65C19425;
	Fri, 24 Apr 2026 11:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777031154;
	bh=ZRF8KOMAcjS+00ie57+cGEuqgLothAlA9B63E8kXI+s=;
	h=Date:To:From:Subject:From;
	b=JPss16w7TV2MASQ1f3/khCMUxLYF+TRj1Titl28YXlBvoLC77kWB4uG3O8K2MNbmI
	 3xLEktC9gmwe1CZt8tg5a7jWyjG4NbIDGSE/xyejzvmpTiG7aEY6ycM31nIj/TlAr7
	 KftASsrYpz8amo9M03lJPPc649c2yeAbJ1XurexA=
Date: Fri, 24 Apr 2026 04:45:53 -0700
To: mm-commits@vger.kernel.org,lukas.bulwahn@gmail.com,dwaipayanray1@gmail.com,dan.carpenter@linaro.org,apw@canonical.com,joe@perches.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-add-check-for-function-pointer-arrays-in-declarations.patch added to mm-nonmm-unstable branch
Message-Id: <20260424114554.1BA65C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: checkpatch: add check for function pointer arrays in declarations
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-add-check-for-function-pointer-arrays-in-declarations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-add-check-for-function-pointer-arrays-in-declarations.patch

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
@@ -4175,7 +4175,7 @@ sub process {
 			$pl =~ s/\b(?:$Attribute|$Sparse)\b//g;
 			if (($pl =~ /^\+\s+$Declare\s*$Ident\s*[=,;:\[]/ ||
 			# function pointer declarations
-			     $pl =~ /^\+\s+$Declare\s*\(\s*\*\s*$Ident\s*\)\s*[=,;:\[\(]/ ||
+			     $pl =~ /^\+\s+$Declare\s*\(\s*\*\s*$Ident(?:\s*\[\s*(?:$Ident|$Constant)?\s*\])?\s*\)\s*[=,;:\[\(]/ ||
 			# foo bar; where foo is some local typedef or #define
 			     $pl =~ /^\+\s+$Ident(?:\s+|\s*\*\s*)$Ident\s*[=,;\[]/ ||
 			# known declaration macros
@@ -4189,7 +4189,7 @@ sub process {
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

checkpatch-add-check-for-function-pointer-arrays-in-declarations.patch

