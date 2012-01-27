From: akpm@linux-foundation.org
Subject: + kcore-make-get_sparsemem_vmemmap_info-static.patch added to -mm tree
Date: Fri, 27 Jan 2012 15:05:08 -0800
Message-ID: <20120127230508.7FF9AA01F8@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:48320 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab2A0XFJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Jan 2012 18:05:09 -0500
Received: by ghrr20 with SMTP id r20so79262ghr.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Jan 2012 15:05:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tixxdz@opendz.org


The patch titled
     Subject: fs/proc/kcore.c: make get_sparsemem_vmemmap_info() static
has been added to the -mm tree.  Its filename is
     kcore-make-get_sparsemem_vmemmap_info-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Djalal Harouni <tixxdz@opendz.org>
Subject: fs/proc/kcore.c: make get_sparsemem_vmemmap_info() static

get_sparsemem_vmemmap_info() is only used inside fs/proc/kcore.c

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/proc/kcore.c~kcore-make-get_sparsemem_vmemmap_info-static fs/proc/kcore.c
--- a/fs/proc/kcore.c~kcore-make-get_sparsemem_vmemmap_info-static
+++ a/fs/proc/kcore.c
@@ -157,7 +157,8 @@ static int kcore_update_ram(void)
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 /* calculate vmemmap's address from given system ram pfn and register it */
-int get_sparsemem_vmemmap_info(struct kcore_list *ent, struct list_head *head)
+static int
+get_sparsemem_vmemmap_info(struct kcore_list *ent, struct list_head *head)
 {
 	unsigned long pfn = __pa(ent->addr) >> PAGE_SHIFT;
 	unsigned long nr_pages = ent->size >> PAGE_SHIFT;
@@ -189,7 +190,8 @@ int get_sparsemem_vmemmap_info(struct kc
 
 }
 #else
-int get_sparsemem_vmemmap_info(struct kcore_list *ent, struct list_head *head)
+static int
+get_sparsemem_vmemmap_info(struct kcore_list *ent, struct list_head *head)
 {
 	return 1;
 }
_
Subject: Subject: fs/proc/kcore.c: make get_sparsemem_vmemmap_info() static

Patches currently in -mm which might be from tixxdz@opendz.org are

origin.patch
kcore-make-get_sparsemem_vmemmap_info-static.patch
notify_change-check-that-i_mutex-is-held.patch

