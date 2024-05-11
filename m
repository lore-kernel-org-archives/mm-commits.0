Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D5A3A28B
	for <mm-commits@vger.kernel.org>; Sat, 11 May 2024 22:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715467941; cv=none; b=lKkw0n068pCx4OoRRUtkEKHt5Eb8jjcj26ShSGzz7lliCqyR65+8n49J2EEdJ+/06GMlZJQb6YeynxACecTYePXNUzS+5ijOCyQak0ik7HEi3azDBWaMBycpfXJ8TefrFRyMqEmd8u5MrWRwterqih5hU9z41qbrLtyzmVWhCFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715467941; c=relaxed/simple;
	bh=7KPFNuXaOC5az6o+tNHG8Vg5h7hhLSDeMdLIsUARByA=;
	h=Date:To:From:Subject:Message-Id; b=jRqeXcV4fB7C51ePXzvne5+BTPu3tUiSmOMcWkOm/dkhujgHeybpiTDTtQSGBVLu4vMYe/I7JKhdUzAeBtpyxFmvkQPgnNyT9Buc1MMs/iLgKQsJOF1biNYfeZlZqJWfHQTsOUPTlUqGCgYTYeSB7Md6ERmHQ1WP8F8JVaxSVtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GRSVQG8Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GRSVQG8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849A2C2BBFC;
	Sat, 11 May 2024 22:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715467940;
	bh=7KPFNuXaOC5az6o+tNHG8Vg5h7hhLSDeMdLIsUARByA=;
	h=Date:To:From:Subject:From;
	b=GRSVQG8Z6gUq9CY76ROfL1Rq5l8zTINO5kwhFJ43fm/nqHk6PR/SxBXsj3c2kZLpd
	 D8BfG2vIvxm8g1KaWThTAsby4510NSV1gTFFId8YY52oDZEASnQuf6VyWx8LtYnXQ2
	 QtoprtyKiTZk3uwcN393rVGWL+L+z/4JL2ZWNGjg=
Date: Sat, 11 May 2024 15:52:20 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,quic_jjohnson@quicinc.com,mac.xxn@outlook.com,lukas.bulwahn@gmail.com,linux@roeck-us.net,joe@perches.com,jcmvbkbc@gmail.com,herbert@gondor.apana.org.au,dwaipayanray1@gmail.com,corbet@lwn.net,chris@zankel.net,chenhuacai@loongson.cn,charlemagnelasse@gmail.com,broonie@kernel.org,apw@canonical.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] documentation-coding-style-ask-function-like-macros-to-evaluate-parameters.patch removed from -mm tree
Message-Id: <20240511225220.849A2C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation: coding-style: ask function-like macros to evaluate parameters
has been removed from the -mm tree.  Its filename was
     documentation-coding-style-ask-function-like-macros-to-evaluate-parameters.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


