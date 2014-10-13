From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared-fix.patch removed from -mm tree
Date: Mon, 13 Oct 2014 15:44:27 -0700
Message-ID: <543c55cb.6dwxyBK+1bi1/Ydp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34730 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbaJMWo1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 18:44:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pfeiner@google.com, bhelgaas@google.com, gorcunov@openvz.org, hughd@google.com, jamieliu@google.com, n-horiguchi@ah.jp.nec.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared-fix
has been removed from the -mm tree.  Its filename was
     mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared-fix.patch

This patch was dropped because it was folded into mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared.patch

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

origin.patch
mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared.patch

