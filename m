Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83424BA38
	for <mm-commits@vger.kernel.org>; Wed,  5 Jun 2024 23:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717628937; cv=none; b=VOmXrfzkQ8d0bP6NrlkKwodTUIAfP20KLgdu6V/4VJ8aJwJ3g8E0cKBHD5jjTCbcDV/hNySbs2jfCGS65zAiPInzxBE0Oj/h8TC0soKV3Hjhu/1knXsx8VhSJJshs32kVlbnroOPvl8T/Oh89x3lxUik/2O+x0KegfAiVoKVNnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717628937; c=relaxed/simple;
	bh=rpvX8PhIidh7lErE5+2uXON3t37eCoOIQPpgs4ZPcfg=;
	h=Date:To:From:Subject:Message-Id; b=T7X/azV10b8zu0EuX/XpnGXuRdraJLqpAXzxDwBDIFcB4F9ggMbyHDJh47abrJLuwSzMCdTibTW1yC46FteABPMk9/F7yTmPhTxleIVDCQbP/MybvnCg5UHND916Y4l3EdrP45yisyak75Ale/+qM5zkplA6Zva+71r+skDIsCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nvC2gHgT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nvC2gHgT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0241AC2BD11;
	Wed,  5 Jun 2024 23:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717628937;
	bh=rpvX8PhIidh7lErE5+2uXON3t37eCoOIQPpgs4ZPcfg=;
	h=Date:To:From:Subject:From;
	b=nvC2gHgT30HXqSGcySFwXYKmrK1tOJTIbfCt5V6BRQrvGhrwh62yrDlcJPStx7iL4
	 cKS0UJnwfPxPdE7SRpPXMXcwTRwJ+q0y9NEnIltpDIj02i2voIU4ejyCKWmM1nFKhw
	 GJRFldNgck7a4eMR56e/AsMXg3NyiB4n16QE/VqY=
Date: Wed, 05 Jun 2024 16:08:56 -0700
To: mm-commits@vger.kernel.org,Jason@zx2c4.com,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + siphash-add-missing-module_description-macro.patch added to mm-nonmm-unstable branch
Message-Id: <20240605230857.0241AC2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: siphash: add missing MODULE_DESCRIPTION() macro
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     siphash-add-missing-module_description-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/siphash-add-missing-module_description-macro.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: siphash: add missing MODULE_DESCRIPTION() macro
Date: Fri, 31 May 2024 18:49:47 -0700

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/siphash_kunit.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240531-md-lib-siphash_kunit-v1-1-38688065b796@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/siphash_kunit.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/siphash_kunit.c~siphash-add-missing-module_description-macro
+++ a/lib/siphash_kunit.c
@@ -194,4 +194,5 @@ static struct kunit_suite siphash_test_s
 kunit_test_suite(siphash_test_suite);
 
 MODULE_AUTHOR("Jason A. Donenfeld <Jason@zx2c4.com>");
+MODULE_DESCRIPTION("Test cases for siphash.c");
 MODULE_LICENSE("Dual BSD/GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

mm-hwpoison-add-module_description.patch
mm-dmapool-add-module_description.patch
mm-kfence-add-module_description.patch
mm-zsmalloc-add-module_description.patch
kmemleak-test-add-missing-module_description-macro.patch
test_xarray-add-missing-module_description-macro.patch
ubsan-add-missing-module_description-macro.patch
backtracetest-add-module_description.patch
dyndbg-add-missing-module_description-macro.patch
lib-ts-add-missing-module_description-macros.patch
kunit-fortify-add-missing-module_description-macros.patch
kunit-add-missing-module_description-macros-for-lib-_testko.patch
lib-asn1_encoder-add-missing-module_description-macro.patch
kunit-add-missing-module_description-macros-to-lib-_kunitc.patch
uuid-add-missing-module_description-macro.patch
siphash-add-missing-module_description-macro.patch

