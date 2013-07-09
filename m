From: akpm@linux-foundation.org
Subject: [merged] audit-fix-decimal-constant-description.patch removed
 from -mm tree
Date: Tue, 09 Jul 2013 16:19:04 -0700
Message-ID: <51dc9a68.QubdzXiXZkpcEYhm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38757 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab3GIXTF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:19:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, geert@linux-m68k.org, eparis@redhat.com, michal.simek@xilinx.com

Subject: [merged] audit-fix-decimal-constant-description.patch removed from -mm tree
To: michal.simek@xilinx.com,eparis@redhat.com,geert@linux-m68k.org,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:19:04 -0700


The patch titled
     Subject: audit: Fix decimal constant description
has been removed from the -mm tree.  Its filename was
     audit-fix-decimal-constant-description.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Simek <michal.simek@xilinx.com>
Subject: audit: Fix decimal constant description

Use proper decimal type for comparison with u32.

Compilation warning was introduced by 780a7654 ("audit: Make testing for a
valid loginuid explicit.")

kernel/auditfilter.c: In function 'audit_data_to_entry':
kernel/auditfilter.c:426:3: warning: this decimal constant
is unsigned only in ISO C90 [enabled by default]
   if ((f->type == AUDIT_LOGINUID) && (f->val == 4294967295)) {

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditfilter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/auditfilter.c~audit-fix-decimal-constant-description kernel/auditfilter.c
--- a/kernel/auditfilter.c~audit-fix-decimal-constant-description
+++ a/kernel/auditfilter.c
@@ -423,7 +423,7 @@ static struct audit_entry *audit_data_to
 		f->lsm_rule = NULL;
 
 		/* Support legacy tests for a valid loginuid */
-		if ((f->type == AUDIT_LOGINUID) && (f->val == 4294967295U)) {
+		if ((f->type == AUDIT_LOGINUID) && (f->val == ~0U)) {
 			f->type = AUDIT_LOGINUID_SET;
 			f->val = 0;
 		}
_

Patches currently in -mm which might be from michal.simek@xilinx.com are

origin.patch
linux-next.patch

