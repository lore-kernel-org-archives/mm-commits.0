Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17650C77B70
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:53:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234791AbjDFCxv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234965AbjDFCxa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:53:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828DF9743
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:53:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1FC962B5D
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:53:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 075ACC433D2;
        Thu,  6 Apr 2023 02:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749587;
        bh=3o2gtvOX43sdVd7F/mH4QtUqV4ERayiPFR/Mm8h9uC8=;
        h=Date:To:From:Subject:From;
        b=Y0WMtdLhI9pZvDhuWsRyd89BUJEUGSua75Vfmr/MwkjdDnvMIm+vUZdnGusJe25F+
         rYKJTwArAqmb8Itfv9UFSGzQlm7zHavg260BZdhbIZGSRCVF+m7TxtaLLhl8nqdrS7
         qTweoJRyf4zlX2uLalM3ARAJYsGRss7P9B72pM44=
Date:   Wed, 05 Apr 2023 19:53:06 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-link-vmlinuxsh-fix-error-message-presentation.patch removed from -mm tree
Message-Id: <20230406025307.075ACC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/link-vmlinux.sh: fix error message presentation
has been removed from the -mm tree.  Its filename was
     scripts-link-vmlinuxsh-fix-error-message-presentation.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: scripts/link-vmlinux.sh: fix error message presentation
Date: Mon Mar  6 01:32:53 PM PST 2023

This comes out as

   Try make KALLSYMS_EXTRA_PASS=1 as a workaround

but we want quotes:

   Try "make KALLSYMS_EXTRA_PASS=1" as a workaround

Link: https://lkml.kernel.org/r/202303042034.Cjc7JTd0-lkp@intel.com
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/link-vmlinux.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/link-vmlinux.sh~scripts-link-vmlinuxsh-fix-error-message-presentation
+++ a/scripts/link-vmlinux.sh
@@ -291,7 +291,7 @@ fi
 if is_enabled CONFIG_KALLSYMS; then
 	if ! cmp -s System.map ${kallsyms_vmlinux}.syms; then
 		echo >&2 Inconsistent kallsyms data
-		echo >&2 Try "make KALLSYMS_EXTRA_PASS=1" as a workaround
+		echo >&2 'Try "make KALLSYMS_EXTRA_PASS=1" as a workaround'
 		exit 1
 	fi
 fi
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file-fix.patch
mm-add-new-api-to-enable-ksm-per-process-fix.patch
memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus-fix.patch
vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix.patch
lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case-fix.patch

