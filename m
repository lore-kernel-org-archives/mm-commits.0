Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794537673;
	b=302fF6N73zdqaYRAJL9eWs9xbOuu5Fzs+hk1EDYPIYmGSbZkktF6pKi40MfyGKLs3Dqc
	 LTGdpsRqFoPGasuewyv7AeyDncfbLoi4G7PSx1wlsVeWWUW/Ss8YdDua4aEkSUqJlIDae
	 TUgu7KVVmREuaDpAbI/YCAw+O0mBmzoYEc8P9nOM0+Jt87Y0hhhErIlThPCP/eQbhS4Bc
	 P5uAI39absvJ6Eh9Ipc9jKRnHqppqvC6C2ITNs1nKbBXh/CNjrQw2XBGSTTy3EYfCa6az
	 VFXsxRK+aykkpWyrmHLRkRqLY+pBId8VUyZ7FWLNYU7y/jviHAF+RgKud11MVJngyTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794537673;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=oOYUz5DYYYrzwO5eKdl2iR2LuZ5mx26Ev11XNE98bDY=;
	b=1felOZJGSsTN8r2PehXbjKauj+Cwk+cnEw57z3ygO0aJv9+8TynlP60jhplp9U6CR1oG
	 0NILHR+E4yoa5pt9s28sai/BZXF1ZdxmSNTp6eE7vNGu1/F6w9fCeXWpcp8E0K8lyyFTA
	 bbvlabFX7tC4ivDpOGnGgLv8VoMXtH8h1ogaeGBGOd/uSx8peGjeSLkGpJ4YpcPpXzhUb
	 6DDro71kvfkvoQeykHcpJghMPOWj4tgXEErsFnYKio1t+HRupAOp7STPSSdUklgLx4Rlh
	 TORuLQsSP+KaXpqzJ2byeW4cZW7xHeKpRGTHyVw4BgL7xEd6/ktDNXgGfpunZ+C32iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mGLDiA6q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D01606A31C
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 02:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mGLDiA6q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630971F000C4;
	Fri, 13 Nov 2026 02:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794537673;
	bh=oOYUz5DYYYrzwO5eKdl2iR2LuZ5mx26Ev11XNE98bDY=;
	h=Date:To:From:Subject;
	b=mGLDiA6qqg0s5Hypayc+SJMMJseUnUOl+mem3X3Nd3DKMMcHlmdDZD6UjmGOLonEQ
	 EKxCR5ewUNHv2/7OTi0mGlIVmAkLOAI9LhqS1kHI8dGGB54Bu+M/9oh1JHnQMuHm/I
	 T/2Agu+ngvY++1lKH0JIYN/B5d2XortwywnccYEw=
Date: Thu, 12 Nov 2026 18:41:12 -0800
To: mm-commits@vger.kernel.org,richard@nod.at,johannes@sipsolutions.net,
	hch@lst.de,anton.ivanov@cambridgegreys.com,ebiggers@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + um-define-kernel_fpu_begin_mask.patch added to mm-nonmm-unstable branch
Message-Id: <20261113024113.630971F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: um: define kernel_fpu_begin_mask()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     um-define-kernel_fpu_begin_mask.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/um-define-kernel_fpu_begin_mask.patch

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
Subject: um: define kernel_fpu_begin_mask()
Date: Wed, 11 Nov 2026 12:56:02 -0800

Patch series "lib/raid: opt out of initializing MXCSR and 387 state".

This series slightly reduces the overhead of the x86 kernel-mode "FPU"
sections in the RAID code by using kernel_fpu_begin_mask(0) instead of
kernel_fpu_begin(), thus opting out of the 'ldmxcsr' (and on 32-bit
kernels, also 'fninit').  MXCSR is irrelevant for integer code.

This mirrors similar optimizations for the crypto and CRC code
(https://lore.kernel.org/linux-crypto/20261105005523.84925-1-ebiggers@kernel.org/).
It's more important there than in the RAID code, since short lengths are
common in the x86-optimized crypto and CRC functions.  However, I think
it's worth updating the RAID code too for consistency.

Unlike the crypto and CRC code, the RAID code is built for user-mode
Linux.  Therefore, as a prerequisite for this change, patch 1 also
defines a stub for kernel_fpu_begin_mask() on user-mode Linux.


This patch (of 3):

Define a stub for kernel_fpu_begin_mask() on user-mode Linux so that
lib/raid/ can switch from kernel_fpu_begin() to kernel_fpu_begin_mask().

Note: this causes a checkpatch error due to the macro's value not having
outer parentheses, but it's left as-is for consistency with the existing
kernel_fpu_begin() and kernel_fpu_end() definitions right next to it.

Link: https://lore.kernel.org/20261111205604.47547-1-ebiggers@kernel.org
Link: https://lore.kernel.org/20261111205604.47547-2-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
---

 arch/um/include/asm/fpu/api.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/um/include/asm/fpu/api.h~um-define-kernel_fpu_begin_mask
+++ a/arch/um/include/asm/fpu/api.h
@@ -11,6 +11,7 @@
  * UML code tree. */
 
 #define kernel_fpu_begin() (void)0
+#define kernel_fpu_begin_mask(mask) (void)(mask)
 #define kernel_fpu_end() (void)0
 
 static inline bool irq_fpu_usable(void)
_

Patches currently in -mm which might be from ebiggers@kernel.org are

xor-remove-obsolete-mmx-optimized-code.patch
raid6-remove-obsolete-mmx-optimized-code.patch
raid6-simplify-cpu-feature-checks.patch
um-define-kernel_fpu_begin_mask.patch
xor-opt-out-of-initializing-mxcsr-and-387-state.patch
raid6-opt-out-of-initializing-mxcsr-and-387-state.patch

