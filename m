From: akpm@linux-foundation.org
Subject: + powerpc-dont-cast-a-pointer-to-pointer-of-list_head.patch added to -mm tree
Date: Wed, 12 Dec 2007 01:00:33 -0800
Message-ID: <200712120900.lBC90Xd5002125@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49673 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757255AbXLLJAk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 04:00:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, benh@kernel.crashing.org, galak@gate.crashing.org, paulus@samba.org


The patch titled
     powerpc: don't cast a pointer to pointer of list_head
has been added to the -mm tree.  Its filename is
     powerpc-dont-cast-a-pointer-to-pointer-of-list_head.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: powerpc: don't cast a pointer to pointer of list_head
From: Li Zefan <lizf@cn.fujitsu.com>

The casting is safe only when the list_head member is the first member of
the structure.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ppc/syslib/ocp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/ppc/syslib/ocp.c~powerpc-dont-cast-a-pointer-to-pointer-of-list_head arch/ppc/syslib/ocp.c
--- a/arch/ppc/syslib/ocp.c~powerpc-dont-cast-a-pointer-to-pointer-of-list_head
+++ a/arch/ppc/syslib/ocp.c
@@ -376,7 +376,7 @@ ocp_remove_one_device(unsigned int vendo
 
 	down_write(&ocp_devices_sem);
 	dev = __ocp_find_device(vendor, function, index);
-	list_del((struct list_head *)dev);
+	list_del(&dev->link);
 	up_write(&ocp_devices_sem);
 
 	DBG(("ocp: ocp_remove_one_device(vendor: %x, function: %x, index: %d)... done.\n", vendor, function, index));
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

powerpc-dont-cast-a-pointer-to-pointer-of-list_head.patch
drm-dont-cast-a-pointer-to-pointer-of-list_head.patch
git-hid.patch
git-net.patch
wireless-libertas-dont-cast-a-pointer-to-pointer-of-list_head.patch
clocksource-remove-redundant-code.patch
clockevent-simplify-list-operations.patch
timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch
time-fix-typo-in-comments.patch
time-delete-comments-that-refer-to-noexistent-symbols.patch
