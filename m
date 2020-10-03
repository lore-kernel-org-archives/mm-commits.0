Return-Path: <SRS0=eNRM=DK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4110C4363D
	for <mm-commits@archiver.kernel.org>; Sat,  3 Oct 2020 05:20:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 913C4206B5
	for <mm-commits@archiver.kernel.org>; Sat,  3 Oct 2020 05:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601702441;
	bh=FadHnwRP3FGCOrAQvlXrb3t/csHLL/vj6cy4Ivtl528=;
	h=Date:From:To:Cc:Subject:Reply-To:List-ID:From;
	b=nRUnBw9NJcEMPsLMAZY5zbev5S4JnsyRp160cOtq+JsZzw+19eKmT0afd5eBJDsBM
	 QToHgnodVCeVQ74fCLXK8MUWDZDHKlbDLzGLny2/EdJVVyTjW6VIAhaS2ePQPGTFL/
	 cYTnEmTilQ5h5jyJdpBKF1pQLU7hKk/TrMhPJaA4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725730AbgJCFUl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 3 Oct 2020 01:20:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgJCFUj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 3 Oct 2020 01:20:39 -0400
Received: from X1 (c-76-21-107-111.hsd1.ca.comcast.net [76.21.107.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBBBA206A1;
        Sat,  3 Oct 2020 05:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601702439;
        bh=FadHnwRP3FGCOrAQvlXrb3t/csHLL/vj6cy4Ivtl528=;
        h=Date:From:To:Cc:Subject:From;
        b=b54REdNLHPlCwTnLJT/2TItL16pH+zEmFFCI/Re3Ieq2dLOMc7PRECt17+yhV6NH/
         2NWN0TM9smhQJDKSy67dzXriRYTJ+KAnTLc83xg+MCyGisOXI4kj1LHzSwUgvgUFwa
         2XMAGNSTYpJcwjt4DjTIgPW3EzTo1jHb+KfQrxQY=
Date:   Fri, 2 Oct 2020 22:20:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Subject: incoming
Message-Id: <20201002222038.4f81529dcd31eb8328d562a6@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

3 patches, based on d3d45f8220d60a0b2aaaacf8fb2be4e6ffd9008e.

Subsystems affected by this patch series:

  mm/slub
  mm/cma
  scripts

Subsystem: mm/slub

    Eric Farman <farman@linux.ibm.com>:
      mm, slub: restore initial kmem_cache flags

Subsystem: mm/cma

    Joonsoo Kim <iamjoonsoo.kim@lge.com>:
      mm/page_alloc: handle a missing case for memalloc_nocma_{save/restore} APIs

Subsystem: scripts

    Eric Biggers <ebiggers@google.com>:
      scripts/spelling.txt: fix malformed entry

 mm/page_alloc.c      |   19 ++++++++++++++++---
 mm/slub.c            |    6 +-----
 scripts/spelling.txt |    2 +-
 3 files changed, 18 insertions(+), 9 deletions(-)

