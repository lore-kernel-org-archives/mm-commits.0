Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA6A1CD3B
	for <mm-commits@vger.kernel.org>; Sat, 11 May 2024 21:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715464225; cv=none; b=LTydUmLSeZdZgnGTehnw1QGKQ7BaEaA+Bt8XwHVWRUaotiFysgTM0IkGOwJE/pgcla5rS2doGlO5hdEbK1iTiSlA8GNHFdovvUerie3OhZ34uTCqaayI8DUfoJCS6OWytSXz9SC0hSPci5MgdFmn2hUJsdHwfk983Oq1+Aj0aA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715464225; c=relaxed/simple;
	bh=CUuNyCnJApszxqXD7HJnS3291tJUdNzD3nUcVzdpCew=;
	h=Date:To:From:Subject:Message-Id; b=DYJe9lMeSPXCnNjWfm2ailpHiWuFCYv17L+CgYaJD5uKXyXLRTmSEXEaRFo+tYbSYthlzwDacIUmoo9UWRTvhB3ud6eUyByWgpBoAAVzrfO3sfbA8NDj/zqU2tOctObuZwW5Qekq1c/PE0xbO5LTcaZU02P/4SwXKAoYgPyf/jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TtpUCXwC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TtpUCXwC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D7BC2BBFC;
	Sat, 11 May 2024 21:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715464225;
	bh=CUuNyCnJApszxqXD7HJnS3291tJUdNzD3nUcVzdpCew=;
	h=Date:To:From:Subject:From;
	b=TtpUCXwCwmYJLlotr+H+SBA7MUe/MntVyZOk6AZNwwv/8IdDThiKRuwavmhwm71U7
	 E6g592sAcyx1kXd5BWEiM1rpSzIg0do4WWJHgFJf2EAed0qrIk00OGRituHkqNq3g3
	 NouMwgdY9v3IRO+wRH8b1SEJjOC4dQY0L7mLqCms=
Date: Sat, 11 May 2024 14:50:24 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,jeffxu@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftest-mm-mseal-read-only-elf-memory-segment-fix-4.patch removed from -mm tree
Message-Id: <20240511215025.60D7BC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftest mm/mseal: fix arm build
has been removed from the -mm tree.  Its filename was
     selftest-mm-mseal-read-only-elf-memory-segment-fix-4.patch

This patch was dropped because it was folded into selftest-mm-mseal-read-only-elf-memory-segment.patch

------------------------------------------------------
From: Jeff Xu <jeffxu@chromium.org>
Subject: selftest mm/mseal: fix arm build
Date: Thu, 2 May 2024 22:53:31 +0000

Add include linux/mman.h to fix arm build.  Fix a typo.

Link: https://lkml.kernel.org/r/20240502225331.3806279-2-jeffxu@chromium.org
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
Suggested-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com> 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mseal_test.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/mseal_test.c~selftest-mm-mseal-read-only-elf-memory-segment-fix-4
+++ a/tools/testing/selftests/mm/mseal_test.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #define _GNU_SOURCE
+#include <linux/mman.h>
 #include <sys/mman.h>
 #include <stdint.h>
 #include <unistd.h>
@@ -29,7 +30,7 @@
 # define PKEY_DISABLE_WRITE     0x2
 #endif
 
-#ifndef PKEY_BITS_PER_KEY
+#ifndef PKEY_BITS_PER_PKEY
 #define PKEY_BITS_PER_PKEY      2
 #endif
 
_

Patches currently in -mm which might be from jeffxu@chromium.org are

mseal-wire-up-mseal-syscall.patch
mseal-add-mseal-syscall.patch
selftest-mm-mseal-memory-sealing.patch
mseal-add-documentation.patch
selftest-mm-mseal-read-only-elf-memory-segment.patch

