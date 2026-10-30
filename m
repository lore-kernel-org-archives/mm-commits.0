Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793378178;
	b=TqOrj6WsP7eP4GPbL/F22E5quZfjWO0++gzpqMqRgJ6amje/4sOnvZtWRhYQxUMO4w0Z
	 vErOik/Uu9TpfgkTnbsriY4ibyaOQdmiOA8QZ86wUBYkIXwZVtlPYNW+5zxyO57o7rBhV
	 zz/NKdsG5NVmkU3XZv+86LdHeh8vC2yuXhIJugezoIaKmrvtcl2HXAf7tw8zs0UNcDw8Q
	 gPT6L95s+/h3vQ7lyZE2S9NRd78loXUA84Q8J4skYpfDbPi9WlmhfMRpzaaaPixds4ZP5
	 RtvWiOYR8AEQWM40PSoWHSzW+NdM/bDrbE2rsk0FNiUaO9kTKzXSzesytsR/IHPMYQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793378178;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=abfwFJPZNcPaNkZM4oQoy8Rd677h3xU5K6s9od3K4gA=;
	b=QGKKuVkL4f7qYfeApNHBWN4wiWdf77wRV8GPeb++I5H1M8KSyRmpMYEquu3yjnDTrC/V
	 Odfo2J0DU/VONdh7mG5RI8rdRx7IxN0ZH/SLPPfqd9ZPEC9r/7i75G17cJqqWSTwna7AF
	 dNwnobuhKFmcz2sDyEMHLkuO2Q22FJrdrzpydzFAq71F91fMkI+Ju133Tx2fokEuPJkRJ
	 Oov9F3de9qwMPC5ALuaM1pNiLI3yYQf1MCsnFhZrBWOrU83JpSXPyvrGsEudXfHGEQuX0
	 5KD7IiOACuD/UdR92bLB4zmsSKKWb8PF+EQqx7uPoQ9bL4eAX6bkJ0JFJZXzDrDOY2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xKnUNaKC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C1A60A2601
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 16:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xKnUNaKC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F321F00A18;
	Fri, 30 Oct 2026 16:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793378164;
	bh=abfwFJPZNcPaNkZM4oQoy8Rd677h3xU5K6s9od3K4gA=;
	h=Date:To:From:Subject;
	b=xKnUNaKC/LmVkb90a2aKw+S6WyjN5F8y3tJ3Nc02scT5WYHrRxL56lbS4ta9Ssu/E
	 LAtUDqW1h8aGKQ7KsIZXrUy7CjCL7nE3SFluto2DW1tN7ltpyRe1st38PnDFf+R87K
	 fA/7+43PZRKGLRiOimOX88Go01EP553Jg+RCvxrg=
Date: Fri, 30 Oct 2026 09:36:03 -0700
To: mm-commits@vger.kernel.org,zhangcoder@yeah.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + include-linux-jhashh-fix-kernel-doc-parameter-name.patch added to mm-nonmm-unstable branch
Message-Id: <20261030163604.43F321F00A18@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: include/linux/jhash.h: fix kernel-doc parameter name
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     include-linux-jhashh-fix-kernel-doc-parameter-name.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/include-linux-jhashh-fix-kernel-doc-parameter-name.patch

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
From: Ziran Zhang <zhangcoder@yeah.net>
Subject: include/linux/jhash.h: fix kernel-doc parameter name
Date: Fri, 30 Oct 2026 17:38:33 +0800

The kernel-doc comment for jhash() documents the first parameter as @k,
but the function signature uses key.

Fix the parameter name in the comment to match the signature.

No functional changes.

Link: https://lore.kernel.org/20261030093834.13043-1-zhangcoder@yeah.net
Signed-off-by: Ziran Zhang <zhangcoder@yeah.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/jhash.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/jhash.h~include-linux-jhashh-fix-kernel-doc-parameter-name
+++ a/include/linux/jhash.h
@@ -58,7 +58,7 @@
 #define JHASH_INITVAL		0xdeadbeef
 
 /* jhash - hash an arbitrary key
- * @k: sequence of bytes as key
+ * @key: sequence of bytes as key
  * @length: the length of the key
  * @initval: the previous hash, or an arbitrary value
  *
_

Patches currently in -mm which might be from zhangcoder@yeah.net are

include-linux-jhashh-fix-kernel-doc-parameter-name.patch

