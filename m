Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D12C7EE29
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 18:57:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243039AbjEYS5F (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 14:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243782AbjEYS4B (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 14:56:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5E94EF9
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 11:48:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14ABA61A0A
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 18:47:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616DDC433D2;
        Thu, 25 May 2023 18:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685040477;
        bh=ODlr58NfczFcv4OKNui7HHchLnPMpB84yETE5yFXCic=;
        h=Date:To:From:Subject:From;
        b=InMi7RV9Va7rR0vCGcwgMp8QQNQk0zZjffR0pRZ78bNPgI380YtIEVsCyBDE9ENUd
         q3HZARwCaGci3C2G/j9zEfACohFpfK6okL8csvOCahwJkSKPcgv0pNTzyQn2CC1aAk
         86QsWxKz03oFhyR1L+emMHeOmrchpUd9FQKZrjkw=
Date:   Thu, 25 May 2023 11:47:56 -0700
To:     mm-commits@vger.kernel.org, thunder.leizhen@huawei.com,
        ebiederm@xmission.com, bhe@redhat.com, horms@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-avoid-calculating-array-size-twice.patch added to mm-nonmm-unstable branch
Message-Id: <20230525184757.616DDC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: avoid calculating array size twice
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-avoid-calculating-array-size-twice.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-avoid-calculating-array-size-twice.patch

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
From: Simon Horman <horms@kernel.org>
Subject: kexec: avoid calculating array size twice
Date: Thu, 25 May 2023 16:26:25 +0200

Avoid calculating array size twice in kexec_purgatory_setup_sechdrs().
Once using array_size(), and once open-coded.

Flagged by Coccinelle:

  .../kexec_file.c:881:8-25: WARNING: array_size is already used (line 877) to compute the same size

No functional change intended.
Compile tested only.

Link: https://lkml.kernel.org/r/20230525-kexec-array_size-v1-1-8b4bf4f7500a@kernel.org
Signed-off-by: Simon Horman <horms@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_file.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/kexec_file.c~kexec-avoid-calculating-array-size-twice
+++ a/kernel/kexec_file.c
@@ -867,6 +867,7 @@ static int kexec_purgatory_setup_sechdrs
 {
 	unsigned long bss_addr;
 	unsigned long offset;
+	size_t sechdrs_size;
 	Elf_Shdr *sechdrs;
 	int i;
 
@@ -874,11 +875,11 @@ static int kexec_purgatory_setup_sechdrs
 	 * The section headers in kexec_purgatory are read-only. In order to
 	 * have them modifiable make a temporary copy.
 	 */
-	sechdrs = vzalloc(array_size(sizeof(Elf_Shdr), pi->ehdr->e_shnum));
+	sechdrs_size = array_size(sizeof(Elf_Shdr), pi->ehdr->e_shnum);
+	sechdrs = vzalloc(sechdrs_size);
 	if (!sechdrs)
 		return -ENOMEM;
-	memcpy(sechdrs, (void *)pi->ehdr + pi->ehdr->e_shoff,
-	       pi->ehdr->e_shnum * sizeof(Elf_Shdr));
+	memcpy(sechdrs, (void *)pi->ehdr + pi->ehdr->e_shoff, sechdrs_size);
 	pi->sechdrs = sechdrs;
 
 	offset = 0;
_

Patches currently in -mm which might be from horms@kernel.org are

kexec-avoid-calculating-array-size-twice.patch

