Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CD85BAC5
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970543; cv=none; b=oxwZMxO3zYXF8ranH7Pf3dZwSolVHAIQ/0QBoNoT8YqI9kmmNzZjiLHHmkFrtPn88SoNBToEuxxdzPWvTPDk9SHOFs9vqADQEtb0lL9pOTqqwVkDN6jRZ1qRAwb6MOqxor8LWzV4tttKnkC5z2QCsSpB81RlxwMpyfdpsLeKyqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970543; c=relaxed/simple;
	bh=9pD1ThO4s918LVXFld6YxyubJ5i7hOxZsUZmmnPGSlc=;
	h=Date:To:From:Subject:Message-Id; b=iuXQ8Np6gPb53xMaM0ly8XZQtGsEQf8QPW8fB8ZVjY0nJWLXDP5i2LOMwqyIHNVXw8A6hj2deUxHW+cdhijo3liyFHtVa9Q5qoMKJwHC8JObea314Yj9dfc3n59nI77z7wtKUvttaJs+OIXgeGxXM2N87YbnvybKEdyZGElIZa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lHwRdCEf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lHwRdCEf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA12C433F1;
	Tue, 23 Jan 2024 00:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970543;
	bh=9pD1ThO4s918LVXFld6YxyubJ5i7hOxZsUZmmnPGSlc=;
	h=Date:To:From:Subject:From;
	b=lHwRdCEfT/sR3H4v1RPmdYo1tbP9qYhpHyUn2pMgMukLSePDBpqFe0Ke6EDa6mumR
	 eNIe03Uu+/hWMcAfBB75xFG7DBteGMUBlWFJB3yrId3NzsExQ6vUxVxiJlDB0KqjaS
	 RQ0TDjSzxuN4q/Enk60PSl6LkS2zOz3o20kBTg1s=
Date: Mon, 22 Jan 2024 16:42:20 -0800
To: mm-commits@vger.kernel.org,geert+renesas@glider.be,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-dhry-remove-unneeded-linux-mutexh.patch added to mm-nonmm-unstable branch
Message-Id: <20240123004223.3DA12C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: dhry: remove unneeded <linux/mutex.h>
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-dhry-remove-unneeded-linux-mutexh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-dhry-remove-unneeded-linux-mutexh.patch

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
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: lib: dhry: remove unneeded <linux/mutex.h>
Date: Mon, 22 Jan 2024 15:50:43 +0100

Patch series "lib: dhry: miscellaneous cleanups".

This patch series contains a few miscellaneous cleanups for the
Dhrystone benchmark test.


This patch (of 3):

The Dhrystone benchmark test does not use mutexes.

Link: https://lkml.kernel.org/r/cover.1705934853.git.geert+renesas@glider.be
Link: https://lkml.kernel.org/r/cf8fafaedccf96143f1513745c43a457480bfc24.1705934853.git.geert+renesas@glider.be
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dhry_run.c |    1 -
 1 file changed, 1 deletion(-)

--- a/lib/dhry_run.c~lib-dhry-remove-unneeded-linux-mutexh
+++ a/lib/dhry_run.c
@@ -10,7 +10,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/mutex.h>
 #include <linux/smp.h>
 
 #define DHRY_VAX	1757
_

Patches currently in -mm which might be from geert+renesas@glider.be are

lib-dhry-remove-unneeded-linux-mutexh.patch
lib-dhry-use-ktime_ms_delta-helper.patch
lib-dhry-add-missing-closing-parenthesis.patch

