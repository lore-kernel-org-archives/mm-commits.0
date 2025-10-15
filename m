Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0149D3254BD
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 20:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760560242; cv=none; b=D6gHhh7XZV2cnoJmXruNqa9QxWlaROxz+WNObuz3RKY9NTa8cimwbWLr19myQgIGOKVF4dA5BPZRxv5+mkzPN+AVPxcR4dqrLkpYNPxFzbtm44gQhaS5wOei6ySOIY2oRnY/N2ECAa1qXYTnIXlamhfczdLzIgR+rC3CBvvbwNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760560242; c=relaxed/simple;
	bh=O3kHum6rX4etOc9WGqpiZj4N4ApteNBU0PwsXpfMwJk=;
	h=Date:To:From:Subject:Message-Id; b=UMOWT6HUI+jmtK0piJXShp05rlCmBnEy/Wmjyd3e9OM694FH96dXadbR2gufVt4ZYF1ZT8sx0aEJvTEV/yb62jvYtXAm+pf7PFU68rEKwVdj3AAc4wInUY8YmxmV8kuaZVmTeQ8Rff+pjGGlrMj0Tpo4TGPcrra+5My2b/+TcTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i6q3AEqs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i6q3AEqs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B02C4CEF8;
	Wed, 15 Oct 2025 20:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760560241;
	bh=O3kHum6rX4etOc9WGqpiZj4N4ApteNBU0PwsXpfMwJk=;
	h=Date:To:From:Subject:From;
	b=i6q3AEqsc1JwbL2jrUIog2ah9kja1T0+MAlVHff6dxQz0LODLDCyiM2rxT2OX7wa1
	 mAnu9bnkbhGLvFB59yfYKQcQoVlvVvHPqOtAi5u4g4PPoXd66vQUT61yNjIP0eWAo4
	 EMHdb3Gvyge8wl1+A+IKI+mgPdlS3l/7NXjCB8x8=
Date: Wed, 15 Oct 2025 13:30:40 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,usamaarif642@gmail.com,sj@kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,kas@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,axelrasmussen@google.com,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-skip-folio_activate-for-mlocked-folios.patch removed from -mm tree
Message-Id: <20251015203041.52B02C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: skip folio_activate() for mlocked folios
has been removed from the -mm tree.  Its filename was
     mm-skip-folio_activate-for-mlocked-folios.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Dmitry Ilvokhin <d@ilvokhin.com>
Subject: mm: skip folio_activate() for mlocked folios
Date: Mon, 6 Oct 2025 13:25:26 +0000

__mlock_folio() does not move folio to unevicable LRU, when
folio_activate() removes folio from LRU.

The user-visible effect is that we unnecessary postpone moving pages to
unevictable LRU that lead to unexpected stats: Mlocked > Unevictable.

To prevent this case also check for folio_test_mlocked() in
folio_mark_accessed().  If folio is not yet marked as unevictable, but
already marked as mlocked, then skip folio_activate() call to allow
__mlock_folio() to make all necessary updates.  It should be safe to skip
folio_activate() here, because mlocked folio should end up in unevictable
LRU eventually anyway.

To observe the problem mmap() and mlock() big file and check Unevictable
and Mlocked values from /proc/meminfo.  On freshly booted system without
any other mlocked memory we expect them to match or be quite close.

See below for more detailed reproduction steps.  Source code of stat.c is
available at [1].

  $ head -c 8G < /dev/urandom > /tmp/random.bin

  $ cc -pedantic -Wall -std=c99 stat.c -O3 -o /tmp/stat
  $ /tmp/stat
  Unevictable:     8389668 kB
  Mlocked:         8389700 kB

  Need to run binary twice. Problem does not reproduce on the first run,
  but always reproduces on the second run.

  $ /tmp/stat
  Unevictable:     5374676 kB
  Mlocked:         8389332 kB

Link: https://lkml.kernel.org/r/aOPDRmk2Zd20qxfk@shell.ilvokhin.com
Link: https://gist.github.com/ilvokhin/e50c3d2ff5d9f70dcbb378c6695386dd [1]
Co-developed-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Acked-by: Usama Arif <usamaarif642@gmail.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/swap.c~mm-skip-folio_activate-for-mlocked-folios
+++ a/mm/swap.c
@@ -469,6 +469,16 @@ void folio_mark_accessed(struct folio *f
 		 * this list is never rotated or maintained, so marking an
 		 * unevictable page accessed has no effect.
 		 */
+	} else if (folio_test_mlocked(folio)) {
+		/*
+		 * Pages that are mlocked, but not yet on unevictable LRU.
+		 * They might be still in mlock_fbatch waiting to be processed
+		 * and activating it here might interfere with
+		 * mlock_folio_batch(). __mlock_folio() will fail
+		 * folio_test_clear_lru() check and give up. It happens because
+		 * __folio_batch_add_and_move() clears LRU flag, when adding
+		 * folio to activate batch.
+		 */
 	} else if (!folio_test_active(folio)) {
 		/*
 		 * If the folio is on the LRU, queue it for activation via
_

Patches currently in -mm which might be from d@ilvokhin.com are


