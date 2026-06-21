Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F90F3655FF
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067099; cv=none; b=kE5LSS7y4WsPBdP7spZrlMVtNuY3VshGmEi+W2u8+v/LpXZl987UaGHXfgC1BQoCPW3a8OJJ9dJLzUCAJ0hMNRmApH+I0aJvMZUpcsDgKq/uA/oqsNS+Pwf4q7ZBV75u7XMky5OeSwxFHDVeY6VVrwD4moiw7AyukB28OsY9lks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067099; c=relaxed/simple;
	bh=YuZx3czysOkAQvY+ZiS1y9kMsZq97ohGSpYsNeUw8LQ=;
	h=Date:To:From:Subject:Message-Id; b=u+s7V9TDbUgYcdtjRbM1j0q5ntin7ymutCMuJNK7OqVR3WLu+7K8Gy2edsfr1+3Fjoti6z4BpX3svwyyzs+dwei11wi459olFN4243VGZiR/N6IBxUGVK/Xpw4kG7G/IahaIOQcsrVu4cOeZU4Ps1DAzFGCKnLQ/FMhnqlzAnoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lIx1CJlM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lIx1CJlM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D431F000E9;
	Sun, 21 Jun 2026 18:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067098;
	bh=s45Fzvif9UBOhYi0Dp8Z8poG5xcExmPDu66KWPCKSWs=;
	h=Date:To:From:Subject;
	b=lIx1CJlMFygDEaTU5VjhL6N35DM28g9pdZiRFtk+y0bn7esupOIMRKT+WA1wo6s15
	 gMYG4S/fO7xfkHRj3WVZENWSUvT7KnhAPZk8aYkNC78pEoTG0ZAdfBrHKmIbTJM42x
	 31qGLwB5D5B8vv2n9xu7OhcEldQNoP2tna8OHUkM=
Date: Sun, 21 Jun 2026 11:38:18 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@kernel.org,surenb@google.com,songliubraving@fb.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jack@suse.cz,dsterba@suse.com,dev.jain@arm.com,david@kernel.org,clm@fb.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-remove-read_only_thp_for_fs-from-file_thp_enabled.patch removed from -mm tree
Message-Id: <20260621183818.79D431F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-remove-read_only_thp_for_fs-from-file_thp_enabled.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
Date: Sun, 17 May 2026 09:54:05 -0400

Replace it with a check on the max folio order of the file's address space
mapping, making sure PMD folio is supported.  Keep the inode
open-for-write check, since even if collapse_file() now makes sure all
to-be-collapsed folios are clean and the created PMD file THP can be
handled by FSes properly, the filemap_flush() could perform undesirable
write back.

Link: https://lore.kernel.org/20260517135416.1434539-4-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Nico Pache <npache@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-remove-read_only_thp_for_fs-from-file_thp_enabled
+++ a/mm/huge_memory.c
@@ -89,9 +89,6 @@ static inline bool file_thp_enabled(stru
 {
 	struct inode *inode;
 
-	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
-		return false;
-
 	if (!vma->vm_file)
 		return false;
 
@@ -100,6 +97,9 @@ static inline bool file_thp_enabled(stru
 	if (IS_ANON_FILE(inode))
 		return false;
 
+	if (!mapping_pmd_folio_support(vma->vm_file->f_mapping))
+		return false;
+
 	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
 }
 
_

Patches currently in -mm which might be from ziy@nvidia.com are


