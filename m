From: akpm@linux-foundation.org
Subject: + force-inlining-of-selected-page-flag-modifications.patch added
 to -mm tree
Date: Mon, 08 Feb 2016 16:29:49 -0800
Message-ID: <56b932fd.fvcXru2+7E9Le9GG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53560 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbcBIA3u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2016 19:29:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvlasenk@redhat.com, mingo@kernel.org, peterz@infradead.org, rientjes@google.com, tgraf@suug.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/page-flags.h: force inlining of selected page flag modifications
has been added to the -mm tree.  Its filename is
     force-inlining-of-selected-page-flag-modifications.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/force-inlining-of-selected-page-flag-modifications.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/force-inlining-of-selected-page-flag-modifications.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Denys Vlasenko <dvlasenk@redhat.com>
Subject: include/linux/page-flags.h: force inlining of selected page flag modifications

Sometimes gcc mysteriously doesn't inline
very small functions we expect to be inlined. See
    https://gcc.gnu.org/bugzilla/show_bug.cgi?id=66122

With this .config:
http://busybox.net/~vda/kernel_config_OPTIMIZE_INLINING_and_Os,
the following functions get deinlined many times.
Examples of disassembly:

<SetPageUptodate> (43 copies, 141 calls):
       55                      push   %rbp
       48 89 e5                mov    %rsp,%rbp
       f0 80 0f 08             lock orb $0x8,(%rdi)
       5d                      pop    %rbp
       c3                      retq

<PagePrivate> (10 copies, 134 calls):
       48 8b 07                mov    (%rdi),%rax
       55                      push   %rbp
       48 89 e5                mov    %rsp,%rbp
       48 c1 e8 0b             shr    $0xb,%rax
       83 e0 01                and    $0x1,%eax
       5d                      pop    %rbp
       c3                      retq

This patch fixes this via s/inline/__always_inline/.

Code size decrease after the patch is ~7k:

    text     data      bss       dec     hex filename
92125002 20826048 36417536 149368586 8e72f0a vmlinux
92118087 20826112 36417536 149361735 8e71447 vmlinux7_pageops_after

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Graf <tgraf@suug.ch>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff -puN include/linux/page-flags.h~force-inlining-of-selected-page-flag-modifications include/linux/page-flags.h
--- a/include/linux/page-flags.h~force-inlining-of-selected-page-flag-modifications
+++ a/include/linux/page-flags.h
@@ -144,12 +144,12 @@ static inline struct page *compound_head
 	return page;
 }
 
-static inline int PageTail(struct page *page)
+static __always_inline int PageTail(struct page *page)
 {
 	return READ_ONCE(page->compound_head) & 1;
 }
 
-static inline int PageCompound(struct page *page)
+static __always_inline int PageCompound(struct page *page)
 {
 	return test_bit(PG_head, &page->flags) || PageTail(page);
 }
@@ -184,31 +184,31 @@ static inline int PageCompound(struct pa
  * Macros to create function definitions for page flags
  */
 #define TESTPAGEFLAG(uname, lname, policy)				\
-static inline int Page##uname(struct page *page)			\
+static __always_inline int Page##uname(struct page *page)		\
 	{ return test_bit(PG_##lname, &policy(page, 0)->flags); }
 
 #define SETPAGEFLAG(uname, lname, policy)				\
-static inline void SetPage##uname(struct page *page)			\
+static __always_inline void SetPage##uname(struct page *page)		\
 	{ set_bit(PG_##lname, &policy(page, 1)->flags); }
 
 #define CLEARPAGEFLAG(uname, lname, policy)				\
-static inline void ClearPage##uname(struct page *page)			\
+static __always_inline void ClearPage##uname(struct page *page)		\
 	{ clear_bit(PG_##lname, &policy(page, 1)->flags); }
 
 #define __SETPAGEFLAG(uname, lname, policy)				\
-static inline void __SetPage##uname(struct page *page)			\
+static __always_inline void __SetPage##uname(struct page *page)		\
 	{ __set_bit(PG_##lname, &policy(page, 1)->flags); }
 
 #define __CLEARPAGEFLAG(uname, lname, policy)				\
-static inline void __ClearPage##uname(struct page *page)		\
+static __always_inline void __ClearPage##uname(struct page *page)	\
 	{ __clear_bit(PG_##lname, &policy(page, 1)->flags); }
 
 #define TESTSETFLAG(uname, lname, policy)				\
-static inline int TestSetPage##uname(struct page *page)			\
+static __always_inline int TestSetPage##uname(struct page *page)	\
 	{ return test_and_set_bit(PG_##lname, &policy(page, 1)->flags); }
 
 #define TESTCLEARFLAG(uname, lname, policy)				\
-static inline int TestClearPage##uname(struct page *page)		\
+static __always_inline int TestClearPage##uname(struct page *page)	\
 	{ return test_and_clear_bit(PG_##lname, &policy(page, 1)->flags); }
 
 #define PAGEFLAG(uname, lname, policy)					\
@@ -371,7 +371,7 @@ PAGEFLAG(Idle, idle, PF_ANY)
 #define PAGE_MAPPING_KSM	2
 #define PAGE_MAPPING_FLAGS	(PAGE_MAPPING_ANON | PAGE_MAPPING_KSM)
 
-static inline int PageAnon(struct page *page)
+static __always_inline int PageAnon(struct page *page)
 {
 	page = compound_head(page);
 	return ((unsigned long)page->mapping & PAGE_MAPPING_ANON) != 0;
@@ -384,7 +384,7 @@ static inline int PageAnon(struct page *
  * is found in VM_MERGEABLE vmas.  It's a PageAnon page, pointing not to any
  * anon_vma, but to that page's node of the stable tree.
  */
-static inline int PageKsm(struct page *page)
+static __always_inline int PageKsm(struct page *page)
 {
 	page = compound_head(page);
 	return ((unsigned long)page->mapping & PAGE_MAPPING_FLAGS) ==
@@ -415,14 +415,14 @@ static inline int PageUptodate(struct pa
 	return ret;
 }
 
-static inline void __SetPageUptodate(struct page *page)
+static __always_inline void __SetPageUptodate(struct page *page)
 {
 	VM_BUG_ON_PAGE(PageTail(page), page);
 	smp_wmb();
 	__set_bit(PG_uptodate, &page->flags);
 }
 
-static inline void SetPageUptodate(struct page *page)
+static __always_inline void SetPageUptodate(struct page *page)
 {
 	VM_BUG_ON_PAGE(PageTail(page), page);
 	/*
@@ -456,12 +456,12 @@ static inline void set_page_writeback_ke
 
 __PAGEFLAG(Head, head, PF_ANY) CLEARPAGEFLAG(Head, head, PF_ANY)
 
-static inline void set_compound_head(struct page *page, struct page *head)
+static __always_inline void set_compound_head(struct page *page, struct page *head)
 {
 	WRITE_ONCE(page->compound_head, (unsigned long)head + 1);
 }
 
-static inline void clear_compound_head(struct page *page)
+static __always_inline void clear_compound_head(struct page *page)
 {
 	WRITE_ONCE(page->compound_head, 0);
 }
_

Patches currently in -mm which might be from dvlasenk@redhat.com are

bufferhead-force-inlining-of-buffer-head-flag-operations.patch
force-inlining-of-selected-page-flag-modifications.patch
asm-generic-force-inlining-of-some-atomic_long-operations.patch
force-inlining-of-some-byteswap-operations.patch
force-inlining-of-unaligned-byteswap-operations.patch

