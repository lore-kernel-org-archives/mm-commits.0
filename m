Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5230B4685
	for <mm-commits@vger.kernel.org>; Sat, 30 Mar 2024 02:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711767538; cv=none; b=UipuPxNkYH/KLIo0bdN4CySkGY3/2VdTJJ2XDRFVDNbwBNuzmwxw8hSmH3V5b3AkVBfhkGCJUTonZ0u40UhsJlvfkXzsIfWG/pZ4uoOuHKKSyj3t7JSCY4v4Gj2Muc9q7Q2xt/rHGQRhdSr9VJS0wsBdmg31hJxeP7TwIMSu7vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711767538; c=relaxed/simple;
	bh=8KJ7ryWhsAOM52kaNCZy3guv3w17NWul2O66eGMAqI0=;
	h=Date:To:From:Subject:Message-Id; b=GhQzBQq9Ma/+MTuQnwYL2uFFR3RjKbIADZvoqFLtdp0VrqQjwPxcryLlVyJhl+S9dJSuApPCLKHGqrhDBa5gz2iZAX3eFM2B8o6TrjL0xbwO/RIcIDEx2ljSU68Tq5+ARTwiH0as6pVRqvA9xEscBI6roRtrWL0+IAkzWUzY20k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LRFXSEsj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LRFXSEsj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD609C433F1;
	Sat, 30 Mar 2024 02:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711767537;
	bh=8KJ7ryWhsAOM52kaNCZy3guv3w17NWul2O66eGMAqI0=;
	h=Date:To:From:Subject:From;
	b=LRFXSEsj+04JOzhcLgke5H4Opp/9p2HdFQng+Al3S1tEOhImusQGXSTwxsJ8H7Usr
	 wK2MEht9RGcC5St5Pnlx2O0AHPk4AgJaevL9Xdr9AnRFzdwmapNnH3Lu7oehnGxnU2
	 GW4ERkvF8Am354/xnyhdmCWG0n9VfvBLeIScNkc8=
Date: Fri, 29 Mar 2024 19:58:57 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,ma.xxn@outlook.com,lukas.bulwahn@gmail.com,linux@roeck-us.net,joe@perches.com,jcmvbkbc@gmail.com,herbert@gondor.apana.org.au,dwaipayanray1@gmail.com,corbet@lwn.net,chris@zankel.net,chenhuacai@loongson.cn,broonie@kernel.org,apw@canonical.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] documentation-coding-style-ask-function-like-macros-to-evaluate-parameters.patch removed from -mm tree
Message-Id: <20240330025857.CD609C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation: coding-style: ask function-like macros to evaluate parameters
has been removed from the -mm tree.  Its filename was
     documentation-coding-style-ask-function-like-macros-to-evaluate-parameters.patch

This patch was dropped because an updated version will be merged

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

arm64-mm-swap-support-thp_swap-on-hardware-with-mte.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio.patch

