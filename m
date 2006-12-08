From: akpm@osdl.org
Subject: - prevent-null-pointer-deref-in-grab_swap_token.patch removed from -mm tree
Date: Fri, 08 Dec 2006 03:05:24 -0800
Message-ID: <200612081105.kB8B5OsJ018636@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49023 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425390AbWLHLG4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 06:06:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roe@sgi.com, riel@redhat.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Prevent NULL pointer deref in grab_swap_token
has been removed from the -mm tree.  Its filename was
     prevent-null-pointer-deref-in-grab_swap_token.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: Prevent NULL pointer deref in grab_swap_token
From: Dean Roe <roe@sgi.com>


grab_swap_token() assumes that the current process has an mm struct, which
is not true for kernel threads invoking get_user_pages().  Since this
should be extremely rare, just return from grab_swap_token() without doing
anything.

Signed-off-by: Dean Roe <roe@sgi.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/thrash.c |    3 +++
 1 files changed, 3 insertions(+)

diff -puN mm/thrash.c~prevent-null-pointer-deref-in-grab_swap_token mm/thrash.c
--- devel/mm/thrash.c~prevent-null-pointer-deref-in-grab_swap_token	2006-03-07 13:22:53.000000000 -0800
+++ devel-akpm/mm/thrash.c	2006-03-07 13:22:53.000000000 -0800
@@ -54,6 +54,9 @@ void grab_swap_token(void)
 	struct mm_struct *mm;
 	int reason;
 
+	if (current->mm == NULL)
+		return;
+
 	/* We have the token. Let others know we still need it. */
 	if (has_swap_token(current->mm)) {
 		current->mm->recent_pagein = 1;
_

Patches currently in -mm which might be from roe@sgi.com are


