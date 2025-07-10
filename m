Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753AE22128B
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127144; cv=none; b=c/LCy41rB7GDfT/hmxG5AmJ7o3ioXK0tmVp3/eRj5IDEbfAmXePuReqAtXW/KBSYuHZLqVXqz+Mj13hw1q2yI8VGNT+LyRtrWLFMB0ZgvSgNLoyVfBgLvel2smUSrPxzrERqN1Aw3xWQht0jxcqG3a43YHMXm2ih05+zZWMdkhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127144; c=relaxed/simple;
	bh=y/4hIdd3DCfwieSrZYnWUpvNVNPKfTQPuwiSCu/0+Uw=;
	h=Date:To:From:Subject:Message-Id; b=Wqe+hxZRjaoDGEwDEGMA+VLJ+e5bChbHB4yI8Jri8wLQQttLepX+PQr+EtoIVWjx/iLu0GDxVDtdLjwUPheRf/fHDpZj1TjMXxn1UPYTiD/PY2h5ListvyiZOlj7c/5y7fhTd8qat9vMwUijzXP3xYqz5O45w6rcQZ7CUFJuSzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MPx8MJN+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MPx8MJN+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060F7C4CEE3;
	Thu, 10 Jul 2025 05:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752127144;
	bh=y/4hIdd3DCfwieSrZYnWUpvNVNPKfTQPuwiSCu/0+Uw=;
	h=Date:To:From:Subject:From;
	b=MPx8MJN+KM15d6guBAFKjEN/Pn1sVME/Q+3H/mI/e3tOl4B8Vyz34Yrdo/aY42F5I
	 7Jn5VJAycA/Bgb2svWWOC08nKiJ4Mwtq4lETcEan7zUE6UB8iwfbohTXBJwh+niXnt
	 Hgs2Bbi1IoPIGcdxOTs7BW+c5IIDV1te1bu8f4+0=
Date: Wed, 09 Jul 2025 22:59:02 -0700
To: mm-commits@vger.kernel.org,weihsinyeh168@gmail.com,arnd@arndb.de,julian@outer-limits.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] replace-__get_unaligned_cpu32-in-jhash-function.patch removed from -mm tree
Message-Id: <20250710055904.060F7C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: include/linux/jhash.h: replace __get_unaligned_cpu32 in jhash function
has been removed from the -mm tree.  Its filename was
     replace-__get_unaligned_cpu32-in-jhash-function.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Julian Vetter <julian@outer-limits.org>
Subject: include/linux/jhash.h: replace __get_unaligned_cpu32 in jhash function
Date: Tue, 3 Jun 2025 15:21:21 +0200

__get_unaligned_cpu32() is deprecated.  So, replace it with the more
generic get_unaligned() and just cast the input parameter.

Link: https://lkml.kernel.org/r/20250603132121.3674066-1-julian@outer-limits.org
Signed-off-by: Julian Vetter <julian@outer-limits.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Wei-Hsin Yeh <weihsinyeh168@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/jhash.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/jhash.h~replace-__get_unaligned_cpu32-in-jhash-function
+++ a/include/linux/jhash.h
@@ -24,7 +24,7 @@
  * Jozsef
  */
 #include <linux/bitops.h>
-#include <linux/unaligned/packed_struct.h>
+#include <linux/unaligned.h>
 
 /* Best hash sizes are of power of two */
 #define jhash_size(n)   ((u32)1<<(n))
@@ -77,9 +77,9 @@ static inline u32 jhash(const void *key,
 
 	/* All but the last block: affect some 32 bits of (a,b,c) */
 	while (length > 12) {
-		a += __get_unaligned_cpu32(k);
-		b += __get_unaligned_cpu32(k + 4);
-		c += __get_unaligned_cpu32(k + 8);
+		a += get_unaligned((u32 *)k);
+		b += get_unaligned((u32 *)(k + 4));
+		c += get_unaligned((u32 *)(k + 8));
 		__jhash_mix(a, b, c);
 		length -= 12;
 		k += 12;
_

Patches currently in -mm which might be from julian@outer-limits.org are


