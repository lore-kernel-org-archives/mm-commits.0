From: akpm@linux-foundation.org
Subject: + drivers-firmware-memmapc-fix-sparse-warnings.patch added to -mm tree
Date: Thu, 13 Nov 2008 14:34:57 -0800
Message-ID: <200811132234.mADMYv9D029362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751869AbYKMWfA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 17:35:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: patrickdepinguin@gmail.com


The patch titled
     drivers/firmware/memmap.c: fix sparse warnings
has been added to the -mm tree.  Its filename is
     drivers-firmware-memmapc-fix-sparse-warnings.patch

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
Subject: drivers/firmware/memmap.c: fix sparse warnings
From: "Thomas De Schampheleire" <patrickdepinguin@gmail.com>

This patch fixes the following sparse warnings:
  CHECK   drivers/firmware/memmap.c
  drivers/firmware/memmap.c:59:25: warning: symbol 'memmap_start_attr'
was not declared. Should it be static?
  drivers/firmware/memmap.c:60:25: warning: symbol 'memmap_end_attr'
was not declared. Should it be static?
  drivers/firmware/memmap.c:61:25: warning: symbol 'memmap_type_attr'
was not declared. Should it be static?

Signed-off-by: Thomas De Schampheleire <patrickdepinguin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/memmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/firmware/memmap.c~drivers-firmware-memmapc-fix-sparse-warnings drivers/firmware/memmap.c
--- a/drivers/firmware/memmap.c~drivers-firmware-memmapc-fix-sparse-warnings
+++ a/drivers/firmware/memmap.c
@@ -56,9 +56,9 @@ struct memmap_attribute {
 	ssize_t (*show)(struct firmware_map_entry *entry, char *buf);
 };
 
-struct memmap_attribute memmap_start_attr = __ATTR_RO(start);
-struct memmap_attribute memmap_end_attr   = __ATTR_RO(end);
-struct memmap_attribute memmap_type_attr  = __ATTR_RO(type);
+static struct memmap_attribute memmap_start_attr = __ATTR_RO(start);
+static struct memmap_attribute memmap_end_attr   = __ATTR_RO(end);
+static struct memmap_attribute memmap_type_attr  = __ATTR_RO(type);
 
 /*
  * These are default attributes that are added for every memmap entry.
_

Patches currently in -mm which might be from patrickdepinguin@gmail.com are

drivers-firmware-memmapc-fix-sparse-warnings.patch

