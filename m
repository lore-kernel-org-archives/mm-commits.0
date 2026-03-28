Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A351A9FA8
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671956; cv=none; b=q/klDzeYfcGj4WMeKO8AS5Z1kU5m3JVQE6xlavrw8/jmiZZxZVtcZgeUYwMgEhWtD1IcbaR/NwOhG4rER1X4CKZyQZFR9Ml05xMaS2OHsZczqbnssxnrC+35WsUl2PvcApaa15KCVnYM/hrBZg/HipjshUQSRr/uH9RQBiPpWOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671956; c=relaxed/simple;
	bh=DwPZyhoiNsXKafvDOty7axRZAMb9S3CoVZwhzlhkHYo=;
	h=Date:To:From:Subject:Message-Id; b=tvCDIwr1QKzh7q63zeL3tceiAcZKJMRE4x6NeSoqz8w+DgbsHsL4CFOWeiaVdPakeDrpkicnd6/F/2EEC93DO8rqDqkUqnElTr9tX/eJyZb2Lx01iq6dVvvcPlLXFJZmT5vy0i+isMpx38uFEcvU5pxMVZNsTvAWsWQcrJ7i+BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZCOavgBX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZCOavgBX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49FE6C4CEF7;
	Sat, 28 Mar 2026 04:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671956;
	bh=DwPZyhoiNsXKafvDOty7axRZAMb9S3CoVZwhzlhkHYo=;
	h=Date:To:From:Subject:From;
	b=ZCOavgBXhPrUvdqoe6/kZHFuU0fS7H+AG3o9Pt5zAgm3fvcqlAiIvPWUMb09M57O6
	 3qNysgtrU5b02EMbmJiUCNAXiZ16sOBRkDAf+mmd0IeREAWEkgWG/8U4/sL07Wxs8B
	 NKsOQXaljW2Frk7Ie0OrVr0/lMCK9jTVm8AeSckg=
Date: Fri, 27 Mar 2026 21:25:55 -0700
To: mm-commits@vger.kernel.org,bhe@redhat.com,ebiggers@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-kexec-remove-inclusion-of-crypto-hashh.patch removed from -mm tree
Message-Id: <20260328042556.49FE6C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/kexec: remove inclusion of crypto/hash.h
has been removed from the -mm tree.  Its filename was
     kernel-kexec-remove-inclusion-of-crypto-hashh.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


