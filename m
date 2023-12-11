Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85EA3C21
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yFRXJ/fs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF5FC433C8;
	Mon, 11 Dec 2023 00:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256068;
	bh=AtrK5OaiA7OPP4w5h9D2edFMWjH0xs81wLSqM5xC6UA=;
	h=Date:To:From:Subject:From;
	b=yFRXJ/fsgVB17uZWWKaJZwQO+VhPVphuy+HIbZ4qi/aZpqf8AVGnO92vpRjEe62Xl
	 SPWTXN6/JjU6cqYlkTa2TlW5KQ6WHm09rwFMLnLRjh/r5c/CXWOi956QYbLd1kCWQK
	 savYbpOQyoqslRwVmrOqQIv1AGtL0HC/PndIGtDM=
Date: Sun, 10 Dec 2023 16:54:28 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,paul.heidekrueger@tum.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-default-to-inline-instrumentation.patch removed from -mm tree
Message-Id: <20231211005428.7EF5FC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: default to inline instrumentation
has been removed from the -mm tree.  Its filename was
     kasan-default-to-inline-instrumentation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Paul Heidekrüger <paul.heidekrueger@tum.de>
Subject: kasan: default to inline instrumentation
Date: Thu, 9 Nov 2023 15:51:00 +0000

KASan inline instrumentation can yield up to a 2x performance gain at the
cost of a larger binary.

Make inline instrumentation the default, as suggested in the bug report
below.

When an architecture does not support inline instrumentation, it should
set ARCH_DISABLE_KASAN_INLINE, as done by PowerPC, for instance.

Link: https://lkml.kernel.org/r/20231109155101.186028-1-paul.heidekrueger@tum.de
Signed-off-by: Paul Heidekrüger <paul.heidekrueger@tum.de>
Reported-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Marco Elver <elver@google.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=203495
Acked-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.kasan |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/Kconfig.kasan~kasan-default-to-inline-instrumentation
+++ a/lib/Kconfig.kasan
@@ -134,7 +134,7 @@ endchoice
 choice
 	prompt "Instrumentation type"
 	depends on KASAN_GENERIC || KASAN_SW_TAGS
-	default KASAN_OUTLINE
+	default KASAN_INLINE if !ARCH_DISABLE_KASAN_INLINE
 
 config KASAN_OUTLINE
 	bool "Outline instrumentation"
_

Patches currently in -mm which might be from paul.heidekrueger@tum.de are


