Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47786C7EE43
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:27:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbjFIX1E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbjFIX0z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:26:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628F830E5
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:26:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F34065CD7
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:26:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950CEC433EF;
        Fri,  9 Jun 2023 23:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353213;
        bh=+viFOUdaivgrb1l0RiIWm2pX8nVKXGNCnT4ZrBa6R9E=;
        h=Date:To:From:Subject:From;
        b=E17pxrcWePVc+hGTzEgqzcWiZIWi8ChytWr6zYA65APOJ7h1ki3fLHwb19PFMC4f5
         C6FX6etfdrN2vcbQoWzCIRLV7zbeEoNIV8nxMtjFoWYu+oznsOihsYnWJ9/ePPYcKc
         cgJGJAwO9phrtXKebgocJ4YkxtNMjiDcsm9pLaDA=
Date:   Fri, 09 Jun 2023 16:26:52 -0700
To:     mm-commits@vger.kernel.org, william.lam@bytedance.com,
        wefu@redhat.com, pintu@codeaurora.org, osalvador@suse.de,
        mgorman@techsingularity.net, wenyang.linux@foxmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide.patch removed from -mm tree
Message-Id: <20230609232653.950CEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: compaction: optimize compact_memory to comply with the admin-guide
has been removed from the -mm tree.  Its filename was
     mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: add __read_mostly, per Mel]
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
+static int __read_mostly sysctl_compact_memory;
 
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


