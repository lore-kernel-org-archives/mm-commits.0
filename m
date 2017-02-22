From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memory_hotplug-set-magic-number-to-page-freelsit-instead-of-page-lrunext-fix.patch removed from -mm tree
Date: Wed, 22 Feb 2017 15:24:34 -0800
Message-ID: <58ae1db2.eKdl1tstMF/HYAAY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46354 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933777AbdBVXZB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:25:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: isimatu.yasuaki@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory_hotplug-set-magic-number-to-page-freelsit-instead-of-page-lrunext-fix
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-set-magic-number-to-page-freelsit-instead-of-page-lrunext-fix.patch

This patch was dropped because it was folded into mm-memory_hotplug-set-magic-number-to-page-freelsit-instead-of-page-lrunext.patch

------------------------------------------------------
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: mm-memory_hotplug-set-magic-number-to-page-freelsit-instead-of-page-lrunext-fix

The following patch is not applied correctly.
http://lkml.kernel.org/r/2c29bd9f-5b67-02d0-18a3-8828e78bbb6f@gmail.com

So the following unnecessary code still remains.

get_page_bootmem()
{
...
        page->lru.next = (struct list_head *)type;
...

The patch removes this code from get_page_bootmem()

Link: http://lkml.kernel.org/r/722b1cc4-93ac-dd8b-2be2-7a7e313b3b0b@gmail.com
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplug-set-magic-number-to-page-freelsit-instead-of-page-lrunext-fix mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-set-magic-number-to-page-freelsit-instead-of-page-lrunext-fix
+++ a/mm/memory_hotplug.c
@@ -179,7 +179,6 @@ static void release_memory_resource(stru
 void get_page_bootmem(unsigned long info,  struct page *page,
 		      unsigned long type)
 {
-	page->lru.next = (struct list_head *)type;
 	page->freelist = (void *)type;
 	SetPagePrivate(page);
 	set_page_private(page, info);
_

Patches currently in -mm which might be from isimatu.yasuaki@jp.fujitsu.com are

mm-memory_hotplug-set-magic-number-to-page-freelsit-instead-of-page-lrunext.patch

