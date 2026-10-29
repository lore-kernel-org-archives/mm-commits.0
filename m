Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793246795;
	b=3WSMa4y3rm0GUuapLbxPsiVJzBIsxzy0peHUfhkMn/LzBv1yLnfnAz9XBAT+5I8qvIf0
	 /jh/WBpsJ3Z/RQL14WO8QsEIWaVsNxHhu8H3PyGOviLSJbTqqCYr+ueyEMQ9wB/ypN7A5
	 2Q+UQAeZGDb4j6843B+8WqZUEimDawK5qFXAXSwBayO3kIyPXRGow1TyWyAfdGhtBPQQP
	 Nry5HSVwTgwmG+JCllYoLT8+fouLlmO8YUkGH6NQsRr95/C5HT/oXQRrl6QT9A9voFLcr
	 RAcC3GWCSluePNgeytw3mk8yHyojHVK13zfA5vAM78uievwxStYHWTCUmTZzjWknh3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793246795;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=cNRt4xYmTinvA7xQrkCJU2NU5j/s5L4rhC6iQxwd4RI=;
	b=Z13daSxq7gra37Y6XArnsQblRo9fEHopMBltIwCSMaJklBTx4O/3q+qEkmG1ta6Joys8
	 k3nQAFjEkw4FyNX1/nl4ziIy5uOoTcjtcH6Wlcv7Erk3Kkzho5hkUPqKRXNEhK7FUSZXr
	 QGyMmKAQ+cIH9QE48OC7v572ugNpROholYSEqPERt9PWobrNVBJ82zRguyaiUBIAthsfY
	 AQ1qc+FgNn5qdADGTQFdpqhCGc8YH0VvEbHpeai1cglY4pQqDuC4DOtUpJ1HdmQ7r1iDF
	 tZzak2bXSERAVTfcMGCoHOi1mHIBntenJdoJqtQtPdwhX5i6Db9LLkaJj++3HhM8jfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HcmFIFob;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAB3606A31A;
	Thu, 29 Oct 2026 04:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HcmFIFob
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4701F01825;
	Thu, 29 Oct 2026 04:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793246794;
	bh=cNRt4xYmTinvA7xQrkCJU2NU5j/s5L4rhC6iQxwd4RI=;
	h=Date:To:From:Subject;
	b=HcmFIFobNdXbRCc1Bw1vokIuM5bOeyQYeSvgSHFgD7wVT/wX2CCIEa7oTz+GK47GH
	 iu5lV8ThXGwx/5Th8fG2RvvMX9kXuVJ+aaj9eNBZzANU5x6qx0SxEXh2lYVxkLlJvo
	 amtJqRqNuSm7ufg3bGeMUb9xSpVjSolwdx45jGdo=
Date: Wed, 28 Oct 2026 21:06:33 -0700
To: mm-commits@vger.kernel.org,stefan.kristiansson@saunalahti.fi,
	stable@vger.kernel.org,shorne@gmail.com,lkp@intel.com,kmehltretter@gmail.com,
	jonas@southpole.se,brads@mainlining.org,arnd@arndb.de,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + openrisc-export-mulsi3.patch added to mm-hotfixes-unstable branch
Message-Id: <20261029040634.1F4701F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: openrisc: export __mulsi3 for modules
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     openrisc-export-mulsi3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/openrisc-export-mulsi3.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: openrisc: export __mulsi3 for modules
Date: Wed Oct 28 06:24:22 PM PDT 2026

OpenRISC configurations without hardware multiplication fail to build
modules which contain compiler-generated calls to __mulsi3.  The failure
is widespread, affecting filesystems, drivers and KUnit tests at modpost.

When CONFIG_OPENRISC_HAVE_INST_MUL is disabled, the architecture Makefile
passes -msoft-mul to GCC.  The multiplication helper is supplied by the
libgcc archive linked into vmlinux, but or32_ksyms.c does not export it. 
Built-in callers can therefore link while module callers cannot resolve
the symbol.

Export __mulsi3 alongside the other compiler-generated helpers.

The omission predates 7c3f4d699f34 ("resource, kunit: stop selecting
GET_FREE_REGION"), which the robot identified when reporting an additional
failing module.  It was already present in the initial OpenRISC export
list.

Fixes: 616257669e1a ("OpenRISC: Miscellaneous")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202610290106.o8Fs3NvO-lkp@intel.com/
Assisted-by: LLM
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Karl Mehltretter <kmehltretter@gmail.com>
Cc: <stable@vger.kernel.org>
---

 arch/openrisc/kernel/or32_ksyms.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/openrisc/kernel/or32_ksyms.c~openrisc-export-mulsi3
+++ a/arch/openrisc/kernel/or32_ksyms.c
@@ -35,6 +35,7 @@ DECLARE_EXPORT(__divsi3);
 DECLARE_EXPORT(__umodsi3);
 DECLARE_EXPORT(__modsi3);
 DECLARE_EXPORT(__muldi3);
+DECLARE_EXPORT(__mulsi3);
 DECLARE_EXPORT(__ashrdi3);
 DECLARE_EXPORT(__ashldi3);
 DECLARE_EXPORT(__lshrdi3);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

openrisc-export-mulsi3.patch
maintainers-add-ipc-maintainers.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch
ipc-msg-clamp-negative-statistics.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

