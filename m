From: akpm@linux-foundation.org
Subject: [merged] mm-mlockc-document-scary-looking-stack-expansion-mlock-chain.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:54:23 -0800
Message-ID: <20130225205423.BE19131C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:39132 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757433Ab3BYUyY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:54:24 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so347961ggi.3
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:54:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, viro@ZenIV.linux.org.uk, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mlock.c: document scary-looking stack expansion mlock chain
has been removed from the -mm tree.  Its filename was
     mm-mlockc-document-scary-looking-stack-expansion-mlock-chain.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm/mlock.c: document scary-looking stack expansion mlock chain

The fact that mlock calls get_user_pages, and get_user_pages might
call mlock when expanding a stack looks like a potential recursion.

However, mlock makes sure the requested range is already contained
within a vma, so no stack expansion will actually happen from mlock.

Should this ever change: the stack expansion mlocks only the newly
expanded range and so will not result in recursive expansion.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>
Acked-by: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/mlock.c~mm-mlockc-document-scary-looking-stack-expansion-mlock-chain mm/mlock.c
--- a/mm/mlock.c~mm-mlockc-document-scary-looking-stack-expansion-mlock-chain
+++ a/mm/mlock.c
@@ -185,6 +185,10 @@ long __mlock_vma_pages_range(struct vm_a
 	if (vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC))
 		gup_flags |= FOLL_FORCE;
 
+	/*
+	 * We made sure addr is within a VMA, so the following will
+	 * not result in a stack expansion that recurses back here.
+	 */
 	return __get_user_pages(current, mm, addr, nr_pages, gup_flags,
 				NULL, NULL, nonblocking);
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-memmap_init_zone-performance-improvement.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

