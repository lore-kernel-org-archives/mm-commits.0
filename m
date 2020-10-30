Return-Path: <SRS0=SeUK=EF=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00479C00A89
	for <mm-commits@archiver.kernel.org>; Fri, 30 Oct 2020 05:18:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86C34221FF
	for <mm-commits@archiver.kernel.org>; Fri, 30 Oct 2020 05:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604035091;
	bh=QBlFQi9Xwhs7WBWHR3NudADwwvbsObBjb3wTis7qXTc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=nUVpP6V6uxKZn5ZTC1uJCZZa0qxqH0eQE+AMNP8DgxUXAZFw6bwo7QG9K1rodF58L
	 99+foErM35ggpmqq+klMGrrgxsnoxtzwmgb41nT5R7sUxrj/g9PbRNZhe0sMV+E+dg
	 hIk+c6PI4nX2yd8xf2R7xftw0g+Pn46ZUsylmGvM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725775AbgJ3FSK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Oct 2020 01:18:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725771AbgJ3FSK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Oct 2020 01:18:10 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F6CB20725;
        Fri, 30 Oct 2020 05:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604035089;
        bh=QBlFQi9Xwhs7WBWHR3NudADwwvbsObBjb3wTis7qXTc=;
        h=Date:From:To:Subject:From;
        b=OCQxK7rDc5Z4IJKBWhoEjSYm940qnsjUvbYAGH9u9kR0BTpy3Da8b9rPC2j3xFgzd
         BZ7Glvos6ysF+bH8SapL/tZZKmMbfl0bDXWC39Ub8DdsjfQ7x5kiUbPNvKvdx1dgNi
         TAux/WmsJL2Aam2pQoBqjFGjc1IPuBl+MpGT+UyM=
Date:   Thu, 29 Oct 2020 22:18:08 -0700
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, daniel@ffwll.ch, hch@lst.de,
        mm-commits@vger.kernel.org
Subject:  + mm-unexport-follow_pte_pmd.patch added to -mm tree
Message-ID: <20201030051808.VrMzByhjS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: unexport follow_pte_pmd
has been added to the -mm tree.  Its filename is
     mm-unexport-follow_pte_pmd.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-unexport-follow_pte_pmd.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-unexport-follow_pte_pmd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: unexport follow_pte_pmd

Patch series "simplify follow_pte a bit".

This small series drops the not needed follow_pte_pmd exports, and
simplifies the follow_pte family of functions a bit.


This patch (of 2):

follow_pte_pmd() is only used by the DAX code, which can't be modular.

Link: https://lkml.kernel.org/r/20201029101432.47011-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memory.c~mm-unexport-follow_pte_pmd
+++ a/mm/memory.c
@@ -4787,7 +4787,6 @@ int follow_pte_pmd(struct mm_struct *mm,
 						    ptepp, pmdpp, ptlp)));
 	return res;
 }
-EXPORT_SYMBOL(follow_pte_pmd);
 
 /**
  * follow_pfn - look up PFN at a user virtual address
_

Patches currently in -mm which might be from hch@lst.de are

mm-unexport-follow_pte_pmd.patch
mm-simplify-follow_ptepmd.patch

