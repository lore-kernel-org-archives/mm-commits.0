Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33291BC4E
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 02:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749004379; cv=none; b=sARTbmC93B/1QTTGliEbLJN+md7SZSTqh5Gx4DOVN+quemOf2sEWorpYOtqsB2SwqCunA0Cqk5f1e1q7THLBvRU5/WSZPxpreJDA+JN3GA0Fqm8qhJNHkmflf73bpvwohT1ZryPP3hC7loFb0PNZl4/8T8RtO0LoEFYS46C7R4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749004379; c=relaxed/simple;
	bh=TGGfC5FgnI1wrcaX8ZGyAYgVYL2Eg0GUM55UEdQty2k=;
	h=Date:To:From:Subject:Message-Id; b=d5jv3v00CZtsECAtwxpov3uaDVtH6m0VzUEWtW8H5von4Jx89TLL789jll+IYGOeNQBFVMmjVtOC+cFvV9BcD723PZRoDY3y4+0cSonCMtBKx0bRp2fGptVzC4Tx9b292P7Cn7foxbmfGkUjzhRfC7u1NyvtFAhN5DPfkvW6z8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w03wPw66; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w03wPw66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4622EC4CEED;
	Wed,  4 Jun 2025 02:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749004378;
	bh=TGGfC5FgnI1wrcaX8ZGyAYgVYL2Eg0GUM55UEdQty2k=;
	h=Date:To:From:Subject:From;
	b=w03wPw66ES7Hr+Uc6n+GHW9QfDQ0Oy5sNAG4eyBj08V98gQenUcderEdt0OXOzawa
	 3zwzqGtXGVNYllb0XqzK8Az+XVPAXbGaNTRR1l4vQs5FCteHUY503LJlMfBL84jFLQ
	 kngeTmqYM4fW6y3XViK5sxmTH4sfngNQhAMSHnMM=
Date: Tue, 03 Jun 2025 19:32:57 -0700
To: mm-commits@vger.kernel.org,snovitoll@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kmsan-test-add-module-description.patch added to mm-hotfixes-unstable branch
Message-Id: <20250604023258.4622EC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kmsan: test: add module description
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kmsan-test-add-module-description.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-test-add-module-description.patch

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
From: Arnd Bergmann <arnd@arndb.de>
Subject: kmsan: test: add module description
Date: Tue, 3 Jun 2025 09:53:07 +0200

Every module should have a description, and kbuild now warns for those
that don't.

WARNING: modpost: missing MODULE_DESCRIPTION() in mm/kmsan/kmsan_test.o

Link: https://lkml.kernel.org/r/20250603075323.1839608-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Macro Elver <elver@google.com>
Cc: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/kmsan_test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/kmsan/kmsan_test.c~kmsan-test-add-module-description
+++ a/mm/kmsan/kmsan_test.c
@@ -732,3 +732,4 @@ kunit_test_suites(&kmsan_test_suite);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Alexander Potapenko <glider@google.com>");
+MODULE_DESCRIPTION("Test cases for KMSAN");
_

Patches currently in -mm which might be from arnd@arndb.de are

kmsan-test-add-module-description.patch

