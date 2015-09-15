From: akpm@linux-foundation.org
Subject: +
 userfaultfd-selftest-dont-error-out-if-pthread_mutex_t-isnt-identical.patch added to -mm tree
Date: Tue, 15 Sep 2015 13:04:43 -0700
Message-ID: <55f879db.itjRd3TgBec47W2S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37032 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbbIOUEo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Sep 2015 16:04:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dgilbert@redhat.com, mpe@ellerman.id.au, shuahkh@osg.samsung.com, treding@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: selftest: don't error out if pthread_mutex_t isn't identical
has been added to the -mm tree.  Its filename is
     userfaultfd-selftest-dont-error-out-if-pthread_mutex_t-isnt-identical.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-selftest-dont-error-out-if-pthread_mutex_t-isnt-identical.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-selftest-dont-error-out-if-pthread_mutex_t-isnt-identical.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: selftest: don't error out if pthread_mutex_t isn't identical

On ppc big endian this check fails, the mutex doesn't necessarily need to
be identical for all pages after pthread_mutex_lock/unlock cycles.  The
count verification (outside of the pthread_mutex_t structure) suffices and
that is retained.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Thierry Reding <treding@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftest-dont-error-out-if-pthread_mutex_t-isnt-identical tools/testing/selftests/vm/userfaultfd.c
--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftest-dont-error-out-if-pthread_mutex_t-isnt-identical
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -580,15 +580,6 @@ static int userfaultfd_stress(void)
 		/* verification */
 		if (bounces & BOUNCE_VERIFY) {
 			for (nr = 0; nr < nr_pages; nr++) {
-				if (my_bcmp(area_dst,
-					    area_dst + nr * page_size,
-					    sizeof(pthread_mutex_t))) {
-					fprintf(stderr,
-						"error mutex %lu\n",
-						nr);
-					err = 1;
-					bounces = 0;
-				}
 				if (*area_count(area_dst, nr) != count_verify[nr]) {
 					fprintf(stderr,
 						"error area_count %Lu %Lu %lu\n",
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-revert-userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key.patch
userfaultfd-selftest-headers-fixup.patch
userfaultfd-selftest-avoid-my_bcmp-false-positives-with-powerpc.patch
userfaultfd-selftest-return-an-error-if-bounce_verify-fails.patch
userfaultfd-selftest-dont-error-out-if-pthread_mutex_t-isnt-identical.patch

