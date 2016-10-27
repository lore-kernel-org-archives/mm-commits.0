From: akpm@linux-foundation.org
Subject: + mm-fixup-get_user_pages-comments.patch added to -mm tree
Date: Wed, 26 Oct 2016 17:13:02 -0700
Message-ID: <5811468e.SgwBpQILeROqnUMt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41645 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935495AbcJ0AND (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Oct 2016 20:13:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lstoakes@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix up get_user_pages* comments
has been added to the -mm tree.  Its filename is
     mm-fixup-get_user_pages-comments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fixup-get_user_pages-comments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fixup-get_user_pages-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-fixup-get_user_pages-comments.patch

