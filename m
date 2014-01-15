From: akpm@linux-foundation.org
Subject: +
 mm-make-setpage_address-static-inline-if-want_page_virtual.patch added to
 -mm tree
Date: Wed, 15 Jan 2014 12:53:57 -0800
Message-ID: <52d6f565.ITU0QZK+Y/gyDNw4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43326 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbaAOUx5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jan 2014 15:53:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mst@redhat.com, linux@roeck-us.net, geert@linux-m68k.org

Subject: + mm-make-setpage_address-static-inline-if-want_page_virtual.patch added to -mm tree
To: geert@linux-m68k.org,linux@roeck-us.net,mst@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 15 Jan 2014 12:53:57 -0800


The patch titled
     Subject: mm: Make {,set}page_address() static inline if WANT_PAGE_VIRTUAL
has been added to the -mm tree.  Its filename is
     mm-make-setpage_address-static-inline-if-want_page_virtual.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-make-setpage_address-static-inline-if-want_page_virtual.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-make-setpage_address-static-inline-if-want_page_virtual.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: mm: Make {,set}page_address() static inline if WANT_PAGE_VIRTUAL

{,set}page_address() are macros if WANT_PAGE_VIRTUAL.  If
!WANT_PAGE_VIRTUAL, they're plain C functions.

If someone calls them with a void *, this pointer is auto-converted to
struct page * if !WANT_PAGE_VIRTUAL, but causes a build failure on
architectures using WANT_PAGE_VIRTUAL (arc, m68k and sparc):

drivers/md/bcache/bset.c: In function `__btree_sort':
drivers/md/bcache/bset.c:1190: warning: dereferencing `void *' pointer
drivers/md/bcache/bset.c:1190: error: request for member `virtual' in something not a structure or union

Convert them to static inline functions to fix this.  There are already
plenty of users of struct page members inside <linux/mm.h>, so there's no
reason to keep them as macros.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN include/linux/mm.h~mm-make-setpage_address-static-inline-if-want_page_virtual include/linux/mm.h
--- a/include/linux/mm.h~mm-make-setpage_address-static-inline-if-want_page_virtual
+++ a/include/linux/mm.h
@@ -846,11 +846,14 @@ static __always_inline void *lowmem_page
 #endif
 
 #if defined(WANT_PAGE_VIRTUAL)
-#define page_address(page) ((page)->virtual)
-#define set_page_address(page, address)			\
-	do {						\
-		(page)->virtual = (address);		\
-	} while(0)
+static inline void *page_address(const struct page *page)
+{
+	return page->virtual;
+}
+static inline void set_page_address(struct page *page, void *address)
+{
+	page->virtual = address;
+}
 #define page_address_init()  do { } while(0)
 #endif
 
_

Patches currently in -mm which might be from geert@linux-m68k.org are

mm-make-setpage_address-static-inline-if-want_page_virtual.patch
asm-typesh-remove-include-asm-generic-int-l64h.patch
maintainers-add-an-entry-for-the-macintosh-hfsplus-filesystem.patch
init-mainc-remove-unused-declaration-of-tc_init.patch
rtc-rtc-cmos-remove-superfluous-name-cast.patch
rtc-disable-rtc_drv_cmos-on-atari.patch
drivers-rtc-rtc-s5mc-s5m_rtc_suspendresume-should-depend-on-config_pm_sleep.patch
proc-cleanup-simplify-get_task_state-task_state_array.patch
linux-next.patch

