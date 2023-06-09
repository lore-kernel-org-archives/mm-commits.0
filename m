Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BC73C7EE43
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:31:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbjFIXbM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232632AbjFIX3K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:29:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22B34220
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:28:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 701EB61AE1
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:28:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E46C4339B;
        Fri,  9 Jun 2023 23:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353327;
        bh=dJ2yh4cMDPxfnRB+4dt4h6v6Njvck7f70CmSjwju+3c=;
        h=Date:To:From:Subject:From;
        b=TcmZk2TBphrc9Mx5Gj1xDA9GhSjWkwEVamwcnpf1e+04VzZc3/bLAfRGZv82RjEaK
         FZcy0X7VUHVdTn3ZLZDJ0TXkBR36eE9w8uggIfIqbDOGzM85Bi7ISecHN+mmEWw6m8
         3Sz4PCQsh2y1gxUOTqpVRVf3EtnjnLyGYX7Ll0n4=
Date:   Fri, 09 Jun 2023 16:28:47 -0700
To:     mm-commits@vger.kernel.org, trix@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-set-sysctl_lowmem_reserve_ratio-storage-class-specifier-to-static.patch removed from -mm tree
Message-Id: <20230609232847.C4E46C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: page_alloc: set sysctl_lowmem_reserve_ratio storage-class-specifier to static
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-set-sysctl_lowmem_reserve_ratio-storage-class-specifier-to-static.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tom Rix <trix@redhat.com>
Subject: mm: page_alloc: set sysctl_lowmem_reserve_ratio storage-class-specifier to static
Date: Thu, 18 May 2023 10:11:19 -0400

smatch reports
mm/page_alloc.c:247:5: warning: symbol
  'sysctl_lowmem_reserve_ratio' was not declared. Should it be static?

This variable is only used in its defining file, so it should be static

Link: https://lkml.kernel.org/r/20230518141119.927074-1-trix@redhat.com
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-set-sysctl_lowmem_reserve_ratio-storage-class-specifier-to-static
+++ a/mm/page_alloc.c
@@ -244,7 +244,7 @@ static void __free_pages_ok(struct page
  * TBD: should special case ZONE_DMA32 machines here - in those we normally
  * don't need any ZONE_NORMAL reservation
  */
-int sysctl_lowmem_reserve_ratio[MAX_NR_ZONES] = {
+static int sysctl_lowmem_reserve_ratio[MAX_NR_ZONES] = {
 #ifdef CONFIG_ZONE_DMA
 	[ZONE_DMA] = 256,
 #endif
_

Patches currently in -mm which might be from trix@redhat.com are

watchdog-delete-old-declarations-for-watchdog_softhardlockup_user_enabled-make-static.patch

