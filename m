Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22014C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C84D020878
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817860;
	bh=I1oPvgUFXZI/JchfhpOsS+KnjOIOJFmcW5JgN5nAvcw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=QPmS76+SSL05d+7CfaUlGJVz1HFPBd44cDSt0qoD1nJzmVjW7zNztAP4S6O9nQJ68
	 XKH28UC2E1PZTI0fjBcMQAAo6EqooNh+skZ5sxY3uiR9am+jbysy3YAhngLBp6rRp8
	 gOADlK4S3UmL+WNEwZ/mMQIee4+Xz8fzBh2FYVS4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388015AbgJPDLA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:11:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387864AbgJPDLA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:11:00 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6156920789;
        Fri, 16 Oct 2020 03:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817858;
        bh=I1oPvgUFXZI/JchfhpOsS+KnjOIOJFmcW5JgN5nAvcw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Ysj2JnSjyo7uOJRidv17JUV+GAZX3ROVCymCVnrQpvCmIZYm/5KvMppBvGCTgnXrE
         00pj7vXfXFhOZ+82Com5wai4mlh/5+x/vJfAOtwmaq/NR3hGV3+1F7XFCH04Lr/M1m
         /cFkVu3z4sIumoHAdWZKzBi30E82tQga0l+EYVZY=
Date:   Thu, 15 Oct 2020 20:10:57 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  [patch 106/156] lib: dynamic_queue_limits: delete
 duplicated words + fix typo
Message-ID: <20201016031057.ok6N8sGhl%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib: dynamic_queue_limits: delete duplicated words + fix typo

Drop the repeated word "the".
Fix spelling of "excess".

Link: https://lkml.kernel.org/r/20200823040449.25946-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dynamic_queue_limits.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/dynamic_queue_limits.c~lib-dynamic_queue_limits-delete-duplicated-words-fix-typo
+++ a/lib/dynamic_queue_limits.c
@@ -60,8 +60,8 @@ void dql_completed(struct dql *dql, unsi
 		 * A decrease is only considered if the queue has been busy in
 		 * the whole interval (the check above).
 		 *
-		 * If there is slack, the amount of execess data queued above
-		 * the the amount needed to prevent starvation, the queue limit
+		 * If there is slack, the amount of excess data queued above
+		 * the amount needed to prevent starvation, the queue limit
 		 * can be decreased.  To avoid hysteresis we consider the
 		 * minimum amount of slack found over several iterations of the
 		 * completion routine.
_
