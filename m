Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F2A4655D
	for <mm-commits@vger.kernel.org>; Mon, 22 Jul 2024 23:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721690788; cv=none; b=S/CcZcJO6DglI3i8s1WT3dkuBN4uCsSFR8cwqUndoSSsJhKY8/dfKNzY2z9/EaYriTN/ryxyNroKFLvOAiNZI4pIDQVFriSEzKXeVn0tcu2CF2RwEwVBZZrRGxE2cMxa5PQ4N4h2StqKzwrWofP0SEsDFTYj9j/wAohDdNsMzUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721690788; c=relaxed/simple;
	bh=uXFwExwhhZvm8SoRhlfWVyRTalpBBo+1d3D6LF3KvFQ=;
	h=Date:To:From:Subject:Message-Id; b=jXE4nGY3hieE3ba+6hx95Wr1J4Rp9CVmtXkCVqwLgBpICcAVlmg6KCAkQwL+5uy0u3InBL/rE9QnFzFIE6rdrqlouaigzd8Tm/5K4kflZVvrCKXuMKpLubarHyL13TLVARvcHaBnvPtpZ7nOvH0waZGfWl2dPNz6jF3iHnHkBJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Kja0XH5f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Kja0XH5f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFF2C116B1;
	Mon, 22 Jul 2024 23:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721690788;
	bh=uXFwExwhhZvm8SoRhlfWVyRTalpBBo+1d3D6LF3KvFQ=;
	h=Date:To:From:Subject:From;
	b=Kja0XH5fc/sRAvX9jdoFFa8/rRrYWFIjv2E1loNa0ScOJnF230zILvRFsOgTFE7Vy
	 oLqt7F/twi4FfhB6EozlQahPJuXkp88nbRnnu8KGD4PTq6C99mqcq9bwXrsujArZxu
	 suAdfqIK68fIf/ymTNcpKOEmnT0eRmKsIMD8C0Lg=
Date: Mon, 22 Jul 2024 16:26:27 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,nogikh@google.com,linux@rasmusvillemoes.dk,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kcov-dont-instrument-lib-find_bitc.patch added to mm-nonmm-unstable branch
Message-Id: <20240722232628.3DFF2C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kcov: don't instrument lib/find_bit.c
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kcov-dont-instrument-lib-find_bitc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kcov-dont-instrument-lib-find_bitc.patch

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
From: Andrey Konovalov <andreyknvl@gmail.com>
Subject: kcov: don't instrument lib/find_bit.c
Date: Tue, 23 Jul 2024 00:37:26 +0200

This file produces large amounts of flaky coverage not useful for the
KCOV's intended use case (guiding the fuzzing process).

Link: https://lkml.kernel.org/r/20240722223726.194658-1-andrey.konovalov@linux.dev
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Aleksandr Nogikh <nogikh@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/Makefile~kcov-dont-instrument-lib-find_bitc
+++ a/lib/Makefile
@@ -14,6 +14,7 @@ KCOV_INSTRUMENT_list_debug.o := n
 KCOV_INSTRUMENT_debugobjects.o := n
 KCOV_INSTRUMENT_dynamic_debug.o := n
 KCOV_INSTRUMENT_fault-inject.o := n
+KCOV_INSTRUMENT_find_bit.o := n
 
 # string.o implements standard library functions like memset/memcpy etc.
 # Use -ffreestanding to ensure that the compiler does not try to "optimize"
_

Patches currently in -mm which might be from andreyknvl@gmail.com are

kcov-dont-instrument-lib-find_bitc.patch

