Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0972C001DB
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 20:59:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbjHLU71 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 16:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjHLU70 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 16:59:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138881736
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 13:59:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 954BB60F37
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 20:59:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8AEC433C7;
        Sat, 12 Aug 2023 20:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691873968;
        bh=CHVZ/vgbLN+ZOy6o/5dnh78oOLVWnUIQGvE6fECDJkc=;
        h=Date:To:From:Subject:From;
        b=d9q1TushiFiBn0AbEUNFsDm7JZbgI2PViIMNlG0qvG8MIT/YJlKEUr9YEm4scHBnO
         MHA9w2HqMCrYQMzNpiSjkCqNIxCtGyrf8CSssHl5dQhhUP/HcapKpn1L497rQhJ2wx
         GjdiBKUaXlt/xHMtG/f6KUguLyTtkLRR0aD+TqWI=
Date:   Sat, 12 Aug 2023 13:59:27 -0700
To:     mm-commits@vger.kernel.org, pmladek@suse.com, mhocko@suse.com,
        lkp@intel.com, lecopzer.chen@mediatek.com, kernelfans@gmail.com,
        dianders@chromium.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] nmi_backtrace-allow-excluding-an-arbitrary-cpu-fix.patch removed from -mm tree
Message-Id: <20230812205927.EA8AEC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nmi_backtrace-allow-excluding-an-arbitrary-cpu-fix
has been removed from the -mm tree.  Its filename was
     nmi_backtrace-allow-excluding-an-arbitrary-cpu-fix.patch

This patch was dropped because it was folded into nmi_backtrace-allow-excluding-an-arbitrary-cpu.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: nmi_backtrace-allow-excluding-an-arbitrary-cpu-fix
Date: Sat Aug  5 09:58:07 AM PDT 2023

fix trigger_allbutcpu_cpu_backtrace() stub

Cc: Douglas Anderson <dianders@chromium.org>
Cc: kernel test robot <lkp@intel.com>
Cc: Lecopzer Chen <lecopzer.chen@mediatek.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Pingfan Liu <kernelfans@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/nmi.h~nmi_backtrace-allow-excluding-an-arbitrary-cpu-fix
+++ a/include/linux/nmi.h
@@ -190,7 +190,7 @@ static inline bool trigger_all_cpu_backt
 {
 	return false;
 }
-static inline bool trigger_allbutcpu_cpu_backtrace(void)
+static inline bool trigger_allbutcpu_cpu_backtrace(int exclude_cpu)
 {
 	return false;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
acpi-hmat-calculate-abstract-distance-with-hmat-checkpatch-fixes.patch
mm-remove-redundant-k-macro-definition-fix.patch
nmi_backtrace-allow-excluding-an-arbitrary-cpu.patch

