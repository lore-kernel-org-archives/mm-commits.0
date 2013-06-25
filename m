From: akpm@linux-foundation.org
Subject: + audit-fix-decimal-constant-description.patch added to -mm tree
Date: Tue, 25 Jun 2013 13:12:10 -0700
Message-ID: <51c9f99a.izyegVbMQGbsw+xl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42512 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab3FYUML (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 16:12:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, geert@linux-m68k.org, eparis@redhat.com, michal.simek@xilinx.com

Subject: + audit-fix-decimal-constant-description.patch added to -mm tree
To: michal.simek@xilinx.com,eparis@redhat.com,geert@linux-m68k.org,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 13:12:10 -0700


The patch titled
     Subject: audit: Fix decimal constant description
has been added to the -mm tree.  Its filename is
     audit-fix-decimal-constant-description.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
audit-fix-decimal-constant-description.patch

