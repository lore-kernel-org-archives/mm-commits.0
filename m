From: akpm@linux-foundation.org
Subject: [patch 044/123] mm: fix up get_user_pages* comments
Date: Mon, 12 Dec 2016 16:42:46 -0800
Message-ID: <584f4406.nw1PmHebG/nsFOiE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40990 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752885AbcLMAmr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:42:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, lstoakes@gmail.com, mhocko@suse.com

From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm: fix up get_user_pages* comments

In the previous round of get_user_pages* changes comments attached to
__get_user_pages_unlocked() and get_user_pages_unlocked() were rendered
incorrect, this patch corrects them.

In addition the get_user_pages_unlocked() comment seems to have already
been outdated as it referred to tsk, mm parameters which were removed in
c12d2da5 ("mm/gup: Remove the macro overload API migration helpers from
the get_user*() APIs"), this patch fixes this also.

Link: http://lkml.kernel.org/r/20161025233435.5338-1-lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff -puN mm/gup.c~mm-fixup-get_user_pages-comments mm/gup.c
--- a/mm/gup.c~mm-fixup-get_user_pages-comments
+++ a/mm/gup.c
@@ -858,14 +858,12 @@ long get_user_pages_locked(unsigned long
 EXPORT_SYMBOL(get_user_pages_locked);
 
 /*
- * Same as get_user_pages_unlocked(...., FOLL_TOUCH) but it allows to
- * pass additional gup_flags as last parameter (like FOLL_HWPOISON).
+ * Same as get_user_pages_unlocked(...., FOLL_TOUCH) but it allows for
+ * tsk, mm to be specified.
  *
  * NOTE: here FOLL_TOUCH is not set implicitly and must be set by the
- * caller if required (just like with __get_user_pages). "FOLL_GET",
- * "FOLL_WRITE" and "FOLL_FORCE" are set implicitly as needed
- * according to the parameters "pages", "write", "force"
- * respectively.
+ * caller if required (just like with __get_user_pages). "FOLL_GET"
+ * is set implicitly if "pages" is non-NULL.
  */
 __always_inline long __get_user_pages_unlocked(struct task_struct *tsk, struct mm_struct *mm,
 					       unsigned long start, unsigned long nr_pages,
@@ -895,10 +893,8 @@ EXPORT_SYMBOL(__get_user_pages_unlocked)
  *      get_user_pages_unlocked(tsk, mm, ..., pages);
  *
  * It is functionally equivalent to get_user_pages_fast so
- * get_user_pages_fast should be used instead, if the two parameters
- * "tsk" and "mm" are respectively equal to current and current->mm,
- * or if "force" shall be set to 1 (get_user_pages_fast misses the
- * "force" parameter).
+ * get_user_pages_fast should be used instead if specific gup_flags
+ * (e.g. FOLL_FORCE) are not required.
  */
 long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
 			     struct page **pages, unsigned int gup_flags)
_
