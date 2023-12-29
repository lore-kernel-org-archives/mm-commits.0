Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B95D14270
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DdFki+D3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07968C433C9;
	Fri, 29 Dec 2023 20:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880077;
	bh=AzQCpKaSb6G7hFU0jf+eNeLJs2UKk3pcrWzrPZCM44s=;
	h=Date:To:From:Subject:From;
	b=DdFki+D3tgTkmMgFP5/Cd2MaiqGF9AQD7CbmilPVuaCO4mHJ9h4u+KFo4WnmPkg/v
	 ezBOpY703gzHB+Am4kXhgt5ZFyow1VEduhXO3CKUs0eiSjdqCG96tY6lfoL1lisJC4
	 jM8hMBDaCMhdVpAureeiRQCxZAEYsO6+Hw2xHWvM=
Date: Fri, 29 Dec 2023 12:01:16 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-export-kasan_poison-as-gpl.patch removed from -mm tree
Message-Id: <20231229200117.07968C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: export kasan_poison as GPL
has been removed from the -mm tree.  Its filename was
     kasan-export-kasan_poison-as-gpl.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: export kasan_poison as GPL
Date: Thu, 21 Dec 2023 21:04:51 +0100

KASAN uses EXPORT_SYMBOL_GPL for symbols whose exporting is only required
for KASAN tests when they are built as a module.

kasan_poison is one on those symbols, so export it as GPL.

Link: https://lkml.kernel.org/r/171d0b8b2e807d04cca74f973830f9b169e06fb8.1703188911.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/shadow.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/shadow.c~kasan-export-kasan_poison-as-gpl
+++ a/mm/kasan/shadow.c
@@ -145,7 +145,7 @@ void kasan_poison(const void *addr, size
 
 	__memset(shadow_start, value, shadow_end - shadow_start);
 }
-EXPORT_SYMBOL(kasan_poison);
+EXPORT_SYMBOL_GPL(kasan_poison);
 
 #ifdef CONFIG_KASAN_GENERIC
 void kasan_poison_last_granule(const void *addr, size_t size)
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-stop-leaking-stack-trace-handles.patch

