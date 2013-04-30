From: akpm@linux-foundation.org
Subject: [merged] auditsc-use-kzalloc-instead-of-kmallocmemset.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:43:15 -0700
Message-ID: <20130430184315.72E5B5A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:35348 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759093Ab3D3SnQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:43:16 -0400
Received: by mail-yh0-f73.google.com with SMTP id f35so84353yha.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:43:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rakib.mullick@gmail.com, eparis@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/auditsc.c: use kzalloc instead of kmalloc+memset
has been removed from the -mm tree.  Its filename was
     auditsc-use-kzalloc-instead-of-kmallocmemset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rakib Mullick <rakib.mullick@gmail.com>
Subject: kernel/auditsc.c: use kzalloc instead of kmalloc+memset

In audit_alloc_context() use kzalloc instead of kmalloc+memset.  Also
rename audit_zero_context() to audit_set_context(), to represent it's
inner workings properly.

[akpm@linux-foundation.org: remove audit_set_context() altogether - fold it into its caller]
Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditsc.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff -puN kernel/auditsc.c~auditsc-use-kzalloc-instead-of-kmallocmemset kernel/auditsc.c
--- a/kernel/auditsc.c~auditsc-use-kzalloc-instead-of-kmallocmemset
+++ a/kernel/auditsc.c
@@ -1034,21 +1034,15 @@ static inline void audit_free_aux(struct
 	}
 }
 
-static inline void audit_zero_context(struct audit_context *context,
-				      enum audit_state state)
-{
-	memset(context, 0, sizeof(*context));
-	context->state      = state;
-	context->prio = state == AUDIT_RECORD_CONTEXT ? ~0ULL : 0;
-}
