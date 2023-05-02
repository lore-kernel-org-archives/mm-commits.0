Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1AECC77B78
	for <mm-commits@archiver.kernel.org>; Tue,  2 May 2023 20:50:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbjEBUuq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 May 2023 16:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjEBUup (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 May 2023 16:50:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1E71BD4
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 13:50:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15F8F628B4
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 20:50:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D447C433D2;
        Tue,  2 May 2023 20:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683060643;
        bh=NhplG4qTlWEV7y444svgEY8DUwv3AdMoup7u/VZ7oQ4=;
        h=Date:To:From:Subject:From;
        b=eXquGM+1+t+cKO+2vBaQSDLzP0kLC619dkgMjtgZDZPcbd6wfc/oyUphcjzASifri
         ve+eaw3nhAJx5WdqVN6eF8EGIjoTCd4LAgbS9MozBpYE/zjYh1gA44pUNlFpJzwc9P
         Iue4guqNoPWI9/ZxTOUK0DpjYQIpnI/hWQYz4ldM=
Date:   Tue, 02 May 2023 13:50:42 -0700
To:     mm-commits@vger.kernel.org, william.lam@bytedance.com,
        wefu@redhat.com, pintu@codeaurora.org, osalvador@suse.de,
        mgorman@techsingularity.net, wenyang.linux@foxmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide.patch added to mm-unstable branch
Message-Id: <20230502205043.6D447C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: optimize compact_memory to comply with the admin-guide
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Wen Yang <wenyang.linux@foxmail.com>
Subject: mm: compaction: optimize compact_memory to comply with the admin-guide
Date: Tue, 25 Apr 2023 23:52:35 +0800

For the /proc/sys/vm/compact_memory file, the admin-guide states: When 1
is written to the file, all zones are compacted such that free memory is
available in contiguous blocks where possible.  This can be important for
example in the allocation of huge pages although processes will also
directly compact memory as required

But it was not strictly followed, writing any value would cause all zones
to be compacted.

It has been slightly optimized to comply with the admin-guide.  Enforce
the 1 on the unlikely chance that the sysctl handler is ever extended to
do something different.

Commit ef4984384172 ("mm/compaction: remove unused variable
sysctl_compact_memory") has also been optimized a bit here, as the
declaration in the external header file has been eliminated, and
sysctl_compact_memory also needs to be verified.

Link: https://lkml.kernel.org/r/tencent_DFF54DB2A60F3333F97D3F6B5441519B050A@qq.com
Signed-off-by: Wen Yang <wenyang.linux@foxmail.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: William Lam <william.lam@bytedance.com>
Cc: Pintu Kumar <pintu@codeaurora.org>
Cc: Fu Wei <wefu@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide
+++ a/mm/compaction.c
@@ -1736,6 +1736,7 @@ static int sysctl_compact_unevictable_al
  */
 static unsigned int __read_mostly sysctl_compaction_proactiveness = 20;
 static int sysctl_extfrag_threshold = 500;
+static int sysctl_compact_memory;
 
 static inline void
 update_fast_start_pfn(struct compact_control *cc, unsigned long pfn)
@@ -2780,6 +2781,15 @@ static int compaction_proactiveness_sysc
 static int sysctl_compaction_handler(struct ctl_table *table, int write,
 			void *buffer, size_t *length, loff_t *ppos)
 {
+	int ret;
+
+	ret = proc_dointvec(table, write, buffer, length, ppos);
+	if (ret)
+		return ret;
+
+	if (sysctl_compact_memory != 1)
+		return -EINVAL;
+
 	if (write)
 		compact_nodes();
 
@@ -3095,7 +3105,7 @@ static int proc_dointvec_minmax_warn_RT_
 static struct ctl_table vm_compaction[] = {
 	{
 		.procname	= "compact_memory",
-		.data		= NULL,
+		.data		= &sysctl_compact_memory,
 		.maxlen		= sizeof(int),
 		.mode		= 0200,
 		.proc_handler	= sysctl_compaction_handler,
_

Patches currently in -mm which might be from wenyang.linux@foxmail.com are

mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide.patch

