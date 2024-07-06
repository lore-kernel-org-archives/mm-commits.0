Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACAE4C3D0
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720292033; cv=none; b=OV23GP8s0Oy3ZA4rtjYPKyA6zciN5kNWAojQjKT4TCDtdcrEtpQmOLjwVQ++OlQ4JKjZcUYqtsT+/hcShxJRvRkR8UbVooLxRMzloQZlfsJsHFepBoANfgonAJbAVSPof74ib55TcYr+FGnfZGtqn8djR6Fq/NOBUZh8Zn6BX/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720292033; c=relaxed/simple;
	bh=zhtjNLIQdetPI+UUx+ShRi3NxvmMcteES5cwG9yRKmI=;
	h=Date:To:From:Subject:Message-Id; b=dd1iT8qVDTA+0M1nEnmUV9+0UIS1lnT10XV6UOkNvoyOGVi57fMukZIykYySX1JhAD4VdPUEMqOyyXhYRb1hLaPIFPJ/43VNXo5gthhz8r5U6STzwzpw7BmVywA5lYnvx6UpWbRDZ+jYAMQRWs8R8F6SgNJy6jgiBQeNDRXlEgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZPTzjAMw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZPTzjAMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90AFC32781;
	Sat,  6 Jul 2024 18:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720292032;
	bh=zhtjNLIQdetPI+UUx+ShRi3NxvmMcteES5cwG9yRKmI=;
	h=Date:To:From:Subject:From;
	b=ZPTzjAMwMHOeeBy5KMNLmAi0CuKZqiVcDI+JDpg8l0YWrJZLsDzFHOTb7NjyVzpMP
	 S7eoVTK7y/GGWm2jmpcWJ5cey8tXFa3Wa4T88EO4QQ3D0AW0lPe2l+6v/E0XPVDDNn
	 Pz0zuPF4XfLbbAW6xSSWs0hFgpPnMd3HylOgk2Gw=
Date: Sat, 06 Jul 2024 11:53:52 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,tony.luck@intel.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jiaqiyan@google.com,jglisse@redhat.com,jane.chu@oracle.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,bcrl@kvack.org,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-hugetlbfs-support-poisoned-recover-from-hugetlbfs_migrate_folio.patch removed from -mm tree
Message-Id: <20240706185352.A90AFC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs: hugetlbfs: support poisoned recover from hugetlbfs_migrate_folio()
has been removed from the -mm tree.  Its filename was
     fs-hugetlbfs-support-poisoned-recover-from-hugetlbfs_migrate_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: fs: hugetlbfs: support poisoned recover from hugetlbfs_migrate_folio()
Date: Wed, 26 Jun 2024 16:53:27 +0800

This is similar to __migrate_folio(), use folio_mc_copy() in HugeTLB folio
migration to avoid panic when copy from poisoned folio.

Link: https://lkml.kernel.org/r/20240626085328.608006-6-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 mm/migrate.c         |   10 ++++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/fs/hugetlbfs/inode.c~fs-hugetlbfs-support-poisoned-recover-from-hugetlbfs_migrate_folio
+++ a/fs/hugetlbfs/inode.c
@@ -1128,7 +1128,7 @@ static int hugetlbfs_migrate_folio(struc
 		hugetlb_set_folio_subpool(src, NULL);
 	}
 
-	folio_migrate_copy(dst, src);
+	folio_migrate_flags(dst, src);
 
 	return MIGRATEPAGE_SUCCESS;
 }
--- a/mm/migrate.c~fs-hugetlbfs-support-poisoned-recover-from-hugetlbfs_migrate_folio
+++ a/mm/migrate.c
@@ -550,10 +550,16 @@ int migrate_huge_page_move_mapping(struc
 				   struct folio *dst, struct folio *src)
 {
 	XA_STATE(xas, &mapping->i_pages, folio_index(src));
-	int expected_count;
+	int rc, expected_count = folio_expected_refs(mapping, src);
+
+	if (folio_ref_count(src) != expected_count)
+		return -EAGAIN;
+
+	rc = folio_mc_copy(dst, src);
+	if (unlikely(rc))
+		return rc;
 
 	xas_lock_irq(&xas);
-	expected_count = folio_expected_refs(mapping, src);
 	if (!folio_ref_freeze(src, expected_count)) {
 		xas_unlock_irq(&xas);
 		return -EAGAIN;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


