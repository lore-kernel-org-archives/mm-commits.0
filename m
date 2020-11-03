Return-Path: <SRS0=UcEf=EJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DC8FC2D0A3
	for <mm-commits@archiver.kernel.org>; Tue,  3 Nov 2020 18:17:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 338F72080D
	for <mm-commits@archiver.kernel.org>; Tue,  3 Nov 2020 18:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604427437;
	bh=cChtLUr/bOmH+IxGPaA3rU9CP2f1cG/N+jnpPnamO1A=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=DXGfYDazwbZO103x8jv/KpM3v9f4mEpood2nGisJoHY6HkHiCU+K9ZP30MsfODAxR
	 /UJavEBwUsxqE0viLZFCs4CTxm54v1Tj6FWSQjIc+SHB1yVJ9pqwyEaaNbAv+sl5k9
	 TNkLxW7+RqOSfqCaejj+wCDYnKy2nb5AUD6Aiz+4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729268AbgKCSRQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 13:17:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:39604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbgKCSRQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 13:17:16 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 808E5207BB;
        Tue,  3 Nov 2020 18:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604427434;
        bh=cChtLUr/bOmH+IxGPaA3rU9CP2f1cG/N+jnpPnamO1A=;
        h=Date:From:To:Subject:From;
        b=Yn42nBdU54vn5pGv+bSmzDsQbrAbLqofQQpKtuvfMUB3mo1gF2wvLjYrJTkpZ9kyY
         Dt0/O6kh1mH1ZdQ7XHlIJDm8100HcnERz/wqvf3WcoXF9ItifVcCLbkuwYbi82c3Z7
         P8XY3uppYu4drqmHxcYrF1t/gqsCdAR/L7orhrdI=
Date:   Tue, 03 Nov 2020 10:17:14 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, chaithco@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-oom-keep-oom_adj-under-or-at-upper-limit-when-printing.patch removed
 from -mm tree
Message-ID: <20201103181714.CbuW8OJFI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: keep oom_adj under or at upper limit when printing
has been removed from the -mm tree.  Its filename was
     mm-oom-keep-oom_adj-under-or-at-upper-limit-when-printing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Charles Haithcock <chaithco@redhat.com>
Subject: mm, oom: keep oom_adj under or at upper limit when printing

For oom_score_adj values in the range [942,999], the current
calculations will print 16 for oom_adj. This patch simply limits the
output so output is inline with docs.

Link: https://lkml.kernel.org/r/20201020165130.33927-1-chaithco@redhat.com
Signed-off-by: Charles Haithcock <chaithco@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/proc/base.c~mm-oom-keep-oom_adj-under-or-at-upper-limit-when-printing
+++ a/fs/proc/base.c
@@ -1049,6 +1049,8 @@ static ssize_t oom_adj_read(struct file
 		oom_adj = (task->signal->oom_score_adj * -OOM_DISABLE) /
 			  OOM_SCORE_ADJ_MAX;
 	put_task_struct(task);
+	if (oom_adj > OOM_ADJUST_MAX)
+		oom_adj = OOM_ADJUST_MAX;
 	len = snprintf(buffer, sizeof(buffer), "%d\n", oom_adj);
 	return simple_read_from_buffer(buf, count, ppos, buffer, len);
 }
_

Patches currently in -mm which might be from chaithco@redhat.com are


