From: akpm@linux-foundation.org
Subject: +
 mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
 added to -mm tree
Date: Tue, 10 Jun 2014 15:41:27 -0700
Message-ID: <53978997.0n1BwlkWoZUURLnj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40671 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaFJWl2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jun 2014 18:41:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fengguang.wu@intel.com, fabf@skynet.be

Subject: + mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch added to -mm tree
To: fabf@skynet.be,fengguang.wu@intel.com
From: akpm@linux-foundation.org
Date: Tue, 10 Jun 2014 15:41:27 -0700


The patch titled
     Subject: mm/readahead.c: remove unused file_ra_state from count_history_pages
has been added to the -mm tree.  Its filename is
     mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch

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
Subject: mm/readahead.c: remove unused file_ra_state from count_history_pages

count_history_pages does only call page_cache_prev_hole in rcu_lock
context using address_space mapping.  There's no need to have
file_ra_state here.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/readahead.c~mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages mm/readahead.c
--- a/mm/readahead.c~mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages
+++ a/mm/readahead.c
@@ -326,7 +326,6 @@ static unsigned long get_next_ra_size(st
  * 	- thrashing threshold in memory tight systems
  */
 static pgoff_t count_history_pages(struct address_space *mapping,
-				   struct file_ra_state *ra,
 				   pgoff_t offset, unsigned long max)
 {
 	pgoff_t head;
@@ -349,7 +348,7 @@ static int try_context_readahead(struct
 {
 	pgoff_t size;
 
-	size = count_history_pages(mapping, ra, offset, max);
+	size = count_history_pages(mapping, offset, max);
 
 	/*
 	 * not enough history pages:
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch

