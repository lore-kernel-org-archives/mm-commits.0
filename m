Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0594F204
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 23:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Su6lvT9w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1121C433C8;
	Wed, 20 Dec 2023 23:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703113408;
	bh=op9ghpFA8EGKf9wLeq5J9aqfxcPd7EYEsbTBCOqBH1s=;
	h=Date:To:From:Subject:From;
	b=Su6lvT9wZihJYCrYRZJhqOEnNEx00eCKXtj2oKMN4xlkXthlabq8uaHzhTUUIuOoh
	 Fkao8u0l+1GSPQ7ih+4hVoXXg16WF2w3atv84+7sWsfPr+qzX+KmsyKPM8qQhTvo7i
	 kiTlljdPcKLs6oufdNGIkwVRxodUwUg32ckhPmio=
Date: Wed, 20 Dec 2023 15:03:27 -0800
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,tudor.ambarus@linaro.org,tsbogend@alpha.franken.de,sfr@canb.auug.org.au,richard@nod.at,richard.henderson@linaro.org,peterz@infradead.org,palmer@rivosinc.com,nicolas@fjasle.eu,nathan@kernel.org,mpe@ellerman.id.au,mattst88@gmail.com,masahiroy@kernel.org,keescook@chromium.org,ink@jurassic.park.msu.ru,gregkh@linuxfoundation.org,glaubitz@physik.fu-berlin.de,dwmw2@infradead.org,dinguyen@kernel.org,davem@davemloft.net,dalias@libc.org,chengzhihao1@huawei.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] makefileextrawarn-turn-on-missing-prototypes-globally.patch removed from -mm tree
Message-Id: <20231220230327.F1121C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Makefile.extrawarn: turn on missing-prototypes globally
has been removed from the -mm tree.  Its filename was
     makefileextrawarn-turn-on-missing-prototypes-globally.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: Makefile.extrawarn: turn on missing-prototypes globally
Date: Thu, 23 Nov 2023 12:05:06 +0100

Over the years we went from > 1000 of warnings to under 100 earlier this
year, and I sent patches to address all the ones that I saw with compile
testing randcom configs on arm64, arm and x86 kernels.  This is a really
useful warning, as it catches real bugs when there are mismatched
prototypes.  In particular with kernel control flow integrity enabled,
those are no longer allowed.

I have done extensive testing to ensure that there are no new build errors
or warnings on any configuration of x86, arm and arm64 builds.  I also
made sure that at least both the normal defconfig and an allmodconfig
build is clean for arc, csky, loongarch, m68k, microblaze, openrisc,
parisc, powerpc, riscv, s390, and xtensa, with the respective maintainers
doing most of the patches.

At this point, there are five architectures with a number of known
regressions: alpha, nios2, mips, sh and sparc.  In the previous version of
this patch, I had turned off the missing prototype warnings for the 15
architectures that still had issues, but since there are only five left, I
think we can leave the rest to the maintainers (Cc'd here) as well.

Link: https://lkml.kernel.org/r/20231123110506.707903-7-arnd@kernel.org
Link: https://lore.kernel.org/lkml/20230810141947.1236730-1-arnd@kernel.org/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com> # RISC-V
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tudor Ambarus <tudor.ambarus@linaro.org>
Cc: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.extrawarn |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/Makefile.extrawarn~makefileextrawarn-turn-on-missing-prototypes-globally
+++ a/scripts/Makefile.extrawarn
@@ -17,6 +17,8 @@ KBUILD_CFLAGS += -Wno-format-security
 KBUILD_CFLAGS += -Wno-trigraphs
 KBUILD_CFLAGS += $(call cc-disable-warning,frame-address,)
 KBUILD_CFLAGS += $(call cc-disable-warning, address-of-packed-member)
+KBUILD_CFLAGS += -Wmissing-declarations
+KBUILD_CFLAGS += -Wmissing-prototypes
 
 ifneq ($(CONFIG_FRAME_WARN),0)
 KBUILD_CFLAGS += -Wframe-larger-than=$(CONFIG_FRAME_WARN)
@@ -95,10 +97,8 @@ export KBUILD_EXTRA_WARN
 ifneq ($(findstring 1, $(KBUILD_EXTRA_WARN)),)
 
 KBUILD_CFLAGS += -Wextra -Wunused -Wno-unused-parameter
-KBUILD_CFLAGS += -Wmissing-declarations
 KBUILD_CFLAGS += $(call cc-option, -Wrestrict)
 KBUILD_CFLAGS += -Wmissing-format-attribute
-KBUILD_CFLAGS += -Wmissing-prototypes
 KBUILD_CFLAGS += -Wold-style-definition
 KBUILD_CFLAGS += -Wmissing-include-dirs
 KBUILD_CFLAGS += $(call cc-option, -Wunused-but-set-variable)
_

Patches currently in -mm which might be from arnd@arndb.de are


