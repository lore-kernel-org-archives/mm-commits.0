Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB542D0C84;
	Sun, 12 Apr 2026 18:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776018464; cv=none; b=jJFShnIU6DZDwNIBiOM5Vjo6lEyRYOETqNE6VvgLX44ZKxzNOxAnJTsAQz5OnXB6/OssfaHYhBgFKlqhzlbL6y+xl/QUzk/w0Fk/zFIJGC74WoXHrXwxGYQfnb/puLIgbVhi6fWVYhK80rkYwBLJSGifJUdvBYxo+i9frBjSA5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776018464; c=relaxed/simple;
	bh=uPYxo5rHqNogmUfzJ9k+FS3+mKIcrmYe3/A7c0uORDM=;
	h=Date:To:From:Subject:Message-Id; b=OCPc6Rru3sCMfpZ12aC6avbNGlY/eRka3FL/21InX9nRWMjVzKQXCnUncveGAh4963hSs5IAEVXPtXXQi/Dc//7+oJDYXaPA5HRLTCz1lg0dofxhSTbRKP8BFzSELMJqwZIQJ3GdNKf9PRR3jMafhMt83SA3fQ98v6vw4pVHnM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DdwY5L18; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DdwY5L18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E9EAC19424;
	Sun, 12 Apr 2026 18:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776018463;
	bh=uPYxo5rHqNogmUfzJ9k+FS3+mKIcrmYe3/A7c0uORDM=;
	h=Date:To:From:Subject:From;
	b=DdwY5L18KGu/bAibw9xJaaL13EZp9JzyePLPDZ7hLlXbvNngsGpy6HGf2Lt4d0Ah9
	 4NGTJApgPrN8wmDo+NgmAEbibw1HzmqmMUqpaelz3joVHwXdfHhm8XEHJLVGaIVr6L
	 +g1TVR2sCFwV34WRJ+FC4myWXChgBsCG2Ly0nQME=
Date: Sun, 12 Apr 2026 11:26:03 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,stable@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baohua@kernel.org,lgs201920130244@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-thp-fix-refcount-leak-in-thpsize_create-error-path.patch removed from -mm tree
Message-Id: <20260412182743.3E9EAC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: thp: Fix refcount leak in thpsize_create() error path
has been removed from the -mm tree.  Its filename was
     mm-thp-fix-refcount-leak-in-thpsize_create-error-path.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Guangshuo Li <lgs201920130244@gmail.com>
Subject: mm: thp: Fix refcount leak in thpsize_create() error path
Date: Sat, 11 Apr 2026 14:21:52 +0800

After kobject_init_and_add(), the lifetime of the embedded struct
kobject is expected to be managed through the kobject core reference
counting.

In thpsize_create(), if kobject_init_and_add() fails, thpsize is freed
directly with kfree() rather than releasing the kobject reference with
kobject_put(). This may leave the reference count of the embedded struct
kobject unbalanced, resulting in a refcount leak and potentially leading
to a use-after-free.

Fix this by using kobject_put(&thpsize->kobj) in the failure path and
letting thpsize_release() handle the final cleanup.

Link: https://lkml.kernel.org/r/20260411062152.2092967-1-lgs201920130244@gmail.com
Fixes: 3485b88390b0 ("mm: thp: introduce multi-size THP sysfs interface")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c~mm-thp-fix-refcount-leak-in-thpsize_create-error-path
+++ a/mm/huge_memory.c
@@ -729,11 +729,8 @@ static struct thpsize *thpsize_create(in
 
 	ret = kobject_init_and_add(&thpsize->kobj, &thpsize_ktype, parent,
 				   "hugepages-%lukB", size);
-	if (ret) {
-		kfree(thpsize);
-		goto err;
-	}
-
+	if (ret)
+		goto err_put;
 
 	ret = sysfs_add_group(&thpsize->kobj, &any_ctrl_attr_grp);
 	if (ret)
_

Patches currently in -mm which might be from lgs201920130244@gmail.com are

device-dax-fix-refcount-leak-in-__devm_create_dev_dax-error-path.patch

