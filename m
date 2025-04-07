Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A8217BA6
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 01:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743990486; cv=none; b=l94iTKCmGRGfbgSEQhKg6E+/UdyINlfauOXT6P/QgTSo/YUCvBWJO90549sGYaJ9JyzYJqQhs4mjdL4yymDl9m36NeNHtukHUFxyLA21xfndrp9AHJtMJQNKHTSFbTVlidl5kFN9fBagCd+bmaXiuP7+GoLha5+WDO9wDk9KJiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743990486; c=relaxed/simple;
	bh=o0FUv8UoUtT+ny77i7p5UjyFMCjh814R3tY6p6ig0gI=;
	h=Date:To:From:Subject:Message-Id; b=H3e6TkLvIdPMCnK9aJr8nu0wB+zUCdvopsPnSZihCMxYhGa7Xv6mDDVGFuvRg0PEfIbfs9bv4aSOVy00MDpxiWDIL/VtQS8AImUKwVZQ3EUvoX1ghXd1X9VHai+7EZkX0wGWg5NlI+PTmT6aDNuMi3hWkF6qFEArymXRfticJR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B6eWVt29; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B6eWVt29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BD7C4CEE3;
	Mon,  7 Apr 2025 01:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743990484;
	bh=o0FUv8UoUtT+ny77i7p5UjyFMCjh814R3tY6p6ig0gI=;
	h=Date:To:From:Subject:From;
	b=B6eWVt29UM74VDCIM5G/9kmLla0dAe/2p/6sFyViWNVNTrIb+czdUDxFAn99P1KmI
	 xUpuEVfQKIk5qtpEuQtWABN8aD2t+nd6STacj5cchdJM+1AF/WFdwoRvSS5aMKfZbZ
	 5lZpSFhASu1VSKn4NkSBDXMnUV388ouaPwBqWGm0=
Date: Sun, 06 Apr 2025 18:48:03 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,pmladek@suse.com,mbenes@suse.cz,masahiroy@kernel.org,jpoimboe@kernel.org,joe.lawrence@redhat.com,jikos@kernel.org,jeff.johnson@oss.qualcomm.com,eahariha@linux.microsoft.com,christophe.leroy@csgroup.eu,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-livepatch-add-module-descriptions.patch added to mm-nonmm-unstable branch
Message-Id: <20250407014804.56BD7C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/livepatch: add module descriptions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     samples-livepatch-add-module-descriptions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-livepatch-add-module-descriptions.patch

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
Subject: samples/livepatch: add module descriptions
Date: Mon, 24 Mar 2025 18:32:28 +0100

Every module should have a description, so add one for each of these modules.

Link: https://lkml.kernel.org/r/20250324173242.1501003-3-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Stehen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/livepatch/livepatch-callbacks-busymod.c |    1 +
 samples/livepatch/livepatch-callbacks-demo.c    |    1 +
 samples/livepatch/livepatch-callbacks-mod.c     |    1 +
 samples/livepatch/livepatch-sample.c            |    1 +
 samples/livepatch/livepatch-shadow-fix1.c       |    1 +
 samples/livepatch/livepatch-shadow-fix2.c       |    1 +
 6 files changed, 6 insertions(+)

--- a/samples/livepatch/livepatch-callbacks-busymod.c~samples-livepatch-add-module-descriptions
+++ a/samples/livepatch/livepatch-callbacks-busymod.c
@@ -56,4 +56,5 @@ static void livepatch_callbacks_mod_exit
 
 module_init(livepatch_callbacks_mod_init);
 module_exit(livepatch_callbacks_mod_exit);
+MODULE_DESCRIPTION("Live patching demo for (un)patching callbacks");
 MODULE_LICENSE("GPL");
--- a/samples/livepatch/livepatch-callbacks-demo.c~samples-livepatch-add-module-descriptions
+++ a/samples/livepatch/livepatch-callbacks-demo.c
@@ -192,5 +192,6 @@ static void livepatch_callbacks_demo_exi
 
 module_init(livepatch_callbacks_demo_init);
 module_exit(livepatch_callbacks_demo_exit);
+MODULE_DESCRIPTION("Live patching demo for (un)patching callbacks");
 MODULE_LICENSE("GPL");
 MODULE_INFO(livepatch, "Y");
--- a/samples/livepatch/livepatch-callbacks-mod.c~samples-livepatch-add-module-descriptions
+++ a/samples/livepatch/livepatch-callbacks-mod.c
@@ -38,4 +38,5 @@ static void livepatch_callbacks_mod_exit
 
 module_init(livepatch_callbacks_mod_init);
 module_exit(livepatch_callbacks_mod_exit);
+MODULE_DESCRIPTION("Live patching demo for (un)patching callbacks, support module");
 MODULE_LICENSE("GPL");
--- a/samples/livepatch/livepatch-sample.c~samples-livepatch-add-module-descriptions
+++ a/samples/livepatch/livepatch-sample.c
@@ -66,5 +66,6 @@ static void livepatch_exit(void)
 
 module_init(livepatch_init);
 module_exit(livepatch_exit);
+MODULE_DESCRIPTION("Kernel Live Patching Sample Module");
 MODULE_LICENSE("GPL");
 MODULE_INFO(livepatch, "Y");
--- a/samples/livepatch/livepatch-shadow-fix1.c~samples-livepatch-add-module-descriptions
+++ a/samples/livepatch/livepatch-shadow-fix1.c
@@ -168,5 +168,6 @@ static void livepatch_shadow_fix1_exit(v
 
 module_init(livepatch_shadow_fix1_init);
 module_exit(livepatch_shadow_fix1_exit);
+MODULE_DESCRIPTION("Live patching demo for shadow variables");
 MODULE_LICENSE("GPL");
 MODULE_INFO(livepatch, "Y");
--- a/samples/livepatch/livepatch-shadow-fix2.c~samples-livepatch-add-module-descriptions
+++ a/samples/livepatch/livepatch-shadow-fix2.c
@@ -128,5 +128,6 @@ static void livepatch_shadow_fix2_exit(v
 
 module_init(livepatch_shadow_fix2_init);
 module_exit(livepatch_shadow_fix2_exit);
+MODULE_DESCRIPTION("Live patching demo for shadow variables");
 MODULE_LICENSE("GPL");
 MODULE_INFO(livepatch, "Y");
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

