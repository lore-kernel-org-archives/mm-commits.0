Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E87337BB5
	for <mm-commits@vger.kernel.org>; Sun,  8 Feb 2026 08:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770538456; cv=none; b=LyQhnao+LlVtJvnn0bicpz5FzK6T43tL3i0b9zbwc5Qpqny/uo7iayjyhLAYRBuOYSUKGYV9IG1fjBqsHahVFRJ9EI6Tr2Rgh0pOHVPaRdoRG0oMG6REQH/W73FkvQNeNUqUfsfb6qEQO/jGAtF/KfRGnkby3VG0x9mlT1n4t9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770538456; c=relaxed/simple;
	bh=9DeGplE/dvk6qVtGhX5RwQEzhtN4jCWVeyPVS+cOy24=;
	h=Date:To:From:Subject:Message-Id; b=NutDzfC1cHE3N4GPIZBgWaxiVh1iowg5pUAw3ub+083R8+reA4Zu9S79d1tqsI0egllW+Yv+Eln6saokNYbT9K0R4CQVi2fglIuC9pmKb8xMpqfi1NEmPbvM446DMW4nsvGlZEeTKgaObD0rLblPJ/Mqylk+pUaweoQ4JqzFJ4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X0bthncY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X0bthncY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A09C4CEF7;
	Sun,  8 Feb 2026 08:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770538456;
	bh=9DeGplE/dvk6qVtGhX5RwQEzhtN4jCWVeyPVS+cOy24=;
	h=Date:To:From:Subject:From;
	b=X0bthncYhwUj4Yf5w4BRum4z/J7SaQIwSBhL9B8MZF1Oc7nchI9pU6t7qGKTBaNV+
	 gZTS1GWlb/7FiBxbrwRldSU018amOWPZ9pTFLEB+OeR+YHfu1CLxMY8h8kCBNgtHvi
	 LCigj9+T6R8RtHgh3vEIW7dbjdBmsYiEjaNI1SKw=
Date: Sun, 08 Feb 2026 00:14:15 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,tycho@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-fix-doc-for-kho_restore_pages.patch removed from -mm tree
Message-Id: <20260208081416.54A09C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: fix doc for kho_restore_pages()
has been removed from the -mm tree.  Its filename was
     kho-fix-doc-for-kho_restore_pages.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Tycho Andersen (AMD)" <tycho@kernel.org>
Subject: kho: fix doc for kho_restore_pages()
Date: Fri, 23 Jan 2026 12:05:06 -0700

This function returns NULL if kho_restore_page() returns NULL, which
happens in a couple of corner cases.  It never returns an error code.

Link: https://lkml.kernel.org/r/20260123190506.1058669-1-tycho@kernel.org
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-fix-doc-for-kho_restore_pages
+++ a/kernel/liveupdate/kexec_handover.c
@@ -299,7 +299,7 @@ EXPORT_SYMBOL_GPL(kho_restore_folio);
  * Restore a contiguous list of order 0 pages that was preserved with
  * kho_preserve_pages().
  *
- * Return: 0 on success, error code on failure
+ * Return: the first page on success, NULL on failure.
  */
 struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages)
 {
_

Patches currently in -mm which might be from tycho@kernel.org are


