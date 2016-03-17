From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-slub-query-dynamic-debug_pagealloc-setting-fix.patch removed from -mm
 tree
Date: Thu, 17 Mar 2016 13:50:06 -0700
Message-ID: <56eb187e.aC1GgtNVepGKlKOf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44200 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbcCQUuH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 16:50:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, borntraeger@de.ibm.com, cl@linux.com, cmetcalf@ezchip.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, tiwai@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-slub-query-dynamic-debug_pagealloc-setting-fix
has been removed from the -mm tree.  Its filename was
     mm-slub-query-dynamic-debug_pagealloc-setting-fix.patch

This patch was dropped because it was folded into mm-slub-query-dynamic-debug_pagealloc-setting.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-slub-query-dynamic-debug_pagealloc-setting-fix

clean up code, per Christian

Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Takashi Iwai <tiwai@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN mm/slub.c~mm-slub-query-dynamic-debug_pagealloc-setting-fix mm/slub.c
--- a/mm/slub.c~mm-slub-query-dynamic-debug_pagealloc-setting-fix
+++ a/mm/slub.c
@@ -254,12 +254,9 @@ static inline void *get_freepointer_safe
 {
 	void *p;
 
-	if (debug_pagealloc_enabled()) {
-		probe_kernel_read(&p,
-			(void **)(object + s->offset), sizeof(p));
-	} else
-		p = get_freepointer(s, object);
