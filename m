Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B771849
	for <mm-commits@vger.kernel.org>; Sun, 13 Oct 2024 01:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728783448; cv=none; b=sFLwJhExWFCIkhiEIDxh6F6vRc7CCLj7J+StHk7Nqk43T90w/sO1ezqcvngdz09VePsj7HAKsIBLNJYzDIsakxz9miXD3THRpxcrKGIhmaJdRadMc4JKdxkP9bEEuII2pxHkf0427gfrPJ1up15HlyLk0Wkju+1M063CBOEdW4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728783448; c=relaxed/simple;
	bh=R9+1evFIIdwLaPOzZVDaCX+gu0xFF1/KpCwKT4PgKAI=;
	h=Date:To:From:Subject:Message-Id; b=EVAQiWMVi3knf1bN516ZBeFbkmTUH46bljoZb0cvpjG47a16tt83FN07R2A0kKv3fgRYn84t/B9LK+EOR4oiRNPc+p+NSbfHN3oneWMIhKtLN+ZXa2M2T5IHfEWrGn02kbLrTgiOo6yFj2gtNulH6k7aRfWNCdjCbfWLl54AjDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=njc8BBGg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="njc8BBGg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA71C4CEC6;
	Sun, 13 Oct 2024 01:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728783446;
	bh=R9+1evFIIdwLaPOzZVDaCX+gu0xFF1/KpCwKT4PgKAI=;
	h=Date:To:From:Subject:From;
	b=njc8BBGglacoZqhdXj5F4v4P4dlLRcwt9D6Ci1iLXS4D2xoAgdkyltZh612QVf8iO
	 jP4Zr3dm2jS0aWoaQGIJ23GQn34DtaAgrAaLyuRjWPaEIYU2wcaHzZL3YY6nAKU6eG
	 4Rw8/wNRdNi+tW2+6OoD6aQVupe6BKQuwjTsuwPo=
Date: Sat, 12 Oct 2024 18:37:26 -0700
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-kasan-kcov-add-bugzilla-links.patch added to mm-hotfixes-unstable branch
Message-Id: <20241013013726.AAA71C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: kasan, kcov: add bugzilla links
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-kasan-kcov-add-bugzilla-links.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-kasan-kcov-add-bugzilla-links.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: MAINTAINERS: kasan, kcov: add bugzilla links
Date: Sun, 13 Oct 2024 00:55:24 +0200

Add links to the Bugzilla component that's used to track KASAN and KCOV
issues.

Link: https://lkml.kernel.org/r/20241012225524.117871-1-andrey.konovalov@linux.dev
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-kasan-kcov-add-bugzilla-links
+++ a/MAINTAINERS
@@ -12242,6 +12242,7 @@ R:	Dmitry Vyukov <dvyukov@google.com>
 R:	Vincenzo Frascino <vincenzo.frascino@arm.com>
 L:	kasan-dev@googlegroups.com
 S:	Maintained
+B:	https://bugzilla.kernel.org/buglist.cgi?component=Sanitizers&product=Memory%20Management
 F:	Documentation/dev-tools/kasan.rst
 F:	arch/*/include/asm/*kasan.h
 F:	arch/*/mm/kasan_init*
@@ -12265,6 +12266,7 @@ R:	Dmitry Vyukov <dvyukov@google.com>
 R:	Andrey Konovalov <andreyknvl@gmail.com>
 L:	kasan-dev@googlegroups.com
 S:	Maintained
+B:	https://bugzilla.kernel.org/buglist.cgi?component=Sanitizers&product=Memory%20Management
 F:	Documentation/dev-tools/kcov.rst
 F:	include/linux/kcov.h
 F:	include/uapi/linux/kcov.h
_

Patches currently in -mm which might be from andreyknvl@gmail.com are

maintainers-kasan-kcov-add-bugzilla-links.patch

