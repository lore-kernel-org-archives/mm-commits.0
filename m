Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09184C3D0
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720292028; cv=none; b=dTSIcoci4/Egspk8kg/ZZDu9YE/PvQlnCAA8KjyrDeK9rPRm+1WRGx1kpDzj4SpQa6l+lZyrAcbpo/S2DzIk/VeB4TR2BC8liyKjMwIyHCtdYK/pdlkKIJN10xGM2o6r9PhXVMzNHVhaCI5HZF4aUHlx5gsx428lULIYGVipnS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720292028; c=relaxed/simple;
	bh=+Hq73XRDkbEynxbyoYiKW3hQYmli4js4Ot15oaOtaNg=;
	h=Date:To:From:Subject:Message-Id; b=l69Msw9nd72u4NkS51neh0CpucPBdVbZvHwcpYcVC5aX2hNQ+K+Pr7JogB2L6QCr1gEBjohx9zb11q0ySgDAylTmCZ+49gak1S4u41qC7LM9BnLrfNCdWsQnYx4T4VSFEvgy4fmhQe9NiAEZI4luDb6O6RqPnJN0dUG19AZJSqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NjvLtmpc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NjvLtmpc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463D8C2BD10;
	Sat,  6 Jul 2024 18:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720292028;
	bh=+Hq73XRDkbEynxbyoYiKW3hQYmli4js4Ot15oaOtaNg=;
	h=Date:To:From:Subject:From;
	b=NjvLtmpcm1ZRJJsuKWwtuZ5z42mgZS/3qmyV54G/I7dLdhXg1QMwqmKBa25dIviBk
	 e4DHXUYgrsCf9203+l5/U3X+On7UTNTUH50u4gmzHZBYUjCmNFp76+7ZaLboGfdjuA
	 tEyevnhvxpGY4bsQZh/eDDsVi5AJV8zEgkk2uon4=
Date: Sat, 06 Jul 2024 11:53:47 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,tony.luck@intel.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jiaqiyan@google.com,jglisse@redhat.com,jane.chu@oracle.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,bcrl@kvack.org,apopple@nvidia.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-folio_mc_copy.patch removed from -mm tree
Message-Id: <20240706185348.463D8C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add folio_mc_copy()
has been removed from the -mm tree.  Its filename was
     mm-add-folio_mc_copy.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: add folio_mc_copy()
Date: Wed, 26 Jun 2024 16:53:24 +0800

Add a #MC variant of folio_copy() which uses copy_mc_highpage() to support
#MC handled during folio copy, it will be used in folio migration soon.

Link: https://lkml.kernel.org/r/20240626085328.608006-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 mm/util.c          |   17 +++++++++++++++++
 2 files changed, 18 insertions(+)

--- a/include/linux/mm.h~mm-add-folio_mc_copy
+++ a/include/linux/mm.h
@@ -1291,6 +1291,7 @@ void put_pages_list(struct list_head *pa
 
 void split_page(struct page *page, unsigned int order);
 void folio_copy(struct folio *dst, struct folio *src);
+int folio_mc_copy(struct folio *dst, struct folio *src);
 
 unsigned long nr_free_buffer_pages(void);
 
--- a/mm/util.c~mm-add-folio_mc_copy
+++ a/mm/util.c
@@ -828,6 +828,23 @@ void folio_copy(struct folio *dst, struc
 }
 EXPORT_SYMBOL(folio_copy);
 
+int folio_mc_copy(struct folio *dst, struct folio *src)
+{
+	long nr = folio_nr_pages(src);
+	long i = 0;
+
+	for (;;) {
+		if (copy_mc_highpage(folio_page(dst, i), folio_page(src, i)))
+			return -EHWPOISON;
+		if (++i == nr)
+			break;
+		cond_resched();
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(folio_mc_copy);
+
 int sysctl_overcommit_memory __read_mostly = OVERCOMMIT_GUESS;
 int sysctl_overcommit_ratio __read_mostly = 50;
 unsigned long sysctl_overcommit_kbytes __read_mostly;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


