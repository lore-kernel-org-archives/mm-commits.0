Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B387B1400C
	for <mm-commits@vger.kernel.org>; Wed, 17 Dec 2025 20:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766004380; cv=none; b=mDgDqfa7QZnxEYweqF5YH9cS52LGtd4g9Z9n609FbnIDpR+6PFz4N5bPG2z/05sCjCxEiWZxpP3LrX4efJxyThQknUk4FMOG39d1vIvLR4e3DcQagVKzNCpnrUlxwEIVXIcwT6/2wNXV0EVUwKdp0WFe400JhHyg0sHDm1xRvvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766004380; c=relaxed/simple;
	bh=Bt39DvjVRfUM3SbyeIKoJvwxwZopkv9eLKq5w+jdSWc=;
	h=Date:To:From:Subject:Message-Id; b=NBpwCQZ6bO+LBTtGhAGUtL8RMLkFmXdb1a3gE6r589hIth823w/RsoRBwueVcEQQhJghdCTqsO61GGWdcQR6P2G1iFPEYyR6HEi2Lk0L/A16IEu961b8SyBp+HKvJEkvIumrnABhrHLkgZdcmWHeCW+ywz7OsntBDpWMSchbCSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gUwOnLn+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gUwOnLn+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F84C4CEF5;
	Wed, 17 Dec 2025 20:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766004380;
	bh=Bt39DvjVRfUM3SbyeIKoJvwxwZopkv9eLKq5w+jdSWc=;
	h=Date:To:From:Subject:From;
	b=gUwOnLn+TPuTxnYga340SazARiCrrZwAZys8jgdl04LO3vF1N1mzp6UxZW/7rfue/
	 iSKKCaequMkCOBP+asstLInqvv9uqBHrU/NxapYce2sMW1wAC7GSBB8VmnqjLCta0p
	 Kd29RNj6q2SoJw0j7XpFwq7KaZTap3P/aqAiVjS8=
Date: Wed, 17 Dec 2025 12:46:19 -0800
To: mm-commits@vger.kernel.org,mic@digikod.net,masahiroy@kernel.org,ihuguet@redhat.com,danny@kdrag0n.dev,haokexin@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + editorconfig-respect-editorconfig-settings-from-parent-directories.patch added to mm-nonmm-unstable branch
Message-Id: <20251217204620.20F84C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: .editorconfig: respect .editorconfig settings from parent directories
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     editorconfig-respect-editorconfig-settings-from-parent-directories.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/editorconfig-respect-editorconfig-settings-from-parent-directories.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Kevin Hao <haokexin@gmail.com>
Subject: .editorconfig: respect .editorconfig settings from parent directories
Date: Wed, 17 Dec 2025 12:23:27 +0800

Setting 'root' to 'true' prevents the editor from searching for other
.editorconfig files in parent directories.  However, a common workflow
involves generating a patch with 'git format-patch' and opening it in an
editor within the kernel source directory.  In such cases, we want any
specific settings for patch files defined in an .editorconfig located
above the kernel source directory to remain effective.  Therefore, remove
the 'root' setting from the kernel .editorconfig.

Link: https://lkml.kernel.org/r/20251217-editconfig-v1-1-883e6dd6dbfa@gmail.com
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Cc: Íñigo Huguet <ihuguet@redhat.com>
Cc: Danny Lin <danny@kdrag0n.dev>
Cc: Mickaël Salaün <mic@digikod.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .editorconfig |    2 --
 1 file changed, 2 deletions(-)

--- a/.editorconfig~editorconfig-respect-editorconfig-settings-from-parent-directories
+++ a/.editorconfig
@@ -1,7 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
-root = true
-
 [{*.{awk,c,dts,dtsi,dtso,h,mk,s,S},Kconfig,Makefile,Makefile.*}]
 charset = utf-8
 end_of_line = lf
_

Patches currently in -mm which might be from haokexin@gmail.com are

editorconfig-respect-editorconfig-settings-from-parent-directories.patch

