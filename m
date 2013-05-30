From: akpm@linux-foundation.org
Subject: + kernel-auditfilterc-fixing-build-warning.patch added to -mm
 tree
Date: Thu, 30 May 2013 13:42:45 -0700
Message-ID: <51a7b9c5.NgSWvJKihVvklJGN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59748 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758281Ab3E3Umq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 May 2013 16:42:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, eparis@redhat.com, raphael.scarv@gmail.com

Subject: + kernel-auditfilterc-fixing-build-warning.patch added to -mm tree
To: raphael.scarv@gmail.com,eparis@redhat.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Thu, 30 May 2013 13:42:45 -0700


The patch titled
     Subject: kernel/auditfilter.c: fixing build warning
has been added to the -mm tree.  Its filename is
     kernel-auditfilterc-fixing-build-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Raphael S. Carvalho" <raphael.scarv@gmail.com>
Subject: kernel/auditfilter.c: fixing build warning

kernel/auditfilter.c:426: warning: this decimal constant is unsigned only in ISO C90

Signed-off-by: Raphael S. Carvalho <raphael.scarv@gmail.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditfilter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/auditfilter.c~kernel-auditfilterc-fixing-build-warning kernel/auditfilter.c
--- a/kernel/auditfilter.c~kernel-auditfilterc-fixing-build-warning
+++ a/kernel/auditfilter.c
@@ -423,7 +423,7 @@ static struct audit_entry *audit_data_to
 		f->lsm_rule = NULL;
 
 		/* Support legacy tests for a valid loginuid */
-		if ((f->type == AUDIT_LOGINUID) && (f->val == 4294967295)) {
+		if ((f->type == AUDIT_LOGINUID) && (f->val == 4294967295U)) {
 			f->type = AUDIT_LOGINUID_SET;
 			f->val = 0;
 		}
_

Patches currently in -mm which might be from raphael.scarv@gmail.com are

kernel-auditfilterc-fixing-build-warning.patch

