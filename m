Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37178C64ED8
	for <mm-commits@archiver.kernel.org>; Thu, 23 Feb 2023 19:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjBWTtl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Feb 2023 14:49:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjBWTtY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2023 14:49:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D936010B
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 11:49:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F368B81A82
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 19:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD97EC433D2;
        Thu, 23 Feb 2023 19:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677181756;
        bh=IA0Wa8AD4cnhuivvmFzc2jLRx9wfaM0COZOuPtJ4z1o=;
        h=Date:To:From:Subject:From;
        b=lgeEMYyI1VVAiJZMHPkZgC4chpx8Ezkfx41oELTmGkmbBhCgQyzhVFegMTe7mGPa3
         PUEI30bIwj2GzKEopJLFutX5IoEm15K44536092Mi2zdxBQ8s6lOvch6BEgxyuAtPi
         w/AZKKr+BsW2Z2vMKzycoVXssTAZLssNtaEF69IE=
Date:   Thu, 23 Feb 2023 11:49:16 -0800
To:     mm-commits@vger.kernel.org, hch@lst.de, rdunlap@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ia64-salinfo-placate-defined-but-not-used-warning.patch added to mm-nonmm-unstable branch
Message-Id: <20230223194916.BD97EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: salinfo: placate defined-but-not-used warning
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ia64-salinfo-placate-defined-but-not-used-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ia64-salinfo-placate-defined-but-not-used-warning.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: ia64: salinfo: placate defined-but-not-used warning
Date: Wed, 22 Feb 2023 19:43:09 -0800

When CONFIG_PROC_FS is not set, proc_salinfo_show() is not used.  Mark the
function as __maybe_unused to quieten the warning message.

../arch/ia64/kernel/salinfo.c:584:12: warning: 'proc_salinfo_show' defined but not used [-Wunused-function]
  584 | static int proc_salinfo_show(struct seq_file *m, void *v)
      |            ^~~~~~~~~~~~~~~~~

Link: https://lkml.kernel.org/r/20230223034309.13375-1-rdunlap@infradead.org
Fixes: 3f3942aca6da ("proc: introduce proc_create_single{,_data}")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/salinfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/ia64/kernel/salinfo.c~ia64-salinfo-placate-defined-but-not-used-warning
+++ a/arch/ia64/kernel/salinfo.c
@@ -581,7 +581,7 @@ static int salinfo_cpu_pre_down(unsigned
  * 'data' contains an integer that corresponds to the feature we're
  * testing
  */
-static int proc_salinfo_show(struct seq_file *m, void *v)
+static int __maybe_unused proc_salinfo_show(struct seq_file *m, void *v)
 {
 	unsigned long data = (unsigned long)v;
 	seq_puts(m, (sal_platform_features & data) ? "1\n" : "0\n");
_

Patches currently in -mm which might be from rdunlap@infradead.org are

ia64-mm-contig-fix-section-mismatch-warning-error.patch
ia64-salinfo-placate-defined-but-not-used-warning.patch

