Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94AD615C158
	for <mm-commits@vger.kernel.org>; Thu, 12 Jun 2025 05:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749706989; cv=none; b=bkdxyRnIK0ArRIr2YcZVoy9Kl6F/loRwoP74Z7WNEi9heSZ4QTYKjrFUYbp5oJwZQYpso16TbXZzPb4++1EBkjJjf6f+Qw0bhqn/vxuJ10gWoDO4cj3cz3TvMotRtvcdDSrEql6mhIvnJsD3J780dYZl4jyKncPP/K4Q9QOCwHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749706989; c=relaxed/simple;
	bh=Kzw2ZDBcl/3c4hL07Zu2hPG2dmKrRBU/HYCzO7E+Qsc=;
	h=Date:To:From:Subject:Message-Id; b=o7SxDtUZb36dKbmY7JkuJFlR8g25jyBA8x0k0NyD/lirf9Hv/PcEtpyws9A815lLyROp/VPc9r7EDQGjvUElBRmv0zUAcRd43rOMhFbGcZhTNtmIuuU2uOrLII8DG26gG8cX/PLSJaU0RWKamB2mV7lyGNinidqOVbr2jfAP4EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N6mXLfuf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N6mXLfuf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65040C4CEEA;
	Thu, 12 Jun 2025 05:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749706989;
	bh=Kzw2ZDBcl/3c4hL07Zu2hPG2dmKrRBU/HYCzO7E+Qsc=;
	h=Date:To:From:Subject:From;
	b=N6mXLfuffCCEkTkWRx+sNRhHigX973a+WZHv61LaX/u71J8tTLSg1HNoVuxuyJukm
	 58W2PAiySk2g4Sz83KU5HN6H2RGZ9HNhUoxjNx/IFW0gL4VI3uC20CsT2VWuic0K5p
	 p/inSHDDtUK98MbzCcT9XrNPcUPZNkzDbf8VWLq0=
Date: Wed, 11 Jun 2025 22:43:08 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,masahiroy@kernel.org,jack@suse.cz,brauner@kernel.org,chenhuacai@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] init-fix-build-warnings-about-exporth.patch removed from -mm tree
Message-Id: <20250612054309.65040C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: init: fix build warnings about export.h
has been removed from the -mm tree.  Its filename was
     init-fix-build-warnings-about-exporth.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huacai Chen <chenhuacai@loongson.cn>
Subject: init: fix build warnings about export.h
Date: Sun, 8 Jun 2025 22:12:35 +0800

After commit a934a57a42f64a4 ("scripts/misc-check: check missing #include
<linux/export.h> when W=1") and 7d95680d64ac8e836c ("scripts/misc-check:
check unnecessary #include <linux/export.h> when W=1"), we get some build
warnings with W=1:

init/main.c: warning: EXPORT_SYMBOL() is used, but #include <linux/export.h> is missing
init/initramfs.c: warning: EXPORT_SYMBOL() is used, but #include <linux/export.h> is missing

So fix these build warnings for the init code.

Link: https://lkml.kernel.org/r/20250608141235.155206-1-chenhuacai@loongson.cn
Fixes: a934a57a42f6 ("scripts/misc-check: check missing #include <linux/export.h> when W=1")
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |    1 +
 init/main.c      |    1 +
 2 files changed, 2 insertions(+)

--- a/init/initramfs.c~init-fix-build-warnings-about-exporth
+++ a/init/initramfs.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/init.h>
 #include <linux/async.h>
+#include <linux/export.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/types.h>
--- a/init/main.c~init-fix-build-warnings-about-exporth
+++ a/init/main.c
@@ -13,6 +13,7 @@
 #define DEBUG		/* Enable initcall_debug */
 
 #include <linux/types.h>
+#include <linux/export.h>
 #include <linux/extable.h>
 #include <linux/module.h>
 #include <linux/proc_fs.h>
_

Patches currently in -mm which might be from chenhuacai@loongson.cn are


