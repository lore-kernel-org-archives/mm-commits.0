Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5AD1B815
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855369; cv=none; b=ZJ4DXYGxW1hSlX2wSp8hA4YmJ0yfcX1FpheH8Ktwy8R9pmRJx3mJr4bYrsoBHqqzC6fUH4O3oHpYLKDCMHbqL+Rg+430mAL8U3hxswePKjAOZPfa3u86a1DkBX0ef9ulgufMfV7B3jL9QXrw9fDYn4N8fOeLuJZrUWGNORwKi3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855369; c=relaxed/simple;
	bh=T2y/nVmMqbXqtiX44+7gCn/ch5pQqEQuy/I6FbRxkZk=;
	h=Date:To:From:Subject:Message-Id; b=jaQTq9pbZq1yHXnhfLSgsrnzHxLF0mOumG22ymKkEnxiQgi7H9ome3KMDnWtjurlxU+12TNs05itmSe4eg93IsS1O3VWKmLxJy2QlWIt68Ea26wg8ArhGPjS22ig0ICuEOA1+gfispwuPq6CpyYBrWqBZLuQ7WTnwjzBwI0Czl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=efCMTjhM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="efCMTjhM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA9DC4CECF;
	Wed,  6 Nov 2024 01:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855368;
	bh=T2y/nVmMqbXqtiX44+7gCn/ch5pQqEQuy/I6FbRxkZk=;
	h=Date:To:From:Subject:From;
	b=efCMTjhM3e+jK3qbVHMLrw0D5RTVyG/bvpmHrtHT8Z67M/sa914BrSLfl98TgKwsT
	 nl0jmTU7QI500XfHReYcZlsF1WF7PXPtHDuDRH29UAgpKvPiFg4feHRcsuYusW1Wel
	 B9AKy5D2RU+JYNjzCNthWnVbDmRnJcwhOElFOalU=
Date: Tue, 05 Nov 2024 17:09:28 -0800
To: mm-commits@vger.kernel.org,yanzhen@vivo.com,yang.lee@linux.alibaba.com,rppt@kernel.org,osalvador@suse.de,mtodorovac69@gmail.com,jakobkoschel@gmail.com,h.j.bos@vu.nl,hbathini@linux.ibm.com,david@redhat.com,c.giuffrida@vu.nl,bjohannesmeyer@gmail.com,bhe@redhat.com,agordeev@linux.ibm.com,adobriyan@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fs-proc-kcorec-fix-coccinelle-reported-error-instances-fix.patch removed from -mm tree
Message-Id: <20241106010928.8CA9DC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs-proc-kcorec-fix-coccinelle-reported-error-instances-fix
has been removed from the -mm tree.  Its filename was
     fs-proc-kcorec-fix-coccinelle-reported-error-instances-fix.patch

This patch was dropped because it was folded into fs-proc-kcorec-fix-coccinelle-reported-error-instances.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-proc-kcorec-fix-coccinelle-reported-error-instances-fix
Date: Tue Oct 29 06:25:57 PM PDT 2024

s/tmp/pos/

Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: "Bos, H.J." <h.j.bos@vu.nl>
Cc: "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>
Cc: Cristiano Giuffrida <c.giuffrida@vu.nl>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Jakob Koschel <jakobkoschel@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Mirsad Todorovac <mtodorovac69@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Cc: Yan Zhen <yanzhen@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/proc/kcore.c~fs-proc-kcorec-fix-coccinelle-reported-error-instances-fix
+++ a/fs/proc/kcore.c
@@ -493,13 +493,13 @@ static ssize_t read_kcore_iter(struct ki
 		 * the previous entry, search for a matching entry.
 		 */
 		if (!m || start < m->addr || start >= m->addr + m->size) {
-			struct kcore_list *tmp;
+			struct kcore_list *pos;
 
 			m = NULL;
-			list_for_each_entry(tmp, &kclist_head, list) {
-				if (start >= tmp->addr &&
-				    start < tmp->addr + tmp->size) {
-					m = tmp;
+			list_for_each_entry(pos, &kclist_head, list) {
+				if (start >= pos->addr &&
+				    start < pos->addr + pos->size) {
+					m = pos;
 					break;
 				}
 			}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-keep-track-of-free-highatomic-fix.patch
mm-fix-__wp_page_copy_user-fallback-path-for-remote-mm-fix.patch
bootmem-stop-using-page-index-fix.patch
vma-detect-infinite-loop-in-vma-tree-fix.patch
maple_tree-add-a-test-checking-storing-null-fix.patch
fs-proc-kcorec-fix-coccinelle-reported-error-instances.patch

