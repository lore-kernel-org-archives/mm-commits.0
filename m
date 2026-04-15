Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C658E2D0C9D
	for <mm-commits@vger.kernel.org>; Wed, 15 Apr 2026 09:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776244557; cv=none; b=mC01+u4lgipCn8w3vdRYrSAPEGs9QgYLIpuJxXRXR67MJ1gS6f+0+xoW2wv6GFEJg3HGDuO4p1m2nbWZ08z+FeIp0fKOBUPytFXTFFYHjVMtZKuJKQkxD1+uEnrE0ZdyRm7ucrPl0v/fvzFu0mRpoBItRmoyJX+Aw1ITG0uEFZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776244557; c=relaxed/simple;
	bh=2PvLo3XT+vifsSjo4XDCLMtZgbSE/fbcA60qKuNjHFw=;
	h=Date:To:From:Subject:Message-Id; b=j+NYEODas21DlVBkn39JkAU1I+KeS4NtLTvT8Dcb/Bc/MdWc8LdaWU2B0oRfMxwrqsqD4w80I3h6GxH3BJAwZzykpLDm6xYQxEWTb/d6AqUUja0VB2eTfohJOIMxlbteNUPvcKBpW2W76/WUc+6yBIA0Z8jUuXhRGNIAQjb+UUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R/faJIS1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R/faJIS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE67C19424;
	Wed, 15 Apr 2026 09:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776244557;
	bh=2PvLo3XT+vifsSjo4XDCLMtZgbSE/fbcA60qKuNjHFw=;
	h=Date:To:From:Subject:From;
	b=R/faJIS158kD1NWW1xqB6Ggt2oUljHZ9D+aRQi9gy3CTNEzmZpuhFjELaUvBteT22
	 dkJde22QtPJTM+1yke1MIMS5J4WZ/wGj7BWWceqD+3QkRSc8MeRb/7s8ggGIEAb/w9
	 syxLihMQuwrjz8fkOqAN58KW5XmfeWkZKQ+6x+B4=
Date: Wed, 15 Apr 2026 02:15:53 -0700
To: mm-commits@vger.kernel.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,tknelms@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-exclude-forward-declarations-of-const-structs.patch removed from -mm tree
Message-Id: <20260415091556.DCE67C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: exclude forward declarations of const structs
has been removed from the -mm tree.  Its filename was
     checkpatch-exclude-forward-declarations-of-const-structs.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


