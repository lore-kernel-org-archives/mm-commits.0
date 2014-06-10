From: akpm@linux-foundation.org
Subject: +
 fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values.patch
 added to -mm tree
Date: Tue, 10 Jun 2014 15:56:01 -0700
Message-ID: <53978d01.nDn1dx6HpQGnX2Ou%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40792 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbaFJW4C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jun 2014 18:56:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dhowells@redhat.com, fabf@skynet.be

Subject: + fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values.patch added to -mm tree
To: fabf@skynet.be,dhowells@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 10 Jun 2014 15:56:01 -0700


The patch titled
     Subject: fs/cachefiles/daemon.c: remove unnecessary tests on unsigned values
has been added to the -mm tree.  Its filename is
     fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/cachefiles/daemon.c: remove unnecessary tests on unsigned values

size_t and unsigned long values are never < 0

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cachefiles/daemon.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/cachefiles/daemon.c~fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values fs/cachefiles/daemon.c
--- a/fs/cachefiles/daemon.c~fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values
+++ a/fs/cachefiles/daemon.c
@@ -222,7 +222,7 @@ static ssize_t cachefiles_daemon_write(s
 	if (test_bit(CACHEFILES_DEAD, &cache->flags))
 		return -EIO;
 
-	if (datalen < 0 || datalen > PAGE_SIZE - 1)
+	if (datalen > PAGE_SIZE - 1)
 		return -EOPNOTSUPP;
 
 	/* drag the command string into the kernel so we can parse it */
@@ -385,7 +385,7 @@ static int cachefiles_daemon_fstop(struc
 	if (args[0] != '%' || args[1] != '\0')
 		return -EINVAL;
 
-	if (fstop < 0 || fstop >= cache->fcull_percent)
+	if (fstop >= cache->fcull_percent)
 		return cachefiles_daemon_range_error(cache, args);
 
 	cache->fstop_percent = fstop;
@@ -457,7 +457,7 @@ static int cachefiles_daemon_bstop(struc
 	if (args[0] != '%' || args[1] != '\0')
 		return -EINVAL;
 
-	if (bstop < 0 || bstop >= cache->bcull_percent)
+	if (bstop >= cache->bcull_percent)
 		return cachefiles_daemon_range_error(cache, args);
 
 	cache->bstop_percent = bstop;
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid.patch
fs-isofs-logging-clean-up.patch
fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch

