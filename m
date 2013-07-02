From: akpm@linux-foundation.org
Subject: +
 ocfs2-fix-null-pointer-dereference-when-tranverse-o2hb_all_regions.patch
 added to -mm tree
Date: Tue, 02 Jul 2013 12:39:44 -0700
Message-ID: <51d32c80.kSlUC83M2Mz4u3jv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58548 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244Ab3GBTjp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jul 2013 15:39:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sunil.mushran@gmail.com, mfasheh@suse.com, jlbec@evilplan.org, jiangyiwen@huawei.com, jeff.liu@oracle.com, xuejiufei@huawei.com

Subject: + ocfs2-fix-null-pointer-dereference-when-tranverse-o2hb_all_regions.patch added to -mm tree
To: xuejiufei@huawei.com,jeff.liu@oracle.com,jiangyiwen@huawei.com,jlbec@evilplan.org,mfasheh@suse.com,sunil.mushran@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 02 Jul 2013 12:39:44 -0700


The patch titled
     Subject: ocfs2: fix NULL pointer dereference when traversing o2hb_all_regions
has been added to the -mm tree.  Its filename is
     ocfs2-fix-null-pointer-dereference-when-tranverse-o2hb_all_regions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-null-pointer-dereference-when-tranverse-o2hb_all_regions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-null-pointer-dereference-when-tranverse-o2hb_all_regions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2367,6 +2367,9 @@ static int o2hb_region_pin(const char *r
 	assert_spin_locked(&o2hb_live_lock);
 
 	list_for_each_entry(reg, &o2hb_all_regions, hr_all_item) {
+		if (reg->hr_item_dropped)
+			continue;
+
 		uuid = config_item_name(&reg->hr_item);
 
 		/* local heartbeat */
@@ -2417,6 +2420,9 @@ static void o2hb_region_unpin(const char
 	assert_spin_locked(&o2hb_live_lock);
 
 	list_for_each_entry(reg, &o2hb_all_regions, hr_all_item) {
+		if (reg->hr_item_dropped)
+			continue;
+
 		uuid = config_item_name(&reg->hr_item);
 		if (region_uuid) {
 			if (strcmp(region_uuid, uuid))
@@ -2632,6 +2638,9 @@ int o2hb_get_all_regions(char *region_uu
 
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

linux-next.patch
ocfs2-add-missing-dlm_put-in-dlm_begin_reco_handler.patch
ocfs2-dlmlock_master-should-return-dlm_normal-after-adding-lock-to-blocked-list.patch
ocfs2-fix-null-pointer-dereference-when-tranverse-o2hb_all_regions.patch

