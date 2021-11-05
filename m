Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6CAAC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:39:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D37886128C
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:39:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233407AbhKEUly (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:41:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232810AbhKEUlx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:41:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C997611C4;
        Fri,  5 Nov 2021 20:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144753;
        bh=rtwuP7hVZi1gtDgBjBy0ZFmr7NoKm/yrpYBknmJAcgI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jevt8ezyR/NAC9Jdo0allCuWrkP2GRGiwnMFKr9jEeKZmSW/p3/SiOXNPd4d124Ri
         sp51P1xiyL75YJUJGS+Z549WSh3eEqvEUm27Zcts5Xqup5XLdtXTZqVUTwtZc/eC9k
         Ewpi7iLOkPPTf4f1SX4cWI57lGSPc4Zd1IGdp1nk=
Date:   Fri, 05 Nov 2021 13:39:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axelrasmussen@google.com,
        ligang.bdlg@bytedance.com, linux-mm@kvack.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, rostedt@goodmis.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 087/262] mm: mmap_lock: remove redundant newline 
 in TP_printk
Message-ID: <20211105203913.NmX2MeX7r%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
