Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF3B8C83005
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:46:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbjFJAqw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232101AbjFJAp6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:45:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA32D30F6
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:45:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E61B651C9
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:45:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1630C433EF;
        Sat, 10 Jun 2023 00:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357956;
        bh=/KRx6YnZra6FoMrUbvuunCi2zaBY+rVzeBliIdGrtmg=;
        h=Date:To:From:Subject:From;
        b=Wc4KtlMiII5/UjpfX+0VskVid/sxchz93mgzHmazD6vWu86nA/uimXlSPqq2+3ws6
         MI+VwvOgi9y9Os+BgkDA9G4qc1LVY7+5sanmgGHGzDmjY1tYzU77u2K09OpLsKmWEs
         bqx4DNA7M29qKMhzkDXfTnZQlWaKKiijgDGvgOx8=
Date:   Fri, 09 Jun 2023 17:45:56 -0700
To:     mm-commits@vger.kernel.org, thunder.leizhen@huawei.com,
        ebiederm@xmission.com, bhe@redhat.com, horms@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kexec-avoid-calculating-array-size-twice.patch removed from -mm tree
Message-Id: <20230610004556.C1630C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kexec: avoid calculating array size twice
has been removed from the -mm tree.  Its filename was
     kexec-avoid-calculating-array-size-twice.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Baoquan He <bhe@redhat.com>
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


