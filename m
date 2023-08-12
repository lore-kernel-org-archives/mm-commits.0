Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D798C0015E
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 20:57:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbjHLU51 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 16:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjHLU50 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 16:57:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4CE1704
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 13:57:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9333F60F37
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 20:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC54C433C8;
        Sat, 12 Aug 2023 20:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691873849;
        bh=byoXe3ZBfUGS8t+msJuWgPUiUtHfDjGAx4pM8qOL2EY=;
        h=Date:To:From:Subject:From;
        b=FOmkN3W81duVPdSlCWo88AKOsbEy+sEEAEXHq7UCl6Jqh/rfYfEoNZ2RyfkNQL61G
         AouTYLwWYXD8ZmNYOspqxp/kluMOTt+H6otsd4Aa8f6Ox+e4YmyxEB8qjFlTeo77qX
         E0bLLhMTh8uBAab2k8NEsjAYsCZAN2EDjpFM6YcI=
Date:   Sat, 12 Aug 2023 13:57:28 -0700
To:     mm-commits@vger.kernel.org, yujie.liu@intel.com,
        vincent.whitchurch@axis.com, vgupta@kernel.org, tj@kernel.org,
        mingo@kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] signal-print-comm-and-exe-name-on-fatal-signals-fix.patch removed from -mm tree
Message-Id: <20230812205728.DBC54C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: signal-print-comm-and-exe-name-on-fatal-signals-fix
has been removed from the -mm tree.  Its filename was
     signal-print-comm-and-exe-name-on-fatal-signals-fix.patch

This patch was dropped because it was folded into signal-print-comm-and-exe-name-on-fatal-signals.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: signal-print-comm-and-exe-name-on-fatal-signals-fix
Date: Tue Jul 11 09:47:45 AM PDT 2023

don't include linux/file.h twice

Reported-by: kernel test robot <yujie.liu@intel.com>
Closes: https://lore.kernel.org/r/202307081626.VOmT8STW-lkp@intel.com/
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/signal.c~signal-print-comm-and-exe-name-on-fatal-signals-fix
+++ a/kernel/signal.c
@@ -25,7 +25,6 @@
 #include <linux/mm.h>
 #include <linux/proc_fs.h>
 #include <linux/tty.h>
-#include <linux/file.h>
 #include <linux/binfmts.h>
 #include <linux/coredump.h>
 #include <linux/security.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
acpi-hmat-calculate-abstract-distance-with-hmat-checkpatch-fixes.patch
mm-remove-redundant-k-macro-definition-fix.patch
signal-print-comm-and-exe-name-on-fatal-signals.patch
drm-i915-move-abs_diff-to-mathh-fix-fix.patch
nmi_backtrace-allow-excluding-an-arbitrary-cpu-fix.patch

