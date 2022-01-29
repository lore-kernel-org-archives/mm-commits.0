Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36894C433FE
	for <mm-commits@archiver.kernel.org>; Sat, 29 Jan 2022 21:41:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353188AbiA2VlA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 29 Jan 2022 16:41:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45978 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241490AbiA2VlA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 29 Jan 2022 16:41:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB55B6091C
        for <mm-commits@vger.kernel.org>; Sat, 29 Jan 2022 21:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C86C340E5;
        Sat, 29 Jan 2022 21:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643492459;
        bh=yKOct+8Ojy/7tytrO0JByvyDyQiOpz7cWY5kCH+UMu0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=nVs29egsJuvBByuXA9pzLGllN1aUZnPZD+zELCc5pUZq9LnFPBha2HK2CrT7Rq7Ra
         OQRMwd+PHiXrjTk2vQR7C7eRJ0oOnHW5+qLnZl8pvwbapQgRXwdPJIi7C6JKA09Wou
         f4cfCwmEmFXrakDUqHcFLWbS17Oqo2NzKw0CPZ2E=
Date:   Sat, 29 Jan 2022 13:40:58 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ebiederm@xmission.com,
        hch@infradead.org, hch@lst.de, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        tony.luck@intel.com, torvalds@linux-foundation.org
Subject:  [patch 03/12] ia64: make IA64_MCA_RECOVERY bool instead
 of tristate
Message-ID: <20220129214058.P5EZlNOCT%akpm@linux-foundation.org>
In-Reply-To: <20220129134026.8ccf701012f26eb2c2c269c9@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: ia64: make IA64_MCA_RECOVERY bool instead of tristate

In linux-next, IA64_MCA_RECOVERY uses the (new) function make_task_dead(),
which is not exported for use by modules.  Instead of exporting it for one
user, convert IA64_MCA_RECOVERY to be a bool Kconfig symbol.

In a config file from "kernel test robot <lkp@intel.com>" for a different
problem, this linker error was exposed when CONFIG_IA64_MCA_RECOVERY=m.

Fixes this build error:

ERROR: modpost: "make_task_dead" [arch/ia64/kernel/mca_recovery.ko] undefined!

Link: https://lkml.kernel.org/r/20220124213129.29306-1-rdunlap@infradead.org
Fixes: 0e25498f8cd4 ("exit: Add and use make_task_dead.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/ia64/Kconfig~ia64-make-ia64_mca_recovery-bool-instead-of-tristate
+++ a/arch/ia64/Kconfig
@@ -318,7 +318,7 @@ config ARCH_PROC_KCORE_TEXT
 	depends on PROC_KCORE
 
 config IA64_MCA_RECOVERY
-	tristate "MCA recovery from errors other than TLB."
+	bool "MCA recovery from errors other than TLB."
 
 config IA64_PALINFO
 	tristate "/proc/pal support"
_
