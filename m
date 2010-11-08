From: akpm@linux-foundation.org
Subject: + mm-convert-sprintf_symbol-to-%ps.patch added to -mm tree
Date: Mon, 08 Nov 2010 14:40:39 -0800
Message-ID: <201011082240.oA8MedmN014016@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51098 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753310Ab0KHWlA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Nov 2010 17:41:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, penberg@kernel.org, trivial@kernel.org


The patch titled
     mm: convert sprintf_symbol to %pS
has been added to the -mm tree.  Its filename is
     mm-convert-sprintf_symbol-to-%ps.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -3676,7 +3676,7 @@ static int list_locations(struct kmem_ca
 		len += sprintf(buf + len, "%7ld ", l->count);
 
 		if (l->addr)
-			len += sprint_symbol(buf + len, (unsigned long)l->addr);
+			len += sprintf(buf + len, "%pS", (void *)l->addr);
 		else
 			len += sprintf(buf + len, "<not-available>");
 
@@ -3986,12 +3986,9 @@ SLAB_ATTR(min_partial);
 
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
@@ -2507,13 +2507,8 @@ static int s_show(struct seq_file *m, vo
 	seq_printf(m, "0x%p-0x%p %7ld",
 		v->addr, v->addr + v->size, v->size);
 
-	if (v->caller) {
-		char buff[KSYM_SYMBOL_LEN];
