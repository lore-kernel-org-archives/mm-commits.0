Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE7A8175E
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104469; cv=none; b=Mv+cBEYQrrmOLv1NwYfAOlkOsST7K3o9hO0taFs9z+mHl5ptb5x/vLIm5JfZjoTx85gM8XT8aYkRjnsp90ZkteKcZUxlTBSLE+HusZPNT42AxhxWu0AuGoQLqtELjwU/MmbOe+4TUbW/tHDsHUDSOJf+c7x+PridJ0yBUkK6hz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104469; c=relaxed/simple;
	bh=31SspX/D0SVPBgH67YzaTKFqMYU/ToPI8P4Al6ywljY=;
	h=Date:To:From:Subject:Message-Id; b=OHkl7F0JucidksJeZeAEU63bg6nLFhM4UtvtJzoBI7p/CQuwnYMGyN/LL1t4JEuZr+9NM8VT9o19TgMszt3C0BHSdpHLzuExYBGSxvNwhTtT8NKrFh8RRJHYOZT0y7cFZDwukPI4D8Y3W+Xp73YYs9ACoWZhCGkY/u96S9yJQls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G944A2VE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G944A2VE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98386C116B1;
	Fri, 26 Apr 2024 04:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104469;
	bh=31SspX/D0SVPBgH67YzaTKFqMYU/ToPI8P4Al6ywljY=;
	h=Date:To:From:Subject:From;
	b=G944A2VEtRtpm0MGlZLv5C2Exfglbzq5G4eRfkGLBLnM7hbPsK55rt+ReZ5C5mWK/
	 0WuvNCWmMbjLJ/l5IMSTrUYuURMHJNc+gjVOEd7uJw8LzYFO1yiRKb9KqVR3L/1eal
	 t96xAKmzDVFksyRp4X/8JJC8V7X8USIwyE7/0oYI=
Date: Thu, 25 Apr 2024 21:07:49 -0700
To: mm-commits@vger.kernel.org,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,justinstitt@google.com,dvyukov@google.com,andreyknvl@gmail.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kcov-avoid-clang-out-of-range-warning.patch removed from -mm tree
Message-Id: <20240426040749.98386C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kcov: avoid clang out-of-range warning
has been removed from the -mm tree.  Its filename was
     kcov-avoid-clang-out-of-range-warning.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: kcov: avoid clang out-of-range warning
Date: Thu, 28 Mar 2024 15:30:42 +0100

The area_size is never larger than the maximum on 64-bit architectutes:

kernel/kcov.c:634:29: error: result of comparison of constant 1152921504606846975 with expression of type '__u32' (aka 'unsigned int') is always false [-Werror,-Wtautological-constant-out-of-range-compare]
                if (remote_arg->area_size > LONG_MAX / sizeof(unsigned long))
                    ~~~~~~~~~~~~~~~~~~~~~ ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The compiler can correctly optimize the check away and the code appears
correct to me, so just add a cast to avoid the warning.

Link: https://lkml.kernel.org/r/20240328143051.1069575-5-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Justin Stitt <justinstitt@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/kcov.c~kcov-avoid-clang-out-of-range-warning
+++ a/kernel/kcov.c
@@ -627,7 +627,8 @@ static int kcov_ioctl_locked(struct kcov
 		mode = kcov_get_mode(remote_arg->trace_mode);
 		if (mode < 0)
 			return mode;
-		if (remote_arg->area_size > LONG_MAX / sizeof(unsigned long))
+		if ((unsigned long)remote_arg->area_size >
+		    LONG_MAX / sizeof(unsigned long))
 			return -EINVAL;
 		kcov->mode = mode;
 		t->kcov = kcov;
_

Patches currently in -mm which might be from arnd@arndb.de are

kbuild-turn-on-wextra-by-default.patch
kbuild-remove-redundant-extra-warning-flags.patch
kbuild-turn-on-wrestrict-by-default.patch
kbuild-enable-wformat-truncation-on-clang.patch
kbuild-enable-wcast-function-type-strict-unconditionally.patch

