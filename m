From: akpm@linux-foundation.org
Subject: [merged] page-flags-move-code-around.patch removed from -mm tree
Date: Tue, 19 Jan 2016 12:00:43 -0800
Message-ID: <569e95eb.RdHy8tz83RYDUxg/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42402 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932819AbcASUAo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:00:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: page-flags: move code around
has been removed from the -mm tree.  Its filename was
     page-flags-move-code-around.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: page-flags: move code around

The preparation patch: we are going to use compound_head(), PageTail() =
and
PageCompound() to define page-flags helpers.

Let's define them before macros.

We cannot user PageHead() helper in PageCompound() as it's not yet
defined -- use test_bit(PG_head, &page->flags) instead.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: J=E9r=F4me Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   41 +++++++++++++++++------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff -puN include/linux/page-flags.h~page-flags-move-code-around includ=
e/linux/page-flags.h
--- a/include/linux/page-flags.h~page-flags-move-code-around
+++ a/include/linux/page-flags.h
@@ -133,6 +133,27 @@ enum pageflags {
=20
 #ifndef __GENERATING_BOUNDS_H
=20
+struct page;	/* forward declaration */
+
+static inline struct page *compound_head(struct page *page)
+{
+	unsigned long head =3D READ_ONCE(page->compound_head);
+
+	if (unlikely(head & 1))
+		return (struct page *) (head - 1);
+	return page;
+}
+
+static inline int PageTail(struct page *page)
+{
+	return READ_ONCE(page->compound_head) & 1;
+}
+
+static inline int PageCompound(struct page *page)
+{
+	return test_bit(PG_head, &page->flags) || PageTail(page);
+}
+
 /*
  * Macros to create function definitions for page flags
  */
@@ -204,7 +225,6 @@ static inline int __TestClearPage##uname
 #define TESTSCFLAG_FALSE(uname)						\
 	TESTSETFLAG_FALSE(uname) TESTCLEARFLAG_FALSE(uname)
=20
-struct page;	/* forward declaration */
=20
 TESTPAGEFLAG(Locked, locked)
 PAGEFLAG(Error, error) TESTCLEARFLAG(Error, error)
@@ -395,11 +415,6 @@ static inline void set_page_writeback_ke
=20
 __PAGEFLAG(Head, head) CLEARPAGEFLAG(Head, head)
=20
-static inline int PageTail(struct page *page)
-{
-	return READ_ONCE(page->compound_head) & 1;
-}
-
 static inline void set_compound_head(struct page *page, struct page *h=
ead)
 {
 	WRITE_ONCE(page->compound_head, (unsigned long)head + 1);
@@ -410,20 +425,6 @@ static inline void clear_compound_head(s
 	WRITE_ONCE(page->compound_head, 0);
 }
=20
-static inline struct page *compound_head(struct page *page)
-{
-	unsigned long head =3D READ_ONCE(page->compound_head);
-
-	if (unlikely(head & 1))
-		return (struct page *) (head - 1);
-	return page;
-}
-
-static inline int PageCompound(struct page *page)
-{
-	return PageHead(page) || PageTail(page);
