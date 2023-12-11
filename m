Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB3D53B6
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n1lgkqbV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DAE3C433C7;
	Mon, 11 Dec 2023 00:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256130;
	bh=Qfzs92D9n56CWne+3Ia1YYgahlbJ6avXFQee0sgEsM0=;
	h=Date:To:From:Subject:From;
	b=n1lgkqbVwK8wyBuEoaQuc9k/M0RxlgBMSESxRoysPhyxC8omuikWR2BuMalALiCj8
	 gS0gUW1QIRbaUNtGhAjNOB2ra3tZsKxGspjy5X0oS2sOFw7oPVBbcF9PGIo+mkcEG/
	 lfeqD9OqlK3h/XeW5KSJrlvmmCV0Y2xdTLZvNRZ4=
Date: Sun, 10 Dec 2023 16:55:29 -0800
To: mm-commits@vger.kernel.org,sjenning@redhat.com,nphamcs@gmail.com,ira.weiny@intel.com,ddstreet@ieee.org,chrisl@kernel.org,fabio.maria.de.francesco@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-replace-kmap_atomic-with-kmap_local_page.patch removed from -mm tree
Message-Id: <20231211005530.8DAE3C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: replace kmap_atomic() with kmap_local_page()
has been removed from the -mm tree.  Its filename was
     mm-zswap-replace-kmap_atomic-with-kmap_local_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Fabio M. De Francesco" <fabio.maria.de.francesco@linux.intel.com>
Subject: mm/zswap: replace kmap_atomic() with kmap_local_page()
Date: Mon, 27 Nov 2023 16:55:21 +0100

kmap_atomic() has been deprecated in favor of kmap_local_page().

Therefore, replace kmap_atomic() with kmap_local_page() in
zswap.c.

kmap_atomic() is implemented like a kmap_local_page() which also disables
page-faults and preemption (the latter only in !PREEMPT_RT kernels).  The
kernel virtual addresses returned by these two API are only valid in the
context of the callers (i.e., they cannot be handed to other threads).

With kmap_local_page() the mappings are per thread and CPU local like in
kmap_atomic(); however, they can handle page-faults and can be called from
any context (including interrupts).  The tasks that call kmap_local_page()
can be preempted and, when they are scheduled to run again, the kernel
virtual addresses are restored and are still valid.

In mm/zswap.c, the blocks of code between the mappings and un-mappings do
not depend on the above-mentioned side effects of kmap_atomic(), so that
the mere replacements of the old API with the new one is all that is
required (i.e., there is no need to explicitly call pagefault_disable()
and/or preempt_disable()).

Link: https://lkml.kernel.org/r/20231127160058.586446-1-fabio.maria.de.francesco@linux.intel.com
Signed-off-by: Fabio M. De Francesco <fabio.maria.de.francesco@linux.intel.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Chris Li <chrisl@kernel.org> (Google)
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Dan Streetman <ddstreet@ieee.org> 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/zswap.c~mm-zswap-replace-kmap_atomic-with-kmap_local_page
+++ a/mm/zswap.c
@@ -1267,16 +1267,16 @@ bool zswap_store(struct folio *folio)
 	}
 
 	if (zswap_same_filled_pages_enabled) {
-		src = kmap_atomic(page);
+		src = kmap_local_page(page);
 		if (zswap_is_page_same_filled(src, &value)) {
-			kunmap_atomic(src);
+			kunmap_local(src);
 			entry->swpentry = swp_entry(type, offset);
 			entry->length = 0;
 			entry->value = value;
 			atomic_inc(&zswap_same_filled_pages);
 			goto insert_entry;
 		}
-		kunmap_atomic(src);
+		kunmap_local(src);
 	}
 
 	if (!zswap_non_same_filled_pages_enabled)
@@ -1422,9 +1422,9 @@ bool zswap_load(struct folio *folio)
 	spin_unlock(&tree->lock);
 
 	if (!entry->length) {
-		dst = kmap_atomic(page);
+		dst = kmap_local_page(page);
 		zswap_fill_page(dst, entry->value);
-		kunmap_atomic(dst);
+		kunmap_local(dst);
 		ret = true;
 		goto stats;
 	}
_

Patches currently in -mm which might be from fabio.maria.de.francesco@linux.intel.com are


