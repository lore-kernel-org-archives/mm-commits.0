Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87967FBF4
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645210; cv=none; b=LpsHYYTogQe4I/Yj0sPdAL/ajR0D3kWW+gsUiW4qn/VuufZ+ga1WBgXk7HPt1mA6ybse2qsASv613bvihdcrQT9sPqQjloOYIM06/ZCv3mYMxkfL/jwntqMqrOmjgDsdY+myzIInaFauluQ5ZL9neSrRfUwfYisfgbleU+KGsx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645210; c=relaxed/simple;
	bh=sK9DbjBRxgpk5Qwqk+zrdR9oy2gucUYAdmXbMcLHNKI=;
	h=Date:To:From:Subject:Message-Id; b=s+2uAu/Xmk9geR74xn992yV/LS5GwafhAzUw0jE+e4J1PuHk0dqOVkwMF7YnJcNRtBz4wZZhy3Ul82KlIk5Z9gkvIhm/EJjdj05d1/fSgqeMCm3XLnYBwWf/8F/0/SEk1eKnq2rmsQG+QQ1e/zRNlHwKaaSNkcH1ZVhrWrRu/AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=POk70DXk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="POk70DXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4FAC43390;
	Thu, 22 Feb 2024 23:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645210;
	bh=sK9DbjBRxgpk5Qwqk+zrdR9oy2gucUYAdmXbMcLHNKI=;
	h=Date:To:From:Subject:From;
	b=POk70DXkVycxQATzVe2I0kDjFZudg40EhXlVnohAsqiN2064M02eCidSETuSYBQhs
	 nh9+QdmygA8NUkPadENyuhXSQGNxa/t46NeLgMu1LbwPmVv2Ne4Z5MNUe0jWAGIlr1
	 P7yoMVqBmbToIyaGtEm/ej23bPbWQozYWamgcKwA=
Date: Thu, 22 Feb 2024 15:40:09 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,nicolas@fjasle.eu,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,masahiroy@kernel.org,mark.rutland@arm.com,linux@armlinux.org.uk,keescook@chromium.org,dave.hansen@linux.intel.com,conor@kernel.org,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] compiler-clangh-update-__diag_clang-macros-for-minimum-version-bump.patch removed from -mm tree
Message-Id: <20240222234010.5A4FAC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: compiler-clang.h: update __diag_clang() macros for minimum version bump
has been removed from the -mm tree.  Its filename was
     compiler-clangh-update-__diag_clang-macros-for-minimum-version-bump.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: compiler-clang.h: update __diag_clang() macros for minimum version bump
Date: Thu, 25 Jan 2024 15:55:17 -0700

The minimum supported version of LLVM for building the kernel has been
bumped to 13.0.1.  Update the __diag_clang() macros for this bump.

Link: https://lkml.kernel.org/r/20240125-bump-min-llvm-ver-to-13-0-1-v1-11-f5ff9bda41c5@kernel.org
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

 include/linux/compiler-clang.h |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/include/linux/compiler-clang.h~compiler-clangh-update-__diag_clang-macros-for-minimum-version-bump
+++ a/include/linux/compiler-clang.h
@@ -114,11 +114,7 @@
 #define __diag_str(s)		__diag_str1(s)
 #define __diag(s)		_Pragma(__diag_str(clang diagnostic s))
 
-#if CONFIG_CLANG_VERSION >= 110000
-#define __diag_clang_11(s)	__diag(s)
-#else
-#define __diag_clang_11(s)
-#endif
+#define __diag_clang_13(s)	__diag(s)
 
 #define __diag_ignore_all(option, comment) \
-	__diag_clang(11, ignore, option)
+	__diag_clang(13, ignore, option)
_

Patches currently in -mm which might be from nathan@kernel.org are


