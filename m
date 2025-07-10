Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926D2286D60
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127184; cv=none; b=KtLzTFWe2xVgCcZzouIgylYMmaXjay80HUVnHf42frG/88ZKQK71QrZrL2t8mMV1LteaOPr6HosCueTUY0L2xc9kO1maTCDi1jqnQG3P2Xn7oxghBN28FVnHm2vCGJlCSsSv8R9RskPzUX36b0w0bhn7AL0tLp3MtJx2vM+pkyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127184; c=relaxed/simple;
	bh=S/JlG4JVuyVXUT1n95e04TyDxzPO0Wqam7odTA4hTVc=;
	h=Date:To:From:Subject:Message-Id; b=SnTk/BucZJ77+2UJpjqYurfVNZegjdGgagvq5uQ131rgWOsHkWbxT06aKoq7ZgqT8SbPjm4y/elqN/f1UyAi9/e/FqU5fVZpTwn/iQS62Lmpkauwhis8xTBvnoEiK7I1BM+4Ivt8W8UdmlJTN/AXe+muTo1BTuDVWN5/rV/5C7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RODx9hsL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RODx9hsL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DBDC4CEE3;
	Thu, 10 Jul 2025 05:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752127184;
	bh=S/JlG4JVuyVXUT1n95e04TyDxzPO0Wqam7odTA4hTVc=;
	h=Date:To:From:Subject:From;
	b=RODx9hsLv2/i/KfsZ+wsRDAd6t8JDBllBQlObhR2QJGPsu6nGxyf5A0hYWOh+BJN0
	 FrlmM156KMgJbPvCWRu7Db/KiDnvIFWU/H70OgCw/yPTUHqq4Vh9XvYvSEXb6ky09x
	 YvcWGC11NlOOu/DV5czH0ORDbgUH+ospIGtWFaO4=
Date: Wed, 09 Jul 2025 22:59:43 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,dyoung@redhat.com,dan.carpenter@linaro.org,bhe@redhat.com,suhui@nfschina.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-proc-vmcore-a-few-cleanups-for-vmcore_add_device_dump.patch removed from -mm tree
Message-Id: <20250710055944.64DBDC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/vmcore: a few cleanups for vmcore_add_device_dump()
has been removed from the -mm tree.  Its filename was
     fs-proc-vmcore-a-few-cleanups-for-vmcore_add_device_dump.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Su Hui <suhui@nfschina.com>
Subject: fs/proc/vmcore: a few cleanups for vmcore_add_device_dump()
Date: Thu, 26 Jun 2025 18:54:41 +0800

There are two cleanups for vmcore_add_device_dump().  Return -ENOMEM
directly rather than goto the label to simplify the code and use
scoped_guard() to simplify the lock/unlock code.

Link: https://lkml.kernel.org/r/20250626105440.1053139-1-suhui@nfschina.com
Signed-off-by: Su Hui <suhui@nfschina.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Suhui <suhui@nfschina.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

--- a/fs/proc/vmcore.c~fs-proc-vmcore-a-few-cleanups-for-vmcore_add_device_dump
+++ a/fs/proc/vmcore.c
@@ -1490,10 +1490,8 @@ int vmcore_add_device_dump(struct vmcore
 		return -EINVAL;
 
 	dump = vzalloc(sizeof(*dump));
-	if (!dump) {
-		ret = -ENOMEM;
-		goto out_err;
-	}
+	if (!dump)
+		return -ENOMEM;
 
 	/* Keep size of the buffer page aligned so that it can be mmaped */
 	data_size = roundup(sizeof(struct vmcoredd_header) + data->size,
@@ -1519,22 +1517,19 @@ int vmcore_add_device_dump(struct vmcore
 	dump->size = data_size;
 
 	/* Add the dump to driver sysfs list and update the elfcore hdr */
-	mutex_lock(&vmcore_mutex);
-	if (vmcore_opened)
-		pr_warn_once("Unexpected adding of device dump\n");
-	if (vmcore_open) {
-		ret = -EBUSY;
-		goto unlock;
-	}
+	scoped_guard(mutex, &vmcore_mutex) {
+		if (vmcore_opened)
+			pr_warn_once("Unexpected adding of device dump\n");
+		if (vmcore_open) {
+			ret = -EBUSY;
+			goto out_err;
+		}
 
-	list_add_tail(&dump->list, &vmcoredd_list);
-	vmcoredd_update_size(data_size);
-	mutex_unlock(&vmcore_mutex);
+		list_add_tail(&dump->list, &vmcoredd_list);
+		vmcoredd_update_size(data_size);
+	}
 	return 0;
 
-unlock:
-	mutex_unlock(&vmcore_mutex);
-
 out_err:
 	vfree(buf);
 	vfree(dump);
_

Patches currently in -mm which might be from suhui@nfschina.com are


