Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17957144D3C
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291710; cv=none; b=Zd7AUM1sUFQt1/j4vkLQRs4V9ZE7S/GJQPgKkk/1/k4YQNoLT5cIXLNvTl/AuNgUZLyTsfbVJOzKq4No4b0DwlHpi8i33WdH1owHpza/oPq8uN4MyUh1z2XgnOKBkpRC2+bm2vvtlDPeynnNjNC+7DO7xoRMtt0G3fXaeYnZsVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291710; c=relaxed/simple;
	bh=9/td69T+nXsvdDTKaX0r/UJgkEcYH6Om1zFLBhcw5mk=;
	h=Date:To:From:Subject:Message-Id; b=qx48ZRgqKbO2zH5mClr7gXCWVz+tBhs2xQFo4GoCJp3O7S9NxOdGd45lpExZhc1QuvS3ef+YRbt7Idnms2t2BHw5noC6Fvrcn1IE95FZ57TWPmf1w1GdcPi6+PuEj7hKjW3Zz4z7hLhQzA0+thprHNBaL3xsoq1adzYVCEl/4+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XpyejTiU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XpyejTiU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29EDC4AF09;
	Tue, 25 Jun 2024 05:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291710;
	bh=9/td69T+nXsvdDTKaX0r/UJgkEcYH6Om1zFLBhcw5mk=;
	h=Date:To:From:Subject:From;
	b=XpyejTiU88qwSY3VnPAGrRqDhUGTa0D7ciZ8906kgJJcU+HAhOhXzpiIigKu5ejiu
	 O1qZRtMm4iid8Q1V1z7fEOnLRikIIW4ZbMUpL7C05jZekGqd8yCn2AV2nuw7/nhkDA
	 CajPpiQWeITahp4wl8FysgB2LP6CVT5xoUqcmcGI=
Date: Mon, 24 Jun 2024 22:01:49 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,lkp@intel.com,david@redhat.com,bp@alien8.de,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-remove-unneeded-empty-string.patch removed from -mm tree
Message-Id: <20240625050149.E29EDC4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: remove unneeded empty string
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-remove-unneeded-empty-string.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure: remove unneeded empty string
Date: Wed, 12 Jun 2024 15:18:27 +0800

Remove unneeded empty string in definition of macro pr_fmt.  No functional
change intended.

Link: https://lkml.kernel.org/r/20240612071835.157004-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory-failure-remove-unneeded-empty-string
+++ a/mm/memory-failure.c
@@ -2518,7 +2518,7 @@ static int __init memory_failure_init(vo
 core_initcall(memory_failure_init);
 
 #undef pr_fmt
-#define pr_fmt(fmt)	"" fmt
+#define pr_fmt(fmt)	fmt
 #define unpoison_pr_info(fmt, pfn, rs)			\
 ({							\
 	if (__ratelimit(rs))				\
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


