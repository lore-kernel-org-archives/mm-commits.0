Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 282AAC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:07:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D36AD2087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817664;
	bh=WHqzbeJL+Jv9AbqA81ataw2zRaw3cad4mqJGc/VcSRs=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=PhfPYzPnqIl1uun9PQB1rAPQyJxZBf1MO+yVSsXdsbzkInY5Yp11Ljk8hnMpUQSRA
	 hF3n4WislH5gxW/fcC3v1PRtGNR9LbnU8A30ThCbjFfxp3a3r1Rm16P2G8SLFCC1n4
	 ggDX1EuweT+fKHixTKTZg3jj0fMUJcxxV6WA8zhQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732511AbgJPDHo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:07:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727382AbgJPDHo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:07:44 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C5C920789;
        Fri, 16 Oct 2020 03:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817664;
        bh=WHqzbeJL+Jv9AbqA81ataw2zRaw3cad4mqJGc/VcSRs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=mGqpKQPNe2PBEevYwaGcqie1k9xTu9LgE+niYZSJ1RaO0EMRsOj+ujKNHAPkJNgyB
         053nLCvtmqZadhgZ3dmG9l6UhNySaxKN6eLZ+jJyWtJrhDXmjXhOspb1GUD1GvxjvG
         75d+fRugu7kc+WytntaIcTr8wpe3UCLpL1VHL0A0=
Date:   Thu, 15 Oct 2020 20:07:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, christian.koenig@amd.com, hch@lst.de,
        jannh@google.com, jgg@nvidia.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 058/156] mm/mmu_notifier: fix mmget() assert in
 __mmu_interval_notifier_insert
Message-ID: <20201016030743.RETEWEd2X%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Jann Horn <jannh@google.com>
Subject: mm/mmu_notifier: fix mmget() assert in __mmu_interval_notifier_ins=
ert

The comment talks about having to hold mmget() (which means mm_users), but
the actual check is on mm_count (which would be mmgrab()).

Given that MMU notifiers are torn down in mmput() -> __mmput() ->
exit_mmap() -> mmu_notifier_release(), I believe that the comment is
correct and the check should be on mm->mm_users.  Fix it up accordingly.

Link: https://lkml.kernel.org/r/20200901000143.207585-1-jannh@google.com
Fixes: 99cb252f5e68 ("mm/mmu_notifier: add an interval tree notifier")
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Christian K=C3=B6nig <christian.koenig@amd.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_notifier.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmu_notifier.c~mm-mmu_notifier-fix-mmget-assert-in-__mmu_interval_=
notifier_insert
+++ a/mm/mmu_notifier.c
@@ -913,7 +913,7 @@ static int __mmu_interval_notifier_inser
 		return -EOVERFLOW;
=20
 	/* Must call with a mmget() held */
-	if (WARN_ON(atomic_read(&mm->mm_count) <=3D 0))
+	if (WARN_ON(atomic_read(&mm->mm_users) <=3D 0))
 		return -EINVAL;
=20
 	/* pairs with mmdrop in mmu_interval_notifier_remove() */
_
