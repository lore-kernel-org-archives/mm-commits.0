Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58A73B71CF
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068165; cv=none; b=NitpNZAmRVxAjc61VHxToSLbTNSim182qKVd1XoqtuNzzkl1saTrouajcbZ1P88FKc/58t/sO9wepkYilf2FynmD9X+Ikxo2KDGSG0wexXTXcrRJWyrKvn2xHwc+2LpONx/sklsYn7lIF2TbdgYYGwS2znEytDiJ0165uSU63Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068165; c=relaxed/simple;
	bh=YjuhrE8PDv6boTYt6i2r+0Tl6N9KOkpdU47tktiRG0I=;
	h=Date:To:From:Subject:Message-Id; b=pgj0HyhaWvVlsJOqr8f+ypEwyFm9IyW7k1OdOMLCEVbUPtGRcjMRQN3SDHoHfd+F8rv2rZ3mQ7uA3mfXBWOe7KvS4Kphh1eqzWIo9Yf+MuKdV5Lhha2jcgENGgyuPg6W0vaa33E6mqX9ub/TwJ/rTEYBlNafxbMEySXrSf9gDxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xcQvx43R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xcQvx43R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C6E1F000E9;
	Fri,  7 Aug 2026 02:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068163;
	bh=+J2T85w/7si2S0gg4BPH/luw3Ug7WfaEHS9lG63NDZc=;
	h=Date:To:From:Subject;
	b=xcQvx43RT4sLqhARp8AjlNm5gVMIfKmPRMzpRhBF99oxPcZoXCuckByfYH0BJpBHc
	 W9VdVZbSecLuNLHW6wjTIM7auUaPAD3ee9+xfKeTmOxWIjiyc2nGutrnQLhYF2A6BZ
	 5nHQie8FFAyce5tEmApPJlVgaVixn1shZx8HajV0=
Date: Thu, 06 Aug 2026 19:02:43 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,liumartin@google.com,richardycc@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-fix-release-order-of-locks-in-zs_page_migrate.patch removed from -mm tree
Message-Id: <20260807020243.A9C6E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: fix release order of locks in zs_page_migrate()
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-fix-release-order-of-locks-in-zs_page_migrate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Richard Chang <richardycc@google.com>
Subject: mm/zsmalloc: fix release order of locks in zs_page_migrate()
Date: Tue, 28 Jul 2026 05:53:33 +0000

In zs_page_migrate(), locks are acquired in the following order:
  1. write_lock(&pool->lock)
  2. spin_lock(&class->lock)
  3. zspage_write_trylock(zspage)

However, upon successful page migration, they were being released in
forward acquisition (FIFO) order:
  1. write_unlock(&pool->lock)
  2. spin_unlock(&class->lock)
  3. zspage_write_unlock(zspage)

Fix the unlocking order to release locks in strict reverse (LIFO)
order of acquisition:
  3. zspage_write_unlock(zspage)
  2. spin_unlock(&class->lock)
  1. write_unlock(&pool->lock)

Releasing locks in reverse order of acquisition adheres to standard
kernel locking hygiene, prevents potential lock ordering and lockdep
inconsistencies.

Link: https://lore.kernel.org/20260728055333.421080-1-richardycc@google.com
Signed-off-by: Richard Chang <richardycc@google.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Martin Liu <liumartin@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-fix-release-order-of-locks-in-zs_page_migrate
+++ a/mm/zsmalloc.c
@@ -1926,9 +1926,9 @@ static int zs_page_migrate(struct page *
 	 * Since we complete the data copy and set up new zspage structure,
 	 * it's okay to release migration_lock.
 	 */
-	write_unlock(&pool->lock);
-	spin_unlock(&class->lock);
 	zspage_write_unlock(zspage);
+	spin_unlock(&class->lock);
+	write_unlock(&pool->lock);
 
 	zpdesc_get(newzpdesc);
 	if (zpdesc_zone(newzpdesc) != zpdesc_zone(zpdesc)) {
_

Patches currently in -mm which might be from richardycc@google.com are


