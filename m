From: akpm@linux-foundation.org
Subject: + mm-remove-alignment-padding-from-anon_vma-on-some-64-bit-builds.patch added to -mm tree
Date: Thu, 23 Sep 2010 16:24:39 -0700
Message-ID: <201009232324.o8NNOdaM025506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753413Ab0IWX0C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Sep 2010 19:26:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@rsk.demon.co.uk, riel@redhat.com


The patch titled
     mm: remove alignment padding from anon_vma on (some) 64 bit builds
has been added to the -mm tree.  Its filename is
     mm-remove-alignment-padding-from-anon_vma-on-some-64-bit-builds.patch

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
Subject: mm: remove alignment padding from anon_vma on (some) 64 bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>

Reorder structure anon_vma to remove alignment padding on 64 builds when
(CONFIG_KSM || CONFIG_MIGRATION).
This will shrink the size of the anon_vma structure from 40 to 32 bytes
& allow more objects per slab in its kmem_cache.

Under slub the objects in the anon_vma kmem_cache will then be 40 bytes
with 102 objects per slab.  (On v2.6.36 without this patch,the size is 48
bytes and 85 objects/slab.)

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/rmap.h~mm-remove-alignment-padding-from-anon_vma-on-some-64-bit-builds include/linux/rmap.h
--- a/include/linux/rmap.h~mm-remove-alignment-padding-from-anon_vma-on-some-64-bit-builds
+++ a/include/linux/rmap.h
@@ -25,8 +25,8 @@
  * pointing to this anon_vma once its vma list is empty.
  */
 struct anon_vma {
-	spinlock_t lock;	/* Serialize access to vma list */
 	struct anon_vma *root;	/* Root of this anon_vma tree */
+	spinlock_t lock;	/* Serialize access to vma list */
 #if defined(CONFIG_KSM) || defined(CONFIG_MIGRATION)
 
 	/*
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

linux-next.patch
timer_list-remove-alignment-padding-on-64-bit-when-config_timer_stats.patch
mm-remove-alignment-padding-from-anon_vma-on-some-64-bit-builds.patch

