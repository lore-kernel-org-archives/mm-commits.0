Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63FABC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:03:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiANWDp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:03:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45458 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiANWDn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:03:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 414CB61FE2
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:03:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A78C36AE5;
        Fri, 14 Jan 2022 22:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197822;
        bh=HJbql4+3mauyMikf7+eBfBDh1LQCYCeuNiH0JIFBsqM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=dOGPolUFpW1JC0IsK7XE7VcGNPcFCpSen0mOaq0pBWHZXLOOWydAfrxMB2AUkt9Xk
         EihYNYdjhZ/xPiQ+zjrgAdlE/r59SFzX1bsNMGFaB2Ec9Wp+x81BOXTmSwnO04dRxs
         VtXzwifF59lHBrCKS0mE95LNLoFgZINWRyKo6pG0=
Date:   Fri, 14 Jan 2022 14:03:41 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
        gregkh@linuxfoundation.org, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        linux-mm@kvack.org, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com, torvalds@linux-foundation.org
Subject:  [patch 016/146] ocfs2: use default_groups in kobj_type
Message-ID: <20220114220341.DGgJjC07l%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
