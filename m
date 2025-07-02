Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056D623BF91
	for <mm-commits@vger.kernel.org>; Wed,  2 Jul 2025 21:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751492255; cv=none; b=qUhbIvk5aS8JznWl5QfwjUXcKFOa/fyTESyvHYhX4oAbD6bwLXTV+ljgzYk3gmxn0m+yz0wkFssWvt4X02zB3dAkRVpTfT4VZvlwj3Tp4Kl+buaiVfseLaCKr0eyq+fLBmhos6CBUe2+vT6WVmPg8S61QpjAATWskwvlOY8yYUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751492255; c=relaxed/simple;
	bh=FhBEu5+HBzgkRt4yXWdFlHyctlTVF98InIMqErg7F+o=;
	h=Date:To:From:Subject:Message-Id; b=Dna1vGkfIq+rxvwFUZmSQHhmL+X7biKx732EFQ6xeBCbLQdvBNP2xcoQyobz3ftFk5xJEYipjKNGa/zKc5zHqKiRv1/e6AYyQmCuZaU0aBBpj/xPM3BZbbVZKNt3z1Nk+k29vCSlqsQACx4MW5IxV0BE/CtmMkUKjbUzw9ij1Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rasxc8Mn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rasxc8Mn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86442C4CEE7;
	Wed,  2 Jul 2025 21:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751492254;
	bh=FhBEu5+HBzgkRt4yXWdFlHyctlTVF98InIMqErg7F+o=;
	h=Date:To:From:Subject:From;
	b=rasxc8MnYcRMKEJ86gM3uJsOIGtmOPR+Ajftb7yx7K6ArdbPvU8UKsakhr9dL/vw+
	 nBqW3IFT374ldbWqdz07YhiBUTqCzOFL1QLJ6poy9iAcn+ax14bVDcc7w9v1HC9tr0
	 8dDdi+o8LzU2YAZkyIRx1Js8wrgBd5HLlq8zmVwg=
Date: Wed, 02 Jul 2025 14:37:33 -0700
To: mm-commits@vger.kernel.org,yebin10@huawei.com,willy@infradead.org,vbabka@suse.cz,tjmercier@google.com,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,peterx@redhat.com,paulmck@kernel.org,osalvador@suse.de,mhocko@kernel.org,lorenzo.stoakes@oracle.com,linux@weissschuh.net,liam.howlett@oracle.com,kaleshsingh@google.com,josef@toxicpanda.com,jannh@google.com,hannes@cmpxchg.org,david@redhat.com,christophe.leroy@csgroup.eu,brauner@kernel.org,andrii@kernel.org,adobriyan@gmail.com,aha310510@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-maps-execute-procmap_query-ioctl-under-per-vma-locks-fix.patch added to mm-unstable branch
Message-Id: <20250702213734.86442C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/maps: move kmalloc() call location in do_procmap_query() out of RCU critical section
has been added to the -mm mm-unstable branch.  Its filename is
     mm-maps-execute-procmap_query-ioctl-under-per-vma-locks-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-maps-execute-procmap_query-ioctl-under-per-vma-locks-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jeongjun Park <aha310510@gmail.com>
Subject: mm/maps: move kmalloc() call location in do_procmap_query() out of RCU critical section
Date: Wed, 2 Jul 2025 22:53:32 +0900

In do_procmap_query(), we are allocating name_buf as much as name_buf_sz
with kmalloc().

However, due to the previous commit eff061546ca5 ("mm/maps: execute
PROCMAP_QUERY ioctl under per-vma locks"), the location of kmalloc() is
located inside the RCU critical section.

This causes might_sleep_if() to be called inside the RCU critical section,
so we need to move the call location of kmalloc() outside the RCU critical
section to prevent this.

Link: https://lkml.kernel.org/r/20250702135332.291866-1-aha310510@gmail.com
Reported-by: syzbot+6246a83e7bd9f8a3e239@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6246a83e7bd9f8a3e239
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Cc: T.J. Mercier <tjmercier@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Ye Bin <yebin10@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/fs/proc/task_mmu.c~mm-maps-execute-procmap_query-ioctl-under-per-vma-locks-fix
+++ a/fs/proc/task_mmu.c
@@ -595,6 +595,7 @@ static int do_procmap_query(struct proc_
 	char build_id_buf[BUILD_ID_SIZE_MAX], *name_buf = NULL;
 	__u64 usize;
 	int err;
+	size_t name_buf_sz;
 
 	if (copy_from_user(&usize, (void __user *)uarg, sizeof(usize)))
 		return -EFAULT;
@@ -621,12 +622,18 @@ static int do_procmap_query(struct proc_
 	if (!mm || !mmget_not_zero(mm))
 		return -ESRCH;
 
-	err = query_vma_setup(priv);
-	if (err) {
+	name_buf_sz = min_t(size_t, PATH_MAX, karg.vma_name_size);
+
+	name_buf = kmalloc(name_buf_sz, GFP_KERNEL);
+	if (!name_buf) {
 		mmput(mm);
-		return err;
+		return -ENOMEM;
 	}
 
+	err = query_vma_setup(priv);
+	if (err)
+		goto fail_vma_setup;
+
 	vma = query_matching_vma(priv, karg.query_addr, karg.query_flags);
 	if (IS_ERR(vma)) {
 		err = PTR_ERR(vma);
@@ -679,20 +686,12 @@ static int do_procmap_query(struct proc_
 	}
 
 	if (karg.vma_name_size) {
-		size_t name_buf_sz = min_t(size_t, PATH_MAX, karg.vma_name_size);
 		const struct path *path;
 		const char *name_fmt;
 		size_t name_sz = 0;
 
 		get_vma_name(vma, &path, &name, &name_fmt);
 
-		if (path || name_fmt || name) {
-			name_buf = kmalloc(name_buf_sz, GFP_KERNEL);
-			if (!name_buf) {
-				err = -ENOMEM;
-				goto out;
-			}
-		}
 		if (path) {
 			name = d_path(path, name_buf, name_buf_sz);
 			if (IS_ERR(name)) {
@@ -733,6 +732,7 @@ static int do_procmap_query(struct proc_
 
 out:
 	query_vma_teardown(priv);
+fail_vma_setup:
 	mmput(mm);
 	kfree(name_buf);
 	return err;
_

Patches currently in -mm which might be from aha310510@gmail.com are

mm-maps-execute-procmap_query-ioctl-under-per-vma-locks-fix.patch

