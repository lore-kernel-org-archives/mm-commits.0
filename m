Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794288888;
	b=Nd13833F+KVRkiTIwWNfWGHOGOcY3ROZTZXIe/GhVnAfyIu7pZbCtB38HExGu7bSaCQb
	 on6GmFUs7QYl3mH6ybzPmftvMqZYpxFgo64WV6937O9EaK1OSrU1f9thbKriAkfo0eLjS
	 mtv2NCCzlpJQJfIomyDF+/YHy2b7WLPRhJ/ZdtGlDKswDU2Yh57so46gcnVuByMvIUH4e
	 FECYujOk4omewtOAky3WH6NnJO4n7B5sdTl8Mcx/Gz1fvTXknmsAchJKC+KTAfIqUf/W3
	 G2HMkeZ0Z6JV1d09IsH4YRfpFL6Hp4ALo8pnzRcd1wLnCOJ7LA26eLYyeMYoe710D9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794288888;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=7AHbqx+LqfndjOy85OP3aVA6YZzRbTvpOJ0Pv2ulMRE=;
	b=Ufer/zcvEntRthI+87Ickvjlstx1/3oJSHZ0lJdKqE1Q/b+pMZvugStZZ1Inu+8VChrS
	 BG5BI5S6Ma8a2kjVIICWaKTcVy44XsQ73F7+mcB8Br9D14lbJSXMPqASc6ew46fwr8z9J
	 lDDAT4awaFIBUBa1Wz7s++CAAwcb6eoPd1A0jbIOCKEr3S65RdgD+LkkttRxnENAJp07d
	 GjXCYulIFnSUyUkZprkrUt8543hWqQIp+InL44tqCrskKfcJrEXuanX+n21KBkDvMO0sG
	 p6tKgdXyXQHUEgnLMJvW3dqoJlc3GogytRXP9cpF5s1kNkxMVySW3iA3eGH8QW7HSJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=O2Sy9Zkb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469C7606A330;
	Tue, 10 Nov 2026 05:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=O2Sy9Zkb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C72271F0089F;
	Tue, 10 Nov 2026 05:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794288887;
	bh=7AHbqx+LqfndjOy85OP3aVA6YZzRbTvpOJ0Pv2ulMRE=;
	h=Date:To:From:Subject;
	b=O2Sy9ZkbOhIWxOjm1EmvKhcQoGHRd39IBYAq6RoutCnX26N51kMd5OnyyJZMQPclg
	 HCILq8sBXqNzFSX3bzm/XkYfRenNLjhh/YlodrHNqBw9ryMUqHKFAgHIwFrYGRXoe2
	 ygqtcbN+KjbmowSljRnG/BmsiL/kGKKSxxR/vDFc=
Date: Mon, 09 Nov 2026 21:34:47 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,akinobu.mita@gmail.com,
	ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fault-inject-fix-boot-failure-with-fault-injection-boot-parameters.patch added to mm-nonmm-hotfixes-unstable branch
Message-Id: <20261110053447.C72271F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: fault-inject: fix boot failure with fault injection boot parameters
has been added to the -mm mm-nonmm-hotfixes-unstable branch.  Its filename is
     fault-inject-fix-boot-failure-with-fault-injection-boot-parameters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fault-inject-fix-boot-failure-with-fault-injection-boot-parameters.patch

This patch will later appear in the mm-nonmm-hotfixes-unstable branch at
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
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: fault-inject: fix boot failure with fault injection boot parameters
Date: Fri,  6 Nov 2026 01:01:58 +0900

Since commit e9bc360b105c ("fault-inject: use prandom where
cryptographically secure randomness is not needed"), setup_fault_attr()
calls prandom_init_once(), which calls kmalloc() and schedule_work().

But setup_fault_attr() can be called from __setup handlers before slab and
workqueues are initialized, so any fault injection boot parameter leads to
boot failure.

So use DO_ONCE_LITE() instead.

Link: https://lore.kernel.org/20261105160209.1504867-1-ekffu200098@gmail.com
Fixes: e9bc360b105c ("fault-inject: use prandom where cryptographically secure randomness is not needed")
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: <stable@vger.kernel.org>
---

 lib/fault-inject.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/lib/fault-inject.c~fault-inject-fix-boot-failure-with-fault-injection-boot-parameters
+++ a/lib/fault-inject.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/once_lite.h>
 #include <linux/prandom.h>
 #include <linux/debugfs.h>
 #include <linux/sched.h>
@@ -50,7 +51,12 @@ int setup_fault_attr(struct fault_attr *
 		return 0;
 	}
 
-	prandom_init_once(&fault_rnd_state);
+	/*
+	 * __setup handlers run before slab and workqueues are initialized,
+	 * but prandom_init_once() calls kmalloc() and schedule_work(). So use
+	 * DO_ONCE_LITE() instead.
+	 */
+	DO_ONCE_LITE(prandom_seed_full_state, &fault_rnd_state);
 
 	attr->probability = probability;
 	attr->interval = interval;
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-memory-remove-unused-vmf_insert_mixed_mkwrite.patch
mm-memory-remove-the-mkwrite-argument-from-__vm_insert_mixed.patch
mm-memory-merge-__vm_insert_mixed-into-vmf_insert_mixed.patch
fault-inject-fix-boot-failure-with-fault-injection-boot-parameters.patch

