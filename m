Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891A9227599
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343206; cv=none; b=Jp35sWtWbL7jEF/OC8d0qfm5DeehZ2w4hmhcg6lA0Ig0iNPxin5sGlicFe4y+USEaTuRKHSuwIsr9U7ewfhfdxT1Ae4Adqa4o6eQlMNPtetxDweyw8BFLM54OHTRqxLMlQYPUZTNg5gKfPT5r73G0txRa6d4bYeboHKkF/91PrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343206; c=relaxed/simple;
	bh=+MpBwpph1MHc/xmqX/E3eybnO/o3ENJjXTNMoBBehfQ=;
	h=Date:To:From:Subject:Message-Id; b=C/VoFgR2RwdMuCdnUjKvjYbqHGuyVkYpwfLnQhX9iwXFHsY0zbu87tdG6xMzGcrmuvxSfh/SAawfhw06hBGdSQpVgwFkzNihuDv55x6WBf8j53RWtZpOxxh360nhVQlLBuJVSyWrbM8w0W5AOxNIa49J15tmmoxKnAJ5lWrzjFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GGprKEWX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GGprKEWX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57782C116D0;
	Mon, 17 Nov 2025 01:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343206;
	bh=+MpBwpph1MHc/xmqX/E3eybnO/o3ENJjXTNMoBBehfQ=;
	h=Date:To:From:Subject:From;
	b=GGprKEWXt26j4CP5Zx5IN79UzyOLBICoe4gmJYEMyeEPK5aVqz2NSASTV2Ec2pVmk
	 PlSf8i5pJ7fMMLr1uRsfOI8d8Ofyy6cNwmG+JxYevJJyF3lW+yQgruQSqXyldflnqD
	 xvSE7cl40351k8LUtgKY4L4aGthpITHOcGw2H0Fs=
Date: Sun, 16 Nov 2025 17:33:25 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,sj@kernel.org,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,leon.hwang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-factor-out-common-logic-in-_sleep_millisecs_store.patch removed from -mm tree
Message-Id: <20251117013326.57782C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: factor out common logic in [scan,alloc]_sleep_millisecs_store()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-factor-out-common-logic-in-_sleep_millisecs_store.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Leon Hwang <leon.hwang@linux.dev>
Subject: mm/khugepaged: factor out common logic in [scan,alloc]_sleep_millisecs_store()
Date: Tue, 21 Oct 2025 21:44:31 +0800

Both scan_sleep_millisecs_store() and alloc_sleep_millisecs_store()
perform the same operations: parse the input value, update their
respective sleep interval, reset khugepaged_sleep_expire, and wake up the
khugepaged thread.

Factor out this duplicated logic into a helper function
__sleep_millisecs_store(), and simplify both store functions.

No functional change intended.

Link: https://lkml.kernel.org/r/20251021134431.26488-1-leon.hwang@linux.dev
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Nico Pache <npache@redhat.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-factor-out-common-logic-in-_sleep_millisecs_store
+++ a/mm/khugepaged.c
@@ -129,9 +129,8 @@ static ssize_t scan_sleep_millisecs_show
 	return sysfs_emit(buf, "%u\n", khugepaged_scan_sleep_millisecs);
 }
 
-static ssize_t scan_sleep_millisecs_store(struct kobject *kobj,
-					  struct kobj_attribute *attr,
-					  const char *buf, size_t count)
+static ssize_t __sleep_millisecs_store(const char *buf, size_t count,
+				       unsigned int *millisecs)
 {
 	unsigned int msecs;
 	int err;
@@ -140,12 +139,19 @@ static ssize_t scan_sleep_millisecs_stor
 	if (err)
 		return -EINVAL;
 
-	khugepaged_scan_sleep_millisecs = msecs;
+	*millisecs = msecs;
 	khugepaged_sleep_expire = 0;
 	wake_up_interruptible(&khugepaged_wait);
 
 	return count;
 }
+
+static ssize_t scan_sleep_millisecs_store(struct kobject *kobj,
+					  struct kobj_attribute *attr,
+					  const char *buf, size_t count)
+{
+	return __sleep_millisecs_store(buf, count, &khugepaged_scan_sleep_millisecs);
+}
 static struct kobj_attribute scan_sleep_millisecs_attr =
 	__ATTR_RW(scan_sleep_millisecs);
 
@@ -160,18 +166,7 @@ static ssize_t alloc_sleep_millisecs_sto
 					   struct kobj_attribute *attr,
 					   const char *buf, size_t count)
 {
-	unsigned int msecs;
-	int err;
-
-	err = kstrtouint(buf, 10, &msecs);
-	if (err)
-		return -EINVAL;
-
-	khugepaged_alloc_sleep_millisecs = msecs;
-	khugepaged_sleep_expire = 0;
-	wake_up_interruptible(&khugepaged_wait);
-
-	return count;
+	return __sleep_millisecs_store(buf, count, &khugepaged_alloc_sleep_millisecs);
 }
 static struct kobj_attribute alloc_sleep_millisecs_attr =
 	__ATTR_RW(alloc_sleep_millisecs);
_

Patches currently in -mm which might be from leon.hwang@linux.dev are


