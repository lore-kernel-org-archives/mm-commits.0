Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BB77493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KBcgZh5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55227C433C8;
	Mon, 11 Dec 2023 01:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257832;
	bh=XXM/CS0kKXcNEn5dlIS1SNB/nuEGe/6JB9eUiwGR9a0=;
	h=Date:To:From:Subject:From;
	b=KBcgZh5l8ISzN8zvEVUvEWWhGYXFCF1620y0vl38G9JfQltBk96JPt58VC7VXIwFE
	 Xiv4cp9QDORT8PUSgT+Piusa2/QRqoi1UD1l3LOKIQSWfWCoUyXqbjjr+WKRgGjqd/
	 uy0ADOqkdVCBilcCDL28Iri70CKF3me4eRmveDYg=
Date: Sun, 10 Dec 2023 17:23:51 -0800
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,tudor.ambarus@linaro.org,tsbogend@alpha.franken.de,sfr@canb.auug.org.au,richard@nod.at,richard.henderson@linaro.org,peterz@infradead.org,palmer@rivosinc.com,nicolas@fjasle.eu,nathan@kernel.org,mpe@ellerman.id.au,mattst88@gmail.com,masahiroy@kernel.org,keescook@chromium.org,ink@jurassic.park.msu.ru,gregkh@linuxfoundation.org,glaubitz@physik.fu-berlin.de,dwmw2@infradead.org,dinguyen@kernel.org,davem@davemloft.net,dalias@libc.org,chengzhihao1@huawei.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ida-make-ida_dump-static.patch removed from -mm tree
Message-Id: <20231211012352.55227C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ida: make 'ida_dump' static
has been removed from the -mm tree.  Its filename was
     ida-make-ida_dump-static.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: ida: make 'ida_dump' static
Date: Thu, 23 Nov 2023 12:05:01 +0100

Patch series "Treewide: enable -Wmissing-prototypes", v3.

At this point, there are five architectures with a number of known
regressions: alpha, nios2, mips, sh and sparc.  In the previous version of
this patch, I had turned off the missing prototype warnings for the 15
architectures that still had issues, but since there are only five left, I
think we can leave the rest to the maintainers (Cc'd here) as well.

The series is also likely to cause occasional build regressions on
linux-next as developers add new code that misses prototypes.  Hopefully
this should be resolved by the time the patches make it into a release and
everyone gets the warnings right away.  


This patch (of 6):

There is no global declaration for ida_dump() and no other callers, so
make it static to avoid this warning:

lib/test_ida.c:16:6: error: no previous prototype for 'ida_dump'

Link: https://lkml.kernel.org/r/20231123110506.707903-1-arnd@kernel.org
Link: https://lkml.kernel.org/r/20231123110506.707903-2-arnd@kernel.org
Fixes: 8ab8ba38d488 ("ida: Start new test_ida module")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rich Felker <dalias@libc.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Tudor Ambarus <tudor.ambarus@linaro.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Kees Cook <keescook@chromium.org>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_ida.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_ida.c~ida-make-ida_dump-static
+++ a/lib/test_ida.c
@@ -13,7 +13,7 @@ static unsigned int tests_run;
 static unsigned int tests_passed;
 
 #ifdef __KERNEL__
-void ida_dump(struct ida *ida) { }
+static void ida_dump(struct ida *ida) { }
 #endif
 #define IDA_BUG_ON(ida, x) do {						\
 	tests_run++;							\
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-fix-kexec_file-dependencies.patch
kexec-fix-kexec_file-dependencies-fix.patch
kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch
makefileextrawarn-turn-on-missing-prototypes-globally.patch

