Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A96AEC433E7
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B23C208B6
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602975866;
	bh=l3f/+lZODYM2CfKLxK4PNWg+zxTmKYI2oShlXk+IO08=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Wyo+2OBXhRCZ2NBU7jGvoN7ym4sAgWWFJR4ziznLLK/U5EWFeT1adwpfViMoQeBYq
	 Rvyc9YfjSnRAOUHHVQbwPH4NGDODpzkNpkBBHNHlWOCVv8pkGeKkC9nKfttVrErmIc
	 WDYT2wRAEPJUCo60aphod3ej0q8EXqYP/BdE82Yw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439841AbgJQXE0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:04:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:45688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438235AbgJQXEZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:04:25 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80A7020878;
        Sat, 17 Oct 2020 23:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602975865;
        bh=l3f/+lZODYM2CfKLxK4PNWg+zxTmKYI2oShlXk+IO08=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=TYCyJObvM4Z363vmCnFlXy/9VPPEQCVVgEXdoevgKD+hhxy167pYj1d+scGXjdJlG
         sHFEyA6/3UBzyYIWw0npw3TCVtpXo56qAIPiZdJJuf9547KWdr0Uxouo2UHZWci1UZ
         ewTBWLcwMMVSUYYF77tXw+lDLk7ZFMc61FSlk0a4=
Date:   Sat, 17 Oct 2020 16:04:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, minchan@kernel.org,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-madvise-introduce-process=5Fmadvise-syscall-an-external-?=
 =?US-ASCII?Q?memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix.patch?=
 removed from -mm tree
Message-ID: <20201017230425.v2iQreazR%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix.patch

This patch was dropped because it was folded into mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix

pidfd_get_pid() gained an argument

Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/madvise.c~mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix
+++ a/mm/madvise.c
@@ -1182,6 +1182,7 @@ SYSCALL_DEFINE5(process_madvise, int, pi
 	struct task_struct *task;
 	struct mm_struct *mm;
 	size_t total_len;
+	unsigned int f_flags;
 
 	if (flags != 0) {
 		ret = -EINVAL;
@@ -1200,7 +1201,7 @@ SYSCALL_DEFINE5(process_madvise, int, pi
 	if (ret < 0)
 		goto out;
 
-	pid = pidfd_get_pid(pidfd);
+	pid = pidfd_get_pid(pidfd, &f_flags);
 	if (IS_ERR(pid)) {
 		ret = PTR_ERR(pid);
 		goto free_iov;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api.patch
mm.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch

