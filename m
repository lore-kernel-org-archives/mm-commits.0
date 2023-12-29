Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886FC13FF0
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1sjcV3oW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DAFFC433C7;
	Fri, 29 Dec 2023 20:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880067;
	bh=R6YVAmACCP3xyNmALHZ/q8lM3zlQYG8omCC6Wl+fxcQ=;
	h=Date:To:From:Subject:From;
	b=1sjcV3oWbMyvNqAJ270rsxLvutM8nTFgMlCyKyFp8Jfxs8nnmzSdgAj2CxFS03P8c
	 nuRLj65gtdHsNXLaGW4uAcfpgqLj52XnSbkcXugWiLVesyDeoj9nmm9sdyINosN3KA
	 NfzUD2gVMyInqNwcoffKTxN0S1qO/v5/57h7bntk=
Date: Fri, 29 Dec 2023 12:01:06 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,lkp@intel.com,jcmvbkbc@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,chris@zankel.net,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] xtensa-kasan-define-kasan_shadow_end.patch removed from -mm tree
Message-Id: <20231229200107.4DAFFC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xtensa, kasan: define KASAN_SHADOW_END
has been removed from the -mm tree.  Its filename was
     xtensa-kasan-define-kasan_shadow_end.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: xtensa, kasan: define KASAN_SHADOW_END
Date: Mon, 25 Dec 2023 16:19:24 +0100

Common KASAN code might rely on the definitions of the shadow mapping
start, end, and size.  Define KASAN_SHADOW_END in addition to
KASAN_SHADOW_START and KASAN_SHADOW_SIZE.

Link: https://lkml.kernel.org/r/20231225151924.5422-1-andrey.konovalov@linux.dev
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202312240755.MqsWuTno-lkp@intel.com/
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/kasan.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/xtensa/include/asm/kasan.h~xtensa-kasan-define-kasan_shadow_end
+++ a/arch/xtensa/include/asm/kasan.h
@@ -18,6 +18,8 @@
 #define KASAN_SHADOW_START (XCHAL_PAGE_TABLE_VADDR + XCHAL_PAGE_TABLE_SIZE)
 /* Size of the shadow map */
 #define KASAN_SHADOW_SIZE (-KASAN_START_VADDR >> KASAN_SHADOW_SCALE_SHIFT)
+/* End of the shadow map */
+#define KASAN_SHADOW_END (KASAN_SHADOW_START + KASAN_SHADOW_SIZE)
 /* Offset for mem to shadow address transformation */
 #define KASAN_SHADOW_OFFSET __XTENSA_UL_CONST(CONFIG_KASAN_SHADOW_OFFSET)
 
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-stop-leaking-stack-trace-handles.patch

