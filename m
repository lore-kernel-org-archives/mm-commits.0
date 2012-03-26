From: akpm@linux-foundation.org
Subject: [merged] kcore-make-get_sparsemem_vmemmap_info-static.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:32:42 -0700
Message-ID: <20120326193242.5AB80A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:38526 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204Ab2CZTcn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:32:43 -0400
Received: by mail-vb0-f74.google.com with SMTP id l22so508386vbn.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:32:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tixxdz@opendz.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/kcore.c: make get_sparsemem_vmemmap_info() static
has been removed from the -mm tree.  Its filename was
     kcore-make-get_sparsemem_vmemmap_info-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Djalal Harouni <tixxdz@opendz.org>
Subject: fs/proc/kcore.c: make get_sparsemem_vmemmap_info() static

get_sparsemem_vmemmap_info() is only used inside fs/proc/kcore.c

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
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

Patches currently in -mm which might be from tixxdz@opendz.org are

origin.patch
notify_change-check-that-i_mutex-is-held.patch

