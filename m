Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738C676F16
	for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2024 19:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711134418; cv=none; b=A/bHHSthZVcIb5OM2CG3nZ5NRq3pBmLlbcV8FdG0M8rrgYWpRhZODd6VWxnAXuOs0lpuceGhAmdyncrFD848v8JppvAkVN3QK2MT8mWd4sYD/vn1wkBVwmv4fMAAZsRu2r/viWgjBJe2eTwXCRnmB6KPrPMo2Hmfd3vJEssXuYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711134418; c=relaxed/simple;
	bh=owpROWrRIozZPkaC/l9YekcDRd3vKFAdC2fKHy8cJ7U=;
	h=Date:To:From:Subject:Message-Id; b=n37kKHJ5/6n9J4HfC5P/a3uEZEqYFWAOe57rZb5ly9wQABhEARbhB3QH1iVxxkQVN9aWcQlx2gmA/cthxb9pf/Rmgztc0Sp85DN5vu9+NzL5YAaH/d8oKfdEX3Oo7nFWwuJV3dHlAh87Dk7CozR2PUMvQ/UQRQTkF2Opga310Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GW1TXUi6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GW1TXUi6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FD1C433C7;
	Fri, 22 Mar 2024 19:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711134418;
	bh=owpROWrRIozZPkaC/l9YekcDRd3vKFAdC2fKHy8cJ7U=;
	h=Date:To:From:Subject:From;
	b=GW1TXUi6Oo7vqthAPe4CJaA6WsTlACfJM4PBsum4vjL4Ui6bPTtgbWctobyAY8A/V
	 3eB8QHJigtZueK4gcu5DBDZECHh1k97g2feWNkmT8MNe/V3Jy0Z0J4AOJW1I4Z4msu
	 8yy87KzBfoDpHxgSHQ2HHD3HKO5vZEGPYEQRFui4=
Date: Fri, 22 Mar 2024 12:06:57 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,ma.xxn@outlook.com,lukas.bulwahn@gmail.com,linux@roeck-us.net,joe@perches.com,jcmvbkbc@gmail.com,herbert@gondor.apana.org.au,dwaipayanray1@gmail.com,corbet@lwn.net,chris@zankel.net,chenhuacai@loongson.cn,broonie@kernel.org,apw@canonical.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-coding-style-ask-function-like-macros-to-evaluate-parameters.patch added to mm-nonmm-unstable branch
Message-Id: <20240322190657.E5FD1C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation: coding-style: ask function-like macros to evaluate parameters
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     documentation-coding-style-ask-function-like-macros-to-evaluate-parameters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-coding-style-ask-function-like-macros-to-evaluate-parameters.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: Documentation: coding-style: ask function-like macros to evaluate parameters
Date: Fri, 22 Mar 2024 21:49:36 +1300

Recent commit 77292bb8ca69c80 ("crypto: scomp - remove memcpy if
sg_nents is 1 and pages are lowmem") leads to warnings on xtensa
and loongarch,
   In file included from crypto/scompress.c:12:
   include/crypto/scatterwalk.h: In function 'scatterwalk_pagedone':
   include/crypto/scatterwalk.h:76:30: warning: variable 'page' set but not used [-Wunused-but-set-variable]
      76 |                 struct page *page;
         |                              ^~~~
   crypto/scompress.c: In function 'scomp_acomp_comp_decomp':
>> crypto/scompress.c:174:38: warning: unused variable 'dst_page' [-Wunused-variable]
     174 |                         struct page *dst_page = sg_page(req->dst);
         |

The reason is that flush_dcache_page() is implemented as a noop
macro on these platforms as below,

 #define flush_dcache_page(page) do { } while (0)

The driver code, for itself, seems be quite innocent and placing
maybe_unused seems pointless,

 struct page *dst_page = sg_page(req->dst);

 for (i = 0; i < nr_pages; i++)
 	flush_dcache_page(dst_page + i);

And it should be independent of architectural implementation
differences.

Let's provide guidance on coding style for requesting parameter
evaluation or proposing the migration to a static inline
function.

Link: https://lkml.kernel.org/r/20240322084937.66018-2-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Suggested-by: Max Filippov <jcmvbkbc@gmail.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Cc: Chris Zankel <chris@zankel.net>
Cc: Huacai Chen <chenhuacai@loongson.cn>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Xining Xu <ma.xxn@outlook.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/process/coding-style.rst |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/Documentation/process/coding-style.rst~documentation-coding-style-ask-function-like-macros-to-evaluate-parameters
+++ a/Documentation/process/coding-style.rst
@@ -827,6 +827,22 @@ Macros with multiple statements should b
 				do_this(b, c);		\
 		} while (0)
 
+Function-like macros with unused parameters should be replaced by static
+inline functions to avoid the issue of unused variables:
+
+.. code-block:: c
+
+	static inline void fun(struct foo *foo)
+	{
+	}
+
+For historical reasons, many files still use the cast to (void) to evaluate
+parameters, but this method is not recommended:
+
+.. code-block:: c
+
+	#define macrofun(foo) do { (void) (foo); } while (0)
+
 Things to avoid when using macros:
 
 1) macros that affect control flow:
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-zswap-fix-kernel-bug-in-sg_init_one.patch
arm64-mm-swap-support-thp_swap-on-hardware-with-mte.patch
documentation-coding-style-ask-function-like-macros-to-evaluate-parameters.patch

