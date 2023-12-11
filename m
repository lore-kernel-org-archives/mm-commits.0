Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6177493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kcBPOUwM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55938C433C8;
	Mon, 11 Dec 2023 01:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257837;
	bh=sgHSnXpWkN2iqggIVj34JtKO4zJJ5SeJrltF6HgHfmE=;
	h=Date:To:From:Subject:From;
	b=kcBPOUwMozNXPwcfKFYZl3XPTERvvXMH5eOlcktld0VKl+3z9DfNn0jk9BpbFeser
	 2/b0USOAV+BN8WwIfkHwFu3azcftyPH7EunA5pERnRvIZam/Fbb5DU/XQOEzW6IABA
	 bPBlI7a6d6WLttrI19wkwoz73rVkPlsArgHAddAE=
Date: Sun, 10 Dec 2023 17:23:56 -0800
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,tudor.ambarus@linaro.org,tsbogend@alpha.franken.de,sfr@canb.auug.org.au,richard@nod.at,richard.henderson@linaro.org,peterz@infradead.org,palmer@rivosinc.com,nicolas@fjasle.eu,nathan@kernel.org,mpe@ellerman.id.au,mattst88@gmail.com,masahiroy@kernel.org,keescook@chromium.org,ink@jurassic.park.msu.ru,gregkh@linuxfoundation.org,glaubitz@physik.fu-berlin.de,dwmw2@infradead.org,dinguyen@kernel.org,davem@davemloft.net,dalias@libc.org,chengzhihao1@huawei.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] usb-fsl-mph-dr-of-mark-fsl_usb2_mpc5121_init-static.patch removed from -mm tree
Message-Id: <20231211012357.55938C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: usb: fsl-mph-dr-of: mark fsl_usb2_mpc5121_init() static
has been removed from the -mm tree.  Its filename was
     usb-fsl-mph-dr-of-mark-fsl_usb2_mpc5121_init-static.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: usb: fsl-mph-dr-of: mark fsl_usb2_mpc5121_init() static
Date: Thu, 23 Nov 2023 12:05:05 +0100

This function is only called locally and should always have been static:

drivers/usb/host/fsl-mph-dr-of.c:291:5: error: no previous prototype for 'fsl_usb2_mpc5121_init' [-Werror=missing-prototypes]

Link: https://lkml.kernel.org/r/20231123110506.707903-6-arnd@kernel.org
Fixes: 230f7ede6c2f ("USB: add USB EHCI support for MPC5121 SoC")
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rich Felker <dalias@libc.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Tudor Ambarus <tudor.ambarus@linaro.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/fsl-mph-dr-of.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/fsl-mph-dr-of.c~usb-fsl-mph-dr-of-mark-fsl_usb2_mpc5121_init-static
+++ a/drivers/usb/host/fsl-mph-dr-of.c
@@ -288,7 +288,7 @@ static void fsl_usb2_mph_dr_of_remove(st
 #define PHYCTRL_LSFE		(1 << 1)	/* Line State Filter Enable */
 #define PHYCTRL_PXE		(1 << 0)	/* PHY oscillator enable */
 
-int fsl_usb2_mpc5121_init(struct platform_device *pdev)
+static int fsl_usb2_mpc5121_init(struct platform_device *pdev)
 {
 	struct fsl_usb2_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct clk *clk;
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-fix-kexec_file-dependencies.patch
kexec-fix-kexec_file-dependencies-fix.patch
kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch
makefileextrawarn-turn-on-missing-prototypes-globally.patch

