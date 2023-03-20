Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D915C6FD1D
	for <mm-commits@archiver.kernel.org>; Mon, 20 Mar 2023 21:15:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjCTVPI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Mar 2023 17:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbjCTVPH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Mar 2023 17:15:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A295253
        for <mm-commits@vger.kernel.org>; Mon, 20 Mar 2023 14:15:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38966B810BC
        for <mm-commits@vger.kernel.org>; Mon, 20 Mar 2023 21:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DF4C433EF;
        Mon, 20 Mar 2023 21:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679346901;
        bh=o3gpahSrJ+D0CdW192k6UP5Mgmnrny4B9UehtuGPKd0=;
        h=Date:To:From:Subject:From;
        b=HaSfGrLsnCDeZx9RP6B+NGGTXLhKKdwZ3/4yb9Fpd026xszPHBbbk17YtmM1LbC3x
         WYBgmqOyPm//OY6klQGtU04RTJf+2v+hUjZJT+Vl96KwHcuZH0MXOgoiIpdc+6zH8g
         7jZC3GVoSh7/duc64cyklOZMTOcqOQ46aswsHFAE=
Date:   Mon, 20 Mar 2023 14:15:00 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org,
        quic_mojha@quicinc.com, david@redhat.com, minwoo.im.dev@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-remove-newline-at-the-end-of-the-trace.patch added to mm-hotfixes-unstable branch
Message-Id: <20230320211501.B6DF4C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mmap: remove newline at the end of the trace
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mmap-remove-newline-at-the-end-of-the-trace.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-remove-newline-at-the-end-of-the-trace.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-mmap-remove-newline-at-the-end-of-the-trace.patch

