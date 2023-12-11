Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A200546BE
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mt2X2An8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F358C433C8;
	Mon, 11 Dec 2023 00:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256103;
	bh=1KIQ7jjLHVLaf/jgVaeJSgP7CSyPdudU8DiknfP0ue4=;
	h=Date:To:From:Subject:From;
	b=Mt2X2An8UUWZBnirFoHDVSf5AE0H8z7OxtoPycFDzZZwvIiyofqRhKvSTeN9c76EG
	 O5Gr71MSZv7tXCVVgM1HmRr/DU5uKJbAcWPx1GXzXka0/LCr1xV84UdNzfB7YwoXga
	 bjoel6NSS2oO77gqWn5nEjxazB2o1EqsscfVfanY=
Date: Sun, 10 Dec 2023 16:55:03 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-check-object_size-in-kasan_complete_mode_report_info.patch removed from -mm tree
Message-Id: <20231211005503.6F358C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: check object_size in kasan_complete_mode_report_info
has been removed from the -mm tree.  Its filename was
     kasan-check-object_size-in-kasan_complete_mode_report_info.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: check object_size in kasan_complete_mode_report_info
Date: Mon, 20 Nov 2023 18:47:17 +0100

Check the object size when looking up entries in the stack ring.

If the size of the object for which a report is being printed does not
match the size of the object for which a stack trace has been saved in the
stack ring, the saved stack trace is irrelevant.

Link: https://lkml.kernel.org/r/68c6948175aadd7e7e7deea61725103d64a4528f.1700502145.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report_tags.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/kasan/report_tags.c~kasan-check-object_size-in-kasan_complete_mode_report_info
+++ a/mm/kasan/report_tags.c
@@ -7,6 +7,7 @@
 #include <linux/atomic.h>
 
 #include "kasan.h"
+#include "../slab.h"
 
 extern struct kasan_stack_ring stack_ring;
 
@@ -58,7 +59,8 @@ void kasan_complete_mode_report_info(str
 		entry = &stack_ring.entries[i % stack_ring.size];
 
 		if (kasan_reset_tag(entry->ptr) != info->object ||
-		    get_tag(entry->ptr) != get_tag(info->access_addr))
+		    get_tag(entry->ptr) != get_tag(info->access_addr) ||
+		    info->cache->object_size != entry->size)
 			continue;
 
 		if (entry->is_free) {
_

Patches currently in -mm which might be from andreyknvl@google.com are


