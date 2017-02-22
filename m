From: akpm@linux-foundation.org
Subject: [patch 043/142] mm/vmalloc.c: use rb_entry_safe
Date: Wed, 22 Feb 2017 15:41:54 -0800
Message-ID: <58ae21c2.Z/mn6CtRmzeN0O7d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48260 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934555AbdBVXmO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:42:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, geliangtang@gmail.com, mhocko@suse.com

From: Geliang Tang <geliangtang@gmail.com>
Subject: mm/vmalloc.c: use rb_entry_safe

Use rb_entry_safe() instead of open-coding it.

Link: http://lkml.kernel.org/r/81bb9820e5b9e4a1c596b3e76f88abf8c4a76cb0.1482221947.git.geliangtang@gmail.com
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmalloc.c~mm-vmallocc-use-rb_entry_safe mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmallocc-use-rb_entry_safe
+++ a/mm/vmalloc.c
@@ -2309,7 +2309,7 @@ EXPORT_SYMBOL_GPL(free_vm_area);
 #ifdef CONFIG_SMP
 static struct vmap_area *node_to_va(struct rb_node *n)
 {
-	return n ? rb_entry(n, struct vmap_area, rb_node) : NULL;
+	return rb_entry_safe(n, struct vmap_area, rb_node);
 }
 
 /**
_
