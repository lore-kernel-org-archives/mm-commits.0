From: akpm@linux-foundation.org
Subject: + page_cgroup-add-helper-function-to-get-swap_cgroup.patch added to -mm tree
Date: Thu, 08 Dec 2011 15:20:56 -0800
Message-ID: <201112082320.pB8NKuiB005772@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:52167 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab1LHXVf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Dec 2011 18:21:35 -0500
Received: by ghrr18 with SMTP id r18so283253ghr.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Dec 2011 15:21:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lliubbo@gmail.com, jweiner@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: page_cgroup: add helper function to get swap_cgroup
has been added to the -mm tree.  Its filename is
     page_cgroup-add-helper-function-to-get-swap_cgroup.patch

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
From: Bob Liu <lliubbo@gmail.com>
Subject: page_cgroup: add helper function to get swap_cgroup

There are multiple places which need to get the swap_cgroup address, so
add a helper function:

static struct swap_cgroup *swap_cgroup_getsc(swp_entry_t ent,
                                struct swap_cgroup_ctrl **ctrl);
to simplify the code.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |   57 ++++++++++++++++++---------------------------
 1 file changed, 24 insertions(+), 33 deletions(-)

diff -puN mm/page_cgroup.c~page_cgroup-add-helper-function-to-get-swap_cgroup mm/page_cgroup.c
--- a/mm/page_cgroup.c~page_cgroup-add-helper-function-to-get-swap_cgroup
+++ a/mm/page_cgroup.c
@@ -376,6 +376,27 @@ not_enough_page:
 	return -ENOMEM;
 }
 
+static struct swap_cgroup *swap_cgroup_getsc(swp_entry_t ent,
+					struct swap_cgroup_ctrl **ctrl)
+{
+	int type = swp_type(ent);
+	unsigned long offset = swp_offset(ent);
+	unsigned long idx = offset / SC_PER_PAGE;
+	unsigned long pos = offset & SC_POS_MASK;
+	struct swap_cgroup_ctrl *temp_ctrl;
+	struct page *mappage;
+	struct swap_cgroup *sc;
+
+	temp_ctrl = &swap_cgroup_ctrl[type];
+	if (ctrl)
+		*ctrl = temp_ctrl;
+
+	mappage = temp_ctrl->map[idx];
+	sc = page_address(mappage);
+	sc += pos;
+	return sc;
+}
+
 /**
  * swap_cgroup_cmpxchg - cmpxchg mem_cgroup's id for this swp_entry.
  * @end: swap entry to be cmpxchged
@@ -388,21 +409,13 @@ not_enough_page:
 unsigned short swap_cgroup_cmpxchg(swp_entry_t ent,
 					unsigned short old, unsigned short new)
 {
-	int type = swp_type(ent);
-	unsigned long offset = swp_offset(ent);
-	unsigned long idx = offset / SC_PER_PAGE;
-	unsigned long pos = offset & SC_POS_MASK;
 	struct swap_cgroup_ctrl *ctrl;
-	struct page *mappage;
 	struct swap_cgroup *sc;
 	unsigned long flags;
 	unsigned short retval;
 
-	ctrl = &swap_cgroup_ctrl[type];
+	sc = swap_cgroup_getsc(ent, &ctrl);
 
-	mappage = ctrl->map[idx];
-	sc = page_address(mappage);
-	sc += pos;
 	spin_lock_irqsave(&ctrl->lock, flags);
 	retval = sc->id;
 	if (retval == old)
@@ -423,21 +436,13 @@ unsigned short swap_cgroup_cmpxchg(swp_e
  */
 unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id)
 {
-	int type = swp_type(ent);
-	unsigned long offset = swp_offset(ent);
-	unsigned long idx = offset / SC_PER_PAGE;
-	unsigned long pos = offset & SC_POS_MASK;
 	struct swap_cgroup_ctrl *ctrl;
-	struct page *mappage;
 	struct swap_cgroup *sc;
 	unsigned short old;
 	unsigned long flags;
 
-	ctrl = &swap_cgroup_ctrl[type];
+	sc = swap_cgroup_getsc(ent, &ctrl);
 
-	mappage = ctrl->map[idx];
-	sc = page_address(mappage);
-	sc += pos;
 	spin_lock_irqsave(&ctrl->lock, flags);
 	old = sc->id;
 	sc->id = id;
@@ -454,21 +459,7 @@ unsigned short swap_cgroup_record(swp_en
  */
 unsigned short lookup_swap_cgroup(swp_entry_t ent)
 {
-	int type = swp_type(ent);
-	unsigned long offset = swp_offset(ent);
-	unsigned long idx = offset / SC_PER_PAGE;
-	unsigned long pos = offset & SC_POS_MASK;
-	struct swap_cgroup_ctrl *ctrl;
-	struct page *mappage;
-	struct swap_cgroup *sc;
-	unsigned short ret;
