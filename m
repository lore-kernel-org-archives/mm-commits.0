Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4885183077
	for <mm-commits@vger.kernel.org>; Wed,  3 Jul 2024 20:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720039902; cv=none; b=S/F7TEkYh1Ucgu0HsYymMaZga7wGNvMeiIE9hjKU5DonBUgn6i4cbD8AZ0ZS2nDNo394YVVCXx0qCv864kygOkmDP3Ce2mFKfUw7ooPzuz5MHd7yqfUcRGBzY56CiwS0DF79vcovZfbVm8k3xLlubi7CX3E2NglVgk1EMa3miyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720039902; c=relaxed/simple;
	bh=2WNPwNLxfo6j5WRJte6s795QclInNT+ddods68adqfY=;
	h=Date:To:From:Subject:Message-Id; b=gXnYVoMAbMtbChuGjIHmLq9zYCC9KO96iUnRynmk0kEWdc8LZyD+vZeN9mtKhgrH2g+tEGueJ9LY3d/2z/i4RSNfFMD+L0RiPxT8XksqSr5dd612eXJ7lVBZXdvMOHAjx5qpCh2JxJ2bvAcJ9h+Neoq8th6q7p61o4Ehs97I3js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oV5nkvMB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oV5nkvMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22307C2BD10;
	Wed,  3 Jul 2024 20:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720039902;
	bh=2WNPwNLxfo6j5WRJte6s795QclInNT+ddods68adqfY=;
	h=Date:To:From:Subject:From;
	b=oV5nkvMBpsFP7fw4pwulGInhwgaQJLpl7EAPm6YL8lOFFEF9tUcZM6vepFyo3zn5/
	 xrqs6z5MbDnbY2URjHdtc7PcxuhsmsX9pQx00yT5L1jUXzRVB6tcau9EtBYy+z0LyZ
	 iCXTQxBiP612RDPI4Q8SUJx/cnO/uSkUryy8XRZI=
Date: Wed, 03 Jul 2024 13:51:41 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,jiaqiyan@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-add-enable_soft_offline-sysctl-fix-fix.patch added to mm-unstable branch
Message-Id: <20240703205142.22307C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs-mm-add-enable_soft_offline-sysctl-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-add-enable_soft_offline-sysctl-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-add-enable_soft_offline-sysctl-fix-fix.patch

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
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: docs-mm-add-enable_soft_offline-sysctl-fix-fix
Date: Mon, 1 Jul 2024 23:37:55 -0700

there are more blank lines needed

Link: https://lkml.kernel.org/r/CACw3F52_obAB742XeDRNun4BHBYtrxtbvp5NkUincXdaob0j1g@mail.gmail.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |    3 +++
 1 file changed, 3 insertions(+)

--- a/Documentation/admin-guide/sysctl/vm.rst~docs-mm-add-enable_soft_offline-sysctl-fix-fix
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -299,8 +299,11 @@ the request to soft offline the pages.
 
 It is worth mentioning that after setting enable_soft_offline to 0, the
 following requests to soft offline pages will not be performed:
+
 - Request to soft offline pages from RAS Correctable Errors Collector.
+
 - On ARM, the request to soft offline pages from GHES driver.
+
 - On PARISC, the request to soft offline pages from Page Deallocation Table.
 
 extfrag_threshold
_

Patches currently in -mm which might be from jiaqiyan@google.com are

mm-memory-failure-refactor-log-format-in-soft-offline-code.patch
mm-memory-failure-userspace-controls-soft-offlining-pages.patch
mm-memory-failure-userspace-controls-soft-offlining-pages-v7.patch
selftest-mm-test-enable_soft_offline-behaviors.patch
selftest-mm-test-enable_soft_offline-behaviors-v7.patch
docs-mm-add-enable_soft_offline-sysctl.patch
docs-mm-add-enable_soft_offline-sysctl-fix.patch
docs-mm-add-enable_soft_offline-sysctl-fix-fix.patch

