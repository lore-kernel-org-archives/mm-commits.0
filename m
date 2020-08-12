Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3527AC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02FBE2076C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195952;
	bh=9hJymbjeZqLd7jmGL/lICFG778oGHSQhXbpMLZ5rn6g=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=GVrjyZzSGLkUSyMJzckqeGVI96Ye59LgW3C8XYOWyBGD8b/OWgyy7IPtnqv2U1Mw+
	 GNvIpwQAqcoNY3ATv2Yzcs0k3pM6e71N+XwoBLMq/+DBAT7MsgIbTF65UTb6G7oYBA
	 4GkW1gRBKB6NAKuf8MmcrTmhZOoP5FWRtdXOhNVA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgHLBcb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:32:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:60992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726517AbgHLBcb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:32:31 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1173A206B2;
        Wed, 12 Aug 2020 01:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195951;
        bh=9hJymbjeZqLd7jmGL/lICFG778oGHSQhXbpMLZ5rn6g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yGq07Z4cIgELJ2SB1hGpPxd8EauTiMVsHlApDjAJhGckyeVjnha/qoZAtTEz8weNr
         ftRnBlSWIynqjBS8GfCm7dOsaiekYL86ltnn88YmKKIjn2HreKQTuvdM5SuBEpZPGm
         XJAUOJL+CdG5bFNCDZNpbwyhxj4v3EHzmALYJA/k=
Date:   Tue, 11 Aug 2020 18:32:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        sjpark@amazon.de, torvalds@linux-foundation.org
Subject:  [patch 042/165] mm: drop duplicated words in <linux/mm.h>
Message-ID: <20200812013230.ciBB8kQUq%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm: drop duplicated words in <linux/mm.h>

Drop the doubled words "to" and "the".

Link: http://lkml.kernel.org/r/d9fae8d6-0d60-4d52-9385-3199ee98de49@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: SeongJae Park <sjpark@amazon.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-drop-duplicated-words-in-linux-mmh
+++ a/include/linux/mm.h
@@ -479,7 +479,7 @@ static inline bool fault_flag_allow_retr
 	{ FAULT_FLAG_INTERRUPTIBLE,	"INTERRUPTIBLE" }
 
 /*
- * vm_fault is filled by the the pagefault handler and passed to the vma's
+ * vm_fault is filled by the pagefault handler and passed to the vma's
  * ->fault function. The vma's ->fault is responsible for returning a bitmask
  * of VM_FAULT_xxx flags that give details about how the fault was handled.
  *
@@ -2599,7 +2599,7 @@ extern unsigned long stack_guard_gap;
 /* Generic expand stack which grows the stack according to GROWS{UP,DOWN} */
 extern int expand_stack(struct vm_area_struct *vma, unsigned long address);
 
-/* CONFIG_STACK_GROWSUP still needs to to grow downwards at some places */
+/* CONFIG_STACK_GROWSUP still needs to grow downwards at some places */
 extern int expand_downwards(struct vm_area_struct *vma,
 		unsigned long address);
 #if VM_GROWSUP
_
