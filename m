From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-introduce-pin_user_pages_unlocked.patch added to
 -mm tree
Date: Mon, 18 May 2020 14:25:07 -0700
Message-ID: <20200518212507.czz1Rs4OA%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726250AbgERVZI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 May 2020 17:25:08 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, awalls@md.metrocast.net, jhubbard@nvidia.com, mchehab@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: introduce pin_user_pages_unlocked
has been added to the -mm tree.  Its filename is
     mm-gup-introduce-pin_user_pages_unlocked.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-gup-introduce-pin_user_pages_unlocked.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-introduce-pin_user_pages_unlocked.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: introduce pin_user_pages_unlocked

Introduce pin_user_pages_unlocked(), which is nearly identical to the
get_user_pages_unlocked() that it wraps, except that it sets FOLL_PIN and
rejects FOLL_GET.

Link: http://lkml.kernel.org/r/20200518012157.1178336-2-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 mm/gup.c           |   17 +++++++++++++++++
 2 files changed, 19 insertions(+)

--- a/include/linux/mm.h~mm-gup-introduce-pin_user_pages_unlocked
+++ a/include/linux/mm.h
@@ -1702,6 +1702,8 @@ long get_user_pages_locked(unsigned long
 		    unsigned int gup_flags, struct page **pages, int *locked);
 long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
 		    struct page **pages, unsigned int gup_flags);
+long pin_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
+		    struct page **pages, unsigned int gup_flags);
 
 int get_user_pages_fast(unsigned long start, int nr_pages,
 			unsigned int gup_flags, struct page **pages);
--- a/mm/gup.c~mm-gup-introduce-pin_user_pages_unlocked
+++ a/mm/gup.c
@@ -2960,3 +2960,20 @@ long pin_user_pages(unsigned long start,
 				     pages, vmas, gup_flags);
 }
 EXPORT_SYMBOL(pin_user_pages);
+
+/*
+ * pin_user_pages_unlocked() is the FOLL_PIN variant of
+ * get_user_pages_unlocked(). Behavior is the same, except that this one sets
+ * FOLL_PIN and rejects FOLL_GET.
+ */
+long pin_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
+			     struct page **pages, unsigned int gup_flags)
+{
+	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
+	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
+		return -EINVAL;
+
+	gup_flags |= FOLL_PIN;
+	return get_user_pages_unlocked(start, nr_pages, pages, gup_flags);
+}
+EXPORT_SYMBOL(pin_user_pages_unlocked);
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup-introduce-pin_user_pages_unlocked.patch
ivtv-convert-get_user_pages-pin_user_pages.patch
