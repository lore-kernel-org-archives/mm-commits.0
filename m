From: akpm@linux-foundation.org
Subject: + mm-kmem_cache_create-make-it-easier-to-catch-null-cache-names.patch added to -mm tree
Date: Tue, 28 Jul 2009 17:06:44 -0700
Message-ID: <200907290006.n6T06ixq018733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752460AbZG2AHI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jul 2009 20:07:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org, penberg@cs.helsinki.fi


The patch titled
     mm: kmem_cache_create(): make it easier to catch NULL cache names
has been added to the -mm tree.  Its filename is
     mm-kmem_cache_create-make-it-easier-to-catch-null-cache-names.patch

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
Subject: mm: kmem_cache_create(): make it easier to catch NULL cache names
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Right now, if you inadvertently pass NULL to kmem_cache_create() at boot
time, it crashes much later after boot somewhere deep inside sysfs which
makes it very non obvious to figure out what's going on.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/slub.c~mm-kmem_cache_create-make-it-easier-to-catch-null-cache-names mm/slub.c
--- a/mm/slub.c~mm-kmem_cache_create-make-it-easier-to-catch-null-cache-names
+++ a/mm/slub.c
@@ -3327,6 +3327,9 @@ struct kmem_cache *kmem_cache_create(con
 {
 	struct kmem_cache *s;
 
+	if (WARN_ON(!name))
+		return NULL;
+
 	down_write(&slub_lock);
 	s = find_mergeable(size, align, flags, name, ctor);
 	if (s) {
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
linux-next.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
powerpc-cell-replace-strncpy-by-strlcpy.patch
mm-kmem_cache_create-make-it-easier-to-catch-null-cache-names.patch
platinumfb-misplaced-parenthesis.patch

