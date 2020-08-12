Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1530C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:01:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91F7620768
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266116;
	bh=ujpZ9gxyCo+RcgStPMHJLNnNInwAsrNK3NbuJIMrOiY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=R7LU2Ol6aUeWExe/pIupyuI2sOO1lKHULpcz5V1zkTHhbLMzO2KvJs+Fc5q/ZafEK
	 0/4t+MiybOk23Q59ufttNd23TwsygUVTZEi66wZnEl8lSrvaomSpZIdcmohpGjjHxw
	 o/C2RuT4seCVMTFgx5gbc0a01MLotxCNbDMNXPBo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgHLVB4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:01:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726611AbgHLVBz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:01:55 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AF162080C;
        Wed, 12 Aug 2020 21:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266115;
        bh=ujpZ9gxyCo+RcgStPMHJLNnNInwAsrNK3NbuJIMrOiY=;
        h=Date:From:To:Subject:From;
        b=X8pAEQ56ezltDEH3aO0wwBPJTTsWkSZZoRWoKeZL9sDooG32yVoYJTwp/Bmhatn69
         tfQqpOd/X/hvcrTVILO8ueyMCOr8xK5YaxbLqbO09uE5ZtDCFBU8RB1qzZAg5F4y1b
         Zv+QRIXD8btvZpa5TX8EDw8+tCt5UJvcxAWWVazM=
Date:   Wed, 12 Aug 2020 14:01:55 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, laoar.shao@gmail.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, rientjes@google.com
Subject:  [merged]
 doc-mm-clarify-proc-pid-oom_score-value-range.patch removed from -mm tree
Message-ID: <20200812210155.hGpymPaqS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: doc, mm: clarify /proc/<pid>/oom_score value range
has been removed from the -mm tree.  Its filename was
     doc-mm-clarify-proc-pid-oom_score-value-range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: doc, mm: clarify /proc/<pid>/oom_score value range

The exported value includes oom_score_adj so the range is no [0, 1000] as
described in the previous section but rather [0, 2000].  Mention that fact
explicitly.

Link: http://lkml.kernel.org/r/20200709062603.18480-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    3 +++
 1 file changed, 3 insertions(+)

--- a/Documentation/filesystems/proc.rst~doc-mm-clarify-proc-pid-oom_score-value-range
+++ a/Documentation/filesystems/proc.rst
@@ -1676,6 +1676,9 @@ This file can be used to check the curre
 any given <pid>. Use it together with /proc/<pid>/oom_score_adj to tune which
 process should be killed in an out-of-memory situation.
 
+Please note that the exported value includes oom_score_adj so it is
+effectively in range [0,2000].
+
 
 3.3  /proc/<pid>/io - Display the IO accounting fields
 -------------------------------------------------------
_

Patches currently in -mm which might be from mhocko@suse.com are


