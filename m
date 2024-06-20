Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B783114A8F
	for <mm-commits@vger.kernel.org>; Thu, 20 Jun 2024 01:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718845973; cv=none; b=SPR1fCwugbabP+QlkvcPjsC3AR4RQX2I9Uf0kjuEXHAkHscPiieyefdgvs/rQRWvVC866D0lkmKLSe0CnCS0Vux/I+vh17uRu6cCiEMTIyfTaZAlKIkXzo2NuFRZEsUygVogDgkn7066fqA6yPGHEQIwV2xKsxCZYHGWwqth0lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718845973; c=relaxed/simple;
	bh=Q27jhXIpsqX3OBVglqVxHwletDGwxTE4J6QLP8ZD5wc=;
	h=Date:To:From:Subject:Message-Id; b=HHzCNFmJ1Tg6JRH/CV5UOgI0sCFtQHbvflqjZU9Ik6ar2ES9TLAsSbFYVPuDN1YcBNqnhKGwQ4PS2BAJMftHXQvLYFFKrrKf5iigYIThy5i6mE2E/WgemC0ftLVi5ECJRjqpeRgmK8nZIy07j6xd1Lu9Tx9qCfQ640zmcUMozJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RcNeYFtZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RcNeYFtZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C8CC4AF0F;
	Thu, 20 Jun 2024 01:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718845973;
	bh=Q27jhXIpsqX3OBVglqVxHwletDGwxTE4J6QLP8ZD5wc=;
	h=Date:To:From:Subject:From;
	b=RcNeYFtZKEolHyWedN/r6YsaW0rgPASorvHVH4l9K1JdyA9GwRD7rnxrrzSZl92Z2
	 g9YuUgRlc8rPmqgbCWh1ntm7yRFxvsifhTCxR2ZeUD6jpkGu3Iu90WsmKdCl5mH/0d
	 ZZPr6cQkA/gCIZfW/3ZxAaBeo9C1bs+A3FTi8HPA=
Date: Wed, 19 Jun 2024 18:12:52 -0700
To: mm-commits@vger.kernel.org,mpe@ellerman.id.au,kirill.shutemov@linux.intel.com,kbingham@kernel.org,jan.kiszka@siemens.com,kuan-ying.lee@canonical.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-change-va_bits_min-when-we-use-16k-page.patch added to mm-nonmm-unstable branch
Message-Id: <20240620011253.24C8CC4AF0F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb: change VA_BITS_MIN when we use 16K page
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-change-va_bits_min-when-we-use-16k-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-change-va_bits_min-when-we-use-16k-page.patch

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
From: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Subject: scripts/gdb: change VA_BITS_MIN when we use 16K page
Date: Wed, 19 Jun 2024 15:49:10 +0800

Change VA_BITS_MIN when we use 16K page.

Link: https://lkml.kernel.org/r/20240619074911.100434-6-kuan-ying.lee@canonical.com
Fixes: 9684ec186f8f ("arm64: Enable LPA2 at boot if supported by the system")
Signed-off-by: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/mm.py |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/scripts/gdb/linux/mm.py~scripts-gdb-change-va_bits_min-when-we-use-16k-page
+++ a/scripts/gdb/linux/mm.py
@@ -47,7 +47,10 @@ class aarch64_page_ops():
 
         self.VA_BITS = constants.LX_CONFIG_ARM64_VA_BITS
         if self.VA_BITS > 48:
-            self.VA_BITS_MIN = 48
+            if constants.LX_CONFIG_ARM64_16K_PAGES:
+                self.VA_BITS_MIN = 47
+            else:
+                self.VA_BITS_MIN = 48
             tcr_el1 = gdb.execute("info registers $TCR_EL1", to_string=True)
             tcr_el1 = int(tcr_el1.split()[1], 16)
             self.vabits_actual = 64 - ((tcr_el1 >> 16) & 63)
_

Patches currently in -mm which might be from kuan-ying.lee@canonical.com are

scripts-gdb-redefine-max_order-sanely.patch
scripts-gdb-rework-module-va-range.patch
scripts-gdb-change-the-layout-of-vmemmap.patch
scripts-gdb-set-vabits_actual-based-on-tcr_el1.patch
scripts-gdb-change-va_bits_min-when-we-use-16k-page.patch
scripts-gdb-rename-pool_index-to-pool_index_plus_1.patch

