Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793814429;
	b=HNNP47dZ67CQ+08qwHNrN0Zwo/WGq0iIYUqe6+tmItGryjAsaGTm7LFMD+n+0tDSMaQL
	 4Uz4uumYrguDC3WQyH9OkZYVJGuCGCyi02SRueGGyskRGWtPhFrTfeyeBDchIx5cPAz6C
	 Y1dNsntAHCnmKwyFChr/vqGATxXQq7i4hXPldBgzLwHipekOkloCfPZ7Lsy2w+uW2XrQb
	 naX/3LKaj9xLBjEQRh8+pWFme5EvA9mecWDX8M9328PzA10oRNStxGJIsbKdabSK9ko6s
	 Swc/AQY9n9gaWywpVoTP0KvY8OavPPufCHyfLqsFV3O1Ku0fx/0cNGQwuWD2UGv9vVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793814429;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=+DHKlqUvVJ7TvH3Q9DU3zWTgpLL9texYCQkCyxYluCk=;
	b=CvyFWTbapyQzDNoYsHFzY6XqynE37RD3jE9LcxXQQpcmD3DUkQFcqu1NVQ+4enfDQ2PM
	 IPXVp5NPAZ6VEB3zljKM9ACnW9R+PbLbeEO25lrxIIlpKllUsIMYEtX+xxtwM2FOaOwCA
	 nN776UXKjVI6wYvtgwWkBoyJoV+aDd11a6+2kkAIi5Z9N+8ADv8chTpFaXsxAR1TS7Ko8
	 XtrLsxsCj6wOYebO8DV2BIyspeZpw+6nuVa/DP3uBc3J80Q6Wd3ivbwyyNXWSXQSbVr/k
	 ZKOqlUXnKDOBwtKH2Gv2fiD8zntpazOhVpm1LBddc7AJybxHF7KbDbt6DAeOP09qdfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=clwkpsxs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30ADD606A328
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 17:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=clwkpsxs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9909A1F000C1;
	Wed,  4 Nov 2026 17:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793814428;
	bh=+DHKlqUvVJ7TvH3Q9DU3zWTgpLL9texYCQkCyxYluCk=;
	h=Date:To:From:Subject;
	b=clwkpsxsT+ZHYAQDLZE1GXPaG4hPiIQ21PzwirD/DIHlo028AC7f721Amn3zNtBzz
	 J9uKeWB6hBgu8xliH9hvsTLMgRUXLz8NyUqSz/9AHDMZsrCtGP5iKPYnWhzekhRTRX
	 yay7zMfh7lJWSollVV1p3T7Ht915hU+uSgN3VT54=
Date: Wed, 04 Nov 2026 09:47:08 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,shuah@kernel.org,
	andrii@kernel.org,sashal@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-proc-search-the-kernel-headers-before-the-tools-copies.patch added to mm-nonmm-unstable branch
Message-Id: <20261104174708.9909A1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/proc: search the kernel headers before the tools copies
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-proc-search-the-kernel-headers-before-the-tools-copies.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-proc-search-the-kernel-headers-before-the-tools-copies.patch

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
From: Sasha Levin <sashal@kernel.org>
Subject: selftests/proc: search the kernel headers before the tools copies
Date: Tue, 03 Nov 2026 09:23:04 -0500

The proc tests are the only selftests that add $(TOOLS_INCLUDES) without
$(KHDR_INCLUDES) in front of it.  The <linux/types.h> in
tools/include/uapi then replaces the real one, and unlike the real one it
does not include <asm/types.h>.  On powerpc and s390, <signal.h> pulls in
the kernel's asm/sigcontext.h, which needs __vector128 from asm/types.h,
so eight proc tests fail to build on powerpc and six on s390:

  /usr/lib/linux/uapi/s390/asm/sigcontext.h:73:9: error: unknown type name '__vector128'

Put $(KHDR_INCLUDES) before $(TOOLS_INCLUDES), as the other selftests that
use TOOLS_INCLUDES do, so that <linux/types.h> comes from the headers of
the kernel under test.

Link: https://lore.kernel.org/20261103142304.122564-1-sashal@kernel.org
Fixes: 81510a0eaa69 ("selftests/proc: add PROCMAP_QUERY ioctl tests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
---

 tools/testing/selftests/proc/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/proc/Makefile~selftests-proc-search-the-kernel-headers-before-the-tools-copies
+++ a/tools/testing/selftests/proc/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 CFLAGS += -Wall -O2 -Wno-unused-function
-CFLAGS += $(TOOLS_INCLUDES)
+CFLAGS += $(KHDR_INCLUDES) $(TOOLS_INCLUDES)
 LDFLAGS += -pthread
 
 TEST_GEN_PROGS :=
_

Patches currently in -mm which might be from sashal@kernel.org are

selftests-proc-cast-the-procmap_query-address-through-uintptr_t.patch
selftests-mm-fix-pointer-width-warnings-on-32-bit-architectures.patch
selftests-mm-uffd-wp-mremap-keep-the-thp-sizes-in-unsigned-long.patch
selftests-proc-search-the-kernel-headers-before-the-tools-copies.patch

