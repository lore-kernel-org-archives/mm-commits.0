Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D2EEC433EF
	for <mm-commits@archiver.kernel.org>; Sat, 29 Jan 2022 02:14:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239177AbiA2COR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Jan 2022 21:14:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34060 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237464AbiA2COQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jan 2022 21:14:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3645B82765
        for <mm-commits@vger.kernel.org>; Sat, 29 Jan 2022 02:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AB9C340E7;
        Sat, 29 Jan 2022 02:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643422454;
        bh=N9ZeVH8LPAJhxMH8K6xU6FNo/DykIVnZ8bNK1991QL4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=plSaVewJmTTGMUIC7RDTRNQLNGs5OGFAvn4jqgeOfLfu1f4jp/t8JbHwic42hcF5h
         bNtL5rN8Er99s+Yb5hqEkWc/DUvhfaJS0FSTDMdyaft+CPEXTQYNhS3Wc45jWxno0N
         yG9aCU9Z5RLXx9mCV/6Wn3dPinvVdKyVnjN4YjQ4=
Date:   Fri, 28 Jan 2022 18:14:13 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, lkp@intel.com,
        mcgrof@kernel.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, ztong0001@gmail.com
Subject:  [patch 1/7] include/linux/sysctl.h: fix
 register_sysctl_mount_point() return type
Message-ID: <20220129021413.W0uHWiqTx%akpm@linux-foundation.org>
In-Reply-To: <20220128181341.2103de95948608a65958ae40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/sysctl.h: fix register_sysctl_mount_point() return type

The CONFIG_SYSCTL=n stub returns the wrong type.

Fixes: ee9efac48a082 ("sysctl: add helper to register a sysctl mount point")
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Tong Zhang <ztong0001@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysctl.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/sysctl.h~include-linux-sysctlh-fix-register_sysctl_mount_point-return-type
+++ a/include/linux/sysctl.h
@@ -265,7 +265,7 @@ static inline struct ctl_table_header *r
 	return NULL;
 }
 
-static inline struct sysctl_header *register_sysctl_mount_point(const char *path)
+static inline struct ctl_table_header *register_sysctl_mount_point(const char *path)
 {
 	return NULL;
 }
_
