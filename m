Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7734315A85E
	for <mm-commits@vger.kernel.org>; Thu,  8 Aug 2024 22:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723155623; cv=none; b=RFR59KGE2tQc0erxlM2IRdqtoQAN3zqk0ukwl1YGhN1uqaxTknPBXFLNTZiC2UjOGKC5RE6JOgJV1USijFshtIg9oMHsSe1DqbKN4uJaWNu34lVztAPgTYdgMolpdvGnPGmeVvWouhyJ4EpY4GwXeRPD3nvail5sWbgOO8svVys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723155623; c=relaxed/simple;
	bh=rxyWqJKsFbPfZQUz8Wj3LbVP0HXVMm6Ki/nSmZhQvzo=;
	h=Date:To:From:Subject:Message-Id; b=d7z6oaYC8XfXIvrqm1o7x9eVEE7H8QnQVXXm+m/AqCRp9cplcH1TFvzEi1Bu4+uK+JLPq9CJUVlggfZ0KTvB86vTqXbmiueGLdm5dx8Xtkw0fj/2yHvshEHlu0B5yf/zFQ7rKcRJeCnJDxl/MvNMCIQOMuUOqGbXlL8oqFQwEz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iHQReJtg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iHQReJtg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC884C32782;
	Thu,  8 Aug 2024 22:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723155623;
	bh=rxyWqJKsFbPfZQUz8Wj3LbVP0HXVMm6Ki/nSmZhQvzo=;
	h=Date:To:From:Subject:From;
	b=iHQReJtgy7HVb6FVW7OnmuHShGovCfMFkbxS6G3+5cHgPxDT4F36kF9+oa65hFhAW
	 TgoIQsw4fiX8HhifTtjeQpXJ1Ex0FOFu5Gm+GMT0y01Ltlz6lv2/oiJsGe1ztPqsbe
	 TXDuAPPc19ynpg5C/Qf/jsShSU8J9v/j8xFfIIL8=
Date: Thu, 08 Aug 2024 15:20:22 -0700
To: mm-commits@vger.kernel.org,linux@roeck-us.net,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-mm-fix-size-of-allocated-pgdir.patch added to mm-hotfixes-unstable branch
Message-Id: <20240808222022.EC884C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc/mm: fix size of allocated PGDIR
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     powerpc-mm-fix-size-of-allocated-pgdir.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-mm-fix-size-of-allocated-pgdir.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: powerpc/mm: fix size of allocated PGDIR
Date: Thu, 8 Aug 2024 11:32:47 +0200

Commit 6b0e82791bd0 ("powerpc/e500: switch to 64 bits PGD on 85xx
(32 bits)") increased the size of PGD entries but failed to increase
the PGD directory.

Use the size of pgd_t instead of the size of pointers to calculate the
allocated size.

Link: https://lkml.kernel.org/r/1cdaacb391cbd3e0240f0e0faf691202874e9422.1723109462.git.christophe.leroy@csgroup.eu
Fixes: 6b0e82791bd0 ("powerpc/e500: switch to 64 bits PGD on 85xx (32 bits)")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/init-common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/mm/init-common.c~powerpc-mm-fix-size-of-allocated-pgdir
+++ a/arch/powerpc/mm/init-common.c
@@ -73,7 +73,7 @@ void setup_kup(void)
 
 #define CTOR(shift) static void ctor_##shift(void *addr) \
 {							\
-	memset(addr, 0, sizeof(void *) << (shift));	\
+	memset(addr, 0, sizeof(pgd_t) << (shift));	\
 }
 
 CTOR(0); CTOR(1); CTOR(2); CTOR(3); CTOR(4); CTOR(5); CTOR(6); CTOR(7);
@@ -117,7 +117,7 @@ EXPORT_SYMBOL_GPL(pgtable_cache);	/* use
 void pgtable_cache_add(unsigned int shift)
 {
 	char *name;
-	unsigned long table_size = sizeof(void *) << shift;
+	unsigned long table_size = sizeof(pgd_t) << shift;
 	unsigned long align = table_size;
 
 	/* When batching pgtable pointers for RCU freeing, we store
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

powerpc-mm-fix-size-of-allocated-pgdir.patch

