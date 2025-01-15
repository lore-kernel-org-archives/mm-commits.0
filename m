Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CB763A9
	for <mm-commits@vger.kernel.org>; Wed, 15 Jan 2025 01:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736904060; cv=none; b=Nd5KFZACFH1s77audnaewL6vwyma4HetLmlrXcFyRHPoapB7d+ViZd0FQfZukwnyBRk8vBk+xi6vuSMPERslu294vF3Drqsj22Ksw9s6CutJ40qBZs94CCL8mOiQK2Y5dby7M7UQUDC2yJtcJBctfGmVdAnJX1jx+ho2ymmBlIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736904060; c=relaxed/simple;
	bh=Dp1nl0gpFuMgKQ/B/N1I9Za/m2cEhwMmwbeFPOJXJZw=;
	h=Date:To:From:Subject:Message-Id; b=aPqqf4iRn4+Qd/cjx7OPjQBS0fe/y1QsgLrbDDVA0jygLxIYWeAsrerijVhMOC/x+tDFqWLpzvyh5NiDtZ+nHPt21WmAn8g1oOYL7GF805FG6ACdQgyWxf7jtzmS67nxfsPjGjYFxoHBvXyTCPiS1gybf6oQPAhE0Y4yv3ftkEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gvn13ltA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gvn13ltA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75FAC4CEDD;
	Wed, 15 Jan 2025 01:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736904059;
	bh=Dp1nl0gpFuMgKQ/B/N1I9Za/m2cEhwMmwbeFPOJXJZw=;
	h=Date:To:From:Subject:From;
	b=Gvn13ltALJPSWkr5xW95+trtDDB3us7lCedd5XKIK2LvjP66Z4vBVv5tHDD12mUiB
	 OpL3TpsWg7w1V//+LxTE0+RIKxJg3Nqwjiisd1wUABMs3y/ou/aREO7G/dxCajVvNt
	 xda1CxX9n81E9uD9YjJhbIJCrJpDUNvlF4Kyyg84=
Date: Tue, 14 Jan 2025 17:20:59 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,anshuman.khandual@arm.com,andreyknvl@gmail.com,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-hw_tags-use-str_on_off-helper-in-kasan_init_hw_tags.patch added to mm-unstable branch
Message-Id: <20250115012059.A75FAC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: hw_tags: Use str_on_off() helper in kasan_init_hw_tags()
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-hw_tags-use-str_on_off-helper-in-kasan_init_hw_tags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-hw_tags-use-str_on_off-helper-in-kasan_init_hw_tags.patch

This patch will later appear in the mm-unstable branch at
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
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: kasan: hw_tags: Use str_on_off() helper in kasan_init_hw_tags()
Date: Tue, 14 Jan 2025 16:09:35 +0100

Remove hard-coded strings by using the str_on_off() helper function.

Link: https://lkml.kernel.org/r/20250114150935.780869-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Suggested-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/hw_tags.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/kasan/hw_tags.c~kasan-hw_tags-use-str_on_off-helper-in-kasan_init_hw_tags
+++ a/mm/kasan/hw_tags.c
@@ -16,6 +16,7 @@
 #include <linux/mm.h>
 #include <linux/static_key.h>
 #include <linux/string.h>
+#include <linux/string_choices.h>
 #include <linux/types.h>
 #include <linux/vmalloc.h>
 
@@ -263,8 +264,8 @@ void __init kasan_init_hw_tags(void)
 
 	pr_info("KernelAddressSanitizer initialized (hw-tags, mode=%s, vmalloc=%s, stacktrace=%s)\n",
 		kasan_mode_info(),
-		kasan_vmalloc_enabled() ? "on" : "off",
-		kasan_stack_collection_enabled() ? "on" : "off");
+		str_on_off(kasan_vmalloc_enabled()),
+		str_on_off(kasan_stack_collection_enabled()));
 }
 
 #ifdef CONFIG_KASAN_VMALLOC
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

kasan-hw_tags-use-str_on_off-helper-in-kasan_init_hw_tags.patch

