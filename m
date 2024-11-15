Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B6418870B;
	Fri, 15 Nov 2024 06:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653069; cv=none; b=fcwWatKawRSkBRGs2cSQv3TxHkOMMmBcsTOdwkSfwzMdolwRQnJWxjUkgoOEXdyk0fVovQxKragFdQ1hTBhgb/yR4ENBPQTh1fDWP02JJcjcAoEZgLlgLlpoajfjyyf7mhwD0EssDgSEdDiNjZKYSluu/tCxEBz4+YynqH2IOa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653069; c=relaxed/simple;
	bh=YssBCgzRINyCv0Zx4Vcsm+bAmx7GOtdCJT7XEG6l8hs=;
	h=Date:To:From:Subject:Message-Id; b=bG4w2eICAESqw+zqk9rOq7dcyhBkeaUgE2MtGtLVcvz/PAMlbdMiRljIcL6hkVd+OZsrgdyuZPzz+6ZkYfjqDvfYUmVRaRmUGpLtbHuv+wreSGyy7Y2oE8cPXJKbsvEVbIw0eLmah+VG//m46hYCb89Rg8WkSCZBIGhpsPxAsHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KqQPsrnv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KqQPsrnv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F82C4CED2;
	Fri, 15 Nov 2024 06:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731653069;
	bh=YssBCgzRINyCv0Zx4Vcsm+bAmx7GOtdCJT7XEG6l8hs=;
	h=Date:To:From:Subject:From;
	b=KqQPsrnvZzYHVXbl7HjKTsUhR4Iga29IqNyAImhk1uSTdqsRJlu9I3mHtmpXNWkws
	 ob45WL1bDAZS1+kuHEqRDoN+Zce2Czx6dJBg2syxdapYBvAaTyzKAH0KnMNcJV/u6f
	 ug99FbZr35fa21iFT+wPSEoC2JBPsaFcBkVNTlNM=
Date: Thu, 14 Nov 2024 22:44:25 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,usama.anjum@collabora.com,stable@vger.kernel.org,ryan.roberts@arm.com,peterx@redhat.com,osalvador@suse.de,mirq-linux@rere.qmqm.pl,david@redhat.com,avagin@google.com,arnd@arndb.de,andrii@kernel.org,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] fs-proc-task_mmu-prevent-integer-overflow-in-pagemap_scan_get_args.patch removed from -mm tree
Message-Id: <20241115064428.F3F82C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/task_mmu: prevent integer overflow in pagemap_scan_get_args()
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-prevent-integer-overflow-in-pagemap_scan_get_args.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: fs/proc/task_mmu: prevent integer overflow in pagemap_scan_get_args()
Date: Thu, 14 Nov 2024 11:59:32 +0300

The "arg->vec_len" variable is a u64 that comes from the user at the start
of the function.  The "arg->vec_len * sizeof(struct page_region))"
multiplication can lead to integer wrapping.  Use size_mul() to avoid
that.

Also the size_add/mul() functions work on unsigned long so for 32bit
systems we need to ensure that "arg->vec_len" fits in an unsigned long.

Link: https://lkml.kernel.org/r/39d41335-dd4d-48ed-8a7f-402c57d8ea84@stanley.mountain
Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Andrei Vagin <avagin@google.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-prevent-integer-overflow-in-pagemap_scan_get_args
+++ a/fs/proc/task_mmu.c
@@ -2665,8 +2665,10 @@ static int pagemap_scan_get_args(struct
 		return -EFAULT;
 	if (!arg->vec && arg->vec_len)
 		return -EINVAL;
+	if (UINT_MAX == SIZE_MAX && arg->vec_len > SIZE_MAX)
+		return -EINVAL;
 	if (arg->vec && !access_ok((void __user *)(long)arg->vec,
-			      arg->vec_len * sizeof(struct page_region)))
+				   size_mul(arg->vec_len, sizeof(struct page_region))))
 		return -EFAULT;
 
 	/* Fixup default values */
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are


