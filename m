Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0306F2EB;
	Wed,  4 Sep 2024 04:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423493; cv=none; b=FEXxhf4T1XEai5Gp3oyvUbzNbV0qB0kZwNWgvY4lzy9qQtn2+m0ifcRUE+uBpzHV5SunSGgHjFIPzoCgfP5zfjWjIIZKmOTnYaSilHbytmgKqv1ekcdIKM6Ej5NrQfqLD0HDiLiYlBDrra48NdHV35FRBMikzoEb2jrjj0NKaj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423493; c=relaxed/simple;
	bh=IJmVIUHdes8t+IvRAKQuW+Qcet8o3Bn6hRLaf8XK4Vo=;
	h=Date:To:From:Subject:Message-Id; b=r26zlf2scR217pC5RFuRXB5XN7Yt9iWe0c+00mgjs5TiZKfEnVEKZZZ8BhOMGdRFA48waJo58WBdw2n9qz8PI0U1dPNM9iIyO7Hyv3sbQ9RuBDgpMzjRo95ICFYazhiY0qIkp3gt/s1EKEEx3M8p/GYX9SK5DuEfdyB+rLU/Ftk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vsFjC5h4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vsFjC5h4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E646EC4CEC2;
	Wed,  4 Sep 2024 04:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423493;
	bh=IJmVIUHdes8t+IvRAKQuW+Qcet8o3Bn6hRLaf8XK4Vo=;
	h=Date:To:From:Subject:From;
	b=vsFjC5h4Avkjx4KCUUmRIkNzV7EyWmYRfeXX3RSjXBIkJQRFich9oVsjJ7JJ2ouhw
	 5baZo8PZL89Kj5f1zHKv5I2LhZXUNadIdQXaSfYC0Mv6nkT3ws4Li+cYBAHcljy0Gi
	 D8Hk9QZDhVjcFNi3zjXQKjAZwVOYtzlPlxKkmvQM=
Date: Tue, 03 Sep 2024 21:18:12 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,iamjoonsoo.kim@lge.com,cl@linux.com,42.hyeyoo@gmail.com,dakr@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-krealloc-consider-spare-memory-for-__gfp_zero.patch removed from -mm tree
Message-Id: <20240904041812.E646EC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: krealloc: consider spare memory for __GFP_ZERO
has been removed from the -mm tree.  Its filename was
     mm-krealloc-consider-spare-memory-for-__gfp_zero.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Danilo Krummrich <dakr@kernel.org>
Subject: mm: krealloc: consider spare memory for __GFP_ZERO
Date: Tue, 13 Aug 2024 00:34:34 +0200

As long as krealloc() is called with __GFP_ZERO consistently, starting
with the initial memory allocation, __GFP_ZERO should be fully honored.

However, if for an existing allocation krealloc() is called with a
decreased size, it is not ensured that the spare portion the allocation is
zeroed.  Thus, if krealloc() is subsequently called with a larger size
again, __GFP_ZERO can't be fully honored, since we don't know the previous
size, but only the bucket size.

Example:

	buf = kzalloc(64, GFP_KERNEL);
	memset(buf, 0xff, 64);

	buf = krealloc(buf, 48, GFP_KERNEL | __GFP_ZERO);

	/* After this call the last 16 bytes are still 0xff. */
	buf = krealloc(buf, 64, GFP_KERNEL | __GFP_ZERO);

Fix this, by explicitly setting spare memory to zero, when shrinking an
allocation with __GFP_ZERO flag set or init_on_alloc enabled.

Link: https://lkml.kernel.org/r/20240812223707.32049-1-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/slab_common.c~mm-krealloc-consider-spare-memory-for-__gfp_zero
+++ a/mm/slab_common.c
@@ -1273,6 +1273,13 @@ __do_krealloc(const void *p, size_t new_
 
 	/* If the object still fits, repoison it precisely. */
 	if (ks >= new_size) {
+		/* Zero out spare memory. */
+		if (want_init_on_alloc(flags)) {
+			kasan_disable_current();
+			memset((void *)p + new_size, 0, ks - new_size);
+			kasan_enable_current();
+		}
+
 		p = kasan_krealloc((void *)p, new_size, flags);
 		return (void *)p;
 	}
_

Patches currently in -mm which might be from dakr@kernel.org are


