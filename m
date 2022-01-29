Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CAD8C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 29 Jan 2022 21:40:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbiA2Vkz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 29 Jan 2022 16:40:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45924 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237586AbiA2Vky (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 29 Jan 2022 16:40:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60F0960C2A
        for <mm-commits@vger.kernel.org>; Sat, 29 Jan 2022 21:40:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E11C340E5;
        Sat, 29 Jan 2022 21:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643492452;
        bh=N9ZeVH8LPAJhxMH8K6xU6FNo/DykIVnZ8bNK1991QL4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=EuFX+VtteN5KZ1uRs7jVGCIkMKEbuQqnyagoRDyWQuttC9RVZRIm4GEW2f1qvnw3I
         9MUA6t3CvFhYY/vRbM7pM4CyrGKWVY/QQnymRPD6kdtU2AYWEC0XpwgbPJQu699ezc
         Kz9JqZ3Y+kQxYSdxT6uyEFicDhww7c73W1bALPko=
Date:   Sat, 29 Jan 2022 13:40:52 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, lkp@intel.com,
        mcgrof@kernel.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, ztong0001@gmail.com
Subject:  [patch 01/12] include/linux/sysctl.h: fix
 register_sysctl_mount_point() return type
Message-ID: <20220129214052.CVzxLNers%akpm@linux-foundation.org>
In-Reply-To: <20220129134026.8ccf701012f26eb2c2c269c9@linux-foundation.org>
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
