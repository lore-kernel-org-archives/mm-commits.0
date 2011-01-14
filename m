From: akpm@linux-foundation.org
Subject: [merged] mm-convert-sprintf_symbol-to-%ps.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:44:45 -0800
Message-ID: <201101142247.p0EMlZP5005015@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525Ab1ANWrk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:47:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, penberg@kernel.org, trivial@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm: convert sprintf_symbol to %pS
has been removed from the -mm tree.  Its filename was
     mm-convert-sprintf_symbol-to-%ps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: convert sprintf_symbol to %pS
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Jiri Kosina <trivial@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c    |   11 ++++-------
 mm/vmalloc.c |    9 ++-------
 2 files changed, 6 insertions(+), 14 deletions(-)

diff -puN mm/slub.c~mm-convert-sprintf_symbol-to-%ps mm/slub.c
--- a/mm/slub.c~mm-convert-sprintf_symbol-to-%ps
+++ a/mm/slub.c
@@ -3636,7 +3636,7 @@ static int list_locations(struct kmem_ca
 		len += sprintf(buf + len, "%7ld ", l->count);
 
 		if (l->addr)
-			len += sprint_symbol(buf + len, (unsigned long)l->addr);
+			len += sprintf(buf + len, "%pS", (void *)l->addr);
 		else
 			len += sprintf(buf + len, "<not-available>");
 
@@ -3946,12 +3946,9 @@ SLAB_ATTR(min_partial);
 
 static ssize_t ctor_show(struct kmem_cache *s, char *buf)
 {
-	if (s->ctor) {
-		int n = sprint_symbol(buf, (unsigned long)s->ctor);
-
-		return n + sprintf(buf + n, "\n");
-	}
-	return 0;
+	if (!s->ctor)
+		return 0;
+	return sprintf(buf, "%pS\n", s->ctor);
 }
 SLAB_ATTR_RO(ctor);
 
diff -puN mm/vmalloc.c~mm-convert-sprintf_symbol-to-%ps mm/vmalloc.c
--- a/mm/vmalloc.c~mm-convert-sprintf_symbol-to-%ps
+++ a/mm/vmalloc.c
@@ -2456,13 +2456,8 @@ static int s_show(struct seq_file *m, vo
 	seq_printf(m, "0x%p-0x%p %7ld",
 		v->addr, v->addr + v->size, v->size);
 
-	if (v->caller) {
-		char buff[KSYM_SYMBOL_LEN];
