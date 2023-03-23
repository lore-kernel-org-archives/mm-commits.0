Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 192E2C76195
	for <mm-commits@archiver.kernel.org>; Thu, 23 Mar 2023 01:34:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbjCWBes (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Mar 2023 21:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbjCWBeW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Mar 2023 21:34:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A31549EB
        for <mm-commits@vger.kernel.org>; Wed, 22 Mar 2023 18:33:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 162D8623A6
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 01:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FFB3C433D2;
        Thu, 23 Mar 2023 01:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679535149;
        bh=TtVEdvv13a5icP40r6mKQbSJO9KF6iveDKVzykWBfXw=;
        h=Date:To:From:Subject:From;
        b=MOI0APRAYQfVQTSaaVlWsW0c5hiReH0XhBEON0anxmnDrRXBOyHH5+SFruA0plGY3
         jZqqyTXThzIkM2vkCiHTxY5/GCao2ANJLSUnby2SnhVsx0iH36+FvcXBPrQ8ihzKu7
         dD0EiLeHj0mxhQc2FQ6DWROknvdwB3V4EEheki9w=
Date:   Wed, 22 Mar 2023 18:32:28 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org,
        quic_mojha@quicinc.com, david@redhat.com, minwoo.im.dev@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mmap-remove-newline-at-the-end-of-the-trace.patch removed from -mm tree
Message-Id: <20230323013229.6FFB3C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: mmap: remove newline at the end of the trace
has been removed from the -mm tree.  Its filename was
     mm-mmap-remove-newline-at-the-end-of-the-trace.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Minwoo Im <minwoo.im.dev@gmail.com>
Subject: mm: mmap: remove newline at the end of the trace
Date: Sat, 11 Mar 2023 08:18:00 +0900

We already have newline in TP_printk so remove the redundant newline
character at the end of the mmap trace.

<...>-345     [006] .....    95.589290: exit_mmap: mt_mod ...

<...>-345     [006] .....    95.589413: vm_unmapped_area: addr=...

<...>-345     [006] .....    95.589571: vm_unmapped_area: addr=...

<...>-345     [006] .....    95.589606: vm_unmapped_area: addr=...

to

<...>-336     [006] .....    44.762506: exit_mmap: mt_mod ...
<...>-336     [006] .....    44.762654: vm_unmapped_area: addr=...
<...>-336     [006] .....    44.762794: vm_unmapped_area: addr=...
<...>-336     [006] .....    44.762835: vm_unmapped_area: addr=...

Link: https://lkml.kernel.org/r/ZAu6qDsNPmk82UjV@minwoo-desktop
FIxes: df529cabb7a25 ("mm: mmap: add trace point of vm_unmapped_area")
Signed-off-by: Minwoo Im <minwoo.im.dev@gmail.com>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/trace/events/mmap.h~mm-mmap-remove-newline-at-the-end-of-the-trace
+++ a/include/trace/events/mmap.h
@@ -35,7 +35,7 @@ TRACE_EVENT(vm_unmapped_area,
 		__entry->align_offset = info->align_offset;
 	),
 
-	TP_printk("addr=0x%lx err=%ld total_vm=0x%lx flags=0x%lx len=0x%lx lo=0x%lx hi=0x%lx mask=0x%lx ofs=0x%lx\n",
+	TP_printk("addr=0x%lx err=%ld total_vm=0x%lx flags=0x%lx len=0x%lx lo=0x%lx hi=0x%lx mask=0x%lx ofs=0x%lx",
 		IS_ERR_VALUE(__entry->addr) ? 0 : __entry->addr,
 		IS_ERR_VALUE(__entry->addr) ? __entry->addr : 0,
 		__entry->total_vm, __entry->flags, __entry->length,
@@ -110,7 +110,7 @@ TRACE_EVENT(exit_mmap,
 		       __entry->mt		= &mm->mm_mt;
 	),
 
-	TP_printk("mt_mod %p, DESTROY\n",
+	TP_printk("mt_mod %p, DESTROY",
 		  __entry->mt
 	)
 );
_

Patches currently in -mm which might be from minwoo.im.dev@gmail.com are


