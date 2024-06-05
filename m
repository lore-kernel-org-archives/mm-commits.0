Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519EA15FD0B
	for <mm-commits@vger.kernel.org>; Wed,  5 Jun 2024 23:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717628553; cv=none; b=bb3ok6ZWZoJu0zmadCUyzRVIGXFRZv7rI789r1tffKcatLY3G0ta0byUGjWz68OdKP89GpJsu+EaaPlPm8HkeTiS3XhUorz04/O6bwmNntOj/NsZ4vbEyabtofeisvupw7B1H0n6ULalqyux9Wr83nSiP6pgaEOjm8Pkx5Ylqxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717628553; c=relaxed/simple;
	bh=y608HKBu2dBYiJss7HL96PZujauoP3Alj9tQvVl1Ze4=;
	h=Date:To:From:Subject:Message-Id; b=FriGJT5u6GcUAFxGPk3yjCi9O6rDl6nUYe9bn00VP4Xc0+QVT1pV06xhg5pKpcIbgZOoDSJxNYoH/rl5RumJm92ugzA++DopakJi5piwfgFe39oQf45Q5eaFjN19nHB486KiVVDxGeiqW7zQDeUdyv+yj3XvmgEZpBkwoFR0Uj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=djg63hEZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="djg63hEZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB31C2BD11;
	Wed,  5 Jun 2024 23:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717628552;
	bh=y608HKBu2dBYiJss7HL96PZujauoP3Alj9tQvVl1Ze4=;
	h=Date:To:From:Subject:From;
	b=djg63hEZE3JP2imRqM7HwOlW295FuBTNNxtphDYXEf+6vO9k663LRdr9GqTZ+zcXV
	 wcJXG5Dw7rj9TRyxgbFojbNbO9+x2mjjD3NQBWrXau0jhZUHkGS+3Qf+vjUevxUmO5
	 z4EjBSMhMebZJV682RHeGcDwdvdUka1nP38rC+U0=
Date: Wed, 05 Jun 2024 16:02:32 -0700
To: mm-commits@vger.kernel.org,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-asn1_encoder-add-missing-module_description-macro.patch added to mm-nonmm-unstable branch
Message-Id: <20240605230232.BCB31C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/asn1_encoder: add missing MODULE_DESCRIPTION() macro
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-asn1_encoder-add-missing-module_description-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-asn1_encoder-add-missing-module_description-macro.patch

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
Subject: lib/asn1_encoder: add missing MODULE_DESCRIPTION() macro
Date: Sat, 1 Jun 2024 16:09:47 -0700

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/asn1_encoder.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240601-md-lib-asn1_encoder-v1-1-8c634ed2d2e8@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/asn1_encoder.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/asn1_encoder.c~lib-asn1_encoder-add-missing-module_description-macro
+++ a/lib/asn1_encoder.c
@@ -449,4 +449,5 @@ asn1_encode_boolean(unsigned char *data,
 }
 EXPORT_SYMBOL_GPL(asn1_encode_boolean);
 
+MODULE_DESCRIPTION("Simple encoder primitives for ASN.1 BER/DER/CER");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

mm-hwpoison-add-module_description.patch
mm-dmapool-add-module_description.patch
mm-kfence-add-module_description.patch
mm-zsmalloc-add-module_description.patch
kmemleak-test-add-missing-module_description-macro.patch
backtracetest-add-module_description.patch
dyndbg-add-missing-module_description-macro.patch
lib-ts-add-missing-module_description-macros.patch
kunit-fortify-add-missing-module_description-macros.patch
kunit-add-missing-module_description-macros-for-lib-_testko.patch
lib-asn1_encoder-add-missing-module_description-macro.patch

