Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2472629D
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854820; cv=none; b=fj+/zVDRWrXwbrm6T13lRjbkcJ9sOXeG9BLLquO/3CqOJQsfI5jM+QmTQxBIvvhDuS65WdImAgne1Yfb0q3/RXmytiQbM7/TGdQqBfHotIdiqo6AmZdQJQSGxfLaSUm6bvLrLq/XMpewpFrNSGCCyg9eKX88mT38hHomIFqb9ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854820; c=relaxed/simple;
	bh=Q9NNefw9IwJdp0YPJZCbJso5ViZ14xW5MbtwukpCkbA=;
	h=Date:To:From:Subject:Message-Id; b=F9tJwWsaqkbIGO5iJGyl872BWkqlgHprmJLYA23aH+tQ5B3G5cgPlvXb6rAvRaRuX46cCuymQ0SrJNcNt3JtPO3D6e0nzAoVjnNie9w8Fis0lmbduGHCVyGC4DPUIaNTCL9or3HGvstgki022xL43EQVDGjIhgu7w0MrJp1rjlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fe5IrzQZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fe5IrzQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB2CC4CECF;
	Wed,  6 Nov 2024 01:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854820;
	bh=Q9NNefw9IwJdp0YPJZCbJso5ViZ14xW5MbtwukpCkbA=;
	h=Date:To:From:Subject:From;
	b=fe5IrzQZN/0CFwjCVe+mSj8yE3IJVV3Wt8U0PMBuDjOpdCPqD0aSZbKX9G45kZGz0
	 vpgOeVTYy+Hyr5pnnA+gxssh2UPp3HjBj5His7ED04IQtXhs0ACbM/ZNjhVrWGEWh3
	 3bIldSlVzUvtFjV4B4+aTg9sX0gHJnp48Pj/2Ca0=
Date: Tue, 05 Nov 2024 17:00:19 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,jack@suse.cz,hughd@google.com,david@redhat.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tmpfs-dont-enable-large-folios-if-not-supported.patch removed from -mm tree
Message-Id: <20241106010020.4FB2CC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tmpfs: don't enable large folios if not supported
has been removed from the -mm tree.  Its filename was
     tmpfs-dont-enable-large-folios-if-not-supported.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: tmpfs: don't enable large folios if not supported
Date: Thu, 17 Oct 2024 22:17:42 +0800

tmpfs can support large folios, but there are some configurable options
(mount options and runtime deny/force) to enable/disable large folio
allocation, so there is a performance issue when performing writes without
large folios.  The issue is similar to commit 4e527d5841e2 ("iomap: fault
in smaller chunks for non-large folio mappings").

Since 'deny' is for emergencies and 'force' is for testing, performance
issues should not be a problem in real production environments, so don't
call mapping_set_large_folios() in __shmem_get_inode() when large folio is
disabled with mount huge=never option (default policy).

Link: https://lkml.kernel.org/r/20241017141742.1169404-1-wangkefeng.wang@huawei.com
Fixes: 9aac777aaf94 ("filemap: Convert generic_perform_write() to support large folios")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/shmem.c~tmpfs-dont-enable-large-folios-if-not-supported
+++ a/mm/shmem.c
@@ -2842,7 +2842,10 @@ static struct inode *__shmem_get_inode(s
 	cache_no_acl(inode);
 	if (sbinfo->noswap)
 		mapping_set_unevictable(inode->i_mapping);
-	mapping_set_large_folios(inode->i_mapping);
+
+	/* Don't consider 'deny' for emergencies and 'force' for testing */
+	if (sbinfo->huge)
+		mapping_set_large_folios(inode->i_mapping);
 
 	switch (mode & S_IFMT) {
 	default:
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-use-aligned-address-in-clear_gigantic_page.patch
mm-use-aligned-address-in-copy_user_gigantic_page.patch

