Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B26387581
	for <mm-commits@vger.kernel.org>; Sat, 14 Mar 2026 22:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773526278; cv=none; b=tFsvPHShbkudjfwcWb70Lrv/rEZ7mwmr28utB46WrA1dfq4rv8KD3wDA+hYltHgu8WYVCOL+pGRG9FqXXoY5iaXL6j/AsrzaCHXtWz06ylsd/xX+PLmy5rg110vLrknUwoeKDv6YxdVTrmdiMbf2/S2Mm6w0imtOZ/KWYN/4bCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773526278; c=relaxed/simple;
	bh=0XgA9rZU7nWNQlPT/NRpYIwoq7HTxk8scoaVzbTcuFM=;
	h=Date:To:From:Subject:Message-Id; b=Jp6+If9vgCbm5/ScUB4+4QkBm/RBeAqvGBBrFjGYTOVGklTazrzrc4u3X5/leQowS5CD8FiR1lGPmaUJDUthnnvSwMUiL8mQcUW52/INpvQagIwqtKMlHu2IvkOdHDrJzTsHbs7tvj8BsFY2PeXxO9qm4I0W1xe8+xazUv5I7V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bMkR7kRv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bMkR7kRv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80B6C116C6;
	Sat, 14 Mar 2026 22:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773526276;
	bh=0XgA9rZU7nWNQlPT/NRpYIwoq7HTxk8scoaVzbTcuFM=;
	h=Date:To:From:Subject:From;
	b=bMkR7kRv88AixCyZIKJtiEIKyilisSroTRnySAlq6aZ9ECYhf6HCuRywZMJC3+1+M
	 62XzALk1U5/Z9BCMEwtyeEnsoQW4b19QLnahfR+co3zzX8Sncfx1MEevFX27HTYIiY
	 j8p1H4RxCbhqccrsOJL8bpPWJUCQCecWM2uxZi3s=
Date: Sat, 14 Mar 2026 15:11:15 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,dyoung@redhat.com,bhe@redhat.com,ebiggers@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-crash-remove-inclusion-of-crypto-sha1h.patch added to mm-nonmm-unstable branch
Message-Id: <20260314221115.E80B6C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/crash: remove inclusion of crypto/sha1.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-crash-remove-inclusion-of-crypto-sha1h.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-crash-remove-inclusion-of-crypto-sha1h.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

kernel-crash-remove-inclusion-of-crypto-sha1h.patch

