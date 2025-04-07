Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4A917BA6
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 01:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743990488; cv=none; b=e/pyHGkoKBwIvsgBieEHRDQdBRDYUPUbd13NHBxH3/A+uiszBVuGw5ae0bQyzKzKo095jMUW7HDZav/Ie0RTCihqDCGrxBoJ/H1j/ZP5e0SI99cTLjfNuvvbVPMajWn0z6XBMF+jd7M99n5CF587V+tCX/pyYvZyTrYTVPAzous=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743990488; c=relaxed/simple;
	bh=cOs77wdZFU3bZIxMk8bX0UD3QHwm3mwb2AfTC1aLNSA=;
	h=Date:To:From:Subject:Message-Id; b=rEPJ60H0vgrFcXCCRwkfIHr9+hZE2WEzdzqysbbOA3JvZGMjsAyeOy2x/n4yLmvldmcB55jpsQOtLmNwIW+ZFQ92LjpKa84am7lc17wrmAcdrbOhcMz3/EeC6SYkty0LorfgAl0NHvqJouDW8LA8vllfsX805WtoX7IA0i3koyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QXLfslGR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QXLfslGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467F8C4CEE3;
	Mon,  7 Apr 2025 01:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743990488;
	bh=cOs77wdZFU3bZIxMk8bX0UD3QHwm3mwb2AfTC1aLNSA=;
	h=Date:To:From:Subject:From;
	b=QXLfslGR+eAjY3+oqhkfEJ0vvGlT9pBIdCLiAhM5HPOieBSdJU6bRu9usjAfNRB1a
	 qm+rm5TYzaVveF5V6zSx4HwH2V4PTzorbpgqlz5pHYdz5zRR5mWB99BpyfPbstFEqh
	 AsameTqLccVT/dGAg0fwPYhOYSaNnGp4UlvXGDXI=
Date: Sun, 06 Apr 2025 18:48:07 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,pmladek@suse.com,mbenes@suse.cz,masahiroy@kernel.org,jpoimboe@kernel.org,joe.lawrence@redhat.com,jikos@kernel.org,jeff.johnson@oss.qualcomm.com,eahariha@linux.microsoft.com,christophe.leroy@csgroup.eu,arnd@arndb.de,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-livepatch-add-module-descriptions-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250407014808.467F8C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples-livepatch-add-module-descriptions-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     samples-livepatch-add-module-descriptions-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-livepatch-add-module-descriptions-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: samples-livepatch-add-module-descriptions-fix
Date: Sun Apr  6 06:44:58 PM PDT 2025

match the livepatch-callbacks-mod.c description, per Petr

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Stehen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/livepatch/livepatch-callbacks-busymod.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/samples/livepatch/livepatch-callbacks-busymod.c~samples-livepatch-add-module-descriptions-fix
+++ a/samples/livepatch/livepatch-callbacks-busymod.c
@@ -56,5 +56,5 @@ static void livepatch_callbacks_mod_exit
 
 module_init(livepatch_callbacks_mod_init);
 module_exit(livepatch_callbacks_mod_exit);
-MODULE_DESCRIPTION("Live patching demo for (un)patching callbacks");
+MODULE_DESCRIPTION("Live patching demo for (un)patching callbacks, support module");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

radix-tree-add-missing-cleanuph-fix.patch
samples-livepatch-add-module-descriptions-fix.patch
mm-kasan-add-module-decription-fix.patch

