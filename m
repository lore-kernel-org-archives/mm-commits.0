Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60A53C2A
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GqcQFm0J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF138C433C8;
	Mon, 11 Dec 2023 00:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256084;
	bh=LAfdqSRfnDfCMUQ5iXgZEImQupvxrDg4qCfi2Ud/jns=;
	h=Date:To:From:Subject:From;
	b=GqcQFm0JUpBcLWDp1COnar3bGBE07t4D4AanUNNbfh9A2YKcd+LumoCJeB9HScnKS
	 qZcuGtOZA+EaJN0eVoVoa4EVeDIpiOafQcYjXj51SQI2uw3yq/pIbdEVVeAcL9B5DF
	 pnOyHjLbS4fuc3hrAxUU428tz6v+EdDFZs6IyBaQ=
Date: Sun, 10 Dec 2023 16:54:44 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-stackdepot-simplify-__stack_depot_save.patch removed from -mm tree
Message-Id: <20231211005444.AF138C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/stackdepot: simplify __stack_depot_save
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-simplify-__stack_depot_save.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: lib/stackdepot: simplify __stack_depot_save
Date: Mon, 20 Nov 2023 18:47:01 +0100

The retval local variable in __stack_depot_save has the union type
handle_parts, but the function never uses anything but the union's handle
field.

Define retval simply as depot_stack_handle_t to simplify the code.

Link: https://lkml.kernel.org/r/3b0763c8057a1cf2f200ff250a5f9580ee36a28c.1700502145.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/lib/stackdepot.c~lib-stackdepot-simplify-__stack_depot_save
+++ a/lib/stackdepot.c
@@ -366,7 +366,7 @@ depot_stack_handle_t __stack_depot_save(
 					gfp_t alloc_flags, bool can_alloc)
 {
 	struct stack_record *found = NULL, **bucket;
-	union handle_parts retval = { .handle = 0 };
+	depot_stack_handle_t handle = 0;
 	struct page *page = NULL;
 	void *prealloc = NULL;
 	unsigned long flags;
@@ -383,7 +383,7 @@ depot_stack_handle_t __stack_depot_save(
 	nr_entries = filter_irq_stacks(entries, nr_entries);
 
 	if (unlikely(nr_entries == 0) || stack_depot_disabled)
-		goto fast_exit;
+		return 0;
 
 	hash = hash_stack(entries, nr_entries);
 	bucket = &stack_table[hash & stack_hash_mask];
@@ -449,9 +449,8 @@ exit:
 		free_pages((unsigned long)prealloc, DEPOT_POOL_ORDER);
 	}
 	if (found)
-		retval.handle = found->handle.handle;
-fast_exit:
-	return retval.handle;
+		handle = found->handle.handle;
+	return handle;
 }
 EXPORT_SYMBOL_GPL(__stack_depot_save);
 
_

Patches currently in -mm which might be from andreyknvl@google.com are


