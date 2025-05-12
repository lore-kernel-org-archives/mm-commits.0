Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46E31A76D4
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011384; cv=none; b=iw8Zoasv/Lts4/cNBkhiGGnJH+lhGw3Ks0Gdzn7MH0afI+TWsZSMSEPVB6qdCk2OF2wdCzxVvPJTUwwBcDwfyV/yjuNccWVO1ACEuwFpGIi0DR4c8EITDrGuwHhSfVhYZZwUtXikwqb/o9sEP+aXqM8CSvR+bvoumwKQBuIQbog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011384; c=relaxed/simple;
	bh=5bHiREhqXG0fz9R/TL0ARf3Sb7G7X0CuMlofjRPbRfs=;
	h=Date:To:From:Subject:Message-Id; b=jPJXzo0FUA0ayMhjczKBAxtNg+EJCd397wTZ+7n56kmpp8ggpvyJr0xzm3Q7OzjvbGMToqIe788MeAR10zHiHxWCe7Ep5gPMPZpInM/OpnlgJtfvmXvgJA92lTT5Hs49GBjjRskofTpniPtm7Q8IrElsfTLLuWRYSh62HjzCys8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ogthGVvV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ogthGVvV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91ACC4CEE4;
	Mon, 12 May 2025 00:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011384;
	bh=5bHiREhqXG0fz9R/TL0ARf3Sb7G7X0CuMlofjRPbRfs=;
	h=Date:To:From:Subject:From;
	b=ogthGVvVGcJzG7+NzOdrvblFc1GX1jEkJAKCbG4jBKWgqJLmEIlSQSlKuOlmfgHEg
	 lNfRdifacWVsXsJuEBNoxnfpoZ98QtCvUCj1fMoY4DGc4yI2Zqg0siJpvFIReMC8lo
	 POxzt5NqV8O0triewxm0LCvwozu/rXWNKa9fCznA=
Date: Sun, 11 May 2025 17:56:24 -0700
To: mm-commits@vger.kernel.org,linux@treblig.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-oid_registryc-remove-unused-sprint_oid.patch removed from -mm tree
Message-Id: <20250512005624.A91ACC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/oid_registry.c: remove unused sprint_OID
has been removed from the -mm tree.  Its filename was
     lib-oid_registryc-remove-unused-sprint_oid.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Dr. David Alan Gilbert" <linux@treblig.org>
Subject: lib/oid_registry.c: remove unused sprint_OID
Date: Thu, 1 May 2025 02:05:02 +0100

sprint_OID() was added as part of 2012's commit 4f73175d0375 ("X.509: Add
utility functions to render OIDs as strings") but it hasn't been used. 
Remove it.

Note that there's also 'sprint_oid' (lower case) which is used in a lot of
places; that's left as is except for fixing its case in a comment.

Link: https://lkml.kernel.org/r/20250501010502.326472-1-linux@treblig.org
Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oid_registry.h |    1 -
 lib/oid_registry.c           |   25 +------------------------
 2 files changed, 1 insertion(+), 25 deletions(-)

--- a/include/linux/oid_registry.h~lib-oid_registryc-remove-unused-sprint_oid
+++ a/include/linux/oid_registry.h
@@ -151,6 +151,5 @@ enum OID {
 extern enum OID look_up_OID(const void *data, size_t datasize);
 extern int parse_OID(const void *data, size_t datasize, enum OID *oid);
 extern int sprint_oid(const void *, size_t, char *, size_t);
-extern int sprint_OID(enum OID, char *, size_t);
 
 #endif /* _LINUX_OID_REGISTRY_H */
--- a/lib/oid_registry.c~lib-oid_registryc-remove-unused-sprint_oid
+++ a/lib/oid_registry.c
@@ -117,7 +117,7 @@ int parse_OID(const void *data, size_t d
 EXPORT_SYMBOL_GPL(parse_OID);
 
 /*
- * sprint_OID - Print an Object Identifier into a buffer
+ * sprint_oid - Print an Object Identifier into a buffer
  * @data: The encoded OID to print
  * @datasize: The size of the encoded OID
  * @buffer: The buffer to render into
@@ -173,26 +173,3 @@ bad:
 	return -EBADMSG;
 }
 EXPORT_SYMBOL_GPL(sprint_oid);
-
-/**
- * sprint_OID - Print an Object Identifier into a buffer
- * @oid: The OID to print
- * @buffer: The buffer to render into
- * @bufsize: The size of the buffer
- *
- * The OID is rendered into the buffer in "a.b.c.d" format and the number of
- * bytes is returned.
- */
-int sprint_OID(enum OID oid, char *buffer, size_t bufsize)
-{
-	int ret;
-
-	BUG_ON(oid >= OID__NR);
-
-	ret = sprint_oid(oid_data + oid_index[oid],
-			 oid_index[oid + 1] - oid_index[oid],
-			 buffer, bufsize);
-	BUG_ON(ret == -EBADMSG);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(sprint_OID);
_

Patches currently in -mm which might be from linux@treblig.org are


