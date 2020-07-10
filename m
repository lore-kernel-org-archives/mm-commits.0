Return-Path: <SRS0=29NR=AV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07651C433E1
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 21:30:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C62682068F
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 21:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594416651;
	bh=fw55ws9zNrFuruoMB63WbeEa3WZnrRfvi9/BrKlWdAs=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=wXYvSEHLfSEwctHre+aeevxZTu7LVUvOzLFXLcHiJKvNqSGbLpXOSyXJfKwbgJj+d
	 Yo4OT7h6lRvrLejtW+zOyTc40++w1zrDC+N2cuRZyJTzC3YWG3ItN8q/ODfST0RgZA
	 RXHn1VT7P9cpE3kqN/COZKtGZwkt2tq4L4TVqszE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgGJVav (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Jul 2020 17:30:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbgGJVav (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Jul 2020 17:30:51 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C775A20725;
        Fri, 10 Jul 2020 21:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594416650;
        bh=fw55ws9zNrFuruoMB63WbeEa3WZnrRfvi9/BrKlWdAs=;
        h=Date:From:To:Subject:From;
        b=YqcKqhzUxITPSirQcJXu/V/yeuuCgXV70aOPR3+A4Ri4v5a/mJrKFJX84QCnf/bF8
         ZK5Rox3BT0s8UqQHrNVLcGWdcZc+yXS8hji1maOPmN+aum39devkfExiI3uAEqvk9Q
         HYq/6g4YTL+Svpip8AXMwPhALaee4KsRFXIeQ2o4=
Date:   Fri, 10 Jul 2020 14:30:50 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, walter-zh.wu@mediatek.com
Subject:  + kasan-record-and-print-the-free-track-v8.patch added to
 -mm tree
Message-ID: <20200710213050.CokT3nKto%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-record-and-print-the-free-track-v8
has been added to the -mm tree.  Its filename is
     kasan-record-and-print-the-free-track-v8.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-record-and-print-the-free-track-v8.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-record-and-print-the-free-track-v8.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Walter Wu <walter-zh.wu@mediatek.com>
Subject: kasan-record-and-print-the-free-track-v8

build fix

Link: http://lkml.kernel.org/r/20200710162440.23887-1-walter-zh.wu@mediatek.com
Signed-off-by: Walter Wu <walter-zh.wu@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/kasan/kasan.h~kasan-record-and-print-the-free-track-v8
+++ a/mm/kasan/kasan.h
@@ -112,8 +112,9 @@ struct kasan_alloc_meta {
 	 * The free stack is stored into struct kasan_free_meta.
 	 */
 	depot_stack_handle_t aux_stack[2];
-#endif
+#else
 	struct kasan_track free_track[KASAN_NR_FREE_STACKS];
+#endif
 #ifdef CONFIG_KASAN_SW_TAGS_IDENTIFY
 	u8 free_pointer_tag[KASAN_NR_FREE_STACKS];
 	u8 free_track_idx;
_

Patches currently in -mm which might be from walter-zh.wu@mediatek.com are

rcu-kasan-record-and-print-call_rcu-call-stack.patch
rcu-kasan-record-and-print-call_rcu-call-stack-v8.patch
kasan-record-and-print-the-free-track.patch
kasan-record-and-print-the-free-track-v8.patch
kasan-add-tests-for-call_rcu-stack-recording.patch
kasan-update-documentation-for-generic-kasan.patch
kasan-fix-kasan-unit-tests-for-tag-based-kasan.patch
kasan-fix-kasan-unit-tests-for-tag-based-kasan-v4.patch

