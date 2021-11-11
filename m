Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E59F9C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFDA061284
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234197AbhKKCp5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:45:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:51190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234183AbhKKCp4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:45:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E58461108;
        Thu, 11 Nov 2021 02:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598588;
        bh=tE03VBAx6p87O0kFm55OY+bk1cV7zNDXfnl6k/xIMGA=;
        h=Date:From:To:Subject:From;
        b=QA4rZf7L69PHKOPsMXH8dcb8WF6JwCR2wVBIkhAgDoGK8Sa6NETXamSpYIHpdllTS
         Tg0V/ZSz5HqDfoYPiZTADFqBRx2P1ZloOyqgNloApeTsgUTbbZCBvABLTufqbD/TYr
         BSc3ko5h52Xkz+bLr/azPOCXsgz9DoTQg4qcvcak=
Date:   Wed, 10 Nov 2021 18:43:08 -0800
From:   akpm@linux-foundation.org
To:     axelrasmussen@google.com, ligang.bdlg@bytedance.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, rostedt@goodmis.org,
        vbabka@suse.cz
Subject:  [merged]
 mm-mmap_lock-remove-redundant-newline-in-tp_printk.patch removed from -mm
 tree
Message-ID: <20211111024308.8dRgTUjBG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mmap_lock: remove redundant newline  in TP_printk
has been removed from the -mm tree.  Its filename was
     mm-mmap_lock-remove-redundant-newline-in-tp_printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gang Li <ligang.bdlg@bytedance.com>
Subject: mm: mmap_lock: remove redundant newline  in TP_printk

Ftrace core will add newline automatically on printing, so using it in
TP_printkcreates a blank line.

Link: https://lkml.kernel.org/r/20211009071105.69544-1-ligang.bdlg@bytedance.com
Signed-off-by: Gang Li <ligang.bdlg@bytedance.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
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


