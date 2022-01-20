Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 344D5C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:23:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377807AbiATVX3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:23:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347243AbiATVX3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:23:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A64C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:23:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 910B160EFA
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:23:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7BEC340E0;
        Thu, 20 Jan 2022 21:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713808;
        bh=O9bLt12fehPXBYkdIlat76jVRp5XrnxITYbePk/W5qU=;
        h=Date:From:To:Subject:From;
        b=GyWJgSHAle0ecu+3R3Zql43VRKxN8bei67SG7j/SXaM/RvpVZ+oLkiTAf4osqa3Jo
         CBA72GEuFU/z09Uz/A0eUyjpxNB0tsY0+0sCLPOG4xQRUQ8/fMZFTnLlm7qKC1OxjW
         GEl9bZOlix3dBO3OcxKgZ3SLeQR4FKiLFJamYpv4=
Date:   Thu, 20 Jan 2022 13:23:27 -0800
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, gregkh@linuxfoundation.org,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com
Subject:  [merged]
 ocfs2-cluster-use-default_groups-in-kobj_type.patch removed from -mm tree
Message-ID: <20220120212327.OeqyVdNMS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: cluster: use default_groups in kobj_type
has been removed from the -mm tree.  Its filename was
     ocfs2-cluster-use-default_groups-in-kobj_type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: ocfs2: cluster: use default_groups in kobj_type

There are currently 2 ways to create a set of sysfs files for a kobj_type,
through the default_attrs field, and the default_groups field.  Move the
ocfs2 cluster sysfs code to use default_groups field which has been the
preferred way since aa30f47cf666 ("kobject: Add support for default
attribute groups to kobj_type") so that we can soon get rid of the
obsolete default_attrs field.

Link: https://lkml.kernel.org/r/20220106102028.3345634-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Tested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/masklog.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/fs/ocfs2/cluster/masklog.c~ocfs2-cluster-use-default_groups-in-kobj_type
+++ a/fs/ocfs2/cluster/masklog.c
@@ -120,7 +120,8 @@ static struct mlog_attribute mlog_attrs[
 	define_mask(KTHREAD),
 };
 
-static struct attribute *mlog_attr_ptrs[MLOG_MAX_BITS] = {NULL, };
+static struct attribute *mlog_default_attrs[MLOG_MAX_BITS] = {NULL, };
+ATTRIBUTE_GROUPS(mlog_default);
 
 static ssize_t mlog_show(struct kobject *obj, struct attribute *attr,
 			 char *buf)
@@ -144,8 +145,8 @@ static const struct sysfs_ops mlog_attr_
 };
 
 static struct kobj_type mlog_ktype = {
-	.default_attrs = mlog_attr_ptrs,
-	.sysfs_ops     = &mlog_attr_ops,
+	.default_groups = mlog_default_groups,
+	.sysfs_ops      = &mlog_attr_ops,
 };
 
 static struct kset mlog_kset = {
@@ -157,10 +158,10 @@ int mlog_sys_init(struct kset *o2cb_kset
 	int i = 0;
 
 	while (mlog_attrs[i].attr.mode) {
-		mlog_attr_ptrs[i] = &mlog_attrs[i].attr;
+		mlog_default_attrs[i] = &mlog_attrs[i].attr;
 		i++;
 	}
-	mlog_attr_ptrs[i] = NULL;
+	mlog_default_attrs[i] = NULL;
 
 	kobject_set_name(&mlog_kset.kobj, "logmask");
 	mlog_kset.kobj.kset = o2cb_kset;
_

Patches currently in -mm which might be from gregkh@linuxfoundation.org are


