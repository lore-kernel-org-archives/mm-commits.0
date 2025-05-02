Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741BE3234
	for <mm-commits@vger.kernel.org>; Fri,  2 May 2025 00:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746146609; cv=none; b=OPkIckXJ/h/MB95SEAvAEJKHq2P9H5saQLP573DU5k+Yz7GpT5tykyY2EUUaD45YOgnnFIvf0DOnZ7khapbQrorlST8pTgNT/4vlJNGS3i8eF3N/bXTDP7Jc7mdW1Fmt0PFTS8kC81nWVtqsnqNYFwRz7sIrRuJUSoLUDLyw6XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746146609; c=relaxed/simple;
	bh=KY9KweRRXRPRFyVY4Yn3o1wS7uQpLHqdwWvkPZiG0Dk=;
	h=Date:To:From:Subject:Message-Id; b=Hn+zGQlZaEPaGokWkoEH158gtS0fwkANbdEeqavLQsxiN7dqx15bu1dUI4wOprRjATbkIfiv/CuVaZpQ60m/djqZmCq4WLTzITVRy4R7ckaS+/8BA1h6r302YLOXcN/Bz2YB11ztV0P7Hk8KBLVMkOdO7mhY68PuEf+WgEAVODo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hzqrWPwX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hzqrWPwX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D27C4CEE3;
	Fri,  2 May 2025 00:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746146608;
	bh=KY9KweRRXRPRFyVY4Yn3o1wS7uQpLHqdwWvkPZiG0Dk=;
	h=Date:To:From:Subject:From;
	b=hzqrWPwX9Ywrv8nVHa/HFKo5xxGKrhvsuYGAapH3je+LljG0+rvZATP2yh8EqN24A
	 2j+T5NrHXNmQ/pIyoT7kEY2s3Q7mkGIjWqn3FVv9O3NvH1ORa3b/YNK5THoTnzMR30
	 YddvRkz0v/h8TO5PwFheIDNuhNCWZplnwYqFLHFo=
Date: Thu, 01 May 2025 17:43:28 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,changyuanl@google.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-add-kho-parsing-support-fix.patch added to mm-unstable branch
Message-Id: <20250502004328.D9D27C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec: include asm/early_ioremap.h
has been added to the -mm mm-unstable branch.  Its filename is
     kexec-add-kho-parsing-support-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-add-kho-parsing-support-fix.patch

This patch will later appear in the mm-unstable branch at
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
Subject: kexec: include asm/early_ioremap.h
Date: Thu, 1 May 2025 15:54:13 -0700

The early_memremap() function is decleared in a header that is only indirectly
included here:

kernel/kexec_handover.c:1116:8: error: call to undeclared function 'early_memremap'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
 1116 |         fdt = early_memremap(fdt_phys, fdt_len);
      |               ^

Link: https://lkml.kernel.org/r/20250501225425.635167-7-changyuanl@google.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_handover.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/kexec_handover.c~kexec-add-kho-parsing-support-fix
+++ a/kernel/kexec_handover.c
@@ -17,6 +17,9 @@
 #include <linux/memblock.h>
 #include <linux/notifier.h>
 #include <linux/page-isolation.h>
+
+#include <asm/early_ioremap.h>
+
 /*
  * KHO is tightly coupled with mm init and needs access to some of mm
  * internal APIs.
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-add-kho-parsing-support-fix.patch

