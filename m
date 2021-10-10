Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9424BC433EF
	for <mm-commits@archiver.kernel.org>; Sun, 10 Oct 2021 21:14:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AEA060F23
	for <mm-commits@archiver.kernel.org>; Sun, 10 Oct 2021 21:14:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbhJJVQe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Oct 2021 17:16:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230364AbhJJVQe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 10 Oct 2021 17:16:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5C3560F22;
        Sun, 10 Oct 2021 21:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633900475;
        bh=5vm/+nul0qfc3Ce+a8w+C9LQ7kXNrgKO3gl/K2j8Qx4=;
        h=Date:From:To:Subject:From;
        b=I1SImNHcMq9VYOLcTncofZvffkWbt1FTjGsIIlwNOSjGYHbNnq8pfBu7PEbagGYx8
         7z2xEyZWytG97rbrPhB+Sf6MCsrb4Xd4MqT28rvERXq0nt0Mb0ZzP0jnacJDPtSsu4
         ODESeYyxthPPAFF3sgrVXeYDCE7gSDF3tuM9C7wo=
Date:   Sun, 10 Oct 2021 14:14:34 -0700
From:   akpm@linux-foundation.org
To:     axelrasmussen@google.com, ligang.bdlg@bytedance.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, rostedt@goodmis.org,
        vbabka@suse.cz
Subject:  +
 mm-mmap_lock-remove-redundant-newline-in-tp_printk.patch added to -mm tree
Message-ID: <20211010211434.a1GwSZmwx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mmap_lock: remove redundant newline  in TP_printk
has been added to the -mm tree.  Its filename is
     mm-mmap_lock-remove-redundant-newline-in-tp_printk.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmap_lock-remove-redundant-newline-in-tp_printk.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap_lock-remove-redundant-newline-in-tp_printk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gang Li <ligang.bdlg@bytedance.com>
Subject: mm: mmap_lock: remove redundant newline  in TP_printk

Ftrace core will add newline automatically on printing, so using it in
TP_printkcreates a blank line.

Link: https://lkml.kernel.org/r/20211009071105.69544-1-ligang.bdlg@bytedance.com
Signed-off-by: Gang Li <ligang.bdlg@bytedance.com>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/mmap_lock.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/trace/events/mmap_lock.h~mm-mmap_lock-remove-redundant-newline-in-tp_printk
+++ a/include/trace/events/mmap_lock.h
@@ -32,7 +32,7 @@ TRACE_EVENT_FN(mmap_lock_start_locking,
 	),
 
 	TP_printk(
-		"mm=%p memcg_path=%s write=%s\n",
+		"mm=%p memcg_path=%s write=%s",
 		__entry->mm,
 		__get_str(memcg_path),
 		__entry->write ? "true" : "false"
@@ -63,7 +63,7 @@ TRACE_EVENT_FN(mmap_lock_acquire_returne
 	),
 
 	TP_printk(
-		"mm=%p memcg_path=%s write=%s success=%s\n",
+		"mm=%p memcg_path=%s write=%s success=%s",
 		__entry->mm,
 		__get_str(memcg_path),
 		__entry->write ? "true" : "false",
@@ -92,7 +92,7 @@ TRACE_EVENT_FN(mmap_lock_released,
 	),
 
 	TP_printk(
-		"mm=%p memcg_path=%s write=%s\n",
+		"mm=%p memcg_path=%s write=%s",
 		__entry->mm,
 		__get_str(memcg_path),
 		__entry->write ? "true" : "false"
_

Patches currently in -mm which might be from ligang.bdlg@bytedance.com are

mm-mmap_lock-remove-redundant-newline-in-tp_printk.patch
mm-mmap_lock-use-declare_event_class-and-define_event_fn.patch

