Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CEF14B097
	for <mm-commits@vger.kernel.org>; Wed, 31 Jul 2024 22:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722464635; cv=none; b=CaPdQoOtyvB81u4UyC7tvx/Hyye4aqfYJ7lUS/FcCsplYtb3eFR8OjekPgwcgKhoaWGrRoIXM1a6dG20qlqZiW6nEGPUAFLjEGbG/NkupQ9anCukraaJ32IWpC3m4XiuWv0Q3OHZDnZ1qsltGoII4Cbc1iL60MXcZEMKxU3TVu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722464635; c=relaxed/simple;
	bh=xOoUKj8qWaSeJsq65xXXy2Cq2E2yJ5ooa/GHJybheJc=;
	h=Date:To:From:Subject:Message-Id; b=pg07uZRCziVzNnPb8vo3iTUUiXPZ/6BeIDfyQ2OwtcAxeRP5QAzLlXtLBQ+lgLHgYS3+A0+o2tMFIbCEmrSJ7tZeu9mPNOktoU6mKtCsav748GFAfmZ1xHrIfwdASu+P+kuDXWHsNOY25tv8Fueyt7f/vbJzb1/3SLvufem9flY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i2ou5PNu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i2ou5PNu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B82DC116B1;
	Wed, 31 Jul 2024 22:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722464634;
	bh=xOoUKj8qWaSeJsq65xXXy2Cq2E2yJ5ooa/GHJybheJc=;
	h=Date:To:From:Subject:From;
	b=i2ou5PNuhf3tKaaegquKdAROTI9dDVIzcFjON1UMzauK7cavtLCwg5Cbeew/jHD35
	 nRRFeWh13GlWWYDUdOxNbSj5boovsX2xyseUmoIv7+va8oZahM1a+F6TIcODm1as8V
	 OjY/HDxJlFqcLzVWhmYn8vcItmtN+FMImxtKTCUA=
Date: Wed, 31 Jul 2024 15:23:53 -0700
To: mm-commits@vger.kernel.org,akinobu.mita@gmail.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + failcmd-make-failcmdsh-executable.patch added to mm-nonmm-unstable branch
Message-Id: <20240731222354.5B82DC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: failcmd: make failcmd.sh executable
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     failcmd-make-failcmdsh-executable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/failcmd-make-failcmdsh-executable.patch

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
From: Breno Leitao <leitao@debian.org>
Subject: failcmd: make failcmd.sh executable
Date: Mon, 29 Jul 2024 01:52:11 -0700

Change the file permissions of tools/testing/fault-injection/failcmd.sh to
allow execution.  This ensures the script can be run directly without
explicitly invoking a shell.

Link: https://lkml.kernel.org/r/20240729085215.3403417-1-leitao@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 0 files changed

diff --git a/tools/testing/fault-injection/failcmd.sh~failcmd-make-failcmdsh-executable a/tools/testing/fault-injection/failcmd.sh
old mode 100644
new mode 100755
_

Patches currently in -mm which might be from leitao@debian.org are

failcmd-add-script-file-in-maintainers.patch
fault-injection-enhance-failcmd-to-exit-on-non-hex-address-input.patch
failcmd-make-failcmdsh-executable.patch

