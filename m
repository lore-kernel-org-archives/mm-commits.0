Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A03633996
	for <mm-commits@vger.kernel.org>; Wed, 13 Mar 2024 19:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710357184; cv=none; b=Jcs+J4WGLcBOtlByI9ttcoc8ERiJWgWRSgx8Bu1yMB96POPymHtbW6nXeJO9HB/xrW3fg07Obnz9odo9qXjZaBOqp93K+qaXRSmETfvyyfn48iB4P8ZGAvzDhf4lO79fZIPXk+DMFLBgAtfwKnW29BaW5C4MMwwY9nUr6eF7qzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710357184; c=relaxed/simple;
	bh=PNgDlfvzlue7R0zBl2U3dqa5D03VV5NQxonAdltLn0E=;
	h=Date:To:From:Subject:Message-Id; b=UdrBlGA4eld3TdZymu3vqmh5bAQ1pq69le48RLa+S1Q9Sl3Dk1HSQQTd0P2V+R8BAn99ivvvhKdgkH2vi+tOXScGFo26MoR/F8ddP3jP3Lpnv0tn7tzr8xwTkrPVioYX2P4EsWhbX5p/sBjezBtAIol7Vi7t+8Yn2t1LzuvKZuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ekNCrMsU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ekNCrMsU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766A2C433F1;
	Wed, 13 Mar 2024 19:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710357183;
	bh=PNgDlfvzlue7R0zBl2U3dqa5D03VV5NQxonAdltLn0E=;
	h=Date:To:From:Subject:From;
	b=ekNCrMsUTpP4JRx24VSoMAr7L6JgH+Od1/MAg6mQZsxdT6RIAjFNin7FmqJVPp4e7
	 an74A6dHj1Dtc/mb1UvAsgoMyNNwANiuOeKWRyYqAm8BF+PM2ZywYCm4hGzhEPv6f+
	 iHPMwktEvjuXS8N60MhDkGvQBxMgN/vWIJtqSk0w=
Date: Wed, 13 Mar 2024 12:13:02 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,ioworker0@gmail.com,david@redhat.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-prohibit-the-last-subpage-from-reusing-the-entire-large-folio.patch removed from -mm tree
Message-Id: <20240313191303.766A2C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: prohibit the last subpage from reusing the entire large folio
has been removed from the -mm tree.  Its filename was
     mm-prohibit-the-last-subpage-from-reusing-the-entire-large-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: prohibit the last subpage from reusing the entire large folio
Date: Fri, 8 Mar 2024 22:27:21 +1300

In a Copy-on-Write (CoW) scenario, the last subpage will reuse the entire
large folio, resulting in the waste of (nr_pages - 1) pages.  This wasted
memory remains allocated until it is either unmapped or memory reclamation
occurs.

The following small program can serve as evidence of this behavior

 main()
 {
 #define SIZE 1024 * 1024 * 1024UL
         void *p = malloc(SIZE);
         memset(p, 0x11, SIZE);
         if (fork() == 0)
                 _exit(0);
         memset(p, 0x12, SIZE);
         printf("done\n");
         while(1);
 }

For example, using a 1024KiB mTHP by:
 echo always > /sys/kernel/mm/transparent_hugepage/hugepages-1024kB/enabled

(1) w/o the patch, it takes 2GiB,

Before running the test program,
 / # free -m
                total        used        free      shared  buff/cache   available
 Mem:            5754          84        5692           0          17        5669
 Swap:              0           0           0

 / # /a.out &
 / # done

After running the test program,
 / # free -m
                 total        used        free      shared  buff/cache   available
 Mem:            5754        2149        3627           0          19        3605
 Swap:              0           0           0

(2) w/ the patch, it takes 1GiB only,

Before running the test program,
 / # free -m
                 total        used        free      shared  buff/cache   available
 Mem:            5754          89        5687           0          17        5664
 Swap:              0           0           0

 / # /a.out &
 / # done

After running the test program,
 / # free -m
                total        used        free      shared  buff/cache   available
 Mem:            5754        1122        4655           0          17        4632
 Swap:              0           0           0

This patch migrates the last subpage to a small folio and immediately
returns the large folio to the system. It benefits both memory availability
and anti-fragmentation.

Link: https://lkml.kernel.org/r/20240308092721.144735-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Lance Yang <ioworker0@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/memory.c~mm-prohibit-the-last-subpage-from-reusing-the-entire-large-folio
+++ a/mm/memory.c
@@ -3499,6 +3499,16 @@ static bool wp_can_reuse_anon_folio(stru
 				    struct vm_area_struct *vma)
 {
 	/*
+	 * We could currently only reuse a subpage of a large folio if no
+	 * other subpages of the large folios are still mapped. However,
+	 * let's just consistently not reuse subpages even if we could
+	 * reuse in that scenario, and give back a large folio a bit
+	 * sooner.
+	 */
+	if (folio_test_large(folio))
+		return false;
+
+	/*
 	 * We have to verify under folio lock: these early checks are
 	 * just an optimization to avoid locking the folio and freeing
 	 * the swapcache if there is little hope that we can reuse.
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are


