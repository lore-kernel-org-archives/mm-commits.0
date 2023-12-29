Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D61713FF7
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fmJDRRbC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37DFEC433C8;
	Fri, 29 Dec 2023 20:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880061;
	bh=27SMcDTvgKW0W+TzU4KSBCQHqbQBzBpUjXIWVj1xYIc=;
	h=Date:To:From:Subject:From;
	b=fmJDRRbChrBtXGJU5bG4OcCKKrioF1meWtGpYBJ/QlRfPEbGrmILwCfKR3F6WH2nQ
	 RrEC8IAB5D6BywZnxLZi+KtlnuAXm+Yd6D5QHJ8CH7BIUUfoAvBeJKP/7JybjWcIuI
	 iCiCE3gI4zglaBlTS6H90NGhSDpXamHf6qxEqsKk=
Date: Fri, 29 Dec 2023 12:01:00 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,penguin-kernel@i-love.sakura.ne.jp,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-stackdepot-fix-comment-in-include-linux-stackdepoth.patch removed from -mm tree
Message-Id: <20231229200101.37DFEC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/stackdepot: fix comment in include/linux/stackdepot.h
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-fix-comment-in-include-linux-stackdepoth.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: lib/stackdepot: fix comment in include/linux/stackdepot.h
Date: Tue, 19 Dec 2023 22:19:53 +0100

As stack traces can now be evicted from the stack depot, remove the
comment saying that they are never removed.

Link: https://lkml.kernel.org/r/0ebe712d91f8d302a8947d3c9e9123bc2b1b8440.1703020707.git.andreyknvl@google.com
Fixes: 108be8def46e ("lib/stackdepot: allow users to evict stack traces")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stackdepot.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/stackdepot.h~lib-stackdepot-fix-comment-in-include-linux-stackdepoth
+++ a/include/linux/stackdepot.h
@@ -11,8 +11,6 @@
  * SLUB_DEBUG needs 256 bytes per object for that). Since allocation and free
  * stack traces often repeat, using stack depot allows to save about 100x space.
  *
- * Stack traces are never removed from the stack depot.
- *
  * Author: Alexander Potapenko <glider@google.com>
  * Copyright (C) 2016 Google, Inc.
  *
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-stop-leaking-stack-trace-handles.patch

