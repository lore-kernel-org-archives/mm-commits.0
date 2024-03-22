Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57384376;
	Fri, 22 Mar 2024 00:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711068679; cv=none; b=A9C5TwZY9+BVlZNtz9jgahyoyw3G7yk8ZZ0G2HApVFN3pfT4wO3XYujFnEp3/TXc5UI/WdyIIYn95Kv08byo7DYpDE2gj2xxO0AHiPPdfvABQkkI+vinvaMUHA1R6TRdH57C+5hxorE1m6/oscuxFpbiEnDOuHPZoGvDOXuXDKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711068679; c=relaxed/simple;
	bh=7hBI+B1ZMCvCk8GyBASAk5SjNJDkj3IBLjma/2AIsEI=;
	h=Date:To:From:Subject:Message-Id; b=jTzscHxvinNu2fYZwdjNUGOPeWJzduJFKfLdpP8FW4D51EG/+cbG0ZSip2HBhW0RA+ln+mu9kas4yBePACOgsGHWY5iKcQEJr1YO8NdxlBInY7KWJ2gZeRzReDLaovU4xc8Vd/kfTsqa3/ac7kNsKrB3qybgsOSLUxyBrHzA9oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FFplpWiR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FFplpWiR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC46C433F1;
	Fri, 22 Mar 2024 00:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711068679;
	bh=7hBI+B1ZMCvCk8GyBASAk5SjNJDkj3IBLjma/2AIsEI=;
	h=Date:To:From:Subject:From;
	b=FFplpWiRXpNNV+qoqr2TkoOON+tMvX0lPPzZc3mNsgucYL6v+Z6T7UiW3bMsfU2BH
	 EWSg4G2SIfoZqL8JwnCHnTEyEL+TahJdxDu/WhX7jjsJQzq/A4ZRVQMX+yybj8Mmqb
	 Net4Ry8kzKcAk88FJ2Mls4YZhL/kBa2vOKpBuOYI=
Date: Thu, 21 Mar 2024 17:51:18 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ndesaulniers@google.com,morbo@google.com,justinstitt@google.com,bcain@quicinc.com,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hexagon-vmlinuxldss-handle-attributes-section.patch added to mm-hotfixes-unstable branch
Message-Id: <20240322005118.EBC46C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hexagon: vmlinux.lds.S: handle attributes section
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     hexagon-vmlinuxldss-handle-attributes-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hexagon-vmlinuxldss-handle-attributes-section.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Nathan Chancellor <nathan@kernel.org>
Subject: hexagon: vmlinux.lds.S: handle attributes section
Date: Tue, 19 Mar 2024 17:37:46 -0700

After the linked LLVM change, the build fails with
CONFIG_LD_ORPHAN_WARN_LEVEL="error", which happens with allmodconfig:

  ld.lld: error: vmlinux.a(init/main.o):(.hexagon.attributes) is being placed in '.hexagon.attributes'

Handle the attributes section in a similar manner as arm and riscv by
adding it after the primary ELF_DETAILS grouping in vmlinux.lds.S, which
fixes the error.

Link: https://lkml.kernel.org/r/20240319-hexagon-handle-attributes-section-vmlinux-lds-s-v1-1-59855dab8872@kernel.org
Fixes: 113616ec5b64 ("hexagon: select ARCH_WANT_LD_ORPHAN_WARN")
Link: https://github.com/llvm/llvm-project/commit/31f4b329c8234fab9afa59494d7f8bdaeaefeaad
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Bill Wendling <morbo@google.com>
Cc: Brian Cain <bcain@quicinc.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/kernel/vmlinux.lds.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/hexagon/kernel/vmlinux.lds.S~hexagon-vmlinuxldss-handle-attributes-section
+++ a/arch/hexagon/kernel/vmlinux.lds.S
@@ -63,6 +63,7 @@ SECTIONS
 	STABS_DEBUG
 	DWARF_DEBUG
 	ELF_DETAILS
+	.hexagon.attributes 0 : { *(.hexagon.attributes) }
 
 	DISCARDS
 }
_

Patches currently in -mm which might be from nathan@kernel.org are

hexagon-vmlinuxldss-handle-attributes-section.patch

