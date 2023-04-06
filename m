Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6BE2C7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:53:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235035AbjDFCxc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235108AbjDFCxT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:53:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B7DF4
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:52:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11D8663A2D
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:52:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB49C433D2;
        Thu,  6 Apr 2023 02:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749577;
        bh=IRUcJv/ihj0wRfmDMhNW0MQ93tnLKTFQg5QAEqSBE00=;
        h=Date:To:From:Subject:From;
        b=Quy5mzX08GZ7Y8xj4a0Vl21f1oxJjZG/53QvGPp1LHF1KgQ7IBK6ouE6+mvRn+63/
         rDam9O3e9/880cvMZs1ArxyjRdbYYgteXE7IcTgGFDFvZTcSRs8J+u8TLmXePvhzZZ
         hDZpDc71T7rq77CvJocgln34M+QiadHhITqH3pO4=
Date:   Wed, 05 Apr 2023 19:52:56 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, rdunlap@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ia64-salinfo-placate-defined-but-not-used-warning.patch removed from -mm tree
Message-Id: <20230406025257.6CB49C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ia64: salinfo: placate defined-but-not-used warning
has been removed from the -mm tree.  Its filename was
     ia64-salinfo-placate-defined-but-not-used-warning.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


