Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7169262FF3
	for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2025 22:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756421367; cv=none; b=oqRUKbJK802ZiAkUt/o7ym9+v+mrOUFQpCTrZtaLjFWaHv6QlH9lbDf3QktVbAEmEBqp+TlxFg+whyp2pkygiJ27LfWCwp+s7AJOlTdgsi2TJ+EnJGtSz/6NvPefEFXvjFApDTx8og3imUsaJr23zE6dZ7KuDuNt7/3gt7MxBNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756421367; c=relaxed/simple;
	bh=mO/KbJZ5En/G99B5f6oQTBuIGGzFXAtEzrsRDxCxdlE=;
	h=Date:To:From:Subject:Message-Id; b=PTWO5CNSx4G4N2HDrWLlb+N5UqwQJ+3+epyIClxpMXOsAGA6fee27F4P5C76xhDx7AM+rXLaA/kbblwC8uemi/oKWyR0wP7dRU5QACpn+1AtfMCqwgD/Q6rWwSVS4wRbT1Vihx0pJPLv35Xz8CRLEiCrWBLEUuUo9sLQyf9Ou9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kOifJuMe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kOifJuMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F5CC4CEEB;
	Thu, 28 Aug 2025 22:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756421366;
	bh=mO/KbJZ5En/G99B5f6oQTBuIGGzFXAtEzrsRDxCxdlE=;
	h=Date:To:From:Subject:From;
	b=kOifJuMe1IjoeRHYxpJfvOEbsj3JBzcl3j9Rx9A86muVuF73Jqs0mipgMMSMFn43E
	 5ZUJX34hhJlE+OvDoYe64Z/EEyeA2T8eUdUaU6NMa21O0R+rkWU9Yres3XJ4iu9igH
	 CIwgFysnxiC6T4nHQsKPyhsm4oXiLD30J6uu1LY0=
Date: Thu, 28 Aug 2025 15:49:25 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,vbabka@suse.cz,sj@kernel.org,lorenzo.stoakes@oracle.com,david@redhat.com,max.kellermann@ionos.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + pagevech-add-const-to-pointer-parameters-of-getter-functions.patch added to mm-new branch
Message-Id: <20250828224926.51F5CC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: pagevec.h: add `const` to pointer parameters of getter functions
has been added to the -mm mm-new branch.  Its filename is
     pagevech-add-const-to-pointer-parameters-of-getter-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/pagevech-add-const-to-pointer-parameters-of-getter-functions.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Max Kellermann <max.kellermann@ionos.com>
Subject: pagevec.h: add `const` to pointer parameters of getter functions
Date: Thu, 28 Aug 2025 15:03:11 +0200

For improved const-correctness.

Link: https://lkml.kernel.org/r/20250828130311.772993-1-max.kellermann@ionos.com
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagevec.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/pagevec.h~pagevech-add-const-to-pointer-parameters-of-getter-functions
+++ a/include/linux/pagevec.h
@@ -51,12 +51,12 @@ static inline void folio_batch_reinit(st
 	fbatch->i = 0;
 }
 
-static inline unsigned int folio_batch_count(struct folio_batch *fbatch)
+static inline unsigned int folio_batch_count(const struct folio_batch *fbatch)
 {
 	return fbatch->nr;
 }
 
-static inline unsigned int folio_batch_space(struct folio_batch *fbatch)
+static inline unsigned int folio_batch_space(const struct folio_batch *fbatch)
 {
 	return PAGEVEC_SIZE - fbatch->nr;
 }
_

Patches currently in -mm which might be from max.kellermann@ionos.com are

pagevech-add-const-to-pointer-parameters-of-getter-functions.patch

