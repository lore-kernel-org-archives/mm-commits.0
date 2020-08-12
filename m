Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D66C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 319F220774
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266190;
	bh=fVSjUH61mTdxGvBKYyEkg3iOryLQtIlz9qUDkFDVTJI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=GhncAVoqNMFw5FMM8cRRaSywdE45yA2KuOpqLoQF+1kTF4zP/5nEfP9Mn4jDyOIb2
	 al5BV3QXO/27WKjsxidXGuFVcIAPnSA15If0TleoWkOpPK9Ckbw8y5KH52zthCv4rj
	 OX0Sd2tePR03q5OInsx/LX6njwzbH4/PqJEbwSbk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbgHLVDK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:03:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbgHLVDJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:03:09 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6542C207F7;
        Wed, 12 Aug 2020 21:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266189;
        bh=fVSjUH61mTdxGvBKYyEkg3iOryLQtIlz9qUDkFDVTJI=;
        h=Date:From:To:Subject:From;
        b=bQfssofzxkhlOrI26csWFa6xK3N0VJ3WgEWbNKA25gx6MoGzXwyLhmAnSzbX6YIHI
         oEbWgz/eru22418jZLFwZv6I1Jxqbb4lybCy1fCx89+/uZnYFSfno/RT6rlo5WBnyC
         7vaPiDHovBlYhcKQdp7UglUYVt5pITCn8kFch8Ew=
Date:   Wed, 12 Aug 2020 14:03:09 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, ziy@nvidia.com
Subject:  [merged] mm-usercopyc-delete-duplicated-word.patch
 removed from -mm tree
Message-ID: <20200812210309.E6TsEd0fA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/usercopy.c: delete duplicated word
has been removed from the -mm tree.  Its filename was
     mm-usercopyc-delete-duplicated-word.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/usercopy.c: delete duplicated word

Drop the repeated word "the".

Link: http://lkml.kernel.org/r/20200801173822.14973-13-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/usercopy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/usercopy.c~mm-usercopyc-delete-duplicated-word
+++ a/mm/usercopy.c
@@ -43,7 +43,7 @@ static noinline int check_stack_object(c
 
 	/*
 	 * Reject: object partially overlaps the stack (passing the
-	 * the check above means at least one end is within the stack,
+	 * check above means at least one end is within the stack,
 	 * so if this check fails, the other end is outside the stack).
 	 */
 	if (obj < stack || stackend < obj + len)
_

Patches currently in -mm which might be from rdunlap@infradead.org are


