Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A17A3A1D2
	for <mm-commits@vger.kernel.org>; Tue,  7 Oct 2025 22:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759877516; cv=none; b=QUQyDDGUauzve9pdaHiMSMRUx0TreE7HzT6fof4zHn7Our43iGPMsncNMnjEpm5E8wm7RZHG0sD0LGw9IiKYASoO632FbUrpTFwY4VBuR3AYXNKJeAPLCqrFxW9SHiPLFWzIJCO4TN9u3oTq13Pqv6z56kCJqoL3PWFbWTxWaYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759877516; c=relaxed/simple;
	bh=gEB4sZb2gMD97tOa9oy0WK9GhAjOM+0HeAiWS51QFmw=;
	h=Date:To:From:Subject:Message-Id; b=NNBDHrgR0/AyYoHUJMJmwjn+YY5YBzyB+dPWJ/MlYoxNyd5vDSDr0O52//0kwOHeBL4S/hY1erGv0GSV51D6Ds5eeZXEqaMKG8g3j31ddEN4B93WY7x2kZP3LbABjBNdnBmxz7sOFpLeAHHbsFOlk08BLCpZuimjT2iJhGSXhwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rJ7CfvgR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rJ7CfvgR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862E4C4CEF1;
	Tue,  7 Oct 2025 22:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759877515;
	bh=gEB4sZb2gMD97tOa9oy0WK9GhAjOM+0HeAiWS51QFmw=;
	h=Date:To:From:Subject:From;
	b=rJ7CfvgR26jeJ06s1frrYuXuwzpGULDLPgbX0gIVoKx1GTDB4tsRXjTT4MF6KJFuj
	 PY3k8c+ECBjH9lMNH/PWybkTiDeaKUoSogEGSjTdUoo/Ci0asYbhERzbx6aKqc7s0Q
	 VG0Y96jHTIim1EJWpj5TQGaaDz6z6WfmL2CKK2nQ=
Date: Tue, 07 Oct 2025 15:51:55 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,usamaarif642@gmail.com,sj@kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,kas@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,axelrasmussen@google.com,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-skip-folio_activate-for-mlocked-folios.patch added to mm-hotfixes-unstable branch
Message-Id: <20251007225155.862E4C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: skip folio_activate() for mlocked folios
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-skip-folio_activate-for-mlocked-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-skip-folio_activate-for-mlocked-folios.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Dmitry Ilvokhin <d@ilvokhin.com>
Subject: mm: skip folio_activate() for mlocked folios
Date: Mon, 6 Oct 2025 13:25:26 +0000

__mlock_folio() does not move folio to unevicable LRU, when
folio_activate() removes folio from LRU.

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

mm-skip-folio_activate-for-mlocked-folios.patch

