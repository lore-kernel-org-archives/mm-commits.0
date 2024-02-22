Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C8E13BAD6
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645202; cv=none; b=onQdMoJGs96N9MYluBjC4PfQNg8KwHLu1MUQ963A8VpaVYTOrvWbYeODfQdRON9kuephEXmJ6bOGI4lIuE/lsCQ/Xje5upwKKfoN4HF2Qgwexrnpy/gtWKnH4jlf2Jj995zEclLXQK5J1fhyA9X2iWp+tD1Qn3cr1V7OsQcdg0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645202; c=relaxed/simple;
	bh=MtDRI/FjUKrtWgCFCHvKIhrN3V2v0KPYYQzuJaZdfyE=;
	h=Date:To:From:Subject:Message-Id; b=ZRVXYdpgDQytsdTd0i2qzjmDbjRkfzdp0e+5j0zpRxG3poSlBiVacGacPUiQKyOpqPtd3QWRfHKyzw/gmcQ4NA3XtgJSXwz8ybJv+i+O++UyFFXM4V4kCQvM1tf2kkc3ERTZRMYqmc2R5fVUb4K+QnHbyERFnFV8oGdW2JbQKvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gjXanC9P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gjXanC9P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F96CC433C7;
	Thu, 22 Feb 2024 23:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645201;
	bh=MtDRI/FjUKrtWgCFCHvKIhrN3V2v0KPYYQzuJaZdfyE=;
	h=Date:To:From:Subject:From;
	b=gjXanC9Pat2mQBeqS3Dg4fu2amMOjKcmTSFN1pOjl8Zh9yw8/fCom7U9BOsNk3Ims
	 +m2yNa4VFW0txmX6zP8M9OUgrpY3KQoSs92pKGSU5YZMgBnUIqf4JvOoTCUYpKq+zx
	 CCl81Fv2CQELBm13PZq7m+GJwHATXDdY3VQXbbqU=
Date: Thu, 22 Feb 2024 15:40:00 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,nicolas@fjasle.eu,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,mark.rutland@arm.com,linux@armlinux.org.uk,keescook@chromium.org,dave.hansen@linux.intel.com,conor@kernel.org,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] makefile-drop-warn-stack-size-plugin-opt.patch removed from -mm tree
Message-Id: <20240222234001.5F96CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Makefile: drop warn-stack-size plugin opt
has been removed from the -mm tree.  Its filename was
     makefile-drop-warn-stack-size-plugin-opt.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: Makefile: drop warn-stack-size plugin opt
Date: Thu, 25 Jan 2024 15:55:08 -0700

Now that the minimum supported version of LLVM for building the kernel has
been bumped to 13.0.1, the inner ifeq statement is always false, as the
build will fail during the configuration stage for older LLVM versions.

This effectively reverts commit 24845dcb170e ("Makefile: LTO: have linker
check -Wframe-larger-than") and its follow up fix, commit 0236526d76b8
("Makefile: lto: Pass -warn-stack-size only on LLD < 13.0.0").

Link: https://lkml.kernel.org/r/20240125-bump-min-llvm-ver-to-13-0-1-v1-2-f5ff9bda41c5@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: "Aneesh Kumar K.V (IBM)" <aneesh.kumar@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Conor Dooley <conor@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    8 --------
 1 file changed, 8 deletions(-)

--- a/Makefile~makefile-drop-warn-stack-size-plugin-opt
+++ a/Makefile
@@ -951,14 +951,6 @@ CC_FLAGS_LTO	+= -fvisibility=hidden
 
 # Limit inlining across translation units to reduce binary size
 KBUILD_LDFLAGS += -mllvm -import-instr-limit=5
-
-# Check for frame size exceeding threshold during prolog/epilog insertion
-# when using lld < 13.0.0.
-ifneq ($(CONFIG_FRAME_WARN),0)
-ifeq ($(call test-lt, $(CONFIG_LLD_VERSION), 130000),y)
-KBUILD_LDFLAGS	+= -plugin-opt=-warn-stack-size=$(CONFIG_FRAME_WARN)
-endif
-endif
 endif
 
 ifdef CONFIG_LTO
_

Patches currently in -mm which might be from nathan@kernel.org are


