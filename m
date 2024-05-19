Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1F225761
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 21:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716154633; cv=none; b=o2wKe949F+YRUw7WLBqa3o7HBcGQzFFtyg69o9UNpMar/tQhUnoBpGBSlwe/iBvyTxg3T1ek6jazmfN8ShmRBNHgjv9Qx5phNMktVj+A1v1fAXZDw27bCktBMBFY8abPw8yYipPqhktZ5wucOsDeaQ4xyJ92vX+hm0DjbUy59Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716154633; c=relaxed/simple;
	bh=aBEHVyEhsM3vv7Z24ypScLIh95TShUgKKTe0msG5/d8=;
	h=Date:To:From:Subject:Message-Id; b=r1muTvueLOVNBCKSXddgwXwKgIv1XoNpRcdjrbD5bX91XTNKfTjTgACkcnch5q9Wzc8l/JY/qBYhPXHiSJT+2YzWsd6HueA90ODZghtj+gElMdD60Y6IP9hE2cXPMyZMUuzMC8c00CnS/KDsySUelRJxTNMrxKtn5WfweBm1MgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HYLeNjUl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HYLeNjUl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1283C32781;
	Sun, 19 May 2024 21:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716154633;
	bh=aBEHVyEhsM3vv7Z24ypScLIh95TShUgKKTe0msG5/d8=;
	h=Date:To:From:Subject:From;
	b=HYLeNjUlYOcW/YWr3Hu8z/MzNeZAhcfi+O/7eKmzTuLI8WOTvBPdqCOrcIspjHK3s
	 bsD8Mz4fpTTLLxSk/2xztb/Nu5f0NwgkiQVSgXKrvqJn0ClYaJexEjTf0c2pDj59Qg
	 pflpo96QSIpdSe9t+F576yw66RyysUt/adxpvLSc=
Date: Sun, 19 May 2024 14:37:12 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,palmer@rivosinc.com,nicolas@fjasle.eu,nathan@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,linux@armlinux.org.uk,hch@lst.de,git@xen0n.name,dave.hansen@linux.intel.com,corbet@lwn.net,christian.koenig@amd.com,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,alexander.deucher@amd.com,samuel.holland@sifive.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] arm-crypto-use-cc_flags_fpu-for-neon-cflags.patch removed from -mm tree
Message-Id: <20240519213712.E1283C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ARM: crypto: use CC_FLAGS_FPU for NEON CFLAGS
has been removed from the -mm tree.  Its filename was
     arm-crypto-use-cc_flags_fpu-for-neon-cflags.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Samuel Holland <samuel.holland@sifive.com>
Subject: ARM: crypto: use CC_FLAGS_FPU for NEON CFLAGS
Date: Fri, 29 Mar 2024 00:18:18 -0700

Now that CC_FLAGS_FPU is exported and can be used anywhere in the source
tree, use it instead of duplicating the flags here.

Link: https://lkml.kernel.org/r/20240329072441.591471-4-samuel.holland@sifive.com
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Christian König <christian.koenig@amd.com> 
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: WANG Xuerui <git@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/lib/Makefile |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/arm/lib/Makefile~arm-crypto-use-cc_flags_fpu-for-neon-cflags
+++ a/arch/arm/lib/Makefile
@@ -40,8 +40,7 @@ $(obj)/csumpartialcopy.o:	$(obj)/csumpar
 $(obj)/csumpartialcopyuser.o:	$(obj)/csumpartialcopygeneric.S
 
 ifeq ($(CONFIG_KERNEL_MODE_NEON),y)
-  NEON_FLAGS			:= -march=armv7-a -mfloat-abi=softfp -mfpu=neon
-  CFLAGS_xor-neon.o		+= $(NEON_FLAGS)
+  CFLAGS_xor-neon.o		+= $(CC_FLAGS_FPU)
   obj-$(CONFIG_XOR_BLOCKS)	+= xor-neon.o
 endif
 
_

Patches currently in -mm which might be from samuel.holland@sifive.com are


