Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A137416C6AF
	for <mm-commits@vger.kernel.org>; Tue,  7 May 2024 17:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715102668; cv=none; b=ctUBjy84dObvUeRTigmh5DO5z4Lel3gTIA9DI/ra2C8jXPRCFd/wVejD4ufsoFaEia+HUssx1zkYEtugQc2trV5rrNyT1yNUI2o6VcQnPFor8Bs3kj+1mL4N1k2pHX5RmSdH6FYFzbx7oi3RAd3Bm5CJGLop5+CBQsN72XrAbcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715102668; c=relaxed/simple;
	bh=vk8qddotg4WiTKkNZWxn7dBrDuf5F1vj5rdLr4KKXQw=;
	h=Date:To:From:Subject:Message-Id; b=FIkepYYksCM5DpgPKTGPXHstEilX/7Ax2MPWJKUpdQuvFhxa3Ct5e1WbbE9mdTOZXEhFd16oi+Ecw0O38YLzP527lNdl5FIt7E5vpbx5BpdkvPal95bNzCwAZjKvXy4nviZhPHXMIBBC/GqnNoRsL9Q3YOOHNdvFvOh9P9npKPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZrdXWuRn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZrdXWuRn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC98C4AF18;
	Tue,  7 May 2024 17:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715102668;
	bh=vk8qddotg4WiTKkNZWxn7dBrDuf5F1vj5rdLr4KKXQw=;
	h=Date:To:From:Subject:From;
	b=ZrdXWuRnmfYqUK6nkx4ipkO1s2q67gfLtXe5cZdaniMTF+B6m+00TMbUvVlBZHqZ/
	 DJ3wL1AZWxjKRKfnRpEtQJalooohAybIxGGXBR3NwKSDZUDTzkFJSXGMgVS44qFiw2
	 iSfF2PuS5iJ/AuY9/s6Sb30+8BhwVvSqMCiuW/EI=
Date: Tue, 07 May 2024 10:24:27 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,quic_jjohnson@quicinc.com,mac.xxn@outlook.com,lukas.bulwahn@gmail.com,linux@roeck-us.net,joe@perches.com,jcmvbkbc@gmail.com,herbert@gondor.apana.org.au,dwaipayanray1@gmail.com,corbet@lwn.net,chris@zankel.net,chenhuacai@loongson.cn,charlemagnelasse@gmail.com,broonie@kernel.org,apw@canonical.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-coding-style-ask-function-like-macros-to-evaluate-parameters.patch added to mm-nonmm-unstable branch
Message-Id: <20240507172428.1EC98C4AF18@smtp.kernel.org>
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
Date: Tue, 7 May 2024 15:27:56 +1200

Patch series "codingstyle: avoid unused parameters for a function-like
macro", v7.

A function-like macro could result in build warnings such as "unused
variable." This patchset updates the guidance to recommend always using a
static inline function instead and also provides checkpatch support for
this new rule.


This patch (of 2):

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

Link: https://lkml.kernel.org/r/20240507032757.146386-1-21cnbao@gmail.com
Link: https://lkml.kernel.org/r/20240507032757.146386-2-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Suggested-by: Max Filippov <jcmvbkbc@gmail.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Acked-by: Joe Perches <joe@perches.com>
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
Cc: Xining Xu <mac.xxn@outlook.com>
Cc: Charlemagne Lasse <charlemagnelasse@gmail.com>
Cc: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/process/coding-style.rst |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/Documentation/process/coding-style.rst~documentation-coding-style-ask-function-like-macros-to-evaluate-parameters
+++ a/Documentation/process/coding-style.rst
@@ -827,6 +827,29 @@ Macros with multiple statements should b
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
+Due to historical practices, many files still employ the "cast to (void)"
+approach to evaluate parameters. However, this method is not advisable.
+Inline functions address the issue of "expression with side effects
+evaluated more than once", circumvent unused-variable problems, and
+are generally better documented than macros for some reason.
+
+.. code-block:: c
+
+	/*
+	 * Avoid doing this whenever possible and instead opt for static
+	 * inline functions
+	 */
+	#define macrofun(foo) do { (void) (foo); } while (0)
+
 Things to avoid when using macros:
 
 1) macros that affect control flow:
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mailmap-add-entry-for-barry-song.patch
documentation-coding-style-ask-function-like-macros-to-evaluate-parameters.patch

