Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DB8EC433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C364264F17
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbhBZBXP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:23:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:53454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230041AbhBZBWf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:22:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF06664F29;
        Fri, 26 Feb 2021 01:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302505;
        bh=Z7hAqP30pPt6oB8SrB5F2wi0tx4rjydXNbbMG8wyZl4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=CBPmwMMtm323AxPFg581dD3DRlQ8O3D3sfPxPA/TB8pglUrf6iMb+/aNW/2Inc+iJ
         UCRSCTISBnMaOzFZVWZ+PkvKozE0thKXhfNYPeWt84GOvslbnY3iBEqJCB2hwUkU+d
         MtGmqlilFjqEYOsWa0F9/aG8/X+4gSr9ujSTURe4=
Date:   Thu, 25 Feb 2021 17:21:44 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rocking@linux.alibaba.com,
        torvalds@linux-foundation.org
Subject:  [patch 100/118] checkpatch: ignore warning designated
 initializers using NR_CPUS
Message-ID: <20210226012144.3f7lsKet5%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peng Wang <rocking@linux.alibaba.com>
Subject: checkpatch: ignore warning designated initializers using NR_CPUS

Some max_length wants to hold as large room as possible to ensure enough
size to tackle with the biggest NR_CPUS.  An example below:

kernel/cgroup/cpuset.c:
static struct cftype legacy_files[] = {
        {
                .name = "cpus",
                .seq_show = cpuset_common_seq_show,
                .write = cpuset_write_resmask,
                .max_write_len = (100U + 6 * NR_CPUS),
                .private = FILE_CPULIST,
        },
	...
}

Link: https://lkml.kernel.org/r/5d4998aa8a8ac7efada2c7daffa9e73559f8b186.1609331255.git.rocking@linux.alibaba.com
Signed-off-by: Peng Wang <rocking@linux.alibaba.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-ignore-warning-designated-initializers-using-nr_cpus
+++ a/scripts/checkpatch.pl
@@ -7025,12 +7025,14 @@ sub process {
 
 # use of NR_CPUS is usually wrong
 # ignore definitions of NR_CPUS and usage to define arrays as likely right
+# ignore designated initializers using NR_CPUS
 		if ($line =~ /\bNR_CPUS\b/ &&
 		    $line !~ /^.\s*\s*#\s*if\b.*\bNR_CPUS\b/ &&
 		    $line !~ /^.\s*\s*#\s*define\b.*\bNR_CPUS\b/ &&
 		    $line !~ /^.\s*$Declare\s.*\[[^\]]*NR_CPUS[^\]]*\]/ &&
 		    $line !~ /\[[^\]]*\.\.\.[^\]]*NR_CPUS[^\]]*\]/ &&
-		    $line !~ /\[[^\]]*NR_CPUS[^\]]*\.\.\.[^\]]*\]/)
+		    $line !~ /\[[^\]]*NR_CPUS[^\]]*\.\.\.[^\]]*\]/ &&
+		    $line !~ /^.\s*\.\w+\s*=\s*.*\bNR_CPUS\b/)
 		{
 			WARN("NR_CPUS",
 			     "usage of NR_CPUS is often wrong - consider using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc\n" . $herecurr);
_
