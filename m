Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D564A1EDA2C
	for <mm-commits@vger.kernel.org>; Tue, 25 Nov 2025 17:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764092843; cv=none; b=PXBHUEL4QJR52XOGiONItImm15PqtllkaXplKsTBpquevUlEZr4Et9BuQNbedvdegJQVFX104muvOPF8e7V3F00QAMlqJ7KVBlwT7KW7OjARw9fLkff9eOgHrTIl2ZLtHJyClxLBbiA10hGewkpkEE/KbWNnSeIyjL9gvvV2C4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764092843; c=relaxed/simple;
	bh=W6Z+omUccruuENcmmJhjIQgV1B3p4+jHuM/rkWIM8rc=;
	h=Date:To:From:Subject:Message-Id; b=GRxleSgr657cGg+bHpHXT1fBweh00eSiqKpWmSMVGW9irkpf0vKjJOjdWGlGUWOtDfTc8aYZVuCPgEVwkgg8ksPKlueQVg8rJdQCpPMa+NTBZDOn+Fp6cy+XkuhWB2Hd2VE+2MD7U/i4qaS2PhW9hExCc2shiJ3cYR4RATLqwQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Lv6CN2Dc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lv6CN2Dc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EAFFC4CEF1;
	Tue, 25 Nov 2025 17:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764092843;
	bh=W6Z+omUccruuENcmmJhjIQgV1B3p4+jHuM/rkWIM8rc=;
	h=Date:To:From:Subject:From;
	b=Lv6CN2DcyPua+uK1qyMOQ3n1AjyImixCw8kEXzT5ky8MJBkdOD5N9PRoR5VUfQb5J
	 Dugtq2jNVoJMzR6IVT+rQmK0JbHYNu/a5AsHUoe3ul7QQsTedLxtpT9dcBJ/UFABBM
	 zjKOg50+6axUOogw6W7RwBo56Rak1XetSnlhwT4w=
Date: Tue, 25 Nov 2025 09:47:22 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kees@kernel.org,jinb.park7@gmail.com,anshuman.khandual@arm.com,geert@linux-m68k.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-debug_rodata_test-indentation-in-kconfig.patch added to mm-unstable branch
Message-Id: <20251125174723.5EAFFC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix DEBUG_RODATA_TEST indentation in Kconfig
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-debug_rodata_test-indentation-in-kconfig.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-debug_rodata_test-indentation-in-kconfig.patch

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
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: mm: fix DEBUG_RODATA_TEST indentation in Kconfig
Date: Tue, 25 Nov 2025 09:19:30 +0100

Most of the DEBUG_RODATA_TEST section is indented by four spaces instead
of the customary single TAB.

Link: https://lkml.kernel.org/r/74f39b1bffc6ed802088cb3e7d17b4c82330e8b3.1764058676.git.geert@linux-m68k.org
Fixes: 2959a5f726f6510d ("mm: add arch-independent testcases for RODATA")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Jinbum Park <jinb.park7@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig.debug |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/Kconfig.debug~mm-fix-debug_rodata_test-indentation-in-kconfig
+++ a/mm/Kconfig.debug
@@ -175,10 +175,10 @@ config DEBUG_PAGE_REF
 	  nil until the tracepoints are actually enabled.
 
 config DEBUG_RODATA_TEST
-    bool "Testcase for the marking rodata read-only"
-    depends on STRICT_KERNEL_RWX
+	bool "Testcase for the marking rodata read-only"
+	depends on STRICT_KERNEL_RWX
 	help
-      This option enables a testcase for the setting rodata read-only.
+	  This option enables a testcase for the setting rodata read-only.
 
 config ARCH_HAS_DEBUG_WX
 	bool
_

Patches currently in -mm which might be from geert@linux-m68k.org are

mm-fix-debug_rodata_test-indentation-in-kconfig.patch

