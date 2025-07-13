Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3662F10E5
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752449595; cv=none; b=pmKmZEHCz+VNTZgZFIE7n2DN2s6gD98JWxA0Jr7mQOmVzlncuHZRz6PkrB7u7EaQwtpWIqUNClNurVhotIAKTnMfjlL6cBsBPOV+9kNKNnUi6eRy2jElo2cZHg90W5DYf7ORYfQEdnwB7ZNL8bU2tkvutPC0WrgV0IJPke4Tv3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752449595; c=relaxed/simple;
	bh=PZbHMFIMUgFDyIDFq1kHj1pyrQnCIsiPaPC4godp4Dc=;
	h=Date:To:From:Subject:Message-Id; b=W5XXk7U8XqrWRs9vKrPC7pf51O0De6yCRtIby9CRHlmDjuBIBUiDElyqNwiqDNsh6ZggpG2V2CtuXFql77iLUjJHXkhbSUE7LbxYTXOmodBS/u3B/c/oG7f0uHhmlMeTL48RqBaE/+QWHKI2iOr8bcaOPaAkmA4TMHaCc5TRj1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NEFhhkYC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NEFhhkYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A55C4CEE3;
	Sun, 13 Jul 2025 23:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752449594;
	bh=PZbHMFIMUgFDyIDFq1kHj1pyrQnCIsiPaPC4godp4Dc=;
	h=Date:To:From:Subject:From;
	b=NEFhhkYChitiS6gpe+En1WavQCBzKBvk9PORtpAyO0YindH2vPqG9g9PU7ZgB89Lb
	 A9iY/H4yfNHEMQavcrLOcL6MI8+Jh+CjXApSDMhUNof5kuLWLXFkAUkbPVAuhzkpyA
	 kiq7gJaM7nHH2ERAmgvIIqgx1z0YqR9gWcu5o+Ps=
Date: Sun, 13 Jul 2025 16:33:13 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-migrate-factor-out-movable_ops-page-handling-into-migrate_movable_ops_page-fix.patch removed from -mm tree
Message-Id: <20250713233314.90A55C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-migrate-factor-out-movable_ops-page-handling-into-migrate_movable_ops_page-fix
has been removed from the -mm tree.  Its filename was
     mm-migrate-factor-out-movable_ops-page-handling-into-migrate_movable_ops_page-fix.patch

This patch was dropped because it was folded into mm-migrate-factor-out-movable_ops-page-handling-into-migrate_movable_ops_page.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-migrate-factor-out-movable_ops-page-handling-into-migrate_movable_ops_page-fix
Date: Thu Jul 10 03:27:57 PM PDT 2025

fix kerneldoc

Reported-by: Stehen Rothwell <sfr@canb.auug.org.au>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-factor-out-movable_ops-page-handling-into-migrate_movable_ops_page-fix
+++ a/mm/migrate.c
@@ -161,7 +161,9 @@ static void putback_movable_ops_page(str
 
 /**
  * migrate_movable_ops_page - migrate an isolated movable_ops page
- * @page: The isolated page.
+ * @dst: The destination page.
+ * @src: The source page.
+ * @mode: The migration mode.
  *
  * Migrate an isolated movable_ops page.
  *
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-migrate-factor-out-movable_ops-page-handling-into-migrate_movable_ops_page.patch
mm-memcg-make-memoryreclaim-interface-generic-fix.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling-fix.patch
squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call-fix.patch

