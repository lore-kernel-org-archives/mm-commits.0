Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2199034D92D
	for <mm-commits@vger.kernel.org>; Tue, 21 Oct 2025 18:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761072987; cv=none; b=Tm+Q6F0A1pQ/DygUQVPVM7Zzgpx5+Q55c3N+7liZQjtJCnjTXL6NFYfR+MCI5RN4vgCMco9hCYJ3yVWB6bwEwTc1UuKuYP64VCn1OFJ1snJ5dDE0p31A6tmNUIdrKnaqKRKI1sSozWgDFV++d6PslTJsG7C+esMHkmXWuIMiKP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761072987; c=relaxed/simple;
	bh=bA0N6vOMXgcLST7rq2S2rusgpuUvzwCsjh6OaG4D2gI=;
	h=Date:To:From:Subject:Message-Id; b=Qj6PHzXyBiQPp3fj2W9GJ4Pez1KSgVvVUapo5ps0Wrpp/JCHlo5cvtT+5r6/1XM6Fm7rbOCT0yg0Hu84dZIcSdB4ooIUCAKoLsyHfLkdUCkZRkysxQdtPw9t+WaCCw7gxgqxrjT078S3jLQNXR9XhsRgHe8jda+/k6azwrzVQSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NdmtpEE+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NdmtpEE+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85ECFC4CEF1;
	Tue, 21 Oct 2025 18:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761072986;
	bh=bA0N6vOMXgcLST7rq2S2rusgpuUvzwCsjh6OaG4D2gI=;
	h=Date:To:From:Subject:From;
	b=NdmtpEE+U16fZ4D+zolEhmED1qZ0EQghutoqN7J2nQZGBDLM3PI+mlz00PQn4Y5Ap
	 8qEvDn/jphohnXKDSvzEETFIEMt/0fP0M/B4j4tR3b1PbrvexLQeSG46WzKLi9A0kk
	 GJfrzdN3xiph9dwMcfGDcJ1jJfaLMvmoX0LsJlXs=
Date: Tue, 21 Oct 2025 11:56:26 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,leon.hwang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-factor-out-common-logic-in-_sleep_millisecs_store.patch added to mm-new branch
Message-Id: <20251021185626.85ECFC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: factor out common logic in [scan,alloc]_sleep_millisecs_store()
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-factor-out-common-logic-in-_sleep_millisecs_store.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-factor-out-common-logic-in-_sleep_millisecs_store.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
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

mm-khugepaged-factor-out-common-logic-in-_sleep_millisecs_store.patch

