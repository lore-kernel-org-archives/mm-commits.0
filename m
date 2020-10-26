Return-Path: <SRS0=L/bp=EB=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 736F8C4363A
	for <mm-commits@archiver.kernel.org>; Mon, 26 Oct 2020 19:21:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36F5B21655
	for <mm-commits@archiver.kernel.org>; Mon, 26 Oct 2020 19:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603740093;
	bh=g3ErhG6hGR/TwUEE0V/ghTPWxX2sAhb9VELYSfgDqe4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=AiEKwZU8xYN10Oga7PUZhQD39kVrrxUFIvDo76IppTJ1PLjKQGUIQ0RkKbT4tcGs/
	 CVS6IBSz04nyK5rZe2r+WpxFVPO8Yy1lCHsAJlGhshl/BvK2K/lJ/HwpgkjCyLCyIz
	 ESxZnn3QKYDDKgxEGBWBl3HRtSTPGpbQggD/DQYw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1792946AbgJZTVc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Oct 2020 15:21:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1792945AbgJZTVc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 26 Oct 2020 15:21:32 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7E8E2080A;
        Mon, 26 Oct 2020 19:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603740091;
        bh=g3ErhG6hGR/TwUEE0V/ghTPWxX2sAhb9VELYSfgDqe4=;
        h=Date:From:To:Subject:From;
        b=HuHVEQ3hnwhL+OmrMddigGjBQEOT6/zzu0qSSBqvX23ru5kJ+rNHjiXEW2JwZTFmV
         Fi20cPMliBlPLqC2o11ghU/mFL13mnPJg7cQvvC7nVzKfmo3vu0D3qSOzodF+FN6v3
         bVfVGDV2xrYaka1EEldQyuRV/gxdbJxq8gJIcoEU=
Date:   Mon, 26 Oct 2020 12:21:31 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rientjes@google.com,
        penberg@kernel.org, iamjoonsoo.kim@lge.com, cl@linux.com,
        sh_def@163.com
Subject:  +
 mmslab_common-use-list_for_each_entry-in-dump_unreclaimable_slab.patch added
 to -mm tree
Message-ID: <20201026192131.m9TYw%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab_common.c: use list_for_each_entry in dump_unreclaimable_slab()
has been added to the -mm tree.  Its filename is
     mmslab_common-use-list_for_each_entry-in-dump_unreclaimable_slab.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmslab_common-use-list_for_each_entry-in-dump_unreclaimable_slab.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmslab_common-use-list_for_each_entry-in-dump_unreclaimable_slab.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hui Su <sh_def@163.com>
Subject: mm/slab_common.c: use list_for_each_entry in dump_unreclaimable_slab()

dump_unreclaimable_slab() acquires the slab_mutex first, and it won't
remove any slab_caches list entry when itering the slab_caches lists.

Thus we do not need list_for_each_entry_safe here, which is against
removal of list entry.

Link: https://lkml.kernel.org/r/20200926043440.GA180545@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/slab_common.c~mmslab_common-use-list_for_each_entry-in-dump_unreclaimable_slab
+++ a/mm/slab_common.c
@@ -978,7 +978,7 @@ static int slab_show(struct seq_file *m,
 
 void dump_unreclaimable_slab(void)
 {
-	struct kmem_cache *s, *s2;
+	struct kmem_cache *s;
 	struct slabinfo sinfo;
 
 	/*
@@ -996,7 +996,7 @@ void dump_unreclaimable_slab(void)
 	pr_info("Unreclaimable slab info:\n");
 	pr_info("Name                      Used          Total\n");
 
-	list_for_each_entry_safe(s, s2, &slab_caches, list) {
+	list_for_each_entry(s, &slab_caches, list) {
 		if (s->flags & SLAB_RECLAIM_ACCOUNT)
 			continue;
 
_

Patches currently in -mm which might be from sh_def@163.com are

mmslab_common-use-list_for_each_entry-in-dump_unreclaimable_slab.patch
mm-hugetlbc-just-use-put_page_testzero-instead-of-page_count.patch
acctc-use-elif-instead-of-end-and-elif.patch

