Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795537122;
	b=fdCkYGO+YyBmqtHX64MlvHNGMbVZRBKvG+Ctd+TjS/2A2sTCOneDxKHt3VUQ0ZJ4AaST
	 isUB6OASZR9/s8nIMCxvNZy5Thy7gYBGMcWZuxcDun4CqndZkmPCU47GBoY0br8MGdiu0
	 SpCUSsZSce9KDaTXYjl8FLyxJ24kNiGhPTekZt9sy03liR3hKPxdOyz0NHZ1J+eEfLgZa
	 YFqIsea9qXf879fXDun/uq1zpOBxd3h6YMAhWsK1aZIlPbKTi3KRJj+Q/s3l8J+azb/qL
	 5vgWQVshqNhKccpdujomt/hAJ5rPpx+vUtJ2ac7TyheDizGsQsCtltvHyoIIiczObsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795537122;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=VEUZlZskdk4UgTxqH4L/94lrCUGqwmGWXjp963UDmcA=;
	b=R6O+3E0WLj7htWLamGxdaiQB3Z0tysuwqknXDfm9/rzgh5SVMmcQJHCC0fIlrJ+9jGR/
	 Fzgeve5sfbBAdN37cnghU9HZ65jjRee9/05STdEyxjmvrCfw0Xsj2wuUDHjL88qs9fXag
	 c+7pn/scgQ8EFpLYf5KRh6WhoeVyf45wzTylVxbgj/XcsYruiQmjbM6TaFSiFrfcw9U/W
	 rAWpgKilzfpDN4w6bxVKr/nYoXr5lU+rbb8vb7yGAWO/oJQKSRDMhu5FTLaVDJnBPaMLs
	 +2VXR5LFEFwNVl5c0rA9ivGjivxAPl2vq1FjZoePWQphFRYpTnuQ9jSV9IfruNyKtew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="sGJM4/uq";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6EF606A323
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 16:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=sGJM4/uq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F3E1F000EC;
	Tue, 24 Nov 2026 16:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795537121;
	bh=VEUZlZskdk4UgTxqH4L/94lrCUGqwmGWXjp963UDmcA=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=sGJM4/uqjxon4+Mt1UArMIIs/qCpRPtGzFFIquXKWPqWGUiEMvih+DBssOWl8Mu1Y
	 oIJoMNCIpy8ZYlDIxWD19G61SvG23wBjBs04Gr4KlorgVMz+h/C5uuyMl4Gn+XSYWL
	 RctHO7Jp1P3GNHtoZxsRsWYdckC1d34RXzH3FRR8=
Date: Tue, 24 Nov 2026 08:18:41 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yu-cheng.yu@intel.com,
	ying.huang@linux.alibaba.com,willy@infradead.org,vbabka@kernel.org,
	usama.arif@linux.dev,tj@kernel.org,surenb@google.com,shakeel.butt@linux.dev,
	rppt@kernel.org,rientjes@google.com,rick.p.edgecombe@intel.com,
	pfalcato@suse.de,peng.fan@nxp.com,nphamcs@gmail.com,mhocko@suse.com,
	matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,
	kas@kernel.org,joshua.hahnjy@gmail.com,jglisse@redhat.com,jbacik@fb.com,
	jannh@google.com,jack@suse.cz,hannes@cmpxchg.org,gourry@gourry.net,
	dennisszhou@gmail.com,dennis@kernel.org,david@kernel.org,
	dave.hansen@linux.intel.com,cl@gentwo.org,chris@chrisdown.name,
	byungchul@sk.com,broonie@kernel.org,bp@alien8.de,balbirs@nvidia.com,
	apopple@nvidia.com,mason@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-3-50a2ed382b61@kernel.org>
References: <20261113-mason-migrate-et-al-fixes-v2-3-50a2ed382b61@kernel.org>
Subject: + mm-cachestat-restart-the-walk-after-each-entry.patch added to mm-unstable branch
Message-Id: <20261124161841.83F3E1F000EC@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: cachestat: restart the walk after each entry
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cachestat-restart-the-walk-after-each-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cachestat-restart-the-walk-after-each-entry.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Chris Mason <mason@kernel.org>
Subject: mm: cachestat: restart the walk after each entry
Date: Fri, 13 Nov 2026 21:45:21 +0000

cachestat() can leave cached pages out of its counts. This happens if
the entry that the call has just counted is replaced by a larger folio
that starts in the same XArray slot.

The issue is that filemap_cachestat() walks the page cache under the RCU
read lock, so racing concurrent collapse/split is possible.

Thus, an entry can be replaced immediately after the walk has returned
it. When that happens, the next xas_find() skips the sibling entries that
point to the slot of that entry, since ordinarily they belong to that
entry.

However a concurrent collapse_file() or __filemap_add_folio() (when
replacing a shadow entry) can store a larger folio in the slot, in which
case the sibling entries belong to the new folio and the walk still skips
them.

Consider:

    cachestat                         collapse
    =========                         ========
    count a 64-page folio in slot 8
                                      store a 512-page folio in slot 8,
                                      with sibling entries in slots 9-15
    xas_find() starts at slot 8
    and skips slots 9-15
      /* 448 pages are never counted */

Also consider:

    filemap_cachestat()                  __filemap_add_folio()
    ===================                  =====================
    counts the shadow entry in slot 0
                                         slot 0: a folio of 32 pages
                                         slots 1-31: siblings of slot 0
    xas_find() skips slots 1-31
      /* 31 pages are never counted */

Essentially the fact that large folios might be present means we cannot
safely continue the XArray walk, and must reset the iterator each time.

Fix this by resetting the walk in each loop. This incurs a performance
penalty, but given that only the RCU lock is held here, it can't be
avoided.

[ljs@kernel.org: squashed 2 commits, fixed up comment in code, and commit message]
Link: https://patch.msgid.link/20261113-mason-migrate-et-al-fixes-v2-3-50a2ed382b61@kernel.org
Fixes: cf264e1329fb ("cachestat: implement cachestat syscall")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>
  Link: https://lore.kernel.org/20261114115640.c707f5c9496fcea4@chrisdown.name
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Jann Horn <jannh@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Yu, Yu-cheng <yu-cheng.yu@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Peng Fan <peng.fan@nxp.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Mark Brown <broonie@kernel.org>
Cc: Dennis Zhou (Facebook) <dennisszhou@gmail.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>

 mm/filemap.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/filemap.c~mm-cachestat-restart-the-walk-after-each-entry
+++ a/mm/filemap.c
@@ -4758,10 +4758,11 @@ resched:
 		if (folio_last_index >= last_index)
 			break;
 
-		if (need_resched()) {
-			xas_set(&xas, curr_index);
+		/* Collapse or new folio spanning shadow entries needs reset. */
+		xas_set(&xas, curr_index);
+
+		if (need_resched())
 			cond_resched_rcu();
-		}
 	}
 	rcu_read_unlock();
 }
_

Patches currently in -mm which might be from mason@kernel.org are

mm-swap-fix-large-swap-in-across-swap-file-extents.patch
hugetlbfs-do-not-grow-a-sealed-file-in-mmap.patch
mm-hugetlb-keep-surplus-folios-that-are-reserved.patch
mm-hugetlb-fix-reservation-leak-on-min_size=-mounts.patch
mm-cachestat-count-each-page-only-once.patch
mm-cachestat-restart-the-walk-after-each-entry.patch
percpu-queue-the-balance-work-on-an-unbound-workqueue.patch

