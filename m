Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD28212B09
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 01:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743990499; cv=none; b=oxs9kTWxsS0UppcPbuIy/CuIDXzkFV4UAUQ9R/gT0ZNg8XbugzqnluC7N1FfHjUOEAWrxmDE2fU88kDoKt6Dme9Gbat84yDMnxtG7B7+126rpb9K0VOSehESh4GEsQfpwuK/uDFYOHHD6NgBPmTIZc/8VywE1EJotQVa21rF1h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743990499; c=relaxed/simple;
	bh=ZQsh4Aw1hPJkpyxbPNLKIOCN+BD5tj3Bby5oovsu60c=;
	h=Date:To:From:Subject:Message-Id; b=ZE0flOqJ+VlYeOQEQ0/ghfoaJg+tuGKn9yvBBEC7+EPiMJGOToSVTCx1tUY8xqHRjg4fFzzcHx0MOQSoL8CFJaip4mWML2lKLIdms3NZWRkhcBTQP4j6iKgPtgphVAkIloUUW0Fu34baD6OpT1ZweH72jMFxub00g+tFYM46lNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hrmznBwQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hrmznBwQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA57C4CEE3;
	Mon,  7 Apr 2025 01:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743990499;
	bh=ZQsh4Aw1hPJkpyxbPNLKIOCN+BD5tj3Bby5oovsu60c=;
	h=Date:To:From:Subject:From;
	b=hrmznBwQTAokE0NN4jSEaASfxJrL+TRAwzahHL7ThQrmZVL3UO0MFjcaLx+VOx2dn
	 ZwIuiaDjiquqORUo8eSTzOF4MJ795Sleiqe9ufcTKly2tzgM348pCXyTco/R38AKZT
	 NuV4wk4HTeec6QUdc480tXrrR62kCdQNcfZrlTuE=
Date: Sun, 06 Apr 2025 18:48:18 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,snovitoll@gmail.com,sfr@canb.auug.org.au,ryabinin.a.a@gmail.com,peterz@infradead.org,niharchaithanya@gmail.com,masahiroy@kernel.org,jeff.johnson@oss.qualcomm.com,jannh@google.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kasan-add-module-decription.patch added to mm-nonmm-unstable branch
Message-Id: <20250407014819.3DA57C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kasan: add module decription
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-kasan-add-module-decription.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kasan-add-module-decription.patch

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
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm/kasan: add module decription
Date: Mon, 24 Mar 2025 18:32:34 +0100

Modules without a description now cause a warning:

WARNING: modpost: missing MODULE_DESCRIPTION() in mm/kasan/kasan_test.o

Link: https://lkml.kernel.org/r/20250324173242.1501003-9-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: Macro Elver <elver@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nihar Chaithanya <niharchaithanya@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc: Stehen Rothwell <sfr@canb.auug.org.au>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/kasan/kasan_test_c.c~mm-kasan-add-module-decription
+++ a/mm/kasan/kasan_test_c.c
@@ -2127,4 +2127,5 @@ static struct kunit_suite kasan_kunit_te
 
 kunit_test_suite(kasan_kunit_test_suite);
 
+MODULE_DESCRIPTION("kunit test case for kasan");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from arnd@arndb.de are

exportfs-add-module-description.patch
asn1-add-module-description.patch
samples-livepatch-add-module-descriptions.patch
fpga-tests-add-module-descriptions.patch
xenbus-add-module-description.patch
zlib-add-module-description.patch
ucs2_string-add-module-description.patch
mm-kasan-add-module-decription.patch
kunit-slub-add-module-description.patch

