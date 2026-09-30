Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E663F547059
	for <mm-commits@vger.kernel.org>; Wed, 30 Sep 2026 02:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790734608; cv=none; b=nwZSxOs+t9BDjtjGWaE/Fzh8sjougFRSA9JQUOkdGkB1YmVy80Tq5/UiRydG4tnIruMilL7lBZwYJFgCob55arE82yI+yZ+/oUCYr0Z/U67ATQY3BU5hzplGeYqTDVxrG3pt5oBjSn7qjHAjBpy+GYzegMgZ3RW4JKjolqiv8cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790734608; c=relaxed/simple;
	bh=w6t2Lk6cycWulNhJaT8fQf7dl9veZpUbaBBknrmxUEo=;
	h=Date:To:From:Subject:Message-Id; b=ZSScuR0QGwijJ9et64ijghFDRO7lQknMrhPey+9jqavAThcCdLV2U4c2RaEnkBS6sO9FbR2upEkSOAbsJ5NPIQrM7Wv8+aMDye/uhiNA1UVrhNocRRrNGe/AM37RbwhOl/fGzE3Pn0TcVpaOqw62+xv8Q2/Bg79wJ5oPxb0zOwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EoqOp/hb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EoqOp/hb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C4D1F000FF;
	Wed, 30 Sep 2026 02:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790734606;
	bh=0p88meOEOyDChqQPPwz9ye4YAY+svuFhv4z+gigVtRg=;
	h=Date:To:From:Subject;
	b=EoqOp/hbimqenOX6l/iEQXNxrvAv7rXrvpYAEjv0v95T2taBZ1z3q5djpO4A9h8sn
	 8dcTa/CTRtHcx+FTEXwBanEClu02cItQYQmSV/0BHCxI4RKj/1DjrVRyCeC3ySQFgN
	 3kwK3kG8bNBC+kwJS71RRpMo6yAAuiRVOsNGTEvk=
Date: Tue, 29 Sep 2026 19:16:45 -0700
To: mm-commits@vger.kernel.org,nsc@kernel.org,nathan@kernel.org,yuntao.wang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-simplify-initramfso-build-rule.patch added to mm-nonmm-unstable branch
Message-Id: <20260930021646.52C4D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init: simplify initramfs.o build rule
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-simplify-initramfso-build-rule.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-simplify-initramfso-build-rule.patch

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
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nsc@kernel.org>
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
init-simplify-initramfso-build-rule.patch

