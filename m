From: akpm@linux-foundation.org
Subject: +
 mm-memory-failurec-define-page-types-for-action_result-in-one-place-v3.patch added to -mm tree
Date: Thu, 26 Mar 2015 12:38:52 -0700
Message-ID: <5514604c.VJ/BIdfB0djBTfcc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbbCZTix (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Mar 2015 15:38:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory-failurec-define-page-types-for-action_result-in-one-place-v3
has been added to the -mm tree.  Its filename is
     mm-memory-failurec-define-page-types-for-action_result-in-one-place-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failurec-define-page-types-for-action_result-in-one-place-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failurec-define-page-types-for-action_result-in-one-place-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm-memory-failurec-define-page-types-for-action_result-in-one-place-v3

ChangeLog v2 -> v3:
- rename action_page_type to action_page_types
- rename enum page_type to enum action_page_type

ChangeLog v1 -> v2:
- fix DIRTY_UNEVICTABLE_LRU typo
- adding "MSG_" prefix to each enum value
- use declaration with type "enum page_type" instead of int
- define action_type_type as "static const char * const" (not "static const=
 char *")

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/memory-failure.c~mm-memory-failurec-define-page-types-for-action_result-in-one-place-v3 mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failurec-define-page-types-for-action_result-in-one-place-v3
+++ a/mm/memory-failure.c
@@ -521,7 +521,7 @@ static const char *action_name[] = {
 	[RECOVERED] = "Recovered",
 };
 
-enum page_type {
+enum action_page_type {
 	MSG_KERNEL,
 	MSG_KERNEL_HIGH_ORDER,
 	MSG_SLAB,
@@ -544,7 +544,7 @@ enum page_type {
 	MSG_UNKNOWN,
 };
 
-static const char *action_page_type[] = {
+static const char * const action_page_types[] = {
 	[MSG_KERNEL]			= "reserved kernel page",
 	[MSG_KERNEL_HIGH_ORDER]		= "high-order kernel page",
 	[MSG_SLAB]			= "kernel slab page",
@@ -823,7 +823,7 @@ static int me_huge_page(struct page *p,
 static struct page_state {
 	unsigned long mask;
 	unsigned long res;
-	int type;
+	enum action_page_type type;
 	int (*action)(struct page *p, unsigned long pfn);
 } error_states[] = {
 	{ reserved,	reserved,	MSG_KERNEL,	me_kernel },
@@ -881,10 +881,10 @@ static struct page_state {
  * "Dirty/Clean" indication is not 100% accurate due to the possibility of
  * setting PG_dirty outside page lock. See also comment above set_page_dirty().
  */
-static void action_result(unsigned long pfn, int type, int result)
+static void action_result(unsigned long pfn, enum action_page_type type, int result)
 {
 	pr_err("MCE %#lx: recovery action for %s: %s\n",
-		pfn, action_page_type[type], action_name[result]);
+		pfn, action_page_types[type], action_name[result]);
 }
 
 static int page_action(struct page_state *ps, struct page *p,
@@ -901,7 +901,7 @@ static int page_action(struct page_state
 	if (count != 0) {
 		printk(KERN_ERR
 		       "MCE %#lx: %s still referenced by %d users\n",
-		       pfn, action_page_type[ps->type], count);
+		       pfn, action_page_types[ps->type], count);
 		result = FAILED;
 	}
 	action_result(pfn, ps->type, result);
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
mm-refactor-do_wp_page-extract-the-reuse-case.patch
mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch
mm-refactor-do_wp_page-extract-the-page-copy-flow.patch
mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch
mm-mempolicy-migrate_to_node-should-only-migrate-to-node.patch
mm-hugetlb-abort-__get_user_pages-if-current-has-been-oom-killed.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place-v3.patch
mm-consolidate-all-page-flags-helpers-in-linux-page-flagsh.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

