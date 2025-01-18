Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997CC7FD
	for <mm-commits@vger.kernel.org>; Sat, 18 Jan 2025 04:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737173219; cv=none; b=XUCGf8g6DyfSn9pI2c0Gofvhr39gJV5OdXJUND4qZl8d1KXppa0JJqkbMDJi65wwoqMAS+9sqpzXP5U8EgP3MzwzKw3nGbHYYOVTSEpNtyr8zjKSMCTqHOlghV3qs/yaH01ipXfiYMu1kPUSDmmsjd2Blgk80/lswMIn7bdtAFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737173219; c=relaxed/simple;
	bh=l/U3m6IgEbeVfTpEc+Z11428RWfFeOa7LHx2KDHMQNk=;
	h=Date:To:From:Subject:Message-Id; b=Wo6ZL1otMtpM8uu/gw3gx9+t2HUdIzRc9bXb4gCFAKwzCxycVhBmhQ2/TChBwyRnofAjnXVoUkhfADH4wMI+L1tyGQZnnS7HJNDnrKOkMPphyDjKb0d6WN4jJCGHdyBHioEsdMYFYBuLLkygWK0U+IvcUWi5W9W+z1awsGpWXC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SfrRFYw6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SfrRFYw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5505C4CED1;
	Sat, 18 Jan 2025 04:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737173219;
	bh=l/U3m6IgEbeVfTpEc+Z11428RWfFeOa7LHx2KDHMQNk=;
	h=Date:To:From:Subject:From;
	b=SfrRFYw6USePiyU4rJlnoJekKiHhgmcLjcveBA3pvj31dri1lFaZQDaTGZg3gcHCx
	 7cEY5sG31TK4r49Qkwmu4VdfgdvaN78agju90Qq3IQIeCWoUq/mCK/XLftR9Oxlb1b
	 a89q8GXsyHcc8F5s35hhw1Kltc06MW/USJl3Fw1w=
Date: Fri, 17 Jan 2025 20:06:58 -0800
To: mm-commits@vger.kernel.org,bsingharora@gmail.com,yang.yang29@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-yang-yang-as-a-co-maintainer-of-per-task-delay-accounting.patch added to mm-nonmm-unstable branch
Message-Id: <20250118040658.E5505C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add Yang Yang as a co-maintainer of PER-TASK DELAY ACCOUNTING
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     maintainers-add-yang-yang-as-a-co-maintainer-of-per-task-delay-accounting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-yang-yang-as-a-co-maintainer-of-per-task-delay-accounting.patch

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
From: Yang Yang <yang.yang29@zte.com.cn>
Subject: MAINTAINERS: add Yang Yang as a co-maintainer of PER-TASK DELAY ACCOUNTING
Date: Fri, 17 Jan 2025 22:20:13 +0800 (CST)

Balbir Singh is the unique maintainer of PER-TASK DELAY ACCOUNTING, and he
had started work on cgroupstats a long time back, this subsystem then is
not growing at a very rapid pace.  With their excellent work delay
accounting is still very useful for observing and optimizing system delay,
but still needs continuous improvement.  Yang Yang with his team had
worked for most of the recent patches of the subsystem, and he has a
strong willing to help, Balbir Singh is glad to see that, so add him as a
co-maintainer.

Link: https://lkml.kernel.org/r/20250117222013817zWHgBaSigRI_eRJt1hqnu@zte.com.cn
Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-yang-yang-as-a-co-maintainer-of-per-task-delay-accounting
+++ a/MAINTAINERS
@@ -18311,6 +18311,7 @@ F:	mm/percpu*.c
 
 PER-TASK DELAY ACCOUNTING
 M:	Balbir Singh <bsingharora@gmail.com>
+M:	Yang Yang <yang.yang29@zte.com.cn>
 S:	Maintained
 F:	include/linux/delayacct.h
 F:	kernel/delayacct.c
_

Patches currently in -mm which might be from yang.yang29@zte.com.cn are

maintainers-add-yang-yang-as-a-co-maintainer-of-per-task-delay-accounting.patch

