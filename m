Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7E74F5FB
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 21:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716154625; cv=none; b=OEjpxCNPxIr8WYJ2gax3B0R3V4E5EGtGtdvzBuOt6sszsMMSy/4NCL2Xp8+i6BY0NTnd//xwBLWyNEoFvJhflY/ATeAXFk48HmQRZ+efzq6SMjOYd09x9j1mE0thEWGjSOQL9yAbxx1poWPq1/+gPdNtZvfJgurVS0iOU64fyko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716154625; c=relaxed/simple;
	bh=MwQilrZltNtUIZXAxR/hduO+uL0ZYD7m76H9IJgtjCA=;
	h=Date:To:From:Subject:Message-Id; b=htqQUP5iWfCPr/OVJildNMdE4TdjbxrycE8tOF2/hhk7DyBIt+J9Gpn8GJbvHpYnhvNvyv0y4AjvvpW+26PQyGTv+lnj/Yj0gwUefmCIRz7aRSNEtgwE6nAIxFInWbGH6FfrHDoUc73uSsvnsnsARqn7yuIMTC3ZK4a+TCzlQQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SUx8M/dR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SUx8M/dR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B327C32781;
	Sun, 19 May 2024 21:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716154625;
	bh=MwQilrZltNtUIZXAxR/hduO+uL0ZYD7m76H9IJgtjCA=;
	h=Date:To:From:Subject:From;
	b=SUx8M/dRATlsmrhffwaEDzuER3B980J+5ejPhEo0Z9RSZ5s8O9C65iu4n5DrUw7r3
	 nvEDoRbjH5oUyuMe9X6tBg1rqmL06LOgT0Zl5+XlNfArCw0s3pZ8l+yX+ayQwv1Ec4
	 qCJN2G2O7wz+OU5IHvLi1GH0XaXuUpDrHbr1OhoA=
Date: Sun, 19 May 2024 14:37:05 -0700
To: mm-commits@vger.kernel.org,nicolas@fjasle.eu,nathan@kernel.org,masahiroy@kernel.org,keescook@chromium.org,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kbuild-enable-wcast-function-type-strict-unconditionally.patch removed from -mm tree
Message-Id: <20240519213705.8B327C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kbuild: enable -Wcast-function-type-strict unconditionally
has been removed from the -mm tree.  Its filename was
     kbuild-enable-wcast-function-type-strict-unconditionally.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: kbuild: enable -Wcast-function-type-strict unconditionally
Date: Mon, 15 Apr 2024 14:20:36 +0200

All known function cast warnings are now addressed, so the warning can be
enabled globally to catch new ones more quickly.

Link: https://lkml.kernel.org/r/20240415122037.1983124-6-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.extrawarn |    1 -
 1 file changed, 1 deletion(-)

--- a/scripts/Makefile.extrawarn~kbuild-enable-wcast-function-type-strict-unconditionally
+++ a/scripts/Makefile.extrawarn
@@ -129,7 +129,6 @@ endif
 KBUILD_CFLAGS += $(call cc-disable-warning, pointer-to-enum-cast)
 KBUILD_CFLAGS += -Wno-tautological-constant-out-of-range-compare
 KBUILD_CFLAGS += $(call cc-disable-warning, unaligned-access)
-KBUILD_CFLAGS += $(call cc-disable-warning, cast-function-type-strict)
 KBUILD_CFLAGS += -Wno-enum-compare-conditional
 KBUILD_CFLAGS += -Wno-enum-enum-conversion
 endif
_

Patches currently in -mm which might be from arnd@arndb.de are


