Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179FF43ABD
	for <mm-commits@vger.kernel.org>; Fri,  6 Dec 2024 01:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733448307; cv=none; b=OOz9aQhFM5hyxxezBSw1kmdXbehmFIw80Jyscuu24qpPH3dopPGfUEzEwAwsYhWj3qR0mMkvJFtK8aDaqMIMpWx6kOT+aP4huyVFnHCeJybHyy0ch9i2r7BYXsJEqiakN/6MSIe6DK2k8fTkBnx1vDC5tgzR1kNdUYACYrZOOoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733448307; c=relaxed/simple;
	bh=PG4QMuZhW3rIU1qmkxajHmV0V6xpShmNRx/LeG3/9SM=;
	h=Date:To:From:Subject:Message-Id; b=Cf0wWMBArVTAA4uoH6BiqdgR2hauV7Vtca1Nj0Ny4q3rv0pUhqMr1mXlORgrQAD2oiccoxRK/Or51UJJMPrtI56gD5Ryk1d5c/245frQ+nkDG6THeXoiC+2esVQ78GgFnBg0ROJxSc1/xcL+if9wFxfL0B0DQuYrFrO7186no5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TixOSAUt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TixOSAUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ADEBC4CED1;
	Fri,  6 Dec 2024 01:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733448306;
	bh=PG4QMuZhW3rIU1qmkxajHmV0V6xpShmNRx/LeG3/9SM=;
	h=Date:To:From:Subject:From;
	b=TixOSAUt7tLGIgx8jjJwJHXfWLrRKF6NLTT7WnK11GIfDmRkI9J4wwi4R5AERRVKN
	 e0l2FYnWLDDs0ukdY7zupOsveRWrr+9lM+5u4T8xmX5dkPzlG2doVizNSGyayxvT+4
	 75aIhrd0ng8leOiy47AKuEuLW+SgUrX4gDL5NdwA=
Date: Thu, 05 Dec 2024 17:25:05 -0800
To: mm-commits@vger.kernel.org,huang.ying.caritas@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entry-for-ying-huang.patch added to mm-hotfixes-unstable branch
Message-Id: <20241206012506.7ADEBC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: add entry for Ying Huang
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-entry-for-ying-huang.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entry-for-ying-huang.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Huang Ying <huang.ying.caritas@gmail.com>
Subject: mailmap: add entry for Ying Huang
Date: Thu, 5 Dec 2024 20:42:01 +0800

Map my old company email to my personal email.

Link: https://lkml.kernel.org/r/20241205124201.529308-1-huang.ying.caritas@gmail.com
Signed-off-by: "Huang, Ying" <huang.ying.caritas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-ying-huang
+++ a/.mailmap
@@ -735,6 +735,7 @@ Wolfram Sang <wsa@kernel.org> <w.sang@pe
 Wolfram Sang <wsa@kernel.org> <wsa@the-dreams.de>
 Yakir Yang <kuankuan.y@gmail.com> <ykk@rock-chips.com>
 Yanteng Si <si.yanteng@linux.dev> <siyanteng@loongson.cn>
+Ying Huang <huang.ying.caritas@gmail.com> <ying.huang@intel.com>
 Yusuke Goda <goda.yusuke@renesas.com>
 Zack Rusin <zack.rusin@broadcom.com> <zackr@vmware.com>
 Zhu Yanjun <zyjzyj2000@gmail.com> <yanjunz@nvidia.com>
_

Patches currently in -mm which might be from huang.ying.caritas@gmail.com are

mailmap-add-entry-for-ying-huang.patch

