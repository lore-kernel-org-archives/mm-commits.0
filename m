Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0871229ACC3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489871; cv=none; b=IOjq4m3hnKOKrYRvDzx1Et3VnW/uvlJgtUMaV3YkIm3bB2JSWbf6IcM0Ume1OxGLA6/fXxuCD4c2KKz/fZeThs78rUvbnjsBMK0yKt9pqpQHb9h1uAzy2oZsKkh+TppNIMbEi9XfOMVrt870sHZ9tWXbFe0NFXiG9GwD6ww+BO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489871; c=relaxed/simple;
	bh=vP8zfbMRdRyvnC1yzjsz81aDl4SwQLZGmLyjICpfjxM=;
	h=Date:To:From:Subject:Message-Id; b=BXA1ZlSlYe1AAynWKiPsZk7hkWBbGy8qmHLVAiGvVcWoii6JJuiAr5hw88IgRYIp8laUPMmY7MoHcI0AAsBOlwoT8r7hoKktPKmj5KjCm1BdXEOcaF36QO9Lnw57qRpgHfwh5gEGpgQyzqr6ZX73EceCQX/66aAYVMHwz0oBMF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CXS+UjOk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CXS+UjOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F69C4CEE7;
	Sun, 21 Sep 2025 21:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489870;
	bh=vP8zfbMRdRyvnC1yzjsz81aDl4SwQLZGmLyjICpfjxM=;
	h=Date:To:From:Subject:From;
	b=CXS+UjOkXfb60ihhHjsO9GdoorO4CDtO8suE/qU808O9wjcJ0HTakePcVXrr7h+Jy
	 0Pf8TukvaKrSGaPIGC18D8Mm8eiqY5uoCTWZcS5q8WcuZnBC4jd2Sug4kmWnfqAlPK
	 XWIGY5tSBvTOoTfxN5eKls0S+5P4InCappj/oEqw=
Date: Sun, 21 Sep 2025 14:24:30 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,willy@infradead.org,weixugc@google.com,vishal.moola@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,thuth@redhat.com,tglx@linutronix.de,svens@linux.ibm.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rientjes@google.com,peterz@infradead.org,osalvador@suse.de,nysal@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,luto@kernel.org,lorenzo.stoakes@oracle.com,linux@armlinux.org.uk,liam.howlett@oracle.com,jfalempe@redhat.com,jcmvbkbc@gmail.com,james.bottomley@HansenPartnership.com,jack@suse.cz,hughd@google.com,hpa@zytor.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,deller@gmx.de,david@redhat.com,davem@davemloft.net,chris@zankel.net,broonie@kernel.org,brauner@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,andreas@gaisler.com,agordeev@linux.ibm.com,max.kellermann@ionos.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-constify-mapping-related-test-functions-for-improved-const-correctness.patch removed from -mm tree
Message-Id: <20250921212430.C2F69C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs: constify mapping related test functions for improved const-correctness
has been removed from the -mm tree.  Its filename was
     fs-constify-mapping-related-test-functions-for-improved-const-correctness.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Max Kellermann <max.kellermann@ionos.com>
Subject: fs: constify mapping related test functions for improved const-correctness
Date: Mon, 1 Sep 2025 22:50:13 +0200

We select certain test functions which either invoke each other, functions
that are already const-ified, or no further functions.

It is therefore relatively trivial to const-ify them, which provides a
basis for further const-ification further up the call stack.

Link: https://lkml.kernel.org/r/20250901205021.3573313-5-max.kellermann@ionos.com
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Zankel <chris@zankel.net>
Cc: David Rientjes <rientjes@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Bottomley <james.bottomley@HansenPartnership.com>
Cc: Jocelyn Falempe <jfalempe@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Nysal Jan K.A" <nysal@linux.ibm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Russel King <linux@armlinux.org.uk>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/fs.h~fs-constify-mapping-related-test-functions-for-improved-const-correctness
+++ a/include/linux/fs.h
@@ -537,7 +537,7 @@ struct address_space {
 /*
  * Returns true if any of the pages in the mapping are marked with the tag.
  */
-static inline bool mapping_tagged(struct address_space *mapping, xa_mark_t tag)
+static inline bool mapping_tagged(const struct address_space *mapping, xa_mark_t tag)
 {
 	return xa_marked(&mapping->i_pages, tag);
 }
@@ -585,7 +585,7 @@ static inline void i_mmap_assert_write_l
 /*
  * Might pages of this file be mapped into userspace?
  */
-static inline int mapping_mapped(struct address_space *mapping)
+static inline int mapping_mapped(const struct address_space *mapping)
 {
 	return	!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root);
 }
@@ -599,7 +599,7 @@ static inline int mapping_mapped(struct
  * If i_mmap_writable is negative, no new writable mappings are allowed. You
  * can only deny writable mappings, if none exists right now.
  */
-static inline int mapping_writably_mapped(struct address_space *mapping)
+static inline int mapping_writably_mapped(const struct address_space *mapping)
 {
 	return atomic_read(&mapping->i_mmap_writable) > 0;
 }
_

Patches currently in -mm which might be from max.kellermann@ionos.com are


