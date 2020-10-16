Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49A0CC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:22:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD1BC20878
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602814975;
	bh=ytBCwNzXN/e6WoUPPJ179zQxL0x0VQo2iSZewua1A3A=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=RqI+rna5QOjQ2Fh9dOrQJ3RgQqvHmps0fsjRykyHzVoD5FG3NnITmfEVbNPrqUGO5
	 yBw4PWEy6M8hcqdgw2+RMWRvQ1RRkn7zFcL3PEm9PEpYAwj3nGDjhvELYYE1AK3rH6
	 edecqDWuLdkFqijlOXO1jFb7xu8FO0EAz0Ho6NbE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393712AbgJPCWz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:22:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393686AbgJPCU5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:20:57 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 378FF20878;
        Fri, 16 Oct 2020 02:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602814855;
        bh=ytBCwNzXN/e6WoUPPJ179zQxL0x0VQo2iSZewua1A3A=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=f8JgCf7J5bI2fQvleQEniyIJ2FCv5CRxlpBikNhBzxLLxkM34xjDbKE5YNs8LlqkZ
         bLCZhW7zqf6H/ETIKqk8Cl+naoyc+nDUHGFLWsOTbjMxCrklzuiT9gYmDZbgm88z+c
         bEGXWmylrQZgdNjIdJyOT3CD6MBtL6yS8HX3uMHI=
Date:   Thu, 15 Oct 2020 19:20:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 checkpatch-emit-a-warning-on-embedded-filenames-fix.patch removed from -mm
 tree
Message-ID: <20201016022054.ehDJxsW3E%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch-emit-a-warning-on-embedded-filenames-fix
has been removed from the -mm tree.  Its filename was
     checkpatch-emit-a-warning-on-embedded-filenames-fix.patch

This patch was dropped because it was folded into checkpatch-emit-a-warning-on-embedded-filenames.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: checkpatch-emit-a-warning-on-embedded-filenames-fix

remove stray " di"

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-emit-a-warning-on-embedded-filenames-fix
+++ a/scripts/checkpatch.pl
@@ -3274,7 +3274,7 @@ sub process {
 		}
 
 # check for embedded filenames
-		if ($rawline =~ /^\+.*\Q$realfile\E/) { di
+		if ($rawline =~ /^\+.*\Q$realfile\E/) {
 			WARN("EMBEDDED_FILENAME",
 			     "It's generally not useful to have the filename in the file\n" . $herecurr);
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

checkpatch-emit-a-warning-on-embedded-filenames.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
mm.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

