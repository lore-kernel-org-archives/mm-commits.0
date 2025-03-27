Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154AA1A3150
	for <mm-commits@vger.kernel.org>; Thu, 27 Mar 2025 17:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743097921; cv=none; b=kiPGX2Uc9+VON3DmHthP7A8QmDztalbWnQwTD07/aKL7iHuRcUaQfhjXGmMGN8Gqj9rB9tUiIOEbeYz4vOiBUVCREneZMsH6KfB4DsjMo8+n93Rzr55FNEg32yZ1z4Y+o7wEweUIPKj971Rav8NaLrFucBgJILSBdhGFzVPMI4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743097921; c=relaxed/simple;
	bh=lHhGkF/DNKFPeP1Ubj8kkzsBETzKYwUGQyHDE5eHp1U=;
	h=Date:To:From:Subject:Message-Id; b=evRsHJEGSvCB6RmEZPfY55AUiemYaP0IRxfqS98EnzHyeyz6L/OunHsNxypfAky0iz+0+11WqwdiqR7+MRQdS7gHGKXLdaztETuKo8OxrsLKumoo51L6DXF3RpfJQ0qWDX7qqzuj6Uakc5aLCXRHarMNUY8zOQXc0zYOdBOAwks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gPLGi4iY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gPLGi4iY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B907C4CEDD;
	Thu, 27 Mar 2025 17:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743097920;
	bh=lHhGkF/DNKFPeP1Ubj8kkzsBETzKYwUGQyHDE5eHp1U=;
	h=Date:To:From:Subject:From;
	b=gPLGi4iY8j8Y/zM50dqqx9A9rQNTkTiNOuaY17j6jvbQwlE7+HLxGUIln+W0hRx5q
	 DbQUK1aQBo6sRi+uexI5R3foOp0lTymKRO91tjEpHAAYoKw49W8rIzbwamrISV/7Xd
	 cE0qDjyfAQpgMloDn8BnNpZE3lcpbidz6PZjCSCw=
Date: Thu, 27 Mar 2025 10:51:59 -0700
To: mm-commits@vger.kernel.org,nicolas@fjasle.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-an-entry-for-nicolas-schier.patch added to mm-nonmm-unstable branch
Message-Id: <20250327175200.7B907C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: Add an entry for Nicolas Schier
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-add-an-entry-for-nicolas-schier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-an-entry-for-nicolas-schier.patch

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
From: Nicolas Schier <nicolas@fjasle.eu>
Subject: mailmap: Add an entry for Nicolas Schier
Date: Wed, 26 Mar 2025 21:13:55 +0100

Add mapping to linux.dev address as mail usage at work is limited and my
mail provider for private mails is suffering from its own domain name
block lists.

Link: https://lkml.kernel.org/r/20250326-mailmap-add-entry-for-nicolas-v1-1-3c26579a7fdf@fjasle.eu
Signed-off-by: Nicolas Schier <nicolas@fjasle.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-add-an-entry-for-nicolas-schier
+++ a/.mailmap
@@ -546,6 +546,8 @@ Nicolas Pitre <nico@fluxnic.net> <nicola
 Nicolas Pitre <nico@fluxnic.net> <nico@linaro.org>
 Nicolas Saenz Julienne <nsaenz@kernel.org> <nsaenzjulienne@suse.de>
 Nicolas Saenz Julienne <nsaenz@kernel.org> <nsaenzjulienne@suse.com>
+Nicolas Schier <nicolas.schier@linux.dev> <n.schier@avm.de>
+Nicolas Schier <nicolas.schier@linux.dev> <nicolas@fjasle.eu>
 Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
 Nikolay Aleksandrov <razor@blackwall.org> <naleksan@redhat.com>
 Nikolay Aleksandrov <razor@blackwall.org> <nikolay@redhat.com>
_

Patches currently in -mm which might be from nicolas@fjasle.eu are

mailmap-add-an-entry-for-nicolas-schier.patch

