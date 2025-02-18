Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089653A1B6
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 04:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739852648; cv=none; b=sj2TeTmi+gxsHkCEewd1nul6iYdFLhnM9qFYS7dks7wTQUmcAb6ZGj8fxE2f18EK+FYVYDm8fUBdqfeNzD3x7nTOQJRCC9fBTGlrHGvPILkgHhISgVRKI5ayB8fFwShbvPFJQ1oIxAl0wGcIpp5YpQW5OUuwzxulV6UQx3mx2f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739852648; c=relaxed/simple;
	bh=aLsX8Jy5U4nCYW5DjSZHUxbohuKV8cGNv1TWfe6yKJY=;
	h=Date:To:From:Subject:Message-Id; b=bGEp+z8b8ZycnzWdvROZ8NCiZxWRGl93eZuYGggYAFYtVGpixYrElVFU3nlhQhzcTYO3RH40G70gt4WQbMSg+i6F3l/KTTw+AkyhUJyp5gTcWLDyz/nElwZadlBGL4edYGV64q7vGiQG2//gbuMPIYwKKWKJCV33oo1D6hpJepY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DiHJXyUq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DiHJXyUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B384C4CEE2;
	Tue, 18 Feb 2025 04:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739852647;
	bh=aLsX8Jy5U4nCYW5DjSZHUxbohuKV8cGNv1TWfe6yKJY=;
	h=Date:To:From:Subject:From;
	b=DiHJXyUq9/8HUUiCz+U30t8tdCtMYopfjAx56XhOtVupqLvSc4tGKE7+40ojJfylh
	 15XIuoAuIUtbUgY36vijAndPBviQn82NBC2Z71abQ4ep43GzJDGWmS1Ivx0y8n1CIf
	 ktOH5G4UsKvbsgGU9nlIaXbMEnBnR6AIRbOcEOyk=
Date: Mon, 17 Feb 2025 20:24:06 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,suchitkarunakaran@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-mm-fix-spelling-mistake.patch added to mm-unstable branch
Message-Id: <20250218042407.5B384C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation/mm: fix spelling mistake
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-mm-fix-spelling-mistake.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-mm-fix-spelling-mistake.patch

This patch will later appear in the mm-unstable branch at
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
From: Suchit K <suchitkarunakaran@gmail.com>
Subject: Documentation/mm: fix spelling mistake
Date: Sat, 15 Feb 2025 22:30:42 +0530

The word watermark was misspelled as "watemark".

Link: https://lkml.kernel.org/r/CAO9wTFhe4sf1eVVgijt2cdLPPsUHBj7B=HN-380_JSpve5KbvQ@mail.gmail.com
Signed-off-by: Suchit <suchitkarunakaran@gmail.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/balance.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/mm/balance.rst~documentation-mm-fix-spelling-mistake
+++ a/Documentation/mm/balance.rst
@@ -81,7 +81,7 @@ Page stealing from process memory and sh
 alleviate memory pressure on any zone in the page's node that has fallen below
 its watermark.
 
-watemark[WMARK_MIN/WMARK_LOW/WMARK_HIGH]/low_on_memory/zone_wake_kswapd: These
+watermark[WMARK_MIN/WMARK_LOW/WMARK_HIGH]/low_on_memory/zone_wake_kswapd: These
 are per-zone fields, used to determine when a zone needs to be balanced. When
 the number of pages falls below watermark[WMARK_MIN], the hysteric field
 low_on_memory gets set. This stays set till the number of free pages becomes
_

Patches currently in -mm which might be from suchitkarunakaran@gmail.com are

documentation-mm-fix-spelling-mistake.patch

