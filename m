Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAF212FB2F
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 23:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720827617; cv=none; b=knhR6PY4sUBxKBeDtVveXpstEcI2qR5MGyDicc1WoKXkz1f9SpHDQ/hP+nLKEIGNmZnZOkHUPgowlWJNBUJv2Iubad9A0FflOF/9LOMrfUA2Lp02sBjs+ZTEXfTO8xMrCyqsaiEAiFs8h0ShwMRVwVg5pi4pcHXkpJotL9Pd69o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720827617; c=relaxed/simple;
	bh=fQrjy/b+jUiilOD5HCHLG/AThARgjBNfqoMeEpJYK9U=;
	h=Date:To:From:Subject:Message-Id; b=NMdISqZftmMP35sGDXmpICEjoTtPa1Z6aSwQYq08S/8tc4GffV0NI0a2HqeygbRfdxmicATRCYbfQGoLEoCqioDIP8MJqZEWcTRJce6D6ov6LTJYq3Zf2n36+6FBH6/5WWZKFftn+ym+LUQ97LW6IZUQeyOqzkUbsoWsLlnqlyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2wOeTUVF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2wOeTUVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8B4C32782;
	Fri, 12 Jul 2024 23:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720827616;
	bh=fQrjy/b+jUiilOD5HCHLG/AThARgjBNfqoMeEpJYK9U=;
	h=Date:To:From:Subject:From;
	b=2wOeTUVFnxpsm8+6+qhfhzVz8+GiVfPBdU+E1QF/Jxnl5eJ/WESrq9xdDR40MP3EP
	 nN2DEYB8hgG2OyLwlIdIvh5yTbgTczY4iBNu9ax6WT3i0Dhy1uh4yOuRKUgHViw0sh
	 VfOIXcmVZwkTnlP6pXjQhaKMHyr6mqDaDwXOuMk8=
Date: Fri, 12 Jul 2024 16:40:15 -0700
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,masahiroy@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] init-remove-unused-__meminit-macros.patch removed from -mm tree
Message-Id: <20240712234016.7E8B4C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: init: remove unused __MEMINIT* macros
has been removed from the -mm tree.  Its filename was
     init-remove-unused-__meminit-macros.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Masahiro Yamada <masahiroy@kernel.org>
Subject: init: remove unused __MEMINIT* macros
Date: Sun, 7 Jul 2024 01:05:05 +0900

These macros are not used anywhere.

Link: https://lkml.kernel.org/r/20240706160511.2331061-1-masahiroy@kernel.org
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/include/linux/init.h~init-remove-unused-__meminit-macros
+++ a/include/linux/init.h
@@ -99,10 +99,6 @@
 #define __INITRODATA	.section	".init.rodata","a",%progbits
 #define __FINITDATA	.previous
 
-#define __MEMINIT        .section	".meminit.text", "ax"
-#define __MEMINITDATA    .section	".meminit.data", "aw"
-#define __MEMINITRODATA  .section	".meminit.rodata", "a"
-
 /* silence warnings when references are OK */
 #define __REF            .section       ".ref.text", "ax"
 #define __REFDATA        .section       ".ref.data", "aw"
_

Patches currently in -mm which might be from masahiroy@kernel.org are


