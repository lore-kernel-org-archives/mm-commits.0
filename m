Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BE51A9FA8
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671955; cv=none; b=U+yzBQ9fNL6wLcSKTnUCJZ5M/CcsFFxRxtoxro5s4srWP/X3ivkyzDdbs81mM+iO0ZSEHbWFu8MfxlNw3L0g1tYfYIfB2vVQr17EW6UeOby+WndVBZe70DSbO3HL/K452LOUKu++qDYugRo+DiuTcj99g/CZ2a8rq2PICtHrLPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671955; c=relaxed/simple;
	bh=82xoMyiwl65wKPSc6PzDKSq7diYqu60fBKp0tG1ifMI=;
	h=Date:To:From:Subject:Message-Id; b=a9ZJaO8GRjWLCePfqgg1g9CwqhniZ3U4YkN1lupF548erJg87I/Xs/cGFArAS6ifxzMAxWldnTJ4g18vjGtzbE2PQUm+pcJKklkcazXvFIZOGpdhlKDN/IRrJQsIr26XN4ZH8vHSDKpsiqfAQ4nuctdjpyasXkyGt4d9MrJXkFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nW/kqxBS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nW/kqxBS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2810CC4CEF7;
	Sat, 28 Mar 2026 04:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671955;
	bh=82xoMyiwl65wKPSc6PzDKSq7diYqu60fBKp0tG1ifMI=;
	h=Date:To:From:Subject:From;
	b=nW/kqxBSeU+sLAUyG19RNM5RgeMCDEtKAqldwak89zInU01MF90B33c1AKmlJ9XTr
	 w7y/tFk9zWdg9d5W0IBftSS7YEPbnRnCs8F8ACAW6FFw/Uw4mgvQCZ3nmZLj6XDYCs
	 2xWnbf5gG7xxK2oYpODAf94KZFCc+/U6go8AmOOA=
Date: Fri, 27 Mar 2026 21:25:54 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,dyoung@redhat.com,bhe@redhat.com,ebiggers@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-crash-remove-inclusion-of-crypto-sha1h.patch removed from -mm tree
Message-Id: <20260328042555.2810CC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/crash: remove inclusion of crypto/sha1.h
has been removed from the -mm tree.  Its filename was
     kernel-crash-remove-inclusion-of-crypto-sha1h.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Eric Biggers <ebiggers@kernel.org>
Subject: kernel/crash: remove inclusion of crypto/sha1.h
Date: Sat, 14 Mar 2026 13:42:43 -0700

Several files related to kernel crash dumps include crypto/sha1.h but
never use any of its functionality.  Remove these includes so that these
files don't unnecessarily come up in searches for which kernel code is
still using the obsolete SHA-1 algorithm.

Link: https://lkml.kernel.org/r/20260314204243.45001-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c    |    2 --
 kernel/crash_reserve.c |    2 --
 kernel/vmcore_info.c   |    2 --
 3 files changed, 6 deletions(-)

--- a/kernel/crash_core.c~kernel-crash-remove-inclusion-of-crypto-sha1h
+++ a/kernel/crash_core.c
@@ -27,8 +27,6 @@
 #include <asm/page.h>
 #include <asm/sections.h>
 
-#include <crypto/sha1.h>
-
 #include "kallsyms_internal.h"
 #include "kexec_internal.h"
 
--- a/kernel/crash_reserve.c~kernel-crash-remove-inclusion-of-crypto-sha1h
+++ a/kernel/crash_reserve.c
@@ -20,8 +20,6 @@
 #include <asm/page.h>
 #include <asm/sections.h>
 
-#include <crypto/sha1.h>
-
 #include "kallsyms_internal.h"
 #include "kexec_internal.h"
 
--- a/kernel/vmcore_info.c~kernel-crash-remove-inclusion-of-crypto-sha1h
+++ a/kernel/vmcore_info.c
@@ -18,8 +18,6 @@
 #include <asm/page.h>
 #include <asm/sections.h>
 
-#include <crypto/sha1.h>
-
 #include "kallsyms_internal.h"
 #include "kexec_internal.h"
 
_

Patches currently in -mm which might be from ebiggers@kernel.org are


