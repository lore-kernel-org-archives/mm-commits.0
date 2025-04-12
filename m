Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77118134D4
	for <mm-commits@vger.kernel.org>; Sat, 12 Apr 2025 00:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744418007; cv=none; b=lo+uytdpfDFd0ofxPf0XD1Nu3zrCUSiP1NKr+z9fz9FNm4kKSz5Ydp9LAz9T7XE+Y+SCQQRxeB2th/mdM1g5IudvVzur5ukX9n6EBUASZwsrp5E4j1xOfyQWb20yn81lqXoVP2izE6YK6AFIsQPgCHejokVlYu8d+k39T4HmlIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744418007; c=relaxed/simple;
	bh=h3D/gf5z7Kim/cJk2AY6379F97LwA6abg3nQOj9Ys+c=;
	h=Date:To:From:Subject:Message-Id; b=p6/FtcrArEAoy7sAUp988B9oGwgnHGDY8HNMDoOU8qSor+Ho4LQsPZDg77CTSRv2yBYUuubWF67WhmOTD84KX7zv30TQYFwSjTHN93/lPm8Q/w3IIiDhdWR/zysXE6bqWeAIbH4YSEq0jQuK2gBwRQBREbKMuS3KXi7THdcIsI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sTy2ebLi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sTy2ebLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CDB5C4CEE2;
	Sat, 12 Apr 2025 00:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744418007;
	bh=h3D/gf5z7Kim/cJk2AY6379F97LwA6abg3nQOj9Ys+c=;
	h=Date:To:From:Subject:From;
	b=sTy2ebLickciUhiKEqv0Xytbd2Yaqzx6HoNbxlstVXyUymaNag5OcehnClm1GYpS0
	 VGABt4kqQP/3xEsQt2Z1BqR/p5efjYFKjK3aMSyXeakVcoav8pLJWAyicUJWDCRAiY
	 MGuIlMOX/r0BsX7YdqW68CmMLo5pURSkbn59I00I=
Date: Fri, 11 Apr 2025 17:33:26 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,pmladek@suse.com,mbenes@suse.cz,masahiroy@kernel.org,jpoimboe@kernel.org,joe.lawrence@redhat.com,jikos@kernel.org,jeff.johnson@oss.qualcomm.com,eahariha@linux.microsoft.com,christophe.leroy@csgroup.eu,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] samples-livepatch-add-module-descriptions.patch removed from -mm tree
Message-Id: <20250412003327.4CDB5C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/livepatch: add module descriptions
has been removed from the -mm tree.  Its filename was
     samples-livepatch-add-module-descriptions.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: samples/livepatch: add module descriptions
Date: Mon, 24 Mar 2025 18:32:28 +0100

Every module should have a description, so add one for each of these modules.

[akpm@linux-foundation.org: match the livepatch-callbacks-mod.c description, per Petr]
Link: https://lkml.kernel.org/r/20250324173242.1501003-3-arnd@kernel.org
Fixes: 6c6c1fc09de3 ("modpost: require a MODULE_DESCRIPTION()")
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
+MODULE_DESCRIPTION("Live patching demo for (un)patching callbacks, support module");
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


