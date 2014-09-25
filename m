From: akpm@linux-foundation.org
Subject: +
 mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared-fix.patch added to -mm tree
Date: Thu, 25 Sep 2014 12:47:48 -0700
Message-ID: <54247164./bguVvE1FNy+PHSe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35280 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaIYTrs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Sep 2014 15:47:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pfeiner@google.com, bhelgaas@google.com, gorcunov@openvz.org, hughd@google.com, jamieliu@google.com, n-horiguchi@ah.jp.nec.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared-fix
has been added to the -mm tree.  Its filename is
     mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Feiner <pfeiner@google.com>
Subject: mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared-fix

For completeness of the arch-independent pgprot-modify,

Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jamie Liu <jamieliu@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Peter Feiner <pfeiner@google.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/asm-generic/pgtable.h~mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared-fix include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared-fix
+++ a/include/asm-generic/pgtable.h
@@ -261,6 +261,8 @@ static inline pgprot_t pgprot_modify(pgp
 		newprot = pgprot_noncached(newprot);
 	if (pgprot_val(oldprot) == pgprot_val(pgprot_writecombine(oldprot)))
 		newprot = pgprot_writecombine(newprot);
+	if (pgprot_val(oldprot) == pgprot_val(pgprot_device(oldprot)))
+		newprot = pgprot_device(newprot);
 	return newprot;
 }
 #endif
_

Patches currently in -mm which might be from pfeiner@google.com are

mm-softdirty-addresses-before-vmas-in-pte-holes-arent-softdirty.patch
mm-softdirty-keep-bit-when-zapping-file-pte.patch
mm-softdirty-unmapped-addresses-between-vmas-are-clean.patch
mm-softdirty-unmapped-addresses-between-vmas-are-clean-v2.patch
mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared.patch
mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared-fix.patch

