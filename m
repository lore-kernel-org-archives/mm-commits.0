From: akpm@linux-foundation.org
Subject: + mm-add-documentation-for-page-fragment-apis.patch added to -mm
 tree
Date: Thu, 05 Jan 2017 16:00:15 -0800
Message-ID: <586ede0f.Wjugoa8Q2lDpvsod%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35228 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966796AbdAFAgm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2017 19:36:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.h.duyck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add documentation for page fragment APIs
has been added to the -mm tree.  Its filename is
     mm-add-documentation-for-page-fragment-apis.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-documentation-for-page-fragment-apis.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-documentation-for-page-fragment-apis.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: mm: add documentation for page fragment APIs

This is a first pass at trying to add documentation for the page_frag
APIs.  They may still change over time but for now I thought I would try
to get these documented so that as more network drivers and stack calls
make use of them we have one central spot to document how they are meant
to be used.

Link: http://lkml.kernel.org/r/20170104024157.13451.6758.stgit@localhost.localdomain
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_frags |   42 ++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff -puN /dev/null Documentation/vm/page_frags
--- /dev/null
+++ a/Documentation/vm/page_frags
@@ -0,0 +1,42 @@
+Page fragments
+--------------
+
+A page fragment is an arbitrary-length arbitrary-offset area of memory
+which resides within a 0 or higher order compound page.  Multiple
+fragments within that page are individually refcounted, in the page's
+reference counter.
+
+The page_frag functions, page_frag_alloc and page_frag_free, provide a
+simple allocation framework for page fragments.  This is used by the
+network stack and network device drivers to provide a backing region of
+memory for use as either an sk_buff->head, or to be used in the "frags"
+portion of skb_shared_info.
+
+In order to make use of the page fragment APIs a backing page fragment
+cache is needed.  This provides a central point for the fragment allocation
+and tracks allows multiple calls to make use of a cached page.  The
+advantage to doing this is that multiple calls to get_page can be avoided
+which can be expensive at allocation time.  However due to the nature of
+this caching it is required that any calls to the cache be protected by
+either a per-cpu limitation, or a per-cpu limitation and forcing interrupts
+to be disabled when executing the fragment allocation.
+
+The network stack uses two separate caches per CPU to handle fragment
+allocation.  The netdev_alloc_cache is used by callers making use of the
+__netdev_alloc_frag and __netdev_alloc_skb calls.  The napi_alloc_cache is
+used by callers of the __napi_alloc_frag and __napi_alloc_skb calls.  The
+main difference between these two calls is the context in which they may be
+called.  The "netdev" prefixed functions are usable in any context as these
+functions will disable interrupts, while the "napi" prefixed functions are
+only usable within the softirq context.
+
+Many network device drivers use a similar methodology for allocating page
+fragments, but the page fragments are cached at the ring or descriptor
+level.  In order to enable these cases it is necessary to provide a generic
+way of tearing down a page cache.  For this reason __page_frag_cache_drain
+was implemented.  It allows for freeing multiple references from a single
+page via a single call.  The advantage to doing this is that it allows for
+cleaning up the multiple references that were added to a page in order to
+avoid calling get_page per allocation.
+
+Alexander Duyck, Nov 29, 2016.
_

Patches currently in -mm which might be from alexander.h.duyck@intel.com are

mm-rename-__alloc_page_frag-to-page_frag_alloc-and-__free_page_frag-to-page_frag_free.patch
mm-rename-__page_frag-functions-to-__page_frag_cache-drop-order-from-drain.patch
mm-add-documentation-for-page-fragment-apis.patch

