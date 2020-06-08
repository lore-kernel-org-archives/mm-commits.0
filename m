From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 17/54] mm/gup: update pin_user_pages.rst for "case
 3" (mmu notifiers)
Date: Sun, 07 Jun 2020 21:40:59 -0700
Message-ID: <20200608044059.8aZSEkI9C%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgFHElA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:41:00 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, corbet@lwn.net, daniel@ffwll.ch, david@fromorbit.com, jack@suse.cz, jglisse@redhat.com, jhubbard@nvidia.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, vbabka@suse.cz

=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: update pin_user_pages.rst for "case 3" (mmu notifiers)

Update case 3 so that it covers the use of mmu notifiers, for hardware
that does, or does not have replayable page faults.

Also, elaborate case 4 slightly, as it was quite cryptic.

Link: http://lkml.kernel.org/r/20200527194953.11130-1-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/pin_user_pages.rst |   29 +++++++++++---------
 1 file changed, 17 insertions(+), 12 deletions(-)

--- a/Documentation/core-api/pin_user_pages.rst~mm-gup-update-pin_user_page=
srst-for-case-3-mmu-notifiers
+++ a/Documentation/core-api/pin_user_pages.rst
@@ -148,23 +148,28 @@ NOTE: Some pages, such as DAX pages, can
 because DAX pages do not have a separate page cache, and so "pinning" impl=
ies
 locking down file system blocks, which is not (yet) supported in that way.
=20
-CASE 3: Hardware with page faulting support
--------------------------------------------
-Here, a well-written driver doesn't normally need to pin pages at all. How=
ever,
-if the driver does choose to do so, it can register MMU notifiers for the =
range,
-and will be called back upon invalidation. Either way (avoiding page pinni=
ng, or
-using MMU notifiers to unpin upon request), there is proper synchronizatio=
n with
-both filesystem and mm (page_mkclean(), munmap(), etc).
+CASE 3: MMU notifier registration, with or without page faulting hardware
+-------------------------------------------------------------------------
+Device drivers can pin pages via get_user_pages*(), and register for mmu
+notifier callbacks for the memory range. Then, upon receiving a notifier
+"invalidate range" callback , stop the device from using the range, and un=
pin
+the pages. There may be other possible schemes, such as for example explic=
itly
+synchronizing against pending IO, that accomplish approximately the same t=
hing.
=20
-Therefore, neither flag needs to be set.
+Or, if the hardware supports replayable page faults, then the device drive=
r can
+avoid pinning entirely (this is ideal), as follows: register for mmu notif=
ier
+callbacks as above, but instead of stopping the device and unpinning in the
+callback, simply remove the range from the device's page tables.
=20
-In this case, ideally, neither get_user_pages() nor pin_user_pages() shoul=
d be
-called. Instead, the software should be written so that it does not pin pa=
ges.
-This allows mm and filesystems to operate more efficiently and reliably.
+Either way, as long as the driver unpins the pages upon mmu notifier callb=
ack,
+then there is proper synchronization with both filesystem and mm
+(page_mkclean(), munmap(), etc). Therefore, neither flag needs to be set.
=20
 CASE 4: Pinning for struct page manipulation only
 -------------------------------------------------
-Here, normal GUP calls are sufficient, so neither flag needs to be set.
+If only struct page data (as opposed to the actual memory contents that a =
page
+is tracking) is affected, then normal GUP calls are sufficient, and neithe=
r flag
+needs to be set.
=20
 page_maybe_dma_pinned(): the whole point of pinning
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
_
