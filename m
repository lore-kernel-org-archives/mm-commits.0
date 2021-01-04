Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 735DEC433DB
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 23:19:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 307482253D
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 23:19:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbhADXTC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Jan 2021 18:19:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:55002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727276AbhADXTC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 4 Jan 2021 18:19:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A59B322473;
        Mon,  4 Jan 2021 23:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609802301;
        bh=/EWmep0s5kOlZSyu5zYzauiJ0JEXCDQ3GPudUeZfL28=;
        h=Date:From:To:Subject:From;
        b=bIuaGNMfJFfkjRDe4w3jic1gZX7sOoLivGeXV1xmWxFPW/O+EgTcuyjhpVWn0uRhJ
         x6emd3Ze/H/Q7ank8FJ2YDa+Jx8mGwjYY4yFnpwIkhDFE0IU5k4hEMeY/ZOGbVCcEo
         tmwcUfmUB+zsKXHoSVSbv7l2xki0fmMwppqc84Ng=
Date:   Mon, 04 Jan 2021 15:18:21 -0800
From:   akpm@linux-foundation.org
To:     joe@perches.com, mm-commits@vger.kernel.org,
        rocking@linux.alibaba.com
Subject:  +
 checkpatch-ignore-warning-designated-initializers-using-nr_cpus.patch added
 to -mm tree
Message-ID: <20210104231821.r7OhUVkQ2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: ignore warning designated initializers using NR_CPUS
has been added to the -mm tree.  Its filename is
     checkpatch-ignore-warning-designated-initializers-using-nr_cpus.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-ignore-warning-designated-initializers-using-nr_cpus.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-ignore-warning-designated-initializers-using-nr_cpus.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -7034,12 +7034,14 @@ sub process {
 
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

Patches currently in -mm which might be from rocking@linux.alibaba.com are

checkpatch-ignore-warning-designated-initializers-using-nr_cpus.patch

