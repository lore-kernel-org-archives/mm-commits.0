Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55C93C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:34:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 365EB206B2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196058;
	bh=VOdimQHhnbi6/MY/jADG5zX3GlNUbaWgujS3WnEFT10=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=VIs2i0m5gQENHV9SASntNCrc/gVp9jAcNjnwxaXkh5SPG0Q3szFuSNQoLb33Kyi67
	 lzzo92yQoGgoIXhloWLqUJdfjLM/GPv+dv0iqIKfoemuuxqY2c3gkQVVGKiShtUOYO
	 khsOFH99Bbz2swz32jHmCUfydbny3tWP6GhkDH7o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgHLBeS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:34:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbgHLBeR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:34:17 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37CEF207DA;
        Wed, 12 Aug 2020 01:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196057;
        bh=VOdimQHhnbi6/MY/jADG5zX3GlNUbaWgujS3WnEFT10=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0j9QWgSc4MrDG5Si6dlvpxdziJY0CFgfv0zFT7DMyu39sdrOf40+i++vV4xYz6oiF
         Uf2JmaoodmfdAF/bopUW2yOJ8nLpbsJ7S/UXh4kFKQ7edi3tFGQzlN3EIThA6XBB0W
         8VYWC/rcMXpCBYGPWbv3xQo8mbxUI3hnC1Rto+PM=
Date:   Tue, 11 Aug 2020 18:34:16 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, nivedita@alum.mit.edu,
        torvalds@linux-foundation.org
Subject:  [patch 076/165] kernel.h: remove duplicate include of
 asm/div64.h
Message-ID: <20200812013416.0td1Hx8Zs%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Arvind Sankar <nivedita@alum.mit.edu>
Subject: kernel.h: remove duplicate include of asm/div64.h

This seems to have been added inadvertently in commit
  72deb455b5ec ("block: remove CONFIG_LBDAF")

Link: http://lkml.kernel.org/r/20200727034852.2813453-1-nivedita@alum.mit.edu
Fixes: 72deb455b5ec ("block: remove CONFIG_LBDAF")
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/kernel.h~kernelh-remove-duplicate-include-of-asm-div64h
+++ a/include/linux/kernel.h
@@ -17,7 +17,6 @@
 #include <asm/byteorder.h>
 #include <asm/div64.h>
 #include <uapi/linux/kernel.h>
-#include <asm/div64.h>
 
 #define STACK_MAGIC	0xdeadbeef
 
_
