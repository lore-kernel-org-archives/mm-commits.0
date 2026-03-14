Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE3A40DFA1
	for <mm-commits@vger.kernel.org>; Sat, 14 Mar 2026 22:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773526309; cv=none; b=GHMmnmeSAC6DG8wtMJuOX5XPU5COGE7myhAd9JRT5tY0x7juWOkkwT+rNNjnmeGq2U5D4d0MndQurhhBg+ol/Yl59YBzvXR/wmNn5YTKKzf7kaK57qdXbgqUyPS8XoHkj+QqBSsBZlHHtESO1OFldeCaFa0eMXhedR1089Q+MG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773526309; c=relaxed/simple;
	bh=i6Fe02PwHSGfyCm1G0ilJS8sEehQ7wofIdQAiaKq3vg=;
	h=Date:To:From:Subject:Message-Id; b=BlPI/x4Qxp6WhZi86jMYRCQb67U1hiNOevtaPssctaSvEQke+SIi4eJciBiAHyDqvf3Cqdztx6vqpJoaQg0CkybvNWW3oD8rqlGEn8JkdYPp73SBdo0pjZrbugcOs8whqrgN1kpSCnxOtlks8qllxSdvd6IyYgR8qznB6dcdNkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1ZRVe7mO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1ZRVe7mO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F2DC116C6;
	Sat, 14 Mar 2026 22:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773526309;
	bh=i6Fe02PwHSGfyCm1G0ilJS8sEehQ7wofIdQAiaKq3vg=;
	h=Date:To:From:Subject:From;
	b=1ZRVe7mOK8j1CL7pp+Ty42Of2CLQDIaPKRe6Ay/a5hyBt4yuftHpfOvtPwZDGskLn
	 40X7LtEfiCcrYCi2brL3uvfnms7H+m2v3BjFQ4aDbg1MVgxSpL+6SpML42huQWHa5P
	 CC9LRt7UL7uSuCobmWNSS/q6Vb7aAVQ8VVGp4PxY=
Date: Sat, 14 Mar 2026 15:11:48 -0700
To: mm-commits@vger.kernel.org,bhe@redhat.com,ebiggers@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-kexec-remove-inclusion-of-crypto-hashh.patch added to mm-nonmm-unstable branch
Message-Id: <20260314221149.32F2DC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/kexec: remove inclusion of crypto/hash.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-kexec-remove-inclusion-of-crypto-hashh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-kexec-remove-inclusion-of-crypto-hashh.patch

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
Subject: kernel/kexec: remove inclusion of crypto/hash.h
Date: Sat, 14 Mar 2026 13:41:44 -0700

kexec_core.c does not do any cryptographic hashing, so the header
crypto/hash.h is not needed at all.

Link: https://lkml.kernel.org/r/20260314204144.44884-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/kexec_core.c~kernel-kexec-remove-inclusion-of-crypto-hashh
+++ a/kernel/kexec_core.c
@@ -47,7 +47,6 @@
 #include <asm/page.h>
 #include <asm/sections.h>
 
-#include <crypto/hash.h>
 #include "kexec_internal.h"
 
 atomic_t __kexec_lock = ATOMIC_INIT(0);
_

Patches currently in -mm which might be from ebiggers@kernel.org are

kernel-crash-remove-inclusion-of-crypto-sha1h.patch
kernel-kexec-remove-inclusion-of-crypto-hashh.patch

