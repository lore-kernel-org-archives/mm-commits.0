Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA9A80C16
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104161; cv=none; b=fF26Pr1nu9Wo9JMm/HaiWUdsNPRM4FwjQjy0CKn76M4WBQHFkZxeyA7NoyQgdDr76icdf/3UhphDU/6S9NHG6mLkI1CNg4S7I6ddryKT4TFgn4uhpl3DRAVLC/TAQJGE1WRhREzbvmhMlM9esJ4+B2YgBKmsUbPMkx/+SiybNUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104161; c=relaxed/simple;
	bh=BPqiVPB++SiYjbIjOkSex7IL0kVgcrDLVv0ObFUhisw=;
	h=Date:To:From:Subject:Message-Id; b=HzWZvdG+L3caLwBYnyZ4dsHc5dME8PIdtMLaBE7cG8KnxGMz4NVdonT72lGBkaa9rZDERMgb1Fy6Quz2J2/+wdlKnC42yuZJlzswSRSdUyA4oy1MiKI8lj206GO242HDf6dL+x97CIdcNNleeXeNC/fIAiTcEWiWgmb0dy1HIkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WUhUfmAQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WUhUfmAQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D164FC116B1;
	Fri, 26 Apr 2024 04:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104160;
	bh=BPqiVPB++SiYjbIjOkSex7IL0kVgcrDLVv0ObFUhisw=;
	h=Date:To:From:Subject:From;
	b=WUhUfmAQ41CyOyEOIDkKP1Q9nLqo5VmB0lSG0vYVw+4tIKKs51eJzd0z3lp/N1BYN
	 6oLuGLkqM3cw2v+bHFQ/HCEHMmLkJxU0eaMmCDKGTdpF14IK9lzaRHpJqje+V4ikbf
	 mR7+2+DqMef3ZHakpWVu6FVaBnDfCaR6OfgsENYA=
Date: Thu, 25 Apr 2024 21:02:40 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,sunnanyong@huawei.com,shr@devkernel.io,riel@surriel.com,hannes@cmpxchg.org,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-remove-redundant-code-in-ksm_fork.patch removed from -mm tree
Message-Id: <20240426040240.D164FC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: remove redundant code in ksm_fork
has been removed from the -mm tree.  Its filename was
     mm-ksm-remove-redundant-code-in-ksm_fork.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm/ksm: remove redundant code in ksm_fork
Date: Tue, 2 Apr 2024 10:49:34 +0800

Since commit 3c6f33b7273a ("mm/ksm: support fork/exec for prctl"), when a
child process is forked, the MMF_VM_MERGE_ANY flag will be inherited in
mm_init(). So, it's unnecessary to set the flag in ksm_fork().

Link: https://lkml.kernel.org/r/20240402024934.1093361-1-tujinjiang@huawei.com
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ksm.h |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/include/linux/ksm.h~mm-ksm-remove-redundant-code-in-ksm_fork
+++ a/include/linux/ksm.h
@@ -45,16 +45,8 @@ static inline void ksm_might_unmap_zero_
 
 static inline int ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
-	int ret;
-
-	if (test_bit(MMF_VM_MERGEABLE, &oldmm->flags)) {
-		ret = __ksm_enter(mm);
-		if (ret)
-			return ret;
-	}
-
-	if (test_bit(MMF_VM_MERGE_ANY, &oldmm->flags))
-		set_bit(MMF_VM_MERGE_ANY, &mm->flags);
+	if (test_bit(MMF_VM_MERGEABLE, &oldmm->flags))
+		return __ksm_enter(mm);
 
 	return 0;
 }
_

Patches currently in -mm which might be from tujinjiang@huawei.com are


