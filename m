Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E63311589
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282415; cv=none; b=EndQcKDvxBnvU74HIjw5h1yJPwxlH66FNizgBv2zUS1xZo+8QmpI7Gho+KVvDYoO9INqC+dnOuUM/k7YwwKcilWcfnTgONf2izeNorbf867SRMyrQYlXHLvkgF1dTynYFC+NTDcy1psvGqKf9cx7OohmxK8jsRy3nK/caQne+5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282415; c=relaxed/simple;
	bh=fTnbwu/htDf/O+NYCkBpuWTMKxS7KLvOs+jPO6i3Tb8=;
	h=Date:To:From:Subject:Message-Id; b=V7vFn53kK2WDYc4NeMQwiUquRM6c1VSZuYn2eKGAqZ+Wbss9StowWRfV0pvslGDwFxTPcDX/N5w6pVbfHD/4fEfgvK9ZWkGqx3xT0EqcFj4srh8/tyueM1/UUmBuooVEA6xTPN+nkC2eDZ/rj/IdGjGmR7Sn+VKmswHjicL/CwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CM+DdYSP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CM+DdYSP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBD0C4CEF8;
	Thu, 27 Nov 2025 22:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282415;
	bh=fTnbwu/htDf/O+NYCkBpuWTMKxS7KLvOs+jPO6i3Tb8=;
	h=Date:To:From:Subject:From;
	b=CM+DdYSPHrVeDdlGox6ZEndRkJYyB6+XypGYNv0UPRuEQOq6aCZHTzF4IvaTU6Pmr
	 ZB9rC5XL8uUL19UliXK6+Doy4Fr7mF/xXKKVJ+/MU9I9viFzCuQoxwxI4JJbyod8pY
	 +PXP3HSct86DgrR1h0r4RblIvPt3qPLQ2ycXlflQ=
Date: Thu, 27 Nov 2025 14:26:54 -0800
To: mm-commits@vger.kernel.org,yoann.congal@smile.fr,yesanishhere@gmail.com,yanjun.zhu@linux.dev,witu@nvidia.com,wagi@kernel.org,vincent.guittot@linaro.org,tj@kernel.org,tglx@linutronix.de,stuart.w.hayes@gmail.com,song@kernel.org,skhawaja@google.com,saeedm@nvidia.com,rppt@kernel.org,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,rdunlap@infradead.org,quic_zijuhu@quicinc.com,pratyush@kernel.org,pasha.tatashin@soleen.com,parav@nvidia.com,ojeda@kernel.org,myungjoo.ham@samsung.com,mmaurer@google.com,mingo@redhat.com,masahiroy@kernel.org,mark.rutland@arm.com,lukas@wunner.de,linux@weissschuh.net,leonro@nvidia.com,leon@kernel.org,lennart@poettering.net,kanie@linux.alibaba.com,Jonathan.Cameron@huawei.com,joel.granados@kernel.org,jgg@nvidia.com,jannh@google.com,ira.weiny@intel.com,ilpo.jarvinen@linux.intel.com,hughd@google.com,hpa@zytor.com,hannes@cmpxchg.org,gregkh@linuxfoundation.org,graf@amazon.com,dmatlack@google.com,djeffery@redhat.com,david@redhat.com,dan.j.williams@intel.com,dakr@kernel.org,cw00.choi@samsung.com,corbet@lwn.net,chrisl@kernel.org,chenridong@huawei.com,brauner@kernel.org,bp@alien8.de,bhelgaas@google.com,bartosz.golaszewski@linaro.org,axboe@kernel.dk,anna.schumaker@oracle.com,andriy.shevchenko@linux.intel.com,aliceryhl@google.com,aleksander.lobakin@intel.com,ptyadav@amazon.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mm-shmem-export-some-functions-to-internalh.patch removed from -mm tree
Message-Id: <20251127222654.EDBD0C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: export some functions to internal.h
has been removed from the -mm tree.  Its filename was
     mm-shmem-export-some-functions-to-internalh.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pratyush Yadav <ptyadav@amazon.de>
