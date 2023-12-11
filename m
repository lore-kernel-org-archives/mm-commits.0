Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD5C4692
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nmzva6ud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 881DBC433CA;
	Mon, 11 Dec 2023 00:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256083;
	bh=dUM+rlq8uUYkDP2o+fb/EcVFfNr1dyE8ZNmHpSIR08w=;
	h=Date:To:From:Subject:From;
	b=Nmzva6udBqlK7038C+i4w6RBTW2PEDx9pKFcgNR/YTqNUVvn5JDYMsf3mQA+/xQcX
	 VZlZabj8fMqMaD5btvKTICINvHAOkC0AQcvgU+/IWYX13S8OaOb4E9z7uXZ3+JorLs
	 KNKkB17yjkZooYqo3SZkmgxbrjSBcG6y3KXujymQ=
Date: Sun, 10 Dec 2023 16:54:43 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-stackdepot-check-disabled-flag-when-fetching.patch removed from -mm tree
Message-Id: <20231211005443.881DBC433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/stackdepot: check disabled flag when fetching
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-check-disabled-flag-when-fetching.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: lib/stackdepot: check disabled flag when fetching
Date: Mon, 20 Nov 2023 18:47:00 +0100

Do not try fetching a stack trace from the stack depot if the
stack_depot_disabled flag is enabled.

Link: https://lkml.kernel.org/r/c3bfa3b7ab00b2e48ab75a3fbb9c67555777cb08.1700502145.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/stackdepot.c~lib-stackdepot-check-disabled-flag-when-fetching
+++ a/lib/stackdepot.c
@@ -483,7 +483,7 @@ unsigned int stack_depot_fetch(depot_sta
 	 */
 	kmsan_unpoison_memory(entries, sizeof(*entries));
 
-	if (!handle)
+	if (!handle || stack_depot_disabled)
 		return 0;
 
 	if (parts.pool_index > pool_index_cached) {
_

Patches currently in -mm which might be from andreyknvl@google.com are


