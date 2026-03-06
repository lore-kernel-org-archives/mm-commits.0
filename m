Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8983A3AA1B4
	for <mm-commits@vger.kernel.org>; Fri,  6 Mar 2026 17:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772819797; cv=none; b=eZjUGVnNj/wa6riiMfFmDWvCW1Sxih50LVNPSQ9OEBAAXBgHMV/3dFa9k6iYj9YUTrvwgh0REHkayO/JpA+LiTv0nQ/4Pc5DtlW2vmZmmYftbvgn7ywewQIM97vNPHmkdMhpYido4Si2pRgWpdlhh3z0Dtw/3L4Wi88g6UTv0MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772819797; c=relaxed/simple;
	bh=tydQT26QS5GOWI0Ai0OWipKs1IdGdCkGkp2kHNlgQEo=;
	h=Date:To:From:Subject:Message-Id; b=iojm75mqH2vKwPIMeNvapM97gydKbfOEmajMaWCrBLf3LgW4Rpcl6CQU1pnMRm0H+UFgRwccge/WDcNnDAF4dZk6+Vv5f2hprtR8Dkj73EpVTIOvR/HslcHasAxSMUFF0py3Cw6l11tmTn+Ul8H3iQUO3hCnQE2fy39mj4U10s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eYCGpZdZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eYCGpZdZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A903C4CEF7;
	Fri,  6 Mar 2026 17:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772819797;
	bh=tydQT26QS5GOWI0Ai0OWipKs1IdGdCkGkp2kHNlgQEo=;
	h=Date:To:From:Subject:From;
	b=eYCGpZdZaM2PMkGca/5vXc7FRDS9belErV+13O3tDS3wA+u3mTZfF2HY3UMJ8Vgrc
	 6ubIc3ctuC+aGvF2O4nwrcDaFuKTCsEhuNEy3PZ4Z55dtvFT8O4/qU++U0xk8r+37G
	 ituLtypS4guggA3esCZhmaFc142Zt4QixGX6WCFk=
Date: Fri, 06 Mar 2026 09:56:36 -0800
To: mm-commits@vger.kernel.org,objecting@objecting.org,andriy.shevchenko@linux.intel.com,hlcj1234567@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-uuid-fix-typo-reversion-to-revision-in-comment.patch added to mm-nonmm-unstable branch
Message-Id: <20260306175637.1A903C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/uuid: fix typo "reversion" to "revision" in comment
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-uuid-fix-typo-reversion-to-revision-in-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-uuid-fix-typo-reversion-to-revision-in-comment.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Josh Law <hlcj1234567@gmail.com>
Subject: lib/uuid: fix typo "reversion" to "revision" in comment
Date: Fri, 6 Mar 2026 16:12:50 +0000

Fix a typo in __uuid_gen_common() where "reversion" (meaning to revert)
was used instead of "revision" when describing the UUID variant field.

Link: https://lkml.kernel.org/r/20260306161250.2811500-1-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/uuid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/uuid.c~lib-uuid-fix-typo-reversion-to-revision-in-comment
+++ a/lib/uuid.c
@@ -54,7 +54,7 @@ EXPORT_SYMBOL(generate_random_guid);
 static void __uuid_gen_common(__u8 b[16])
 {
 	get_random_bytes(b, 16);
-	/* reversion 0b10 */
+	/* revision 0b10 */
 	b[8] = (b[8] & 0x3F) | 0x80;
 }
 
_

Patches currently in -mm which might be from hlcj1234567@gmail.com are

lib-glob-add-missing-spdx-license-identifier.patch
lib-uuid-fix-typo-reversion-to-revision-in-comment.patch

