Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260191C0DCC
	for <mm-commits@vger.kernel.org>; Wed, 29 May 2024 19:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717009564; cv=none; b=E0rv7pSMXo3JUHh4BtqeOv0L3gF+3XnEE6Jz2ssW4ET0j/Ct4N0AWdq0c2ziqCtd8r+2233dtoi0HrjpK5eHYuPstQblFK4xgJHSGWSZ1oDA4jJFFV8OPtWtNmNMmbvle3g92PYLi+VR5CR9R1OMU8ud4fy5KEsntkHYEPvybXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717009564; c=relaxed/simple;
	bh=A3Y94Hj2VENXRsIs/+9DBykW0JeS3a8d3NwykhFgQa4=;
	h=Date:To:From:Subject:Message-Id; b=M9L1yClZk/WRXrDtOLUOyWuqJrT27vkg9W6AzShqrBxwbvYgKDmMqI2UDL6vfijGN2ep8pyHitwMN7hrv1cyYzyOoL2IwI0HOvRh2G5RSSuOSSieDPZCUKrQhBiWVQ3vIxZDXciSbcNb3uioTGr+TdFpU47ckLstFIaBU0lIvIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fqw141gk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fqw141gk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39D8C113CC;
	Wed, 29 May 2024 19:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717009563;
	bh=A3Y94Hj2VENXRsIs/+9DBykW0JeS3a8d3NwykhFgQa4=;
	h=Date:To:From:Subject:From;
	b=fqw141gkF2f8lX7sNwQbnL8Prvqe7iHsHAB/18YfHCej9xcM8YS4vlYBaivkE325C
	 A2YiE10tz+/5NzZal7PkySdZ+ndrEZ6KFSUDLWPhtLG8R4h/vRkYcrOYbZ6aVFr/0Q
	 6WNJ5oz+vg2KYqFQQUS3LR/YVDCLdKSMvYdWE34E=
Date: Wed, 29 May 2024 12:06:02 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,senozhatsky@chromium.org,rppt@kernel.org,minchan@kernel.org,david@redhat.com,42.hyeyoo@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type-fix.patch added to mm-unstable branch
Message-Id: <20240529190603.A39D8C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type-fix
Date: Wed May 29 12:04:52 PM PDT 2024

fix PG_hugetlb typo, per David

Cc: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/page-flags.h~mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type-fix
+++ a/include/linux/page-flags.h
@@ -955,7 +955,7 @@ PAGEFLAG_FALSE(HasHWPoisoned, has_hwpois
 #define PG_offline	0x20000000
 #define PG_table	0x10000000
 #define PG_guard	0x08000000
-#define PG_hugetlb	0x04008000
+#define PG_hugetlb	0x04000000
 #define PG_slab		0x02000000
 #define PAGE_MAPCOUNT_RESERVE	(~0x0000ffff)
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type-fix.patch

