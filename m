Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A8228EC
	for <mm-commits@vger.kernel.org>; Wed, 14 May 2025 02:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747190035; cv=none; b=qsv7YWin1PI0V028+pjSHL0Re175137OEjnevupUSbJj0winBSZcWnTSDRlfL9ei9MUUauNDHgImdRGQQwrfx/HiYeqA3fsbRjiADJ6KDW3YNmMEOciBYjp5I+9W51OPRvW8nPbjpcOFfG3RT1NRKYgaUoek9jvkrVT4s9SxmhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747190035; c=relaxed/simple;
	bh=iav8rE2TdsgEGN5Knu0r7kWSrQ/CcJNY6VdaFlUOnP0=;
	h=Date:To:From:Subject:Message-Id; b=Wg3EcyULKgwt5purZOFfUProUKs4sWy6xEbFhSyTqA+pGWngPASew15PMjAaKhNwddBMSaquY7tLKoYIP1OpC9g8Vg7HPlGRznowwo+XcYNx6V5gujKuVLc/Qlocz7hWNcYc0n9pT4rDYxwNzM2wSevCeuG9bGJa/IdBro8ZZik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=toLcxBrD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="toLcxBrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70606C4AF09;
	Wed, 14 May 2025 02:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747190034;
	bh=iav8rE2TdsgEGN5Knu0r7kWSrQ/CcJNY6VdaFlUOnP0=;
	h=Date:To:From:Subject:From;
	b=toLcxBrDBzcJ7F5I5t6J+Ym2RMZ9z8kDriIOUflWzYrxtyO0r2vrG94wG9bMIgn8T
	 kKmk93856x4cnq5crtm7MLc3C4W7hkgAQ9z3SXkrM4qzW/Kcm4M+zrb5DQueOvlGgt
	 2sgFK4Jo0Xtl5dnUTybPa14//ygJzrHPn/Gd6cx0=
Date: Tue, 13 May 2025 19:33:53 -0700
To: mm-commits@vger.kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-hung-task-detector-section.patch added to mm-hotfixes-unstable branch
Message-Id: <20250514023354.70606C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add hung-task detector section
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-hung-task-detector-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-hung-task-detector-section.patch

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
From: Lance Yang <lance.yang@linux.dev>
Subject: MAINTAINERS: add hung-task detector section
Date: Tue, 13 May 2025 13:22:34 +0800

The hung-task detector is missing in MAINTAINERS.  While it's been quiet
recently, I'm actively working on it and volunteering to review patches. 
Adding this section will make it easier for contributors to know who to
contact.

Link: https://lkml.kernel.org/r/20250513052234.46463-1-lance.yang@linux.dev
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/MAINTAINERS~maintainers-add-hung-task-detector-section
+++ a/MAINTAINERS
@@ -11099,6 +11099,14 @@ L:	linuxppc-dev@lists.ozlabs.org
 S:	Odd Fixes
 F:	drivers/tty/hvc/
 
+HUNG TASK DETECTOR
+M:	Andrew Morton <akpm@linux-foundation.org>
+R:	Lance Yang <lance.yang@linux.dev>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	include/linux/hung_task.h
+F:	kernel/hung_task.c
+
 I2C ACPI SUPPORT
 M:	Mika Westerberg <westeri@kernel.org>
 L:	linux-i2c@vger.kernel.org
_

Patches currently in -mm which might be from lance.yang@linux.dev are

maintainers-add-hung-task-detector-section.patch

