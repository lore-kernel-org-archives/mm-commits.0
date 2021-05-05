Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7781CC43461
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5879961421
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbhEEBkv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:40:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:44354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231869AbhEEBkv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:40:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 544B1610A1;
        Wed,  5 May 2021 01:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178795;
        bh=9PrXqHw3L6RXU9RWEvz1C9Zd1/0GiUCuLCkDM/Z6lTM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PpixPnXhourCKx8fidaM3jntcXXZHsn0bzcim+q+AJvP7neTWxZBcX9dzUblmjhAu
         O6F4BSox2fuZHnMxcBNfZ9l5l3BWwZK7QhkoLmk6z8YH260SEh2FpYWB9rK98dJtwH
         4eaWDhInf43xUP6SrGgxfCPqomSmopl/929olG2Q=
Date:   Tue, 04 May 2021 18:39:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        david@redhat.com, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@soleen.com, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 132/143] arm64/Kconfig: introduce
 ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
Message-ID: <20210505013954.zQYv5JGVU%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Oscar Salvador <osalvador@suse.de>
Subject: arm64/Kconfig: introduce ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE

Enable arm64 platform to use the MHP_MEMMAP_ON_MEMORY feature.

Link: https://lkml.kernel.org/r/20210421102701.25051-9-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/Kconfig~arm64-kconfig-introduce-arch_mhp_memmap_on_memory_enable
+++ a/arch/arm64/Kconfig
@@ -316,6 +316,9 @@ config ZONE_DMA32
 	bool "Support DMA32 zone" if EXPERT
 	default y
 
+config ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
+	def_bool y
+
 config SMP
 	def_bool y
 
_
