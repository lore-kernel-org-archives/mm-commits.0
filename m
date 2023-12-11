Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82B67493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z0MX+NCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EAB0C433C8;
	Mon, 11 Dec 2023 01:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257833;
	bh=zzPL1Z31mbDMs9deKrcjW8E19Zu+5TQVY5jSXsmWRJw=;
	h=Date:To:From:Subject:From;
	b=Z0MX+NCuCp3dkHeBsRcUC5XcdBBhlCFWdKMODquTqUw8/c2zfFYdEhEmQe53NSsVH
	 V0lOjXXWl0C9N925LRxUYCiVkFCPI/95b1Pm/QbiugahP8Imx9srvNb8JvnuiXLOFR
	 BVqcuiu9glX+HQ3+5DJYh4et7oq+oCYbdVEc9+3g=
Date: Sun, 10 Dec 2023 17:23:53 -0800
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,tudor.ambarus@linaro.org,tsbogend@alpha.franken.de,sfr@canb.auug.org.au,richard@nod.at,richard.henderson@linaro.org,peterz@infradead.org,palmer@rivosinc.com,nicolas@fjasle.eu,nathan@kernel.org,mpe@ellerman.id.au,mattst88@gmail.com,masahiroy@kernel.org,keescook@chromium.org,ink@jurassic.park.msu.ru,gregkh@linuxfoundation.org,glaubitz@physik.fu-berlin.de,dwmw2@infradead.org,dinguyen@kernel.org,davem@davemloft.net,dalias@libc.org,chengzhihao1@huawei.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] jffs2-mark-__jffs2_dbg_superblock_counts-static.patch removed from -mm tree
Message-Id: <20231211012353.7EAB0C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: jffs2: mark __jffs2_dbg_superblock_counts() static
has been removed from the -mm tree.  Its filename was
     jffs2-mark-__jffs2_dbg_superblock_counts-static.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: jffs2: mark __jffs2_dbg_superblock_counts() static
Date: Thu, 23 Nov 2023 12:05:02 +0100

This function is only called locally and does not need to be global. 
Since there is no external prototype, gcc warns about the non-static
definition:

fs/jffs2/debug.c:160:6: error: no previous prototype for '__jffs2_dbg_superblock_counts' [-Werror=missing-prototypes]

Link: https://lkml.kernel.org/r/20231123110506.707903-3-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/jffs2/debug.c~jffs2-mark-__jffs2_dbg_superblock_counts-static
+++ a/fs/jffs2/debug.c
@@ -157,7 +157,7 @@ __jffs2_dbg_prewrite_paranoia_check(stru
 	kfree(buf);
 }
 
-void __jffs2_dbg_superblock_counts(struct jffs2_sb_info *c)
+static void __jffs2_dbg_superblock_counts(struct jffs2_sb_info *c)
 {
 	struct jffs2_eraseblock *jeb;
 	uint32_t free = 0, dirty = 0, used = 0, wasted = 0,
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-fix-kexec_file-dependencies.patch
kexec-fix-kexec_file-dependencies-fix.patch
kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch
makefileextrawarn-turn-on-missing-prototypes-globally.patch

