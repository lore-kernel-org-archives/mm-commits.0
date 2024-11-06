Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127571862BB
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855677; cv=none; b=qEp+FNU5BG37UXbB6JFhCuCWqPFcjf59Gj+h8IR40rUeHRbfPe+JbeqJoia5LzAqY3bR2No8T+bKwFK2lf4KAWTexMez39kR9nw3vMy++5vL82j0vz/8yJ5AcnGpym3fBcAt/aFtQQF++4IAjeUzDAfnBSGTf3txl3HCYe3n80w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855677; c=relaxed/simple;
	bh=pRMAP7Z4OA6PZNSCtdge7m2iMcQI2jeTtv4GZPe5rlE=;
	h=Date:To:From:Subject:Message-Id; b=ReKeGtWwz0TBj29+SaIBVXzAPq4YoOXQRu1wEFSVIkK6cpKARxOz61rr6GRdiL7AmG5gT+PPjdfrlzHEZiJYF/U2MUIYaMPxpcDJb+zq70yIbn1+k1UOa8JkFIZ2T7RIiI5Rf6h/MTWhZtU7rWyfd+SkIFYOYo/oWKUdlsHOnlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VH5PUXFH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VH5PUXFH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4E7C4CECF;
	Wed,  6 Nov 2024 01:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855676;
	bh=pRMAP7Z4OA6PZNSCtdge7m2iMcQI2jeTtv4GZPe5rlE=;
	h=Date:To:From:Subject:From;
	b=VH5PUXFH/9mbNteNPstLct0jBePUlzJJW41VLzA7qbqQ21tbasniBnJhE28tkWlWT
	 kB11GB9x8DhZMfP/j7npORzBaWabF009F3WfynXhEI/m+E62tyt7fTHpQsfdNqo3Mp
	 ceBnD2kMoT5yM53w4AsSMF0vVse8SM/8Xj+XYqlw=
Date: Tue, 05 Nov 2024 17:14:36 -0800
To: mm-commits@vger.kernel.org,yanzhen@vivo.com,yang.lee@linux.alibaba.com,rppt@kernel.org,osalvador@suse.de,jakobkoschel@gmail.com,h.j.bos@vu.nl,hbathini@linux.ibm.com,david@redhat.com,c.giuffrida@vu.nl,bjohannesmeyer@gmail.com,bhe@redhat.com,akpm@linux-foundation.org,agordeev@linux.ibm.com,adobriyan@gmail.com,mtodorovac69@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-proc-kcorec-fix-coccinelle-reported-error-instances.patch removed from -mm tree
Message-Id: <20241106011436.DD4E7C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/kcore.c: fix coccinelle reported ERROR instances
has been removed from the -mm tree.  Its filename was
     fs-proc-kcorec-fix-coccinelle-reported-error-instances.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mirsad Todorovac <mtodorovac69@gmail.com>
Subject: fs/proc/kcore.c: fix coccinelle reported ERROR instances
Date: Tue, 29 Oct 2024 06:46:52 +0100

Coccinelle complains about the nested reuse of the pointer `iter' with
different pointer type:

./fs/proc/kcore.c:515:26-30: ERROR: invalid reference to the index variable of the iterator on line 499
./fs/proc/kcore.c:534:23-27: ERROR: invalid reference to the index variable of the iterator on line 499
./fs/proc/kcore.c:550:40-44: ERROR: invalid reference to the index variable of the iterator on line 499
./fs/proc/kcore.c:568:27-31: ERROR: invalid reference to the index variable of the iterator on line 499
./fs/proc/kcore.c:581:28-32: ERROR: invalid reference to the index variable of the iterator on line 499
./fs/proc/kcore.c:599:27-31: ERROR: invalid reference to the index variable of the iterator on line 499
./fs/proc/kcore.c:607:38-42: ERROR: invalid reference to the index variable of the iterator on line 499
./fs/proc/kcore.c:614:26-30: ERROR: invalid reference to the index variable of the iterator on line 499

Replacing `struct kcore_list *iter' with `struct kcore_list *tmp' doesn't change the
scope and the functionality is the same and coccinelle seems happy.

NOTE: There was an issue with using `struct kcore_list *pos' as the nested iterator.
      The build did not work!

[akpm@linux-foundation.org: s/tmp/pos/]
Link: https://lkml.kernel.org/r/20241029054651.86356-2-mtodorovac69@gmail.com
Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
Link: https://lkml.kernel.org/r/20220331223700.902556-1-jakobkoschel@gmail.com
Fixes: 04d168c6d42d ("fs/proc/kcore.c: remove check of list iterator against head past the loop body")
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
Signed-off-by: Mirsad Todorovac <mtodorovac69@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>
Cc: Cristiano Giuffrida <c.giuffrida@vu.nl>
Cc: "Bos, H.J." <h.j.bos@vu.nl>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Yan Zhen <yanzhen@vivo.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/proc/kcore.c~fs-proc-kcorec-fix-coccinelle-reported-error-instances
+++ a/fs/proc/kcore.c
@@ -493,13 +493,13 @@ static ssize_t read_kcore_iter(struct ki
 		 * the previous entry, search for a matching entry.
 		 */
 		if (!m || start < m->addr || start >= m->addr + m->size) {
-			struct kcore_list *iter;
+			struct kcore_list *pos;
 
 			m = NULL;
-			list_for_each_entry(iter, &kclist_head, list) {
-				if (start >= iter->addr &&
-				    start < iter->addr + iter->size) {
-					m = iter;
+			list_for_each_entry(pos, &kclist_head, list) {
+				if (start >= pos->addr &&
+				    start < pos->addr + pos->size) {
+					m = pos;
 					break;
 				}
 			}
_

Patches currently in -mm which might be from mtodorovac69@gmail.com are


