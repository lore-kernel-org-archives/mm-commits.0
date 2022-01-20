Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4C82C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:23:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377806AbiATVXZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:23:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56364 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237238AbiATVXY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:23:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5287BB81E6A
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:23:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D03C340E0;
        Thu, 20 Jan 2022 21:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713802;
        bh=V+K8vwvEWtB7sZ1d94qakNOEZjG14vMsjplFgEi1dUY=;
        h=Date:From:To:Subject:From;
        b=qTGPjQB3JsCl2Gft6QkFelnCT5hGNACvGGGZOo8rAR725Lzz71ERmtFxzaiBrbDmw
         CpXG/jHeU5wavv4XNP3Kyj00tJJr0v1IhzVRDIer6PlO1PcGPY0hD7Swh2GSqK/R/L
         SPMNLMuVBeuPtb6Qt6YKZC+KXif/k/5GiDoabCiU=
Date:   Thu, 20 Jan 2022 13:23:21 -0800
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, gregkh@linuxfoundation.org,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com
Subject:  [merged] ocfs2-use-default_groups-in-kobj_type.patch
 removed from -mm tree
Message-ID: <20220120212321.U_APXvuzm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: use default_groups in kobj_type
has been removed from the -mm tree.  Its filename was
     ocfs2-use-default_groups-in-kobj_type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: ocfs2: use default_groups in kobj_type

There are currently 2 ways to create a set of sysfs files for a kobj_type,
through the default_attrs field, and the default_groups field.  Move the
ocfs2 code to use default_groups field which has been the preferred way
since aa30f47cf666 ("kobject: Add support for default attribute groups to
kobj_type") so that we can soon get rid of the obsolete default_attrs
field.

Link: https://lkml.kernel.org/r/20211228144517.391660-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/filecheck.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/filecheck.c~ocfs2-use-default_groups-in-kobj_type
+++ a/fs/ocfs2/filecheck.c
@@ -94,6 +94,7 @@ static struct attribute *ocfs2_filecheck
 	&ocfs2_filecheck_attr_set.attr,
 	NULL
 };
+ATTRIBUTE_GROUPS(ocfs2_filecheck);
 
 static void ocfs2_filecheck_release(struct kobject *kobj)
 {
@@ -138,7 +139,7 @@ static const struct sysfs_ops ocfs2_file
 };
 
 static struct kobj_type ocfs2_ktype_filecheck = {
-	.default_attrs = ocfs2_filecheck_attrs,
+	.default_groups = ocfs2_filecheck_groups,
 	.sysfs_ops = &ocfs2_filecheck_ops,
 	.release = ocfs2_filecheck_release,
 };
_

Patches currently in -mm which might be from gregkh@linuxfoundation.org are


