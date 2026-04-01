Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCD826299
	for <mm-commits@vger.kernel.org>; Wed,  1 Apr 2026 03:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775012981; cv=none; b=bb3rbI8eiTu0EMX8dqB27Y3ok/jYHZ93ap26GxFKv21z/KvpbBQ+xaPMBIxr59Z5Qeu4+UczxTg0Gd2XmCjX6eYYmcCVan8ZuDbXuAks1aP+5xll/i8nnCTbjgjL2c6H1Zj2VgkKOi51TgxKQCil4k+7ttWAnYeGjxIpnznHUrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775012981; c=relaxed/simple;
	bh=ki20QyqOI648N2zFQMEAgyngAoKrTCQiMu00jieuslc=;
	h=Date:To:From:Subject:Message-Id; b=bK6Etpvk7x0SIaQAOtt/hfBjPCOi+3iD/XCXLNA+E/6hqqjeok+OHgAsAT1Ifds+5VkgZbi6SCyjEko2ZAHJBcCOgXRoKBPHEq9PxP9OV4hpiSt5zVa8U/fcbaoYCMHSp62pxvJtM2h2JRJrkrBEUU+B5bohRHJB65bTydHIOWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mUUZ0l2+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mUUZ0l2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4DAC19423;
	Wed,  1 Apr 2026 03:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775012980;
	bh=ki20QyqOI648N2zFQMEAgyngAoKrTCQiMu00jieuslc=;
	h=Date:To:From:Subject:From;
	b=mUUZ0l2+tCp7voxA/kQnT+WToMoRofoPFUpKv6XRg3mw4l+Ld5KxXCz4tg75A/FTp
	 SECw0VwzcThLmIogM5wHEnj91ULHNj/tF31T6J4DiwK9rULvIpYtlQOPxdnoKgXB+v
	 53Zf+wSYDJ7gNH7V8ue03pAeir/r+oiGzy9AUcMc=
Date: Tue, 31 Mar 2026 20:09:40 -0700
To: mm-commits@vger.kernel.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,tknelms@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-exclude-forward-declarations-of-const-structs.patch added to mm-nonmm-unstable branch
Message-Id: <20260401030940.BE4DAC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: checkpatch: exclude forward declarations of const structs
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-exclude-forward-declarations-of-const-structs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-exclude-forward-declarations-of-const-structs.patch

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
From: Taylor Nelms <tknelms@google.com>
Subject: checkpatch: exclude forward declarations of const structs
Date: Tue, 31 Mar 2026 14:15:09 -0400

Limit checkpatch warnings for normally-const structs by excluding patterns
consistent with forward declarations.

For example, the forward declaration `struct regmap_access_table;` in a
header file currently generates a warning recommending that it is
generally declared as const; however, this would apply a useless type
qualifier in the empty declaration `const struct regmap_access_table;`,
and subsequently generate compiler warnings.

Link: https://lkml.kernel.org/r/20260331181509.1258693-1-tknelms@google.com
Signed-off-by: Taylor Nelms <tknelms@google.com>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-exclude-forward-declarations-of-const-structs
+++ a/scripts/checkpatch.pl
@@ -7512,10 +7512,10 @@ sub process {
 		}
 
 # check for various structs that are normally const (ops, kgdb, device_tree)
-# and avoid what seem like struct definitions 'struct foo {'
+# and avoid what seem like struct definitions 'struct foo {' or forward declarations 'struct foo;'
 		if (defined($const_structs) &&
 		    $line !~ /\bconst\b/ &&
-		    $line =~ /\bstruct\s+($const_structs)\b(?!\s*\{)/) {
+		    $line =~ /\bstruct\s+($const_structs)\b(?!\s*[\{;])/) {
 			WARN("CONST_STRUCT",
 			     "struct $1 should normally be const\n" . $herecurr);
 		}
_

Patches currently in -mm which might be from tknelms@google.com are

checkpatch-exclude-forward-declarations-of-const-structs.patch

