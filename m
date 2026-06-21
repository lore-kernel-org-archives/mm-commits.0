Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C29D3655CF
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067112; cv=none; b=talQZ2OJG2Z5OoT+Pg0UdqEL2o6hkcfIcOngTEluCBrR67R4bW0qcFO3/OB2wkxIhR17OM1f4J3R+SkO+d6IN/6/TF5l46yz7DFoy0BvoXfQT3fHOd5g0SipCzN9IkCXNRugpTqVjrQbx43CObYzSFmo6o+XCAEhZGLV6YST6+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067112; c=relaxed/simple;
	bh=dpH8jMBHSO9Y14qAYjx5r3ePxgmTji028F86pg0KUlU=;
	h=Date:To:From:Subject:Message-Id; b=OUIjqDNQhKni1QXjwfgAilbjuP2xPY6Q2gnKh8LK19mzeVsvDF73gwk5qqMbj5LxtxjYFlmjea3t6iChx2aNm1/yaXs0wQNUK9SatBMvKh0UAebpzH0Mfv4tSV9kt5RJ4/qolxmFVinWN5H9koTKtYBsh8zMeqkMMBXZC5laDe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MnF1c6HW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MnF1c6HW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8DDA1F000E9;
	Sun, 21 Jun 2026 18:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067110;
	bh=dWnItsx+MjC1F71ZLTyXxAIGRbA5nc6moU0fMOM5W6g=;
	h=Date:To:From:Subject;
	b=MnF1c6HWklePQ3PdVkRj/DJB4z2220C9vTEr2JaB5JI2IXcvKAY9vvaExIr0i9rtp
	 q3KQi8OoVVe1GjhFS5rq8uNUgbxXxJcGmd6eJNp24gxnYSHFnPvlhn6JCX2FMnzVTX
	 1jOCU06CmI1WTX+8rbocN5c1zU6Bp85wqLJKMZ8U=
Date: Sun, 21 Jun 2026 11:38:29 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@kernel.org,surenb@google.com,songliubraving@fb.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jack@suse.cz,dsterba@suse.com,dev.jain@arm.com,david@kernel.org,clm@fb.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-btrfs-remove-a-comment-referring-to-read_only_thp_for_fs.patch removed from -mm tree
Message-Id: <20260621183829.E8DDA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/btrfs: remove a comment referring to READ_ONLY_THP_FOR_FS
has been removed from the -mm tree.  Its filename was
     fs-btrfs-remove-a-comment-referring-to-read_only_thp_for_fs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: fs/btrfs: remove a comment referring to READ_ONLY_THP_FOR_FS
Date: Sun, 17 May 2026 09:54:12 -0400

READ_ONLY_THP_FOR_FS is no longer present, remove related comment.

Link: https://lore.kernel.org/20260517135416.1434539-11-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Sterba <dsterba@suse.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam@infradead.org>
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

 fs/btrfs/defrag.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/fs/btrfs/defrag.c~fs-btrfs-remove-a-comment-referring-to-read_only_thp_for_fs
+++ a/fs/btrfs/defrag.c
@@ -860,9 +860,6 @@ again:
 		return folio;
 
 	/*
-	 * Since we can defragment files opened read-only, we can encounter
-	 * transparent huge pages here (see CONFIG_READ_ONLY_THP_FOR_FS).
-	 *
 	 * The IO for such large folios is not fully tested, thus return
 	 * an error to reject such folios unless it's an experimental build.
 	 *
_

Patches currently in -mm which might be from ziy@nvidia.com are


