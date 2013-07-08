From: akpm@linux-foundation.org
Subject: [merged]
 mm-nommuc-add-additional-check-for-vread-just-like-vwrite-has-done.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:25:46 -0700
Message-ID: <51db123a.mUnYZ7DHqhq0pewS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50490 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab3GHTZr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:25:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, viro@zeniv.linux.org.uk, riel@redhat.com, gang.chen@asianux.com

Subject: [merged] mm-nommuc-add-additional-check-for-vread-just-like-vwrite-has-done.patch removed from -mm tree
To: gang.chen@asianux.com,riel@redhat.com,viro@zeniv.linux.org.uk,walken@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:25:46 -0700


The patch titled
     Subject: mm/nommu.c: add additional check for vread() just like vwrite() has done
has been removed from the -mm tree.  Its filename was
     mm-nommuc-add-additional-check-for-vread-just-like-vwrite-has-done.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: mm/nommu.c: add additional check for vread() just like vwrite() has done

vwrite() checks for overflow. vread() should do the same thing.

Since vwrite() checks the source buffer address, vread() should check
the destination buffer address.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/nommu.c~mm-nommuc-add-additional-check-for-vread-just-like-vwrite-has-done mm/nommu.c
--- a/mm/nommu.c~mm-nommuc-add-additional-check-for-vread-just-like-vwrite-has-done
+++ a/mm/nommu.c
@@ -282,6 +282,10 @@ EXPORT_SYMBOL(vmalloc_to_pfn);
 
 long vread(char *buf, char *addr, unsigned long count)
 {
+	/* Don't allow overflow */
+	if ((unsigned long) buf + count < count)
+		count = -(unsigned long) buf;
+
 	memcpy(buf, addr, count);
 	return count;
 }
_

Patches currently in -mm which might be from gang.chen@asianux.com are

origin.patch
linux-next.patch
kernel-auditfilterc-fix-leak-in-audit_add_rule-error-path.patch
include-linux-interrupth-add-dummy-irq_set_irq_wake-for-generic_hardirqs.patch

