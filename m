Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFD54C6D
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 00:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723509769; cv=none; b=taF48A8eZXXrixljHukk2vkpFiy4jfOzwrN4yp2OLABbVfwAuB643/XkiM9avHYLqTf2HNmBWSdUVLNm793RLSovVuWP5bkTSJyuMeO8UGfmkrHUeIYx+28V1bvpd/1yOMMbzpwFlJ+6t2L2itKsW0OxyTiYAS8kUSKKoqpjdLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723509769; c=relaxed/simple;
	bh=ANyuwOqHWoKXLPOsQS8luDQ3HRWXqZ5R6TsU7bG1mB8=;
	h=Date:To:From:Subject:Message-Id; b=HJ+pCNpk2H4d4x+X8rtlr1DtUMiPPZ9dZQdopdfgv9JWI53Po8XFlDqJdNpsFehJ7MhGnVyTDVYWJwpQrfAcNgt0xrvB/DWws12xbTdLZKtMMBMs0M3ld0X2gaSEbE0hlEHrj4vCDJ2bHQwcMMBvKyCInZMRTpa2H8SesnEHsRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VFDkATyP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VFDkATyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7571C4AF0E;
	Tue, 13 Aug 2024 00:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723509768;
	bh=ANyuwOqHWoKXLPOsQS8luDQ3HRWXqZ5R6TsU7bG1mB8=;
	h=Date:To:From:Subject:From;
	b=VFDkATyP2K3kp6cD2TvJEMlRJhHTaaWumIELZjZMpRHxcEQ0puGgsgWj8cNH+k/5P
	 QDW4+k8t86XvM1/6/LSJiJ/CNSAa9yLg43Yh5sOPGZ3g98Kw3/kbTSKW+XJ39qyJ/i
	 EcuiMvyM5pBvkOsvsuIWRIAl2CfOeihFmLLMwwFs=
Date: Mon, 12 Aug 2024 17:42:48 -0700
To: mm-commits@vger.kernel.org,linux@roeck-us.net,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] powerpc-mm-fix-size-of-allocated-pgdir.patch removed from -mm tree
Message-Id: <20240813004248.B7571C4AF0E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc/mm: fix size of allocated PGDIR
has been removed from the -mm tree.  Its filename was
     powerpc-mm-fix-size-of-allocated-pgdir.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


