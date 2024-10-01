Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DD81CEABE
	for <mm-commits@vger.kernel.org>; Tue,  1 Oct 2024 22:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727820794; cv=none; b=B7vsBoscXY91oPSFM2UgvKbm9N/y68jCfleoUJsPCRULXAO1BiWl4e/nom6y6heIXOqWIxIDlMUmxGQCOLJO29CDq6xudUWTHGUMgRiNA3vW1cekrbyLcVb+X8XuxURBz3ujIaOm6I+oYD82ng4i0vt9HSJVMF1raEfel1Zon1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727820794; c=relaxed/simple;
	bh=UxcUgnfuAQmZ+8stdP8Y8D83wWZK+BflwnamU5t3VNA=;
	h=Date:To:From:Subject:Message-Id; b=m2meb5ko9a3iMz6lAz892AdScOwCZ7m4cUIHy4BWB01IjKQi8hBHXQkIeJ+44XPrmtQnlooCoq1kxkwrOsSddxjBUl8wvYqYyNAXNGW28KmogEKosUun8xLbyK9V2dIDT9F8b7neRnvzOoQG4NOk3JUkSXiJM5d9tV/2uTpTziQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EbLCn5qf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EbLCn5qf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0045C4CEC6;
	Tue,  1 Oct 2024 22:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727820793;
	bh=UxcUgnfuAQmZ+8stdP8Y8D83wWZK+BflwnamU5t3VNA=;
	h=Date:To:From:Subject:From;
	b=EbLCn5qfVm2sGFVgdrIFCMIFKLxCgjZWmVaqVPZP1tRrPpSopi7Tx6HRkQl8gOLDz
	 sVmvHLm+u8dkB3i8oHMFQ9fD/w5pQepCQN08hAJA8F4uXBybR9NPHGkdRQnZphheyE
	 B+4/oyjY7lhSGQMfspU5iSiPXGh7o4G9Ahjs+ToU=
Date: Tue, 01 Oct 2024 15:13:13 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,wajdi.k.feghali@intel.com,usamaarif642@gmail.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,nphamcs@gmail.com,nanhai.zou@intel.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,kanchana.p.sridhar@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-define-obj_cgroup_get-if-config_memcg-is-not-defined.patch added to mm-unstable branch
Message-Id: <20241001221313.E0045C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: define obj_cgroup_get() if CONFIG_MEMCG is not defined.
has been added to the -mm mm-unstable branch.  Its filename is
     mm-define-obj_cgroup_get-if-config_memcg-is-not-defined.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-define-obj_cgroup_get-if-config_memcg-is-not-defined.patch

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
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Subject: mm: define obj_cgroup_get() if CONFIG_MEMCG is not defined.
Date: Mon, 30 Sep 2024 22:32:16 -0700

This resolves an issue with obj_cgroup_get() not being defined if
CONFIG_MEMCG is not defined.

Before this patch, we would see build errors if obj_cgroup_get() is called
from code that is agnostic of CONFIG_MEMCG.

The zswap_store() changes for large folios in subsequent commits will
require the use of obj_cgroup_get() in zswap code that falls into this
category.

Link: https://lkml.kernel.org/r/20241001053222.6944-2-kanchana.p.sridhar@intel.com
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Wajdi Feghali <wajdi.k.feghali@intel.com>
Cc: "Zou, Nanhai" <nanhai.zou@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/memcontrol.h~mm-define-obj_cgroup_get-if-config_memcg-is-not-defined
+++ a/include/linux/memcontrol.h
@@ -1282,6 +1282,10 @@ struct mem_cgroup *mem_cgroup_from_css(s
 	return NULL;
 }
 
+static inline void obj_cgroup_get(struct obj_cgroup *objcg)
+{
+}
+
 static inline void obj_cgroup_put(struct obj_cgroup *objcg)
 {
 }
_

Patches currently in -mm which might be from kanchana.p.sridhar@intel.com are

mm-define-obj_cgroup_get-if-config_memcg-is-not-defined.patch
mm-zswap-modify-zswap_compress-to-accept-a-page-instead-of-a-folio.patch
mm-zswap-rename-zswap_pool_get-to-zswap_pool_tryget.patch
mm-change-count_objcg_event-to-count_objcg_events-for-batch-event-updates.patch
mm-zswap-modify-zswap_stored_pages-to-be-atomic_long_t.patch
mm-zswap-support-large-folios-in-zswap_store.patch
mm-swap-count-successful-large-folio-zswap-stores-in-hugepage-zswpout-stats.patch

