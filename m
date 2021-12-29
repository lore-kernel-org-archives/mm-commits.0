Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE349C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 29 Dec 2021 23:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbhL2Xfu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Dec 2021 18:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233173AbhL2Xfu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Dec 2021 18:35:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB4BC061574
        for <mm-commits@vger.kernel.org>; Wed, 29 Dec 2021 15:35:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6F1C615A8
        for <mm-commits@vger.kernel.org>; Wed, 29 Dec 2021 23:35:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F69C36AEA;
        Wed, 29 Dec 2021 23:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640820949;
        bh=8g+OuQBldqaoo6TyABRspjHyWqFG9bqmmGvgEzbBeis=;
        h=Date:From:To:Subject:From;
        b=VBAbPmhvULkazN1ceL7/4Phw7ZWRqhONClOV6n0tL8ePOK1pyUCNUC52zgaGShUjn
         PykFwM84s2sj8eOUoxq+fdpgakdmsmrR83QVfv/5HSDv3NUZAUka1axNlMKedt4kIi
         VQpcCKhtsjx+O/OIhDw0d1LmP/JOyc6Uju3GnANc=
Date:   Wed, 29 Dec 2021 15:35:49 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, gregkh@linuxfoundation.org, ghe@suse.com,
        gechangwei@live.cn, ocfs2-devel@oss.oracle.com
Subject:  + ocfs2-use-default_groups-in-kobj_type.patch added to -mm
 tree
Message-ID: <20211229233549.asRi_%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: use default_groups in kobj_type
has been added to the -mm tree.  Its filename is
     ocfs2-use-default_groups-in-kobj_type.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-use-default_groups-in-kobj_type.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-use-default_groups-in-kobj_type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Greg Kroah-Hartman via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
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

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are

ocfs2-use-default_groups-in-kobj_type.patch

