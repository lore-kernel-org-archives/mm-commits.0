Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D5E1D5146
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334128; cv=none; b=tUm4CmHU1jjDAbQhSzlRy3odi9MzJdku/WJ5dsB2UPWyryxk+aOniIxvFQMlTm1O5cb4Etxt+dCvFQS+fnyhtfND9DRrSWPNDqjLA5BGCShX9TQ/tk/oGEvNxfbZmJbWT+iMPrqR1Z9ZdaWlfNdm7Ypr0jHwW9Df3izf69EMwbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334128; c=relaxed/simple;
	bh=6rRr443CE5jcRO9BpVvs7Fe3j0bMusAWDbA6o2V9/OM=;
	h=Date:To:From:Subject:Message-Id; b=tuczLFPqasNhheXFeCW+ndaG7mHwOvj41yxcqEJELsmTNgh8gjCliCVdijlyYKnpPtR8UabZ5cRi4+6/h8k1Oe5vfKKxz4yhlsFuFDXpLCig2eY4Wlxi9CEu+O26by/LeiqOvGbDPUlq6kuFLGHMOzldf0V1T4dcJeMf/WlsyyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TNl26IBy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TNl26IBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6CD1F0089B;
	Wed,  7 Oct 2026 00:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334127;
	bh=5ujT0LCVCAe+i+l7kJe/nWCoCqVIphW+U6vJ999mLkI=;
	h=Date:To:From:Subject;
	b=TNl26IByrdEtWW6RN+mlFR2Mrfrw+nr3hkQHc2Gr0XjVfq6I5ir/MY/a/DObDbHQ7
	 QPvGPFEHdkpGsWSGBCwrUpi4xWEulaLX8gNDEHY1mC4QxddieYbdV0P1EP3nsXqB/L
	 Y9fecAekVAJ6hUzNTl8EiSTvbLRWpoA8xTfEQYYQ=
Date: Tue, 06 Oct 2026 17:48:46 -0700
To: mm-commits@vger.kernel.org,yury.khrustalev@arm.com,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kevin.brodsky@arm.com,david@kernel.org,hemanth.selam@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-remove-the-local-pkey_unrestricted-fallback.patch removed from -mm tree
Message-Id: <20261007004847.4B6CD1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: remove the local PKEY_UNRESTRICTED fallback
has been removed from the -mm tree.  Its filename was
     selftests-mm-remove-the-local-pkey_unrestricted-fallback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hemanth Selam <hemanth.selam@gmail.com>
Subject: selftests/mm: remove the local PKEY_UNRESTRICTED fallback
Date: Tue, 25 Aug 2026 21:47:15 +0530

pkey-helpers.h defines PKEY_UNRESTRICTED itself when the macro is not
already known, a stopgap from when the generic definition was still under
review.  It has been merged since, commit 6d61527d931b ("mm/pkey: Add
PKEY_UNRESTRICTED macro"), so the guard is never taken and the FIXME can
be honoured.

The definition comes from tools/include/uapi/asm-generic/mman-common.h via
TOOLS_INCLUDES, which commit e076eaca5906 ("selftests: break the
dependency upon local header files") added so that the mm selftests build
without "make headers".  It is reached through the <asm-generic/mman.h>
that the system <asm/mman.h> includes.  Building the pkey tests with
KHDR_INCLUDES pointing at an empty directory confirms that; emptying
TOOLS_INCLUDES as well is what makes the macro go missing.

No functional change intended.

Link: https://lore.kernel.org/20260825161715.2807297-1-hemanth.selam@gmail.com
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Assisted-by: Cursor:claude-opus-5
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Yury Khrustalev <yury.khrustalev@arm.com>
---

 tools/testing/selftests/mm/pkey-helpers.h |    7 -------
 1 file changed, 7 deletions(-)

--- a/tools/testing/selftests/mm/pkey-helpers.h~selftests-mm-remove-the-local-pkey_unrestricted-fallback
+++ a/tools/testing/selftests/mm/pkey-helpers.h
@@ -114,13 +114,6 @@ void record_pkey_malloc(void *ptr, long
 #define PKEY_MASK	(PKEY_DISABLE_ACCESS | PKEY_DISABLE_WRITE)
 #endif
 
-/*
- * FIXME: Remove once the generic PKEY_UNRESTRICTED definition is merged.
- */
-#ifndef PKEY_UNRESTRICTED
-#define PKEY_UNRESTRICTED 0x0
-#endif
-
 #ifndef set_pkey_bits
 static inline u64 set_pkey_bits(u64 reg, int pkey, u64 flags)
 {
_

Patches currently in -mm which might be from hemanth.selam@gmail.com are

scripts-spellingtxt-keep-british-spelling-for-initalise.patch

