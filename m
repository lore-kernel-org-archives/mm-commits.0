Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F2F468D
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hg7wu64x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814C8C433C7;
	Mon, 11 Dec 2023 00:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256097;
	bh=BEAGM4Sh6bwKit5clMUR5pFEXqyw1HiEirtFqmX7/eo=;
	h=Date:To:From:Subject:From;
	b=Hg7wu64xNEgvDtRfXSZamkUAJUDfedcDrJ8dwaAcChOiwMOPyHqVOz69NS+bwFowc
	 irvs1Cou+ylEz/hs8xx7kckj6dkhjmh1MmMv04dHvrrC5oGHdXSD/GJVFLkfJEuVoJ
	 Spmp9EPM/BY7phVTEYdH4IbJgcgijRAIviPfNuAA=
Date: Sun, 10 Dec 2023 16:54:57 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-use-stack_depot_save-instead-of-__stack_depot_save.patch removed from -mm tree
Message-Id: <20231211005457.814C8C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmsan: use stack_depot_save instead of __stack_depot_save
has been removed from the -mm tree.  Its filename was
     kmsan-use-stack_depot_save-instead-of-__stack_depot_save.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kmsan: use stack_depot_save instead of __stack_depot_save
Date: Mon, 20 Nov 2023 18:47:12 +0100

Make KMSAN use stack_depot_save instead of __stack_depot_save, as it
  always passes true to __stack_depot_save as the last argument.

Link: https://lkml.kernel.org/r/18092240699efdc6acd78b51e41ea782953e6c8d.1700502145.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/core.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/kmsan/core.c~kmsan-use-stack_depot_save-instead-of-__stack_depot_save
+++ a/mm/kmsan/core.c
@@ -76,7 +76,7 @@ depot_stack_handle_t kmsan_save_stack_wi
 	/* Don't sleep. */
 	flags &= ~(__GFP_DIRECT_RECLAIM | __GFP_KSWAPD_RECLAIM);
 
-	handle = __stack_depot_save(entries, nr_entries, flags, true);
+	handle = stack_depot_save(entries, nr_entries, flags);
 	return stack_depot_set_extra_bits(handle, extra);
 }
 
@@ -185,11 +185,10 @@ depot_stack_handle_t kmsan_internal_chai
 	/*
 	 * @entries is a local var in non-instrumented code, so KMSAN does not
 	 * know it is initialized. Explicitly unpoison it to avoid false
-	 * positives when __stack_depot_save() passes it to instrumented code.
+	 * positives when stack_depot_save() passes it to instrumented code.
 	 */
 	kmsan_internal_unpoison_memory(entries, sizeof(entries), false);
-	handle = __stack_depot_save(entries, ARRAY_SIZE(entries), __GFP_HIGH,
-				    true);
+	handle = stack_depot_save(entries, ARRAY_SIZE(entries), __GFP_HIGH);
 	return stack_depot_set_extra_bits(handle, extra_bits);
 }
 
_

Patches currently in -mm which might be from andreyknvl@google.com are


