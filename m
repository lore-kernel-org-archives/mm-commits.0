Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C734623BB
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 21:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716154319; cv=none; b=fE5DYw7ldUybxFUBbxZDTdZjmJIOL4Jfg6elEZGO4Y+J21VEFlyDJTj44EIAYveB2mOVjC4N+kFl6hX5KaR7g/kLE7UhM0iLzpkT4mKptNei+DxqTXMxryFlrsI6u8On6Vpka9s9sJ6SD4+SNOdTnu6CUhrMfJhnbltySOdlkUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716154319; c=relaxed/simple;
	bh=nDdcK7oSKa90Rx33qRiu2oKC1jgEikAd2sYEOoH5yTw=;
	h=Date:To:From:Subject:Message-Id; b=JV85bkAn8SiyzNRDYy1mUxEei1LxbGLYuBkeec1BfF4TqY6FXZcB/+6o5VVpougW1P942P+VnwhljLggBwloNT1sh+xRDWh8jtkGcpYEWACc6r6Vpb2rDgkid94MwzzVvyzxjNGb14RB2kaOCXXIbZZCyzkCWHi+Yzr5QBIkWCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iGjUVZCq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iGjUVZCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC45C32781;
	Sun, 19 May 2024 21:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716154319;
	bh=nDdcK7oSKa90Rx33qRiu2oKC1jgEikAd2sYEOoH5yTw=;
	h=Date:To:From:Subject:From;
	b=iGjUVZCqZHEbHppy4UzlBJRM6PlKbT3rX7F79uls+Bx3XL8ymf2mF5EHQy7g9z2fg
	 YWaZcBnkFQmSz9IoSMJFTbKqT5Mv+DIvS7UWwenkJjuOq7fX7thFZLnjSBZkC4O9GV
	 H7EYhxaNAV4wpyesgeV3aEjNEE1NJeOmfDJy0sCo=
Date: Sun, 19 May 2024 14:31:58 -0700
To: mm-commits@vger.kernel.org,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + backtracetest-add-module_description.patch added to mm-nonmm-unstable branch
Message-Id: <20240519213159.2FC45C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: backtracetest: add MODULE_DESCRIPTION()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     backtracetest-add-module_description.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/backtracetest-add-module_description.patch

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
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: backtracetest: add MODULE_DESCRIPTION()
Date: Sat, 18 May 2024 16:12:05 -0700

Fix the 'make W=1' warning:

WARNING: modpost: missing MODULE_DESCRIPTION() in kernel/backtracetest.o

Link: https://lkml.kernel.org/r/20240518-md-backtracetest-v1-1-fab9f942c139@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/backtracetest.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/backtracetest.c~backtracetest-add-module_description
+++ a/kernel/backtracetest.c
@@ -74,5 +74,6 @@ static void exitf(void)
 
 module_init(backtrace_regression_test);
 module_exit(exitf);
+MODULE_DESCRIPTION("Simple stack backtrace regression test module");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Arjan van de Ven <arjan@linux.intel.com>");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

backtracetest-add-module_description.patch

