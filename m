Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D21402BBE
	for <mm-commits@vger.kernel.org>; Tue, 28 Apr 2026 12:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777380941; cv=none; b=AVipOfO8K+3MbRdQQ3+toXk4CgWmZqGaKqdLfEBTmVYtCAy9Wzpfbxb71z2UQy3vWh64sdQcrJetd987xuu4q7CFiOsWckUq2I8f7cSG4RcMjAWJPK/hq2BzrognLUGcQkwZAOrwlgFXf7YlFAnQ/ezVi6TdFiBb6aJape7AN88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777380941; c=relaxed/simple;
	bh=rC9gtqgQopXhLzZU+atHiOGbSWMzLGC3Rea2P4Danqw=;
	h=Date:To:From:Subject:Message-Id; b=AhFWnfF4CbF/69CADxxp2qLT71Q3oIlMiQOEcnwrhqFU+rwUZaNB6TmgWcypcDSNdPXAtog7IS7yYGKyqZx7rylRJ+RmtDmFF2WOo7MLUciX+eXL35Jz+2s/H1wNd22Pp57qOH/7DqPxMvNgAcLAwoVww/712WejdWDIfJ1w1LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HkWrGtZO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HkWrGtZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7C9C2BCAF;
	Tue, 28 Apr 2026 12:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777380939;
	bh=rC9gtqgQopXhLzZU+atHiOGbSWMzLGC3Rea2P4Danqw=;
	h=Date:To:From:Subject:From;
	b=HkWrGtZOWsJxzZyWk7Y+rt/K3t77lF94fBNPypnY381znQ54KGO6LtEqZ30ng3265
	 S26Y9nW4cVC3P0YbrBDKqjBCZ1vlR9iAWC+2ca0z5ImvmDxQy+S/a0dAT7ld+01yFW
	 HLJpzbuC1bdcKQ16yFa2oDqmbmeKVJdmKLMcdOpE=
Date: Tue, 28 Apr 2026 05:55:38 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,thomas.weissschuh@linutronix.de,glaubitz@physik.fu-berlin.de,geert+renesas@glider.be,dalias@libc.org,contact@artur-rojek.eu,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sh-fix-fallout-from-zero_page-consolidation.patch added to mm-hotfixes-unstable branch
Message-Id: <20260428125539.5E7C9C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sh: fix fallout from ZERO_PAGE consolidation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     sh-fix-fallout-from-zero_page-consolidation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sh-fix-fallout-from-zero_page-consolidation.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: sh: fix fallout from ZERO_PAGE consolidation
Date: Fri, 17 Apr 2026 13:32:07 +0300

Consolidation of empty_zero_page declarations broke boot on sh.

sh stores its initial boot parameters in a page reserved in
arch/sh/kernel/head_32.S.  Before commit 6215d9f4470f ("arch, mm:
consolidate empty_zero_page") this page was referenced in C code as an
array and after that commit it is referenced as a pointer.

This causes wrong code generation and boot hang.

Declare boot_params_page as an array to fix the issue.

Link: https://lore.kernel.org/20260417103208.1217010-1-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Fixes: 6215d9f4470f ("arch, mm: consolidate empty_zero_page")
Reported-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Tested-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Tested-by: Artur Rojek <contact@artur-rojek.eu>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/setup.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sh/include/asm/setup.h~sh-fix-fallout-from-zero_page-consolidation
+++ a/arch/sh/include/asm/setup.h
@@ -7,7 +7,7 @@
 /*
  * This is set up by the setup-routine at boot-time
  */
-extern unsigned char *boot_params_page;
+extern unsigned char boot_params_page[];
 #define PARAM boot_params_page
 
 #define MOUNT_ROOT_RDONLY (*(unsigned long *) (PARAM+0x000))
_

Patches currently in -mm which might be from rppt@kernel.org are

sh-fix-fallout-from-zero_page-consolidation.patch

