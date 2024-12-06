Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5A747F4A;
	Fri,  6 Dec 2024 03:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733457323; cv=none; b=g4VNR3X57hV5OcRoeM2llinfuTodq0YV180Lyl26uu0Z58K9lBCO3L7tkmVZaXPpqaaZb8ZINJljv0D9K6K482MFusrm+TFZ26pali6raXVWZUdKegVHfv65WDqJ/K7G9B3fQyOqnwdRLcd1oO8hfddZt6Bmn6G2t4txm/h6mp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733457323; c=relaxed/simple;
	bh=9i9HrqhZz6c+acN5GGUzr6pym+5FwUVhfaxQ2WvpBhE=;
	h=Date:To:From:Subject:Message-Id; b=VbZAb8KMgfqzO9nQwS61mONBgEXQXVjBZgJMUqCoJTx4CvxlMLJFHqNUvjVc/OLafSKhW0Oatr7GdeYaIqmodxYA0IRqQkPANBcV3U4QwLFJYJV3AQKpP4Gn6alVXQZJvguvv/dbamkAUvur8tlT9v2rrOcaD2DmXbtDPpuUqdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MybESibK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MybESibK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E5BCC4CED1;
	Fri,  6 Dec 2024 03:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733457323;
	bh=9i9HrqhZz6c+acN5GGUzr6pym+5FwUVhfaxQ2WvpBhE=;
	h=Date:To:From:Subject:From;
	b=MybESibKnvfuT+IPqcjQznceJoKs7yAz8D6I9uDQ+bQ4hbeMP09Nu8yMrVCexnBvf
	 1PGQj3F3+HqjodxEUTz5GZJOR5FKn9iOdq/gEJaIQNRfBFZ9lD7H/5voEw08oFKfMQ
	 432+9R3yQc+jUDZK09sLpuk6sZBd43E7EGN6W7gM=
Date: Thu, 05 Dec 2024 19:55:22 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,urezki@gmail.com,stable@vger.kernel.org,mhocko@suse.com,hch@infradead.org,ast@kernel.org,andrii@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-vreallocs-kasan-poisoning-logic.patch removed from -mm tree
Message-Id: <20241206035523.4E5BCC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix vrealloc()'s KASAN poisoning logic
has been removed from the -mm tree.  Its filename was
     mm-fix-vreallocs-kasan-poisoning-logic.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrii Nakryiko <andrii@kernel.org>
Subject: mm: fix vrealloc()'s KASAN poisoning logic
Date: Mon, 25 Nov 2024 16:52:06 -0800

When vrealloc() reuses already allocated vmap_area, we need to re-annotate
poisoned and unpoisoned portions of underlying memory according to the new
size.

This results in a KASAN splat recorded at [1].  A KASAN mis-reporting
issue where there is none.

Note, hard-coding KASAN_VMALLOC_PROT_NORMAL might not be exactly correct,
but KASAN flag logic is pretty involved and spread out throughout
__vmalloc_node_range_noprof(), so I'm using the bare minimum flag here and
leaving the rest to mm people to refactor this logic and reuse it here.

Link: https://lkml.kernel.org/r/20241126005206.3457974-1-andrii@kernel.org
Link: https://lore.kernel.org/bpf/67450f9b.050a0220.21d33d.0004.GAE@google.com/ [1]
Fixes: 3ddc2fefe6f3 ("mm: vmalloc: implement vrealloc()")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-fix-vreallocs-kasan-poisoning-logic
+++ a/mm/vmalloc.c
@@ -4093,7 +4093,8 @@ void *vrealloc_noprof(const void *p, siz
 		/* Zero out spare memory. */
 		if (want_init_on_alloc(flags))
 			memset((void *)p + size, 0, old_size - size);
-
+		kasan_poison_vmalloc(p + size, old_size - size);
+		kasan_unpoison_vmalloc(p, size, KASAN_VMALLOC_PROT_NORMAL);
 		return (void *)p;
 	}
 
_

Patches currently in -mm which might be from andrii@kernel.org are


