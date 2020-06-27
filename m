From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] lib-fix-test_hmmc-reference-after-free.patch
 removed from -mm tree
Date: Fri, 26 Jun 2020 20:33:20 -0700
Message-ID: <20200627033320.4pTifGPM2%akpm@linux-foundation.org>
References: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbgF0DdV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Jun 2020 23:33:21 -0400
In-Reply-To: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, mm-commits@vger.kernel.org, rcampbell@nvidia.com, rdunlap@infradead.org


The patch titled
     Subject: lib: fix test_hmm.c reference after free
has been removed from the -mm tree.  Its filename was
     lib-fix-test_hmmc-reference-after-free.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Randy Dunlap <rdunlap@infradead.org>
Subject: lib: fix test_hmm.c reference after free

Coccinelle scripts report the following errors:

lib/test_hmm.c:523:20-26: ERROR: reference preceded by free on line 521
lib/test_hmm.c:524:21-27: ERROR: reference preceded by free on line 521
lib/test_hmm.c:523:28-35: ERROR: devmem is NULL but dereferenced.
lib/test_hmm.c:524:29-36: ERROR: devmem is NULL but dereferenced.

Fix these by using the local variable 'res' instead of devmem.

Link: http://lkml.kernel.org/r/c845c158-9c65-9665-0d0b-00342846dd07@infrade=
ad.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/test_hmm.c~lib-fix-test_hmmc-reference-after-free
+++ a/lib/test_hmm.c
@@ -520,8 +520,7 @@ static bool dmirror_allocate_chunk(struc
 err_free:
 	kfree(devmem);
 err_release:
-	release_mem_region(devmem->pagemap.res.start,
-			   resource_size(&devmem->pagemap.res));
+	release_mem_region(res->start, resource_size(res));
 err:
 	mutex_unlock(&mdevice->devmem_lock);
 	return false;
_

Patches currently in -mm which might be from rdunlap@infradead.org are
