From: akpm@linux-foundation.org
Subject: + make-apply_to_page_range-more-robust.patch added to -mm tree
Date: Tue, 26 Jan 2016 16:31:55 -0800
Message-ID: <56a80ffb.TaQ2JyBdSp+QvX9U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40944 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbcA0Ab4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 19:31:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mika.penttila@nextfour.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: make apply_to_page_range() more robust
has been added to the -mm tree.  Its filename is
     make-apply_to_page_range-more-robust.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/make-apply_to_page_range-m=
ore-robust.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/make-apply_to_page_range-m=
ore-robust.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Mika Penttil=E4 <mika.penttila@nextfour.com>
Subject: mm/memory.c: make apply_to_page_range() more robust

Arm and arm64 used to trigger this BUG_ON() - this has now been fixed.

But a WARN_ON() here is sufficient to catch future buggy callers.

Signed-off-by: Mika Penttil=E4 <mika.penttila@nextfour.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/memory.c~make-apply_to_page_range-more-robust mm/memory.c
--- a/mm/memory.c~make-apply_to_page_range-more-robust
+++ a/mm/memory.c
@@ -1876,7 +1876,9 @@ int apply_to_page_range(struct mm_struct
 	unsigned long end =3D addr + size;
 	int err;
=20
-	BUG_ON(addr >=3D end);
+	if (WARN_ON(addr >=3D end))
+		return -EINVAL;
+
 	pgd =3D pgd_offset(mm, addr);
 	do {
 		next =3D pgd_addr_end(addr, end);
_

Patches currently in -mm which might be from mika.penttila@nextfour.com=
 are

make-apply_to_page_range-more-robust.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
