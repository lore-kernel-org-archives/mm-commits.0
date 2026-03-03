Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55082EE611
	for <mm-commits@vger.kernel.org>; Tue,  3 Mar 2026 22:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772577283; cv=none; b=hpqj2qCeOtxFMMmnaSZe+Ns+q6zihYQRYTyGLMsRAyrHTzDitxQcOpV/XOqDu0oGlk2oyYxOabG+tvNhM+4tafSNMhPxpwtKaEWrJEZD//6CgRBHctdxHtDUeDxKOixMcy69ahBylC1yJ6m1SGrTTaGcsqobtr9tyT1WRG1uioM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772577283; c=relaxed/simple;
	bh=OYU71fFKaPnmcpYCwRICIIDpyhxMs+5mqKjc4MC1kD8=;
	h=Date:To:From:Subject:Message-Id; b=G3+JjbZyWxaWfAo0tf8JGC+qH9WlSd6JZVvay0TVVARLaHz9PXf58Yi6iayLKVj0CNrME48lkWIFVAgdG2JEfGx9SmIWXzNZRalIccwxM4PmClxN+fw/PA4RFILpcFcoiJ9kTQ+a10woBbn6qbz8FQDBqS8sYmJ1HKUkm6HLZFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jU0YGuRh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jU0YGuRh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749DDC116C6;
	Tue,  3 Mar 2026 22:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772577283;
	bh=OYU71fFKaPnmcpYCwRICIIDpyhxMs+5mqKjc4MC1kD8=;
	h=Date:To:From:Subject:From;
	b=jU0YGuRhgNKNSXPD0qPCtT/jOHUrzxqR4AcSBoTCSDziv/RbURQGQ8SyO29lSaGeb
	 Lp+TnD0RmkXvgjooxdczObyywfzPwUL3pd+VEA8YnFcWlvYxsLoJx/zv++QzOqRXsA
	 giZmmKWgVyKo/SwmCSzN/0/ccEkGJT0f0I5bQaJo=
Date: Tue, 03 Mar 2026 14:34:42 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuvraj.sakshith@oss.qualcomm.com,xuanzhuo@linux.alibaba.com,wei.liu@kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mst@redhat.com,mhocko@suse.com,mhklinux@outlook.com,lorenzo.stoakes@oracle.com,longli@microsoft.com,liam.howlett@oracle.com,kys@microsoft.com,jasowang@redhat.com,jackmanb@google.com,hannes@cmpxchg.org,haiyangz@microsoft.com,eperezma@redhat.com,decui@microsoft.com,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_reporting-add-page_reporting_order_unspecified-fix.patch added to mm-new branch
Message-Id: <20260303223443.749DDC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-page_reporting-add-page_reporting_order_unspecified-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-page_reporting-add-page_reporting_order_unspecified-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_reporting-add-page_reporting_order_unspecified-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_reporting-add-page_reporting_order_unspecified-fix
Date: Tue Mar  3 02:33:57 PM PST 2026

tweak whitespace, per David

Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Long Li <longli@microsoft.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michael Kelley <mhklinux@outlook.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_reporting.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_reporting.c~mm-page_reporting-add-page_reporting_order_unspecified-fix
+++ a/mm/page_reporting.c
@@ -372,7 +372,7 @@ int page_reporting_register(struct page_
 
 	if (page_reporting_order == -1) {
 		if (prdev->order != PAGE_REPORTING_ORDER_UNSPECIFIED &&
-			prdev->order <= MAX_PAGE_ORDER)
+		    prdev->order <= MAX_PAGE_ORDER)
 			page_reporting_order = prdev->order;
 		else
 			page_reporting_order = pageblock_order;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
maple_tree-add-cp_is_new_root-helper-fix-fix.patch
mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix.patch
mm-rename-zone-lock-to-zone-_lock-fix.patch
mm-page_reporting-add-page_reporting_order_unspecified-fix.patch
kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch

