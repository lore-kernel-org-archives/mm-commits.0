Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE000C433DB
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F9E564F24
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbhB0Cdg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:33:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:53042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230207AbhB0Cco (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:32:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BDD464F4E;
        Sat, 27 Feb 2021 02:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393136;
        bh=nVv6KPfel6ZJa2JaXssCvTi0fTyQSPojfW0xecXnD/k=;
        h=Date:From:To:Subject:From;
        b=07CRKd7J0A5orKXwZhsJSc+uhtylpFSPKhLqY86IzKKm39AYVZ4MI+sQVza2VvN8f
         s6JWM9sFUDRSZ6HuFO1toeyK05iFWZA3WtYIWicQCyqULwwCDEjEuz0KcQe+ZhoGgR
         RecR/Y9dli29LxVXvXa0PC9t1zLAFFtNI93UI3E0=
Date:   Fri, 26 Feb 2021 18:32:16 -0800
From:   akpm@linux-foundation.org
To:     joe@perches.com, mm-commits@vger.kernel.org,
        rocking@linux.alibaba.com
Subject:  [merged]
 checkpatch-ignore-warning-designated-initializers-using-nr_cpus.patch
 removed from -mm tree
Message-ID: <20210227023216.HcOOmKq3W%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: ignore warning designated initializers using NR_CPUS
has been removed from the -mm tree.  Its filename was
     checkpatch-ignore-warning-designated-initializers-using-nr_cpus.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from rocking@linux.alibaba.com are


