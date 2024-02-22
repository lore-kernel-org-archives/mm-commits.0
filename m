Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC7713BAD6
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645202; cv=none; b=rm6nWFLDtZES0Mu3T/Uc1S+kWk5ssxMfH1+fQYS/CFiPGPwFb+VDdqSm9zZX2owwtoPTQOAKvcF9DHe+7B3q4Tw2eI6no5kN5NVotLqWv+mX50I6+ihiJO2jCJMdCmldYyXz/2Ian1+q8tS5ND0L4jUuu23HteJLnY8OaVt838g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645202; c=relaxed/simple;
	bh=kN1ShcwYhKr6OCdIwq0RlUN/ru2MyTjRGwKaXMIs3sk=;
	h=Date:To:From:Subject:Message-Id; b=coGLeaMg0fhdDX0vXqE+DKBc2gdUL6HmwYX6J0G+tpn9ZKdznBzR0v6AJ92lm6jrOC8zKfx4o3WCF0GY5WZbFQ8mCVHFM72xH9m27yCubh8V7+48L9lyXJUI9LXAg0GJ4h7ds6GoVHAIL10KGm4kB4C7lGztSg/knIpMjAjycsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VQ7H8oV4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VQ7H8oV4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79FF3C433C7;
	Thu, 22 Feb 2024 23:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645202;
	bh=kN1ShcwYhKr6OCdIwq0RlUN/ru2MyTjRGwKaXMIs3sk=;
	h=Date:To:From:Subject:From;
	b=VQ7H8oV4P0LoxXabbdkYmwk6tB5T0fsUf2b1eRYERlfdD/iIx1Url7K80iEErhCbU
	 7ORhOd8YNCJYaVZw+W6Vf5Y+xMRgPr3VBS96HqQL6DThpU9w8TWgj24tqK3QA/phHN
	 KvUvQpidtJlh3kNnIBqF11JGOvnG/cr9dEUSKK98=
Date: Thu, 22 Feb 2024 15:40:01 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,nicolas@fjasle.eu,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,mark.rutland@arm.com,linux@armlinux.org.uk,keescook@chromium.org,dave.hansen@linux.intel.com,conor@kernel.org,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] x86-drop-stack-alignment-plugin-opt.patch removed from -mm tree
Message-Id: <20240222234002.79FF3C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86: drop stack-alignment plugin opt
has been removed from the -mm tree.  Its filename was
     x86-drop-stack-alignment-plugin-opt.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: x86: drop stack-alignment plugin opt
Date: Thu, 25 Jan 2024 15:55:09 -0700

Now that the minimum supported version of LLVM for building the kernel has
been bumped to 13.0.1, the inner ifeq statement is always false, as the
build will fail during the configuration stage for older LLVM versions.

This effectively reverts part of commit b33fff07e3e3 ("x86, build: allow
LTO to be selected") and its follow up fix, commit 2398ce80152a ("x86,
lto: Pass -stack-alignment only on LLD < 13.0.0").

Link: https://lkml.kernel.org/r/20240125-bump-min-llvm-ver-to-13-0-1-v1-3-f5ff9bda41c5@kernel.org
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

 arch/x86/Makefile |    6 ------
 1 file changed, 6 deletions(-)

--- a/arch/x86/Makefile~x86-drop-stack-alignment-plugin-opt
+++ a/arch/x86/Makefile
@@ -217,12 +217,6 @@ endif
 
 KBUILD_LDFLAGS += -m elf_$(UTS_MACHINE)
 
-ifdef CONFIG_LTO_CLANG
-ifeq ($(call test-lt, $(CONFIG_LLD_VERSION), 130000),y)
-KBUILD_LDFLAGS	+= -plugin-opt=-stack-alignment=$(if $(CONFIG_X86_32),4,8)
-endif
-endif
-
 ifdef CONFIG_X86_NEED_RELOCS
 LDFLAGS_vmlinux := --emit-relocs --discard-none
 else
_

Patches currently in -mm which might be from nathan@kernel.org are


