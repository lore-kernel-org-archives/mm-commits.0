Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6445DC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:29:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377915AbiATV3r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:29:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377918AbiATV3q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:29:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5684DC061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:29:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14C0BB81E69
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23FBC340E0;
        Thu, 20 Jan 2022 21:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714183;
        bh=Soi87dB5yWGvI7egK/YZYM7RCPFcM8SZoE1o0Aq6tEM=;
        h=Date:From:To:Subject:From;
        b=fuvISg7BEOxQ8SRlXMq1ss/TIYV3c62G5txSkZTL81i31H4yFembvvTMGIkmjybH3
         EwFz0uxnuLRct2uwvZibcLNJBQ+w/bY+NfOqA3RM0LWFu4IdV9hQ4SRXLHz9TPtTaj
         w7SvqcsVKONyhoxf+vMglrAtyiA5yMp7SwiwMZ+4=
Date:   Thu, 20 Jan 2022 13:29:43 -0800
From:   akpm@linux-foundation.org
To:     luo.penghao@zte.com.cn, mcgrof@kernel.org,
        mm-commits@vger.kernel.org, zealci@zte.com.cn
Subject:  [merged] sysctl-remove-redundant-ret-assignment.patch
 removed from -mm tree
Message-ID: <20220120212943.OQ6e1rPMB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: Remove redundant ret assignment
has been removed from the -mm tree.  Its filename was
     sysctl-remove-redundant-ret-assignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: luo penghao <luo.penghao@zte.com.cn>
Subject: sysctl: Remove redundant ret assignment

Subsequent if judgments will assign new values to ret, so the statement
here should be deleted

The clang_analyzer complains as follows:

fs/proc/proc_sysctl.c:

Value stored to 'ret' is never read

Link: https://lkml.kernel.org/r/20211230063622.586360-1-luo.penghao@zte.com.cn
Signed-off-by: luo penghao <luo.penghao@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/proc/proc_sysctl.c~sysctl-remove-redundant-ret-assignment
+++ a/fs/proc/proc_sysctl.c
@@ -1053,7 +1053,6 @@ static int sysctl_follow_link(struct ctl
 	struct ctl_dir *dir;
 	int ret;
 
-	ret = 0;
 	spin_lock(&sysctl_lock);
 	root = (*pentry)->data;
 	set = lookup_header_set(root);
_

Patches currently in -mm which might be from luo.penghao@zte.com.cn are


