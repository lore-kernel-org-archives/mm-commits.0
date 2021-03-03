Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D097C001C7
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C6E864F34
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245133AbhCDA7E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:59:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:50976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1388364AbhCDAML (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 19:12:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8DE264F14;
        Wed,  3 Mar 2021 23:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614814547;
        bh=A8euxTBm3ve8wGPXbsAs6MGSWqPQOTQzncfKiKiN5+Q=;
        h=Date:From:To:Subject:From;
        b=m36zRTVcX6XAvGRxMrT7a++7tAMlmczMV45YWzeLzSzE1A1b7sw64rwUOJkRo9V0r
         UpuD0lPLCfcJkz8yXkgvunfMfkWmxTcwOFfmOVaXXZ/RAReWcVNBHWkRNixkgHW28P
         h2N3nEoLw/2l3QX+Io/n4QXa4ZEdvbos3dzD8g7c=
Date:   Wed, 03 Mar 2021 15:35:46 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, mm-commits@vger.kernel.org, sfr@canb.auug.org.au
Subject:  [folded-merged]
 mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch
 removed from -mm tree
Message-ID: <20210303233546.T98RsMacE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix
has been removed from the -mm tree.  Its filename was
     mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

This patch was dropped because it was folded into mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix

fix warnings

Link: http://lkml.kernel.org/r/20200717174705.GA55916@carbon.DHCP.thefacebook.com
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/vmstat.c~mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix
+++ a/mm/vmstat.c
@@ -168,9 +168,12 @@ EXPORT_SYMBOL(vm_numa_stat);
 EXPORT_SYMBOL(vm_node_stat);
 
 #ifdef CONFIG_SMP
-
 #define MAX_THRESHOLD 125
+#else
+#define MAX_THRESHOLD 0
+#endif
 
+#ifdef CONFIG_SMP
 int calculate_pressure_threshold(struct zone *zone)
 {
 	int threshold;
@@ -623,8 +626,6 @@ void dec_node_page_state(struct page *pa
 EXPORT_SYMBOL(dec_node_page_state);
 #else
 
-#define MAX_THRESHOLD 0
-
 /*
  * Use interrupt disable to serialize counter updates
  */
_

Patches currently in -mm which might be from guro@fb.com are

mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch

