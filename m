From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-fix-null-pointer-dereference-when-tranverse-o2hb_all_regions.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:23:37 -0700
Message-ID: <51db11b9.s3dQO8J2WqawhNOy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50067 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab3GHTXi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:23:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sunil.mushran@gmail.com, mfasheh@suse.com, jlbec@evilplan.org, jiangyiwen@huawei.com, jeff.liu@oracle.com, xuejiufei@huawei.com

Subject: [merged] ocfs2-fix-null-pointer-dereference-when-tranverse-o2hb_all_regions.patch removed from -mm tree
To: xuejiufei@huawei.com,jeff.liu@oracle.com,jiangyiwen@huawei.com,jlbec@evilplan.org,mfasheh@suse.com,sunil.mushran@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:23:37 -0700


The patch titled
     Subject: ocfs2: fix NULL pointer dereference when traversing o2hb_all_regions
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-null-pointer-dereference-when-tranverse-o2hb_all_regions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2: fix NULL pointer dereference when traversing o2hb_all_regions

There may exist NULL pointer dereference in config_item_name() when one
volume(say Volume A) unmounts while another(say Volume B) mounting.

     Volume A                          Volume B
already Mounted.
Unmounting, call
o2hb_heartbeat_group_drop_item()
  -> config_item_put(item)
  set reg(A)->item.ci_name to NULL
  in function config_item_cleanup().
                                    begin mounting, call
                                    o2hb_region_pin() and tranverse all
                                    regions. When reading
                                    reg(A)->item.ci_name, it causes
                                    NULL pointer dereference.
call o2hb_region_release() and
del reg(A) from list.

So we should skip accessing regions that is going to release when
tranverse o2hb_all_regions.

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Signed-off-by: joyce <xuejiufei@huawei.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Sunil Mushran <sunil.mushran@gmail.com>
Cc: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN fs/ocfs2/cluster/heartbeat.c~ocfs2-fix-null-pointer-dereference-when-tranverse-o2hb_all_regions fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-fix-null-pointer-dereference-when-tranverse-o2hb_all_regions
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -2389,6 +2389,9 @@ static int o2hb_region_pin(const char *r
 	assert_spin_locked(&o2hb_live_lock);
 
 	list_for_each_entry(reg, &o2hb_all_regions, hr_all_item) {
+		if (reg->hr_item_dropped)
+			continue;
+
 		uuid = config_item_name(&reg->hr_item);
 
 		/* local heartbeat */
@@ -2439,6 +2442,9 @@ static void o2hb_region_unpin(const char
 	assert_spin_locked(&o2hb_live_lock);
 
 	list_for_each_entry(reg, &o2hb_all_regions, hr_all_item) {
+		if (reg->hr_item_dropped)
+			continue;
+
 		uuid = config_item_name(&reg->hr_item);
 		if (region_uuid) {
 			if (strcmp(region_uuid, uuid))
@@ -2654,6 +2660,9 @@ int o2hb_get_all_regions(char *region_uu
 
 	p = region_uuids;
 	list_for_each_entry(reg, &o2hb_all_regions, hr_all_item) {
+		if (reg->hr_item_dropped)
+			continue;
+
 		mlog(0, "Region: %s\n", config_item_name(&reg->hr_item));
 		if (numregs < max_regions) {
 			memcpy(p, config_item_name(&reg->hr_item),
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

origin.patch
linux-next.patch

