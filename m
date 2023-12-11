Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851D57493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qi13iZFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3FFC433C8;
	Mon, 11 Dec 2023 01:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257821;
	bh=epxxzTVp8s/nNyeqNtQ73Ipx8KhBhKW7W4oT1di9H3U=;
	h=Date:To:From:Subject:From;
	b=Qi13iZFzmnfuqy94uu5mHKo22QwZ2vyRnYo6fYvqFjOV0XIW30LAhe6UuA5ZwSmd5
	 8gZxaEeAe4bnPjo+vH+7Cyl4mLD8sRaglY0eXCbOzFUNpX5HJTwnnhErTq44JIanw8
	 IBxO3UzbpFao8O13ScQEjxebT1E5MUdV7PDqyP/M=
Date: Sun, 10 Dec 2023 17:23:40 -0800
To: mm-commits@vger.kernel.org,tsbogend@alpha.franken.de,sfr@rothwell.id.au,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mips-unhide-uasm_in_compat_space_p-declaration.patch removed from -mm tree
Message-Id: <20231211012341.4F3FFC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mips: unhide uasm_in_compat_space_p() declaration
has been removed from the -mm tree.  Its filename was
     mips-unhide-uasm_in_compat_space_p-declaration.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mips: unhide uasm_in_compat_space_p() declaration
Date: Mon, 4 Dec 2023 12:56:59 +0100

uasm_in_compat_space_p() has a conditional declaration but is defined
unconditionally because of another local user, which causes a warning:

arch/mips/mm/uasm.c:421:5: error: no previous prototype for 'uasm_in_compat_space_p' [-Werror=missing-prototypes]

Make the declaration unconditional to avoid this.

Link: https://lkml.kernel.org/r/20231204115710.2247097-10-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/uasm.h |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/mips/include/asm/uasm.h~mips-unhide-uasm_in_compat_space_p-declaration
+++ a/arch/mips/include/asm/uasm.h
@@ -193,9 +193,7 @@ struct uasm_label {
 
 void uasm_build_label(struct uasm_label **lab, u32 *addr,
 			int lid);
-#ifdef CONFIG_64BIT
 int uasm_in_compat_space_p(long addr);
-#endif
 int uasm_rel_hi(long val);
 int uasm_rel_lo(long val);
 void UASM_i_LA_mostly(u32 **buf, unsigned int rs, long addr);
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-fix-kexec_file-dependencies.patch
kexec-fix-kexec_file-dependencies-fix.patch
kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch
makefileextrawarn-turn-on-missing-prototypes-globally.patch

