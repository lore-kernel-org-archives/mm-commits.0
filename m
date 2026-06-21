Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90ADD36657B
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067114; cv=none; b=hZm7U/Nz5ApnJSJaRcI3CbBTxSVUI2npKdnMo5V9azwSnKZq9de1cnURc8EcJr4peJEy2n79/N2kOkU8PwEq6JADszwct1JOGHvSc5RvIBlOwBKPhOI2RCblQr9K9z+sW3U1djCRu4RuobNwChRtul3YNKQyV6rGw9DX6ITuSYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067114; c=relaxed/simple;
	bh=HVXI0QKs2mylwrd39FHYuP5OO+1SDxl5+dmOQxoH1WY=;
	h=Date:To:From:Subject:Message-Id; b=ELLT33ylTKzKcILPZuZ8B6P3u1sgwLe5Nv4Gf5aMHD4K2gv9ZOwp7HQgstOq788QnfGZ74yZA8smqMYS2jilOqALjsgIQBws2iVry4JlLpcS+ANPNd724y6LSlCgQfTTm2EyixIJzeURNVyo97MY00y3dcjAgV/9Pr/oWSERpKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gn7U9w89; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gn7U9w89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32DEB1F000E9;
	Sun, 21 Jun 2026 18:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067113;
	bh=3yLNRUFv07h6+nwZS0DAo3TrbW4VblyObjV/FS4MRgo=;
	h=Date:To:From:Subject;
	b=gn7U9w89YjvWdXhtdygcph829aTV8q0J44SNodYq4UkVmWwTzPeMtRmkYFRHuUu3W
	 VM9G9Da/LoNVJ/LCUby5Qj+21gMwzTFC0XNqgw5wtY4vL5fKlWuYQyVAjlVHmE4fut
	 +axP3qoldBaT1g6NH6Tbx0qHcC6bPyvrtUAVCE/0=
Date: Sun, 21 Jun 2026 11:38:32 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@kernel.org,surenb@google.com,songliubraving@fb.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jack@suse.cz,dsterba@suse.com,dev.jain@arm.com,david@kernel.org,clm@fb.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-remove-read_only_thp_for_fs-code-from-guard-regions.patch removed from -mm tree
Message-Id: <20260621183833.32DEB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: remove READ_ONLY_THP_FOR_FS code from guard-regions
has been removed from the -mm tree.  Its filename was
     selftests-mm-remove-read_only_thp_for_fs-code-from-guard-regions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: selftests/mm: remove READ_ONLY_THP_FOR_FS code from guard-regions
Date: Sun, 17 May 2026 09:54:14 -0400

Any file system with large folio support and the supported orders include
PMD_ORDER can be used.  There is no need to open a file with read-only.

Link: https://lore.kernel.org/20260517135416.1434539-13-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/guard-regions.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

--- a/tools/testing/selftests/mm/guard-regions.c~selftests-mm-remove-read_only_thp_for_fs-code-from-guard-regions
+++ a/tools/testing/selftests/mm/guard-regions.c
@@ -2203,17 +2203,6 @@ TEST_F(guard_regions, collapse)
 	if (variant->backing != ANON_BACKED)
 		ASSERT_EQ(ftruncate(self->fd, size), 0);
 
-	/*
-	 * We must close and re-open local-file backed as read-only for
-	 * CONFIG_READ_ONLY_THP_FOR_FS to work.
-	 */
-	if (variant->backing == LOCAL_FILE_BACKED) {
-		ASSERT_EQ(close(self->fd), 0);
-
-		self->fd = open(self->path, O_RDONLY);
-		ASSERT_GE(self->fd, 0);
-	}
-
 	ptr = mmap_(self, variant, NULL, size, PROT_READ, 0, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
 
@@ -2237,9 +2226,10 @@ TEST_F(guard_regions, collapse)
 	/*
 	 * Now collapse the entire region. This should fail in all cases.
 	 *
-	 * The madvise() call will also fail if CONFIG_READ_ONLY_THP_FOR_FS is
-	 * not set for the local file case, but we can't differentiate whether
-	 * this occurred or if the collapse was rightly rejected.
+	 * The madvise() call will also fail if the file system does not support
+	 * large folio or the supported orders do not include PMD_ORDER for the
+	 * local file case, but we can't differentiate whether this occurred or
+	 * if the collapse was rightly rejected.
 	 */
 	EXPECT_NE(madvise(ptr, size, MADV_COLLAPSE), 0);
 
_

Patches currently in -mm which might be from ziy@nvidia.com are


