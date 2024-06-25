Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF81142E76
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293156; cv=none; b=CU0afNti3rm/yGqDVH68l+SlkPMl/mdTaaDxsJMmqHlcFDhipuMtNEBWdZz5jQOX+bPa6WLPe9kEqNIMaNyB0OrlloVwOfXFmAaXiY/nw861KbByf3fbCgZJY/aIX44wTqY9Ejnuon2GOLi1PHj9ySQi02kjbWohh9yZLW3xYuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293156; c=relaxed/simple;
	bh=lkkruxwp0F0/Ytf+7UMeHhZd9fPdq2a6WoH2cgo3qUs=;
	h=Date:To:From:Subject:Message-Id; b=tzsgoFwMmVo3gF26S+Fqr5dUMPiS2gpzl3yPxck0Wckg7Ix07sLDvXRcVUNdyAM2sem5NhGdHpAEsJ+P5Jp7JTdAei61WzU5ih8xid5MIyTsAsJQiSNdk3smjQQvEIPk3Y5Nm6szP9uhzoPquMSGyxGWjhbwvf/WH7P77n5nl+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=of8AgS6e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="of8AgS6e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730D6C32782;
	Tue, 25 Jun 2024 05:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293156;
	bh=lkkruxwp0F0/Ytf+7UMeHhZd9fPdq2a6WoH2cgo3qUs=;
	h=Date:To:From:Subject:From;
	b=of8AgS6efPDM71PgRfCO5yEe77nH2BWBQ6Ux9QUZ6KOCVMdtpCbttglK7dpoqWc3d
	 P5YeDPjNEdORHfDfkqxfFFYa638PgJdANcrokhYpUJelKm9f0ywYi74JIPJXHyswZ1
	 8BeHnYT7zRbp6s38pHgHiRG2647On1w3vh+GmCe4=
Date: Mon, 24 Jun 2024 22:25:55 -0700
To: mm-commits@vger.kernel.org,weihsinyeh168@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] tools-fix-typo.patch removed from -mm tree
Message-Id: <20240625052556.730D6C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: include/linux/jhash.h: fix typos
has been removed from the -mm tree.  Its filename was
     tools-fix-typo.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei-Hsin Yeh <weihsinyeh168@gmail.com>
Subject: include/linux/jhash.h: fix typos
Date: Sun, 12 May 2024 13:42:11 +0800

Drop one '-' to adhere to coding style.
Replace 'arbitray' with 'arbitrary'.

Link: https://lkml.kernel.org/r/20240512054211.24726-1-weihsinyeh168@gmail.com
Signed-off-by: Wei-Hsin Yeh <weihsinyeh168@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/jhash.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/jhash.h~tools-fix-typo
+++ a/include/linux/jhash.h
@@ -31,7 +31,7 @@
 /* Mask the hash value, i.e (value & jhash_mask(n)) instead of (value % n) */
 #define jhash_mask(n)   (jhash_size(n)-1)
 
-/* __jhash_mix -- mix 3 32-bit values reversibly. */
+/* __jhash_mix - mix 3 32-bit values reversibly. */
 #define __jhash_mix(a, b, c)			\
 {						\
 	a -= c;  a ^= rol32(c, 4);  c += b;	\
@@ -60,7 +60,7 @@
 /* jhash - hash an arbitrary key
  * @k: sequence of bytes as key
  * @length: the length of the key
- * @initval: the previous hash, or an arbitray value
+ * @initval: the previous hash, or an arbitrary value
  *
  * The generic version, hashes an arbitrary sequence of bytes.
  * No alignment or length assumptions are made about the input key.
@@ -110,7 +110,7 @@ static inline u32 jhash(const void *key,
 /* jhash2 - hash an array of u32's
  * @k: the key which must be an array of u32's
  * @length: the number of u32's in the key
- * @initval: the previous hash, or an arbitray value
+ * @initval: the previous hash, or an arbitrary value
  *
  * Returns the hash value of the key.
  */
_

Patches currently in -mm which might be from weihsinyeh168@gmail.com are


