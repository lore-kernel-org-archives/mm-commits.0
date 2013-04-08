From: akpm@linux-foundation.org
Subject: + auditsc-use-kzalloc-instead-of-kmallocmemset.patch added to -mm tree
Date: Mon, 08 Apr 2013 14:44:22 -0700
Message-ID: <20130408214422.E24BB5A4331@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f202.google.com ([209.85.210.202]:56724 "EHLO
	mail-ia0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935961Ab3DHVoY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Apr 2013 17:44:24 -0400
Received: by mail-ia0-f202.google.com with SMTP id p22so1590987iad.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Apr 2013 14:44:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rakib.mullick@gmail.com, eparis@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: kernel/auditsc.c: use kzalloc instead of kmalloc+memset
has been added to the -mm tree.  Its filename is
     auditsc-use-kzalloc-instead-of-kmallocmemset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rakib Mullick <rakib.mullick@gmail.com>
Subject: kernel/auditsc.c: use kzalloc instead of kmalloc+memset

In audit_alloc_context() use kzalloc instead of kmalloc+memset.  Also
rename audit_zero_context() to audit_set_context(), to represent it's
inner workings properly.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditsc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/auditsc.c~auditsc-use-kzalloc-instead-of-kmallocmemset kernel/auditsc.c
--- a/kernel/auditsc.c~auditsc-use-kzalloc-instead-of-kmallocmemset
+++ a/kernel/auditsc.c
@@ -1034,10 +1034,9 @@ static inline void audit_free_aux(struct
 	}
 }
 
-static inline void audit_zero_context(struct audit_context *context,
+static inline void audit_set_context(struct audit_context *context,
 				      enum audit_state state)
 {
-	memset(context, 0, sizeof(*context));
 	context->state      = state;
 	context->prio = state == AUDIT_RECORD_CONTEXT ? ~0ULL : 0;
 }
@@ -1046,9 +1045,10 @@ static inline struct audit_context *audi
 {
 	struct audit_context *context;
 
-	if (!(context = kmalloc(sizeof(*context), GFP_KERNEL)))
+	context = kzalloc(sizeof(*context), GFP_KERNEL);
+	if (!context)
 		return NULL;
-	audit_zero_context(context, state);
+	audit_set_context(context, state);
 	INIT_LIST_HEAD(&context->killed_trees);
 	INIT_LIST_HEAD(&context->names_list);
 	return context;
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

auditsc-use-kzalloc-instead-of-kmallocmemset.patch
auditsc-use-kzalloc-instead-of-kmallocmemset-fix.patch

