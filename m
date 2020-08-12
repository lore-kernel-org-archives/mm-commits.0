Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5FE8C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:36:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3777206B2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196174;
	bh=rTkZZ+DekSq0hCxH6nnZ5cyFPMNyNzLf7OazUR0RvSM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=KTEeZ7CmqRuoOPcAxhr9VXkst14kHMve5UPQuMNEFy2QzWjcWVALfNCY4pa/xx9c6
	 /A4Cka9MDQmSnJtD8UNETz3rDZKwekAnf1EYXm3a9otSoxIIZ5cw8Hu2LYJjHcuEWt
	 iYHX1NusgEItTwdWWcWDfi8kzqktajX3x5kMbehw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgHLBgO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:36:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLBgO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:36:14 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 617522054F;
        Wed, 12 Aug 2020 01:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196173;
        bh=rTkZZ+DekSq0hCxH6nnZ5cyFPMNyNzLf7OazUR0RvSM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UNtfTANk8hn8x28cbkb8jtHTD7PtN2X8glDpGOhWRfv2fB4TbST3lGgRM/f9midrR
         Rj26WD9hoS2w2xaILCGjVKgdGIQ0oSwiqcodc3DJ1Y/PZ6j7v1rO+Bfzk29nFWbKYC
         iGowrxH4XS23nV6E05KKdebN6JvBW14qyKKTko9c=
Date:   Tue, 11 Aug 2020 18:36:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ast@kernel.org, axboe@kernel.dk,
        bfields@fieldses.org, chainsaw@gentoo.org,
        christian.brauner@ubuntu.com, chuck.lever@oracle.com,
        davem@davemloft.net, dhowells@redhat.com,
        gregkh@linuxfoundation.org, hch@infradead.org,
        jarkko.sakkinen@linux.intel.com, jmorris@namei.org,
        josh@joshtriplett.org, keescook@chromium.org, kuba@kernel.org,
        lars.ellenberg@linbit.com, linux-mm@kvack.org, mcgrof@kernel.org,
        mm-commits@vger.kernel.org, nikolay@cumulusnetworks.com,
        philipp.reisner@linbit.com, ravenexp@gmail.com,
        roopa@cumulusnetworks.com, serge@hallyn.com, shuah@kernel.org,
        slyfox@gentoo.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, yangtiezhu@loongson.cn
Subject:  [patch 113/165] kmod: remove redundant "be an" in the
 comment
Message-ID: <20200812013612.SI7uEp5dE%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: kmod: remove redundant "be an" in the comment

There exists redundant "be an" in the comment, remove it.

Link: http://lkml.kernel.org/r/20200610154923.27510-3-mcgrof@kernel.org
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: David Howells <dhowells@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: James Morris <jmorris@namei.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Roopa Prabhu <roopa@cumulusnetworks.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Sergei Trofimovich <slyfox@gentoo.org>
Cc: Sergey Kvachonok <ravenexp@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tony Vroon <chainsaw@gentoo.org>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/kernel/kmod.c~kmod-remove-redundant-be-an-in-the-comment
+++ a/kernel/kmod.c
@@ -36,9 +36,8 @@
  *
  * If you need less than 50 threads would mean we're dealing with systems
  * smaller than 3200 pages. This assumes you are capable of having ~13M memory,
- * and this would only be an be an upper limit, after which the OOM killer
- * would take effect. Systems like these are very unlikely if modules are
- * enabled.
+ * and this would only be an upper limit, after which the OOM killer would take
+ * effect. Systems like these are very unlikely if modules are enabled.
  */
 #define MAX_KMOD_CONCURRENT 50
 static atomic_t kmod_concurrent_max = ATOMIC_INIT(MAX_KMOD_CONCURRENT);
_
