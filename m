Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57EC3214
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119216; cv=none; b=XdpxNk7i1vu2HqZZfVh9qeqJ1v0xPBVvuOZW/lNNTA7DceRBi2WUSl9gLZqqn8a+6t0o/sqx6SS2QOfPZYNO5VGP9kkdL+EserhjJsdzSUgPmpBGefQ9DqYyAEeBDzvjKqwihvJPW24GtNyX5LY2xFOG7piGbyCZdswWFtdtaYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119216; c=relaxed/simple;
	bh=uw2oyhoRvyHpFxpfNz7NHN4+U2uMzHyyDXcuBFK9quc=;
	h=Date:To:From:Subject:Message-Id; b=lPR5MB8s93q56LWvtJwGV70JTpP6737yklN55AXIaf0ooJDi9E9y+17FGcZ9+1o6yPQFyrUeY5GCxuiAlBlcQcWkqFWtrHPsS8BCX8mexq2ZioBYDey2DGxf7b/GachRcsBrd2p295sUtdKxK4YgDipwOMREk9BoZqp4Jw4Sq/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yZjygSsN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yZjygSsN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C9FC4CEED;
	Tue, 13 May 2025 06:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119216;
	bh=uw2oyhoRvyHpFxpfNz7NHN4+U2uMzHyyDXcuBFK9quc=;
	h=Date:To:From:Subject:From;
	b=yZjygSsNmtlwxps61nGxLbhnA+b9bLF354gmlZuFrZULnC2DeeIOQR/Nsf0WyaG8z
	 fee7DA+fZcIgsjZ1rwLYScQiou7C8mQpLCpF1KxtssKjokz26G+++59L2f/PnV9Lmn
	 T1sNxLmYgf0I2lWr4TI6+UzliAuSwCXmOtQTU8bQ=
Date: Mon, 12 May 2025 23:53:36 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,urezki@gmail.com,shivankg@amd.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-optimize-function-vm_unmap_aliases.patch removed from -mm tree
Message-Id: <20250513065336.89C9FC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: optimize function vm_unmap_aliases()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-optimize-function-vm_unmap_aliases.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/vmalloc: optimize function vm_unmap_aliases()
Date: Sat, 19 Apr 2025 06:36:52 +0800

Remove unneeded local variables and replace them with values.

Link: https://lkml.kernel.org/r/20250418223653.243436-5-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-optimize-function-vm_unmap_aliases
+++ a/mm/vmalloc.c
@@ -2929,10 +2929,7 @@ static void _vm_unmap_aliases(unsigned l
  */
 void vm_unmap_aliases(void)
 {
-	unsigned long start = ULONG_MAX, end = 0;
-	int flush = 0;
-
-	_vm_unmap_aliases(start, end, flush);
+	_vm_unmap_aliases(ULONG_MAX, 0, 0);
 }
 EXPORT_SYMBOL_GPL(vm_unmap_aliases);
 
_

Patches currently in -mm which might be from bhe@redhat.com are


