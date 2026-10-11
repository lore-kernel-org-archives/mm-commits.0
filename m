Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDB834E75D
	for <mm-commits@vger.kernel.org>; Sun, 11 Oct 2026 22:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791757208; cv=none; b=tkwznhndSMdrlSBXN/JfSCAL6LfTZYQR3Pk2IB1Y4G3V1EUufGDpwpzjEcCtdoUoACh+hnGF4uz5wuGdb9kJGPC8MRtEqaBGDEq5KenOu+EVy8ZiVVL6L3O+0gu4CyUTbONAN7ffTQ/sru5jkv5UZSvYFkTza6hfouB/BDDre0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791757208; c=relaxed/simple;
	bh=AkBeVqup1lSavuHkNHwKIFfRuxQRIftsx85MlABsCm4=;
	h=Date:To:From:Subject:Message-Id; b=TsRY6enmDDixg3wiQG9Ra/PsK0biA1rqLYwOifB6gcxWTwLL1f9cJcradGqbv0vgWd8W9PhadFuQn0FffB4L42Scwy1FN+kQdWDoY9Rtq8rQ1ee67XqTs9yMgyeid3UeF7naTJcxobvYA687nfmuU3XlxNdoh9bAdIkyWZrdgxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uWpikJQ3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uWpikJQ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A806C1F0089B;
	Sun, 11 Oct 2026 22:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791757206;
	bh=plwDK7c8nN6YLv3KTSQzFv8bk8AT/ZDLtn7aDOU1X0M=;
	h=Date:To:From:Subject;
	b=uWpikJQ3ma9TcKLbG3joFShJe2IdrxEsk+l3R3DwpQdN5QiRezM/VomAU3i6DadiV
	 OFcr97n5yv4tienAk7n9wXMDP19ppYfWtt8XzbI8Q/K2eK5T7HjrDKWLAMBdc6izim
	 3a1cGBgEwtuMpBTuZdNPdMOXv9CSR9/p/Sk0rmHU=
Date: Sun, 11 Oct 2026 15:20:06 -0700
To: mm-commits@vger.kernel.org,nsc@kernel.org,nathan@kernel.org,yuntao.wang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] init-simplify-initramfso-build-rule.patch removed from -mm tree
Message-Id: <20261011222006.A806C1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: init: simplify initramfs.o build rule
has been removed from the -mm tree.  Its filename was
     init-simplify-initramfso-build-rule.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yuntao Wang <yuntao.wang@linux.dev>
Subject: init: simplify initramfs.o build rule
Date: Wed, 30 Sep 2026 09:57:48 +0800

CONFIG_BLK_DEV_INITRD is known to be enabled in the else branch,
so there is no need to use obj-$(CONFIG_BLK_DEV_INITRD). Use obj-y
directly to make the build rule clearer.

Also, reorder the condition to make the code easier to follow.

No functional change.

Link: https://lore.kernel.org/20260930015748.311366-1-yuntao.wang@linux.dev
Signed-off-by: Yuntao Wang <yuntao.wang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Nicolas Schier <nsc@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
---

 init/Makefile |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/init/Makefile~init-simplify-initramfso-build-rule
+++ a/init/Makefile
@@ -6,10 +6,10 @@
 ccflags-y := -fno-function-sections -fno-data-sections
 
 obj-y                          := main.o version.o mounts.o
-ifneq ($(CONFIG_BLK_DEV_INITRD),y)
-obj-y                          += noinitramfs.o
+ifeq ($(CONFIG_BLK_DEV_INITRD),y)
+obj-y                          += initramfs.o
 else
-obj-$(CONFIG_BLK_DEV_INITRD)   += initramfs.o
+obj-y                          += noinitramfs.o
 endif
 obj-$(CONFIG_GENERIC_CALIBRATE_DELAY) += calibrate.o
 obj-$(CONFIG_INITRAMFS_TEST)   += initramfs_test.o
_

Patches currently in -mm which might be from yuntao.wang@linux.dev are

dyndbg-fix-incorrect-mod_ct-value-in-dynamic_debug_init.patch
dyndbg-clean-up-dynamic_debug_init-to-improve-readability.patch

