Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D5F1EEE6
	for <mm-commits@vger.kernel.org>; Mon, 15 Dec 2025 20:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765832276; cv=none; b=BZjwYyAZ9os4hAQxYqlH+fvWtcLuxYFUp24DVKedoCLPY8GTpl9wxp20JCiSUdkUrAmDqd06Bbb/dMu/XolfjzT2pSlzbfPWeEfXutR456K1oE6h1i2uilmOiOVpxZWkUUyIcheYIyIKQdwVDDjZYPswcKumIYwTIDy4O87uDqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765832276; c=relaxed/simple;
	bh=q/fQaEAw+p8ZPMFRxxx2wFcfX3WBpDUWROr6dFd6Zq0=;
	h=Date:To:From:Subject:Message-Id; b=Z0PyOTrPv4IJT1eE+G/SgfLf7P/5cTNGPoNxoeyiqsvpUA4MMvPYJgxfoQZQgp7MP+ahoTbZYupNAVT/O5I1fgNbChKipCgtLY40I/DBWD6OHYrAToAh0r2dCDxnPZROgY3ZwgYWesnjisY6N9KCcv2GhfdXG5WLLBoGmK+FM7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=itRc0Bqs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="itRc0Bqs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9B3C4CEF5;
	Mon, 15 Dec 2025 20:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765832275;
	bh=q/fQaEAw+p8ZPMFRxxx2wFcfX3WBpDUWROr6dFd6Zq0=;
	h=Date:To:From:Subject:From;
	b=itRc0BqsnHaVqwDQI2DKpMAB36CfyX3Phd/J+I94scqsQbopBnQ+YqhtYBhEJHhmU
	 R8VVQT7IMNvMiPCWzM3GgtYLVxAgUSdss0SPv7nOG1LC4hz0T8na8BXN4pLmby2xnF
	 C95FjmKYNC1dgDCyGVqWy3jWSjy8jqGdru43/oUU=
Date: Mon, 15 Dec 2025 12:57:54 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-abi-headers-to-kho-and-live-update.patch added to mm-hotfixes-unstable branch
Message-Id: <20251215205755.7B9B3C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add ABI headers to KHO and LIVE UPDATE
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-abi-headers-to-kho-and-live-update.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-abi-headers-to-kho-and-live-update.patch

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
From: Pratyush Yadav <pratyush@kernel.org>
Subject: MAINTAINERS: add ABI headers to KHO and LIVE UPDATE
Date: Fri, 12 Dec 2025 16:12:02 +0900

include/linux/kho is supposed to hold KHO headers.  Add it to KHO's
MAINTAINERS entry so the right people can get patches to it.

include/linux/kho/abi contains the live update ABI headers for LUO core
and memfd.  It will also hold ABI headers for other upcoming file types as
well.  Add it to live update entry so live update maintainers can get
changes for it (currently they happen to be the same people).

Link: https://lkml.kernel.org/r/20251212071204.398788-1-pratyush@kernel.org
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-abi-headers-to-kho-and-live-update
+++ a/MAINTAINERS
@@ -13959,6 +13959,7 @@ S:	Maintained
 F:	Documentation/admin-guide/mm/kho.rst
 F:	Documentation/core-api/kho/*
 F:	include/linux/kexec_handover.h
+F:	include/linux/kho/
 F:	kernel/liveupdate/kexec_handover*
 F:	lib/test_kho.c
 F:	tools/testing/selftests/kho/
@@ -14637,6 +14638,7 @@ S:	Maintained
 F:	Documentation/core-api/liveupdate.rst
 F:	Documentation/mm/memfd_preservation.rst
 F:	Documentation/userspace-api/liveupdate.rst
+F:	include/linux/kho/abi/
 F:	include/linux/liveupdate.h
 F:	include/linux/liveupdate/
 F:	include/uapi/linux/liveupdate.h
_

Patches currently in -mm which might be from pratyush@kernel.org are

maintainers-add-abi-headers-to-kho-and-live-update.patch

