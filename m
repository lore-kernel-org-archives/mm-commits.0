Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EEEA17BA2;
	Thu,  6 Jun 2024 02:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717640415; cv=none; b=JoDDFC06T2k0f3i2zh7xaqrKj7llKjCtUatLdEp8EfZitdKyhZdDDGZbOT8JBwkbGC8smBr4K3wSiHWMdulRJDO+kBaYSntZZrebKvJtLuiiq1YHZG/he9cvKjAmvE8kP+FSEXkIl5p96bgIBYI905rOk6ZGb2sBIjOkxDacqMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717640415; c=relaxed/simple;
	bh=koJqcnepCHnoj74e5IkOSn/TRBUuM6AU/U7p02qbm0M=;
	h=Date:To:From:Subject:Message-Id; b=fqBS6wDTwiNczpKLZZAm5vLLNPYJUgVU8asqupMq/xMjdUpfB9ODeu8d+OjCWg1L3ypEbVmHXSh8ZEfpCcwGDuCE8xqeM+mBq7uYra/LrjlTrs+D2nIPcu76Vrayju8TpU52Rybl/DGUxPvo/wf/765Tee34E/VvMFrRg5SneDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z7xKPq9e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z7xKPq9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B72C4AF16;
	Thu,  6 Jun 2024 02:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717640415;
	bh=koJqcnepCHnoj74e5IkOSn/TRBUuM6AU/U7p02qbm0M=;
	h=Date:To:From:Subject:From;
	b=Z7xKPq9egFhI7YcItMnHZuv93Y+X6rL1opqd2sXCTIHy9QbS/hqx8KJ2HF/0SfvRU
	 H97XqeU4Osl789/SEaXGPfU3vPfm91riPSUm9AV4C6Ikepyy2HdlHAHR6mwV0+XPru
	 lPsjuJo+WV+5ldJo+nMFbKhXwGUtLIn+ksjEkSos=
Date: Wed, 05 Jun 2024 19:20:14 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,stable@vger.kernel.org,shr@devkernel.io,ran.xiaokai@zte.com.cn,hughd@google.com,david@redhat.com,aarcange@redhat.com,chengming.zhou@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-ksm-fix-ksm_pages_scanned-accounting.patch removed from -mm tree
Message-Id: <20240606022014.E6B72C4AF16@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: fix ksm_pages_scanned accounting
has been removed from the -mm tree.  Its filename was
     mm-ksm-fix-ksm_pages_scanned-accounting.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chengming Zhou <chengming.zhou@linux.dev>
Subject: mm/ksm: fix ksm_pages_scanned accounting
Date: Tue, 28 May 2024 13:15:21 +0800

Patch series "mm/ksm: fix some accounting problems", v3.

We encountered some abnormal ksm_pages_scanned and ksm_zero_pages during
some random tests.

1. ksm_pages_scanned unchanged even ksmd scanning has progress.
2. ksm_zero_pages maybe -1 in some rare cases.


This patch (of 2):

During testing, I found ksm_pages_scanned is unchanged although the
scan_get_next_rmap_item() did return valid rmap_item that is not NULL.

The reason is the scan_get_next_rmap_item() will return NULL after a full
scan, so ksm_do_scan() just return without accounting of the
ksm_pages_scanned.

Fix it by just putting ksm_pages_scanned accounting in that loop, and it
will be accounted more timely if that loop would last for a long time.

Link: https://lkml.kernel.org/r/20240528-b4-ksm-counters-v3-0-34bb358fdc13@linux.dev
Link: https://lkml.kernel.org/r/20240528-b4-ksm-counters-v3-1-34bb358fdc13@linux.dev
Fixes: b348b5fe2b5f ("mm/ksm: add pages scanned metric")
Signed-off-by: Chengming Zhou <chengming.zhou@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: xu xin <xu.xin16@zte.com.cn>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Cc: Stefan Roesch <shr@devkernel.io>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/ksm.c~mm-ksm-fix-ksm_pages_scanned-accounting
+++ a/mm/ksm.c
@@ -2754,18 +2754,16 @@ static void ksm_do_scan(unsigned int sca
 {
 	struct ksm_rmap_item *rmap_item;
 	struct page *page;
-	unsigned int npages = scan_npages;
 
-	while (npages-- && likely(!freezing(current))) {
+	while (scan_npages-- && likely(!freezing(current))) {
 		cond_resched();
 		rmap_item = scan_get_next_rmap_item(&page);
 		if (!rmap_item)
 			return;
 		cmp_and_merge_page(page, rmap_item);
 		put_page(page);
+		ksm_pages_scanned++;
 	}
-
-	ksm_pages_scanned += scan_npages - npages;
 }
 
 static int ksmd_should_run(void)
_

Patches currently in -mm which might be from chengming.zhou@linux.dev are


