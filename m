Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C41B8BEC
	for <mm-commits@vger.kernel.org>; Mon, 20 Jan 2025 01:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737337173; cv=none; b=HiaLv9tkes/6OG9eMvPkL1pYLlLrhmBbqeOzFcmnuYlAR+oDYL2JFitJf604ZECzFyJqtjbHwofVo5cXNErdqxQ9Je5yIza6SvwJMFb4yMmoRJOS8uFvtmGEIU2dSTTgRZ5ZbbCqBWM0LO6efqDcKLrKUZB4xVG8IMDoRXuf0hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737337173; c=relaxed/simple;
	bh=Ic3fe5pIwy7Ntulm1PIt8FqzzMUO3CfJ+UIQ3wL9kCU=;
	h=Date:To:From:Subject:Message-Id; b=aYuKN8DfGO2b+cVeTr4jcPNrPKcE9AHZHb0ZG6zM06J/xWQ2Rfnq8CSxk9Ty386UKJVsGycTCCM0KikZdH5ENFaiQF8Ddsi4AskP0uVFPtuE+K91HFtLq+wudFOHzg2HwHUhzS9DpzKGbE3YlY15oyRkuCKP3Xm9iZoBFfOTtxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HNAvxVZM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HNAvxVZM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2949C4CEE0;
	Mon, 20 Jan 2025 01:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737337172;
	bh=Ic3fe5pIwy7Ntulm1PIt8FqzzMUO3CfJ+UIQ3wL9kCU=;
	h=Date:To:From:Subject:From;
	b=HNAvxVZM3FLcw4JYfn716r1HA6AqNuG9RqzrHQ5w6bGD3gdVpDtAQU20IMXavOZSy
	 c1exJL8TR3ApTvNx2cB8pbhRU/YGqisFYDPbKWgnSsKXVgMiNh0EsTX72Yk2T5Mp/K
	 m0pKWGEk40Vkj2sYXfkuymrWkZCRWWTohZDxwfrg=
Date: Sun, 19 Jan 2025 17:39:32 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,anshuman.khandual@arm.com,andreyknvl@gmail.com,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-sw_tags-use-str_on_off-helper-in-kasan_init_sw_tags.patch removed from -mm tree
Message-Id: <20250120013932.D2949C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: sw_tags: use str_on_off() helper in kasan_init_sw_tags()
has been removed from the -mm tree.  Its filename was
     kasan-sw_tags-use-str_on_off-helper-in-kasan_init_sw_tags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: kasan: sw_tags: use str_on_off() helper in kasan_init_sw_tags()
Date: Thu, 16 Jan 2025 07:24:04 +0100

Remove hard-coded strings by using the str_on_off() helper function.

Link: https://lkml.kernel.org/r/20250116062403.2496-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Suggested-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/sw_tags.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/kasan/sw_tags.c~kasan-sw_tags-use-str_on_off-helper-in-kasan_init_sw_tags
+++ a/mm/kasan/sw_tags.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 #include <linux/stacktrace.h>
 #include <linux/string.h>
+#include <linux/string_choices.h>
 #include <linux/types.h>
 #include <linux/vmalloc.h>
 #include <linux/bug.h>
@@ -45,7 +46,7 @@ void __init kasan_init_sw_tags(void)
 	kasan_init_tags();
 
 	pr_info("KernelAddressSanitizer initialized (sw-tags, stacktrace=%s)\n",
-		kasan_stack_collection_enabled() ? "on" : "off");
+		str_on_off(kasan_stack_collection_enabled()));
 }
 
 /*
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

ocfs2-use-str_yes_no-and-str_no_yes-helper-functions.patch

