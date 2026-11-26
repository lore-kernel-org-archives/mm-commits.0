Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795675610;
	b=VNNipk7SIIg2z8oPqJJxBhWXYRy9TS4djpl0MzojCC3MEinUjFdtYgeTgmSlORq45zyH
	 x8O8+S3MHrZ+JHkxDwcoQzekEcInUzF1J4aqXrNMnCd5noVr4j7CoxilzPlxJm2bL4iSP
	 SrEaOBYl1e+Ls3bXs1TeN0bHPzQbHqLKq62DRkLGKeTxI/QSrkKGp4IuFjgjThRYimnR/
	 QGR2w2smRNAt32+UNkit2WYTYhqyPq+iX2TsJssWRzrp16neXJ0VJRReIRkS5tw7wgTbb
	 ZTnhe/zOl3I7OSTY18oELzsLGA0gWU+tX9ACkLUVrDq2olFrIpoykW8YPi6DMvBddAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795675610;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=nfP9CjTieezO3lwpfFkrXX2n/YPh5x/I1dzk/kApNL8=;
	b=2Jy8u/QwUK4FwK9LF9yFEoaOU1FF63MqN/dbDv7KV0jtOk2ZaGlGduTBUTenPe6Q6DcH
	 BQeGL56XorRCBLJP1k2an5RdiVDMKwy/sLauGqQz24b0XwRBdFX1SCx3zjulExILOlHan
	 S40MQxOxFNE+SL7eofRYvWO0YPAEVDWuIPgx/ClgcswUZbjuG9qRVsEFAwZJ9LWeYUz2e
	 xPhDwa+iLEx6sIVaJqbx4n9JmJHDI5sI+0xMrElw66wGAN7st8iVKt0D2oc7zjjt24NdI
	 BzmtL9E0s4d4/GklNOxsyWSPwnCw5NIvZfNNgvrZHnMRXdyJdDsXMG5rXUu7fb6oUlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ZM0eTIli;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D4D606A321
	for <mm-commits@vger.kernel.org>; Thu, 26 Nov 2026 06:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ZM0eTIli
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E601F000CA;
	Thu, 26 Nov 2026 06:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795675609;
	bh=nfP9CjTieezO3lwpfFkrXX2n/YPh5x/I1dzk/kApNL8=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=ZM0eTIliTt+vRvDv40QzaRbK58wSxtbjjt2n9z0N7EmAr/27uTcoufLBjRaILZMmv
	 zOKD+9+5gRly6l5Pn2MTTYYcGDPsJh21JnFHF7sI6kjVa19AfK2Su10GIyFaoaAH9V
	 9r355aKKjW1zHehGU0HIZ7jXgfRBeCbA0h6SrMtE=
Date: Wed, 25 Nov 2026 22:46:48 -0800
To: mm-commits@vger.kernel.org,glider@google.com,dvyukov@google.com,
	andreyknvl@gmail.com,chenxionggui@lanxincomputing.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261125033635.3990-1-evers_chen@163.com>
References: <20261125033635.3990-1-evers_chen@163.com>
Subject: + kcov-defer-pc-canonicalization-until-tracing-is-enabled.patch added to mm-nonmm-unstable branch
Message-Id: <20261126064649.84E601F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: kcov: defer PC canonicalization until tracing is enabled
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kcov-defer-pc-canonicalization-until-tracing-is-enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kcov-defer-pc-canonicalization-until-tracing-is-enabled.patch

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
From: Xionggui Chen <chenxionggui@lanxincomputing.com>
Subject: kcov: defer PC canonicalization until tracing is enabled
Date: Wed, 25 Nov 2026 03:36:35 +0000

When CONFIG_KCOV_INSTRUMENT_ALL and CONFIG_RANDOMIZE_BASE are enabled,
__sanitizer_cov_trace_pc() may be called during early boot before the
kernel's virtual memory mappings are fully initialized.

Currently, canonicalize_ip() is called before checking whether KCOV
tracing is enabled.  On RISC-V, canonicalize_ip() calls kaslr_offset(),
which accesses kernel mapping information that may not yet be accessible.

This causes an early boot load access fault even when KCOV tracing is
disabled.

Move canonicalize_ip() after check_kcov_mode() to avoid accessing the
KASLR offset when KCOV tracing is disabled.

The comparison tracing path already performs this check before
canonicalizing the instruction pointer.

The issue was reproduced on RISC-V with Linux 7.4-rc1 using
CONFIG_KCOV_INSTRUMENT_ALL=y and CONFIG_RANDOMIZE_BASE=y.

The fix was verified on QEMU and RISC-V hardware.  KCOV PC tracing
collected 124 entries, and comparison tracing collected 63 entries on the
RISC-V hardware.

Link: https://patch.msgid.link/20261125033635.3990-1-evers_chen@163.com
Fixes: ded97d2c2b2c ("kcov: support comparison operands collection")
Signed-off-by: Xionggui Chen <chenxionggui@lanxincomputing.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>

 kernel/kcov.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/kcov.c~kcov-defer-pc-canonicalization-until-tracing-is-enabled
+++ a/kernel/kcov.c
@@ -216,13 +216,14 @@ void notrace __sanitizer_cov_trace_pc(vo
 {
 	struct task_struct *t;
 	unsigned long *area;
-	unsigned long ip = canonicalize_ip(_RET_IP_);
+	unsigned long ip;
 	unsigned long pos;
 
 	t = current;
 	if (!check_kcov_mode(KCOV_MODE_TRACE_PC, t))
 		return;
 
+	ip = canonicalize_ip(_RET_IP_);
 	area = t->kcov_area;
 	/* The first 64-bit word is the number of subsequent PCs. */
 	pos = READ_ONCE(area[0]) + 1;
_

Patches currently in -mm which might be from chenxionggui@lanxincomputing.com are

selftests-mm-handle-implicit-read-permissions-in-madv_populate.patch
kcov-defer-pc-canonicalization-until-tracing-is-enabled.patch