Subject: mm: shmem: export some functions to internal.h
Date: Tue, 25 Nov 2025 11:58:42 -0500

shmem_inode_acct_blocks(), shmem_recalc_inode(), and
shmem_add_to_page_cache() are used by shmem_alloc_and_add_folio().  This
functionality will be used by memfd LUO integration.

Link: https://lkml.kernel.org/r/20251125165850.3389713-13-pasha.tatashin@soleen.com
Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: David Matlack <dmatlack@google.com>
Cc: Aleksander Lobakin <aleksander.lobakin@intel.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: anish kumar <yesanishhere@gmail.com>
Cc: Anna Schumaker <anna.schumaker@oracle.com>
Cc: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Chen Ridong <chenridong@huawei.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Daniel Wagner <wagi@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Jeffery <djeffery@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guixin Liu <kanie@linux.alibaba.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Matthew Maurer <mmaurer@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Myugnjoo Ham <myungjoo.ham@samsung.com>
Cc: Parav Pandit <parav@nvidia.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Samiullah Khawaja <skhawaja@google.com>
Cc: Song Liu <song@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Stuart Hayes <stuart.w.hayes@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: William Tu <witu@nvidia.com>
Cc: Yoann Congal <yoann.congal@smile.fr>
Cc: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: Zijun Hu <quic_zijuhu@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    6 ++++++
 mm/shmem.c    |   10 +++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

--- a/mm/internal.h~mm-shmem-export-some-functions-to-internalh
+++ a/mm/internal.h
@@ -1562,6 +1562,12 @@ void __meminit __init_page_from_nid(unsi
 unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
 			  int priority);
 
+int shmem_add_to_page_cache(struct folio *folio,
+			    struct address_space *mapping,
+			    pgoff_t index, void *expected, gfp_t gfp);
+int shmem_inode_acct_blocks(struct inode *inode, long pages);
+bool shmem_recalc_inode(struct inode *inode, long alloced, long swapped);
+
 #ifdef CONFIG_SHRINKER_DEBUG
 static inline __printf(2, 0) int shrinker_debugfs_name_alloc(
 			struct shrinker *shrinker, const char *fmt, va_list ap)
--- a/mm/shmem.c~mm-shmem-export-some-functions-to-internalh
+++ a/mm/shmem.c
@@ -219,7 +219,7 @@ static inline void shmem_unacct_blocks(u
 		vm_unacct_memory(pages * VM_ACCT(PAGE_SIZE));
 }
 
-static int shmem_inode_acct_blocks(struct inode *inode, long pages)
+int shmem_inode_acct_blocks(struct inode *inode, long pages)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
@@ -435,7 +435,7 @@ static void shmem_free_inode(struct supe
  *
  * Return: true if swapped was incremented from 0, for shmem_writeout().
  */
-static bool shmem_recalc_inode(struct inode *inode, long alloced, long swapped)
+bool shmem_recalc_inode(struct inode *inode, long alloced, long swapped)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	bool first_swapped = false;
@@ -861,9 +861,9 @@ static void shmem_update_stats(struct fo
 /*
  * Somewhat like filemap_add_folio, but error if expected item has gone.
  */
-static int shmem_add_to_page_cache(struct folio *folio,
-				   struct address_space *mapping,
-				   pgoff_t index, void *expected, gfp_t gfp)
+int shmem_add_to_page_cache(struct folio *folio,
+			    struct address_space *mapping,
+			    pgoff_t index, void *expected, gfp_t gfp)
 {
 	XA_STATE_ORDER(xas, &mapping->i_pages, index, folio_order(folio));
 	unsigned long nr = folio_nr_pages(folio);
_

Patches currently in -mm which might be from ptyadav@amazon.de are


