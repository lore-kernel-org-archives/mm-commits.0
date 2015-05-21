From: akpm@linux-foundation.org
Subject: +
 memory-failure-change-type-of-action_results-param-3-to-enum.patch added to -mm tree
Date: Thu, 21 May 2015 16:18:37 -0700
Message-ID: <555e67cd.7NcwBWkp+z9fxwBi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448AbbEUXSi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 May 2015 19:18:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiexiuqi@huawei.com, gong.chen@linux.intel.com, jim.epost@gmail.com, n-horiguchi@ah.jp.nec.com, rostedt@goodmis.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-failure: change type of action_result's param 3 to enum
has been added to the -mm tree.  Its filename is
     memory-failure-change-type-of-action_results-param-3-to-enum.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memory-failure-change-type-of-action_results-param-3-to-enum.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memory-failure-change-type-of-action_results-param-3-to-enum.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xie XiuQi <xiexiuqi@huawei.com>
Subject: memory-failure: change type of action_result's param 3 to enum

Change type of action_result's param 3 to enum for type consistency,
and rename mf_outcome to mf_result for clearly.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Chen Gong <gong.chen@linux.intel.com>
Cc: Jim Davis <jim.epost@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    2 +-
 mm/memory-failure.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/mm.h~memory-failure-change-type-of-action_results-param-3-to-enum include/linux/mm.h
--- a/include/linux/mm.h~memory-failure-change-type-of-action_results-param-3-to-enum
+++ a/include/linux/mm.h
@@ -2163,7 +2163,7 @@ extern int soft_offline_page(struct page
 /*
  * Error handlers for various types of pages.
  */
-enum mf_outcome {
+enum mf_result {
 	MF_IGNORED,	/* Error: cannot be handled */
 	MF_FAILED,	/* Error: handling failed */
 	MF_DELAYED,	/* Will be handled later */
diff -puN mm/memory-failure.c~memory-failure-change-type-of-action_results-param-3-to-enum mm/memory-failure.c
--- a/mm/memory-failure.c~memory-failure-change-type-of-action_results-param-3-to-enum
+++ a/mm/memory-failure.c
@@ -852,7 +852,8 @@ static struct page_state {
  * "Dirty/Clean" indication is not 100% accurate due to the possibility of
  * setting PG_dirty outside page lock. See also comment above set_page_dirty().
  */
-static void action_result(unsigned long pfn, enum mf_action_page_type type, int result)
+static void action_result(unsigned long pfn, enum mf_action_page_type type,
+			  enum mf_result result)
 {
 	pr_err("MCE %#lx: recovery action for %s: %s\n",
 		pfn, action_page_types[type], action_name[result]);
_

Patches currently in -mm which might be from xiexiuqi@huawei.com are

memory-failure-export-page_type-and-action-result.patch
memory-failure-change-type-of-action_results-param-3-to-enum.patch
tracing-add-trace-event-for-memory-failure.patch
tracing-add-trace-event-for-memory-failure-fix.patch

