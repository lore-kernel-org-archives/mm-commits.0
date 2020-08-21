Return-Path: <SRS0=KdEm=B7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A70C5C433E1
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 23:48:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8133A2076E
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 23:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598053725;
	bh=FREbTn2bClyjM/HVdiuadQDpULbl829d1eZ1Ks5e5HM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=sno8AsbWJTQm8CQMCFyo6kg2UdimLJK9TtxeAPWsJWSrQ4RntMdgX8kEmQtQzWAvi
	 07IbmcSJdczfhb0nTQ5Fbz40uUIAZ4teNlfJmF/JuObNWi2EO29UzZakxJ4PE+Efol
	 8999XQJ5ckSJ5iSJ5hBw2NKV+oyAL7JoEJ4kY9w0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgHUXso (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Aug 2020 19:48:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:60240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726706AbgHUXso (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 21 Aug 2020 19:48:44 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9ADEA2067C;
        Fri, 21 Aug 2020 23:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598053723;
        bh=FREbTn2bClyjM/HVdiuadQDpULbl829d1eZ1Ks5e5HM=;
        h=Date:From:To:Subject:From;
        b=PhuKqKluUJpKqKEPqYps4LDpX1izNH3SDcEemd/M7LngFmg5h+NKmFsitzceykzi8
         5HY5GzBmCwHC9OR1ecvhB/rszertxlXFOayoRmgkTPYE37ieT7lNoBjAJB9ZBdi+b/
         MMWH8gCkMvJl8MmAk4v+3RLgkDH9Z/Wd0TDocRCA=
Date:   Fri, 21 Aug 2020 16:48:43 -0700
From:   akpm@linux-foundation.org
To:     ckennelly@google.com, mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?fs-binfmt=5Felf-use-pt=5Fload-p=5Falign-values-for-suitabl?=
 =?US-ASCII?Q?e-start-address-v4.patch?= added to -mm tree
Message-ID: <20200821234843.KAsipP4rO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-v4
has been added to the -mm tree.  Its filename is
     fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-v4.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-v4.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chris Kennelly <ckennelly@google.com>
Subject: fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-v4

augment comment

Link: https://lkml.kernel.org/r/20200821233848.3904680-2-ckennelly@google.com
Signed-off-by: Chris Kennelly <ckennelly@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/binfmt_elf.c~fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-v4
+++ a/fs/binfmt_elf.c
@@ -431,7 +431,7 @@ static unsigned long maximum_alignment(s
 		if (cmds[i].p_type == PT_LOAD) {
 			unsigned long p_align = cmds[i].p_align;
 
-			/* skip non-power of two alignments */
+			/* skip non-power of two alignments as invalid */
 			if (!is_power_of_2(p_align))
 				continue;
 			alignment = max(alignment, p_align);
_

Patches currently in -mm which might be from ckennelly@google.com are

fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-v4.patch
add-self-test-for-verifying-load-alignment.patch

